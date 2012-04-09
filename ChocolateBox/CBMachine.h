//
//  ChocolateBox.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChocolateBoxProtocol.h"

@interface CBMachine : NSObject <ChocolateBoxProtocol>

@property (nonatomic, assign, readonly) NSString *currentState;
@property (nonatomic, retain, readonly) id machineIdentifier;
@property (nonatomic, retain) id<ChocolateBoxProtocol> supermachine;
@property (nonatomic, readonly) NSSet *states;

- (id)initWithIdentifier:(id)identifier;

@end

#import <UIKit/UIKit.h>

@interface CBMachine (UIKit) <ChocolateBoxUIProtocol>
@end