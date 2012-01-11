//
//  CBState.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBState.h"

@interface CBState ()
@property (nonatomic, retain) NSMutableSet *invalidTransitionStates;
@end

@implementation CBState

@synthesize enter = _enter;
@synthesize exit = _exit;
@synthesize invalidTransitionStates = _invalidTransitionStates;

-(id)initWithEnter:(void(^)(void))enter exit:(void(^)(NSString *nextState))exit {
  if ((self = [super init])) {
    _enter = [enter copy];
    _exit = [exit copy];
    _invalidTransitionStates = [[NSMutableSet alloc] initWithCapacity:8];
  }
  
  return self;
}

- (void)dealloc {
  [_enter release];
  [_exit release];
  [_invalidTransitionStates release];
  
  [super dealloc];
}

- (BOOL)canTransitionToState:(NSString *)state {
  return ![_invalidTransitionStates member:state];
}

- (void)invalidateTransitionToState:(NSString *)state {
  [_invalidTransitionStates addObject:state];
}

- (void)removeInvalidTransitionToState:(NSString*)state {
  [_invalidTransitionStates removeObject:state];
}



@end
