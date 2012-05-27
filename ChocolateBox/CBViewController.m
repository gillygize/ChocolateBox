//
//  CBViewController.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBViewController.h"
#import "CBMachine.h"

@interface CBViewController()
@property (nonatomic, retain) CBMachine *machine;
@end

@implementation CBViewController
@synthesize machine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      machine = [[CBMachine alloc] initWithIdentifier:NSStringFromClass([self class])];
  }
  return self;
}

- (void)dealloc {
  [machine release];
  [super dealloc];
}

- (id<ChocolateBoxProtocol>)supermachine {
  return [machine supermachine];
}

- (void)setSupermachine:(id<ChocolateBoxProtocol>)supermachine {
  [machine setSupermachine:supermachine];
}

- (id<ChocolateBoxProtocol>)submachineWithIdentifier:(id)identifier {
  return [machine submachineWithIdentifier:identifier];
}

- (BOOL)addSubmachine:(id<ChocolateBoxProtocol>)submachine {
  return [machine addSubmachine:submachine];
}

- (void)removeFromSupermachine {
  [machine removeFromSupermachine];
}

- (BOOL)containsSubmachineWithIdentifier:(NSString*)identifier {
  return ([machine submachineWithIdentifier:identifier] != nil);
}

- (BOOL)containsSubmachine:(id<ChocolateBoxProtocol>)submachine {
  return [machine containsSubmachine:submachine];
}

- (void)removeSubmachine:(id<ChocolateBoxProtocol>)submachine {  
  [machine removeSubmachine:submachine];
}

- (NSSet *)states {
  return [machine states];
}

- (void)setInitialState:(NSString *)initialState {
  [machine setInitialState:initialState];
}

- (BOOL)hasState:(NSString *)state {
  return [machine hasState:state];;
}

- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit {
  [machine addState:state enter:enter exit:exit];
}

- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state {
  [machine replaceEnter:enter exit:exit forState:state];
}

- (void)removeState:(NSString *)state {
  [machine removeState:state];
}

- (void)enterInitialState {
  [machine enterInitialState];
}

- (void)transitionToState:(NSString *)state {
  [machine transitionToState:state];
}

- (void)revalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [machine revalidateTransitionFromState:fromState toState:toState];
}

- (void)invalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [machine invalidateTransitionFromState:fromState toState:toState];
}

- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration {
  [machine transitionToState:state animated:animated duration:duration];
}

@end
