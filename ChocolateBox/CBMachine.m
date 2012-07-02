//
//  ChocolateBox.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBMachine.h"
#import "CBState.h"

@interface CBMachine ()

@property (nonatomic, retain) NSMutableDictionary *machineDictionary;
@property (nonatomic, retain) NSMutableDictionary *stateDictionary;
@property BOOL hasEnteredInitialState;

@end

@implementation CBMachine

@synthesize currentState = _currentState;
@synthesize supermachine = _supermachine;
@synthesize machineIdentifier = _machineIdentifier;

@synthesize machineDictionary = _machineDictionary;
@synthesize stateDictionary = _stateDictionary;
@synthesize hasEnteredInitialState = _hasEnteredInitialState;

@dynamic states;

- (id)initWithIdentifier:(id)identifier {
  self = [super init];
  if (self) {
    _machineDictionary = [[NSMutableDictionary alloc] initWithCapacity:8];
    _stateDictionary = [[NSMutableDictionary alloc] initWithCapacity:8];
    _hasEnteredInitialState = NO;
    
    NSAssert(identifier != nil, @"name cannot be nil");
    
    _machineIdentifier = [identifier retain];
  }
    
  return self;
}

- (void)dealloc {
  [_machineDictionary release];
  [_stateDictionary release];
  [_machineIdentifier release];
  
  [super dealloc];
}

- (id<ChocolateBoxProtocol>)supermachine {
  return _supermachine;
}

- (void)setSupermachine:(id<ChocolateBoxProtocol>)supermachine {
  _supermachine = supermachine;
}

- (id<ChocolateBoxProtocol>)submachineWithIdentifier:(id)identifier {
  if ([[self machineIdentifier] isEqual:identifier]) {
    return self;
  }
  
  for (id machineIdentifier in [_machineDictionary allKeys]) {
    id<ChocolateBoxProtocol>machine = [self.machineDictionary objectForKey:machineIdentifier];
    id<ChocolateBoxProtocol> submachine = [machine submachineWithIdentifier:identifier];
    
    if (submachine != nil) {
      return submachine;
    }
  }
  
  return nil;
}

- (BOOL)addSubmachine:(id<ChocolateBoxProtocol>)submachine {
  if (![self containsSubmachine:submachine]) {
    [submachine setSupermachine:self];
    [_machineDictionary setObject:submachine forKey:[submachine machineIdentifier]];
    
    return YES;
  }
  
  return NO;
}

- (void)removeFromSupermachine {
  [_supermachine removeSubmachine:self];
}

- (NSSet *)submachines {
  return [NSSet setWithArray:[_machineDictionary allValues]];
}

- (BOOL)containsSubmachineWithIdentifier:(NSString*)identifier {
  return ([self submachineWithIdentifier:identifier] != nil);
}

- (BOOL)containsSubmachine:(id<ChocolateBoxProtocol>)submachine {
  return ([self submachineWithIdentifier:[submachine machineIdentifier]] != nil);
}

- (void)removeSubmachine:(id<ChocolateBoxProtocol>)submachine {  
  CBMachine *machine = (CBMachine*)[submachine supermachine];
  [machine.machineDictionary removeObjectForKey:[submachine machineIdentifier]];
  [submachine setSupermachine:nil];
}

- (NSSet *)states {
  NSArray *stateArray = [_stateDictionary allKeys];
  
  return [NSSet setWithArray:stateArray];
}

- (void)setInitialState:(NSString *)initialState {
  NSAssert([_stateDictionary objectForKey:initialState], @"Setting the initial state to an unknown state");
  NSAssert(!_hasEnteredInitialState, @"The initial state can not be set after it has been entered");
  
  _currentState = [initialState copy];
}

- (BOOL)hasState:(NSString *)state {
  return ([_stateDictionary objectForKey:state] != nil);
}

- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit {
  NSAssert(![_stateDictionary objectForKey:state], @"Adding a state which has already been added");
  
  CBState *stateObject = [[CBState alloc] initWithEnter:enter exit:exit];
  [_stateDictionary setObject:stateObject forKey:state];
  [stateObject release];
  
  if (!_currentState) {
    _currentState = state;
  }
}

- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state {
  NSAssert([_stateDictionary objectForKey:state], @"Replace a state which does not exist");

  CBState *stateObject = [[CBState alloc] initWithEnter:enter exit:exit];
  [_stateDictionary setObject:stateObject forKey:state];
  [stateObject release];
}

- (void)removeState:(NSString *)state {
  [_stateDictionary removeObjectForKey:state];
  
  [_stateDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    CBState *thisStateObject = (CBState *)obj;
    [thisStateObject removeInvalidTransitionToState:state];
  }];
}

- (void)enterInitialState {
  NSAssert(!_hasEnteredInitialState, @"Entering initial state a second time");
  
  _hasEnteredInitialState = YES;

  CBState *currentStateObject = [_stateDictionary objectForKey:self.currentState];
  
  if (currentStateObject.enter) {
    currentStateObject.enter();
  }  
}

- (void)transitionToState:(NSString *)state {
  [[self submachines] makeObjectsPerformSelector:@selector(transitionToState:) withObject:state];

  if ([state isEqualToString:_currentState]) {
    return;
  }

  NSAssert(self.currentState, @"Trying to transition but the current state is nil");

  CBState *currentStateObject = [_stateDictionary objectForKey:self.currentState];
  CBState *nextStateObject = [_stateDictionary objectForKey:state];

  NSAssert(currentStateObject, @"Trying to transition from an unknown state");

  if (![self hasState:state]) {
    return;
  }
  
  NSAssert([currentStateObject canTransitionToState:state], @"Trying to make an invalid transition");
  
  if (!_hasEnteredInitialState) {
    [self enterInitialState];
  }
  
  if (currentStateObject.exit) {
    currentStateObject.exit(state);
  }
  
  _currentState = state;
  
  if (nextStateObject.enter) {
    nextStateObject.enter();
  }
  
}

- (void)revalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  CBState *fromStateObject = [_stateDictionary objectForKey:fromState];
  
  NSAssert(fromStateObject, @"Revalidating a transition from an unknown state");
  NSAssert([_stateDictionary objectForKey:toState], @"Revalidating a transition from a known state");
  
  [fromStateObject removeInvalidTransitionToState:toState];
}

- (void)invalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  CBState *fromStateObject = [_stateDictionary objectForKey:fromState];
  
  NSAssert(fromStateObject, @"Revalidating a transition from an unknown state");
  NSAssert([_stateDictionary objectForKey:toState], @"Revalidating a transition from a known state");
  
  [fromStateObject invalidateTransitionToState:toState];
}

@end

#import <QuartzCore/QuartzCore.h>

@implementation CBMachine (UIKit)

- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration {
  [CATransaction begin];

  for (id machineIdentifier in _machineDictionary) {
    id<ChocolateBoxUIProtocol> machine = (id<ChocolateBoxUIProtocol>)[self submachineWithIdentifier:machineIdentifier];

    if ([machine hasState:state]) {
      [machine transitionToState:state animated:animated duration:duration];
    }
  }

  NSAssert(self.currentState, @"Trying to transition but the current state is nil");

  CBState *currentStateObject = [self.stateDictionary objectForKey:self.currentState];
  CBState *nextStateObject = [self.stateDictionary objectForKey:state];

  NSAssert(currentStateObject, @"Trying to transition from an unknown state");
  NSAssert(nextStateObject, @"Trying to transition to an unknown state");
  
  NSAssert([currentStateObject canTransitionToState:state], @"Trying to make an invalid transition");
  
  if (currentStateObject.exit) {
    currentStateObject.exit(state);
  }
  
  _currentState = state;
  
  if (nextStateObject.enter) {
    if (animated) {
      [UIView animateWithDuration:duration animations:nextStateObject.enter];
    } else {
      nextStateObject.enter();
    }
  }
  
  [CATransaction commit];
}

@end
