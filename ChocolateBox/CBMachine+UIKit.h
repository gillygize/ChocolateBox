//
//  CBMachine+UIKit.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBMachine.h"
#import "ChocolateBoxProtocol.h"

@protocol ChocolateBoxUIProtocol <ChocolateBoxProtocol>
- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration;
@end

@interface CBMachine (UIKit)
- (void)transitionToState:(NSString *)state animated:(BOOL)animated duration:(NSTimeInterval)duration;
@end
