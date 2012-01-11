//
//  CBState.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBState : NSObject

@property (nonatomic, copy) void(^enter)();
@property (nonatomic, copy) void(^exit)(NSString *previousState);

- (id)initWithEnter:(void(^)(void))enter exit:(void(^)(NSString *nextState))exit;

- (BOOL)canTransitionToState:(NSString *)state;
- (void)invalidateTransitionToState:(NSString *)state;
- (void)removeInvalidTransitionToState:(NSString *)state;

@end
