//
//  ChocolateBoxTests.m
//  ChocolateBoxTests
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CBState.h"

@interface CBStateTests : SenTestCase 
@end

@implementation CBStateTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testStateShouldInitialize
{
  CBState *state = [[CBState alloc] initWithEnter:nil exit:nil];
  
  STAssertNotNil(state, @"The state is nil");
  STAssertTrue([state isMemberOfClass:[CBState class]], @"The state is not an instance of CBState");
}

- (void)testStateShouldHoldAnEnterBlock
{
  CBState *state = [[CBState alloc] initWithEnter:^{
      STAssertTrue(YES, @"The enter block was successfully executed");
    }
    exit:nil];

  STAssertNotNil(state, @"The state is nil");
  state.enter();
}

- (void)testStateShouldHoldAnExitBlock
{
  CBState *state = [[CBState alloc] initWithEnter:nil
    exit:^(NSString *nextState) {
      STAssertEqualObjects(nextState, @"nextState", @"The nextState value was not passed correctly");
      STAssertTrue(YES, @"The exit block was successfully executed");
    }];

  STAssertNotNil(state, @"The state is nil");
}

- (void)testStateShouldKeepTrackOfInvalidTransitions
{
  CBState *state = [[CBState alloc] initWithEnter:nil exit:nil];
  [state invalidateTransitionToState:@"nextState"];

  STAssertFalse([state canTransitionToState:@"nextState"], @"The state did not report an invalid transition");
}

- (void)testStateShouldAllowResettingOfInvalidTransitions
{
  CBState *state = [[CBState alloc] initWithEnter:nil exit:nil];
  [state invalidateTransitionToState:@"nextState"];

  STAssertFalse([state canTransitionToState:@"nextState"], @"The state did not report an invalid transition");
  
  [state removeInvalidTransitionToState:@"nextState"];
  
  STAssertTrue([state canTransitionToState:@"nextState"], @"The state did not report an invalid transition");
}

@end
