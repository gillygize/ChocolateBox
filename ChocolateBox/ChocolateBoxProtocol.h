//
//  ChocolateBoxProtocol.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChocolateBoxProtocol <NSObject>

- (id<ChocolateBoxProtocol>)supermachine;
- (void)setSupermachine:(id<ChocolateBoxProtocol>)supermachine;
- (id<ChocolateBoxProtocol>)submachineWithName:(NSString*)name;
- (id<ChocolateBoxProtocol>)addSubmachineWithName:(NSString*)name;
- (void)removeFromSupermachine;
- (BOOL)containsSubmachineWithName:(NSString*)name;
- (void)removeSubmachineWithName:(NSString*)name;
- (NSString*)name;

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
