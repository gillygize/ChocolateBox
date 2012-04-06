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
  NSMutableDictionary *_machineDictionary;
  NSMutableDictionary *_stateDictionary;
  NSString *_currentState;
  id<ChocolateBoxProtocol> _supermachine;
  BOOL _hasEnteredInitialState;
  NSString *_name;
}

@property (nonatomic, assign, readonly) NSString *currentState;
@property (nonatomic, assign) id<ChocolateBoxProtocol> supermachine;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readonly) NSSet *states;

+ (id<ChocolateBoxProtocol>)machineWithName:(NSString*)name;
- (id)initWithName:(NSString*)name;

@end
