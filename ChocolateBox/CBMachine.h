//
//  ChocolateBox.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBMachine : NSObject

@property (nonatomic, assign, readonly) NSString *currentState;
@property (nonatomic, readonly) NSSet *states;

+ (CBMachine *)machine;

- (void)setInitialState:(NSString *)initialState;
- (BOOL)hasState:(NSString *)state;
- (void)addState:(NSString *)state enter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit;
- (void)removeState:(NSString *)state;
- (void)replaceEnter:(void(^)(void))enter exit:(void(^)(NSString *previousState))exit forState:(NSString *)state;
- (void)transitionToState:(NSString *)state;
- (void)invalidateTransitionFromState:(NSString *)state toState:(NSString *)state;
- (void)revalidateTransitionFromState:(NSString *)state toState:(NSString *)state;

@end
