//
//  ChocolateBox.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBMachine.h"
#import "CBState.h"

@interface CBMachine()
@property (nonatomic, retain) NSMutableDictionary *stateDictionary;
@end

@implementation CBMachine

@synthesize stateDictionary = _stateDictionary;
@synthesize currentState = _currentState;
@dynamic states;

+ (CBMachine *)machine {
  return [[[CBMachine alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
      _stateDictionary = [[NSMutableDictionary alloc] initWithCapacity:8];
    }
    
    return self;
}

- (void)dealloc {
  [_stateDictionary release];
  
  [super dealloc];
}

- (NSSet *)states {
  NSArray *stateArray = [self.stateDictionary allKeys];
  
  return [NSSet setWithArray:stateArray];
}

- (void)setInitialState:(NSString *)initialState {
  NSAssert([self.stateDictionary objectForKey:initialState], @"Setting the initial state to an unknown state");
  NSAssert(_currentState == nil, @"The initial state can not be set after current state has a value");
  
  _currentState = [initialState copy];
}

- (BOOL)hasState:(NSString *)state {
  return ([self.stateDictionary objectForKey:state] != nil);
}

- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit {
  NSAssert(![self.stateDictionary objectForKey:state], @"Adding a state which has already been added");
  
  CBState *stateObject = [[CBState alloc] initWithEnter:enter exit:exit];
  [self.stateDictionary setObject:stateObject forKey:state];
  [stateObject release];
}

- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state {
  NSAssert([self.stateDictionary objectForKey:state], @"Replace a state which does not exist");

  CBState *stateObject = [[CBState alloc] initWithEnter:enter exit:exit];
  [self.stateDictionary setObject:stateObject forKey:state];
  [stateObject release];
}

- (void)removeState:(NSString *)state {
  [self.stateDictionary removeObjectForKey:state];
  
  [self.stateDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    CBState *thisStateObject = (CBState *)obj;
    [thisStateObject removeInvalidTransitionToState:state];
  }];
}

- (void)transitionToState:(NSString *)state {
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
    nextStateObject.enter();
  }
}

- (void)revalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  CBState *fromStateObject = [self.stateDictionary objectForKey:fromState];
  
  NSAssert(fromStateObject, @"Revalidating a transition from an unknown state");
  NSAssert([self.stateDictionary objectForKey:toState], @"Revalidating a transition from a known state");
  
  [fromStateObject removeInvalidTransitionToState:toState];
}

- (void)invalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  CBState *fromStateObject = [self.stateDictionary objectForKey:fromState];
  
  NSAssert(fromStateObject, @"Revalidating a transition from an unknown state");
  NSAssert([self.stateDictionary objectForKey:toState], @"Revalidating a transition from a known state");
  
  [fromStateObject invalidateTransitionToState:toState];
}

@end
