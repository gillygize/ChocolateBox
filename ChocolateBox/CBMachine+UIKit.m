//
//  CBMachine+UIKit.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBMachine+UIKit.h"
#import "CBState.h"

@implementation CBMachine (UIKit)

- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration {
  NSAssert(self.currentState, @"Trying to transition but the current state is nil");

  CBState *currentStateObject = [_stateDictionary objectForKey:self.currentState];
  CBState *nextStateObject = [_stateDictionary objectForKey:state];

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
}

@end
