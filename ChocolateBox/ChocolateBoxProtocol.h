//
//  ChocolateBoxProtocol.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChocolateBoxProtocol <NSObject>

@optional

- (id<ChocolateBoxProtocol>)supermachine;
- (void)setSupermachine:(id<ChocolateBoxProtocol>)supermachine;
- (id<ChocolateBoxProtocol>)submachineWithIdentifier:(id)identifier;
- (BOOL)addSubmachine:(id<ChocolateBoxProtocol>)identifier;
- (void)removeFromSupermachine;
- (BOOL)containsSubmachine:(id)identifer;
- (void)removeSubmachine:(id)identifier;
- (NSSet*)submachines;
- (id)machineIdentifier;

- (void)setInitialState:(NSString *)initialState;
- (void)enterInitialState;
- (NSString*)currentState;
- (BOOL)hasState:(NSString *)state;
- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit;
- (void)removeState:(NSString *)state;
- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state;
- (void)transitionToState:(NSString *)state;
- (void)invalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState;
- (void)revalidateTransitionFromState:(NSString *)fromState toState:(NSString *)toState;

@end

@protocol ChocolateBoxUIProtocol <ChocolateBoxProtocol>
@optional
- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration;
@end