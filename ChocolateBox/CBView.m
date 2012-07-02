//
//  CBView.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBView.h"
#import "CBMachine.h"

@interface CBView()
@property (nonatomic, retain) CBMachine *machine;
@end

@implementation CBView
@synthesize machine = _machine;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _machine = [[CBMachine alloc] initWithIdentifier:[NSString stringWithFormat:@"%@:%p", NSStringFromClass([self class]), self]];
  }
  return self;
}

- (void)dealloc {
  [_machine release];
  [super dealloc];
}

- (id<ChocolateBoxProtocol>)supermachine {
  return [self.machine supermachine];
}

- (void)setSupermachine:(id<ChocolateBoxProtocol>)supermachine {
  [self.machine setSupermachine:supermachine];
}

- (id<ChocolateBoxProtocol>)submachineWithIdentifier:(id)identifier {
  return [self.machine submachineWithIdentifier:identifier];
}

- (BOOL)addSubmachine:(id<ChocolateBoxProtocol>)submachine {
  return [self.machine addSubmachine:submachine];
}

- (void)removeFromSupermachine {
  [self.machine removeFromSupermachine];
}

- (BOOL)containsSubmachineWithIdentifier:(NSString*)identifier {
  return ([self.machine submachineWithIdentifier:identifier] != nil);
}

- (BOOL)containsSubmachine:(id<ChocolateBoxProtocol>)submachine {
  return [self.machine containsSubmachine:submachine];
}

- (void)removeSubmachine:(id<ChocolateBoxProtocol>)submachine {  
  [self.machine removeSubmachine:submachine];
}

- (NSSet*)submachines {
  return [self.machine submachines];
}

- (id)machineIdentifier {
  return [self.machine machineIdentifier];
}

- (NSSet *)states {
  return [self.machine states];
}

- (void)setInitialState:(NSString *)initialState {
  [self.machine setInitialState:initialState];
}

- (BOOL)hasState:(NSString *)state {
  return [self.machine hasState:state];;
}

- (NSString*)currentState {
  return [self.machine currentState];
}

- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit {
  [self.machine addState:state enter:enter exit:exit];
}

- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state {
  [self.machine replaceEnter:enter exit:exit forState:state];
}

- (void)removeState:(NSString *)state {
  [self.machine removeState:state];
}

- (void)enterInitialState {
  [self.machine enterInitialState];
}

- (void)transitionToState:(NSString *)state {
  [self.machine transitionToState:state];
}

- (void)revalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [self.machine revalidateTransitionFromState:fromState toState:toState];
}

- (void)invalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [self.machine invalidateTransitionFromState:fromState toState:toState];
}

- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration {
  [self.machine transitionToState:state animated:animated duration:duration];
}

- (void)addSubview:(UIView*)view {
  if ([view conformsToProtocol:@protocol(ChocolateBoxUIProtocol)]) {
    id<ChocolateBoxUIProtocol> machine = (id<ChocolateBoxUIProtocol>) view;
    [self addSubmachine:machine];
  }
  
  [super addSubview:view];
}

- (void)removeFromSuperview {
  [self removeFromSupermachine];  
  [super removeFromSuperview];
}

@end

@interface CBScrollView()
@property (nonatomic, retain) CBMachine *machine;
@end

@implementation CBScrollView
@synthesize machine = _machine;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _machine = [[CBMachine alloc] initWithIdentifier:[NSString stringWithFormat:@"%@:%p", NSStringFromClass([self class]), self]];
  }
  return self;
}

- (void)dealloc {
  [_machine release];
  [super dealloc];
}

- (id<ChocolateBoxProtocol>)supermachine {
  return [self.machine supermachine];
}

- (void)setSupermachine:(id<ChocolateBoxProtocol>)supermachine {
  [self.machine setSupermachine:supermachine];
}

- (id<ChocolateBoxProtocol>)submachineWithIdentifier:(id)identifier {
  return [self.machine submachineWithIdentifier:identifier];
}

- (BOOL)addSubmachine:(id<ChocolateBoxProtocol>)submachine {
  return [self.machine addSubmachine:submachine];
}

- (void)removeFromSupermachine {
  [self.machine removeFromSupermachine];
}

- (BOOL)containsSubmachineWithIdentifier:(NSString*)identifier {
  return ([self.machine submachineWithIdentifier:identifier] != nil);
}

- (BOOL)containsSubmachine:(id<ChocolateBoxProtocol>)submachine {
  return [self.machine containsSubmachine:submachine];
}

- (void)removeSubmachine:(id<ChocolateBoxProtocol>)submachine {  
  [self.machine removeSubmachine:submachine];
}

- (NSSet*)submachines {
  return [self.machine submachines];
}

- (id)machineIdentifier {
  return [self.machine machineIdentifier];
}

- (NSSet *)states {
  return [self.machine states];
}

- (void)setInitialState:(NSString *)initialState {
  [self.machine setInitialState:initialState];
}

- (BOOL)hasState:(NSString *)state {
  return [self.machine hasState:state];;
}

- (NSString*)currentState {
  return [self.machine currentState];
}

- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit {
  [self.machine addState:state enter:enter exit:exit];
}

- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state {
  [self.machine replaceEnter:enter exit:exit forState:state];
}

- (void)removeState:(NSString *)state {
  [self.machine removeState:state];
}

- (void)enterInitialState {
  [self.machine enterInitialState];
}

- (void)transitionToState:(NSString *)state {
  [self.machine transitionToState:state];
}

- (void)revalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [self.machine revalidateTransitionFromState:fromState toState:toState];
}

- (void)invalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState {
  [self.machine invalidateTransitionFromState:fromState toState:toState];
}

- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration {
  [self.machine transitionToState:state animated:animated duration:duration];
}

- (void)addSubview:(UIView*)view {
  if ([view conformsToProtocol:@protocol(ChocolateBoxUIProtocol)]) {
    id<ChocolateBoxUIProtocol> machine = (id<ChocolateBoxUIProtocol>) view;
    [self addSubmachine:machine];
  }
  
  [super addSubview:view];
}

- (void)removeFromSuperview {
  [self removeFromSupermachine];  
  [super removeFromSuperview];
}

@end
