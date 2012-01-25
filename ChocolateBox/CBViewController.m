//
//  CBViewController.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBViewController.h"

@implementation CBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      machine = [[CBMachine alloc] init];
  }
  return self;
}

- (void)dealloc {
  [machine release];
  [super dealloc];
}

- (void)setInitialState:(NSString *)initialState {
  [machine setInitialState:initialState];
}

- (void)enterInitialState {
  [machine enterInitialState];
}

- (NSString*)currentState {
  return machine.currentState;
}

- (BOOL)hasState:(NSString *)state {
  return [machine hasState:state];
}

- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit {
  [machine addState:state enter:enter exit:exit];
}

- (void)removeState:(NSString *)state {
  [machine removeState:state];
}

- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state {
  [machine replaceEnter:enter exit:exit forState:state];
}

- (void)transitionToState:(NSString *)state {
  [machine transitionToState:state];
}

- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration {
  [machine transitionToState:state animated:animated duration:duration];
}

- (void)invalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [machine invalidateTransitionFromState:fromState toState:toState];
}

- (void)revalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [machine revalidateTransitionFromState:fromState toState:toState];
}

@end
