//
//  ChocolateBox.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChocolateBoxProtocol.h"

@interface CBMachine : NSObject <ChocolateBoxProtocol> {
  NSMutableDictionary *_stateDictionary;
  NSString *_currentState;
  BOOL _hasEnteredInitialState;
}

@property (nonatomic, assign, readonly) NSString *currentState;
@property (nonatomic, readonly) NSSet *states;

+ (CBMachine *)machine;

@end
