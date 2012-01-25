//
//  ChocolateBox.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBMachine.h"
#import "CBState.h"

@implementation CBMachine

@synthesize currentState = _currentState;
@dynamic states;

+ (CBMachine *)machine {
  return [[[CBMachine alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
      _stateDictionary = [[NSMutableDictionary alloc] initWithCapacity:8];
      _hasEnteredInitialState = NO;
    }
    
    return self;
}

- (void)dealloc {
  [_stateDictionary release];
  
  [super dealloc];
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
  if ([state isEqualToString:_currentState]) {
    return;
  }

  NSAssert(self.currentState, @"Trying to transition but the current state is nil");

  CBState *currentStateObject = [_stateDictionary objectForKey:self.currentState];
  CBState *nextStateObject = [_stateDictionary objectForKey:state];

  NSAssert(currentStateObject, @"Trying to transition from an unknown state");
  NSAssert(nextStateObject, @"Trying to transition to an unknown state");
  
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
