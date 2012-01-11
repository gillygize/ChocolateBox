//
//  CBMachineTests.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CBMachine.h"

@interface CBMachineTests : SenTestCase
@end

@implementation CBMachineTests

- (void)testMachineShouldInitialize
{
  CBMachine *machine = [[CBMachine alloc] init];
  
  STAssertNotNil(machine, @"The machine is nil");
  STAssertTrue([machine isMemberOfClass:[CBMachine class]], @"The machine is not an member of CBMachine");
}

- (void)testMachineShouldLoadFromItsConvenienceMethod
{
  CBMachine *machine = [CBMachine machine];
  
  STAssertNotNil(machine, @"The machine is nil");
  STAssertTrue([machine isMemberOfClass:[CBMachine class]], @"The machine is not an member of CBMachine");
}

- (void)testMachineShouldBeAbleToAddAState
{
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
  
  STAssertEquals([machine.states count], (NSUInteger) 1, @"Adding a state did not result in one state");
  STAssertTrue([machine hasState:@"firstState"], @"Machine did not have one state");
}

- (void)testMachineShouldBeAbleToRemoveAState
{
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
    
  STAssertTrue([machine hasState:@"firstState"], @"Machine did not have one state");

  [machine removeState:@"firstState"];
    
  STAssertFalse([machine hasState:@"firstState"], @"Machine did not not remove its state");
}

- (void)testMachineShouldBeAbleToSetInitialState
{
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  
  STAssertEqualObjects(machine.currentState, @"firstState", @"Machine did not set its initial state");  
}

- (void)testMachineShouldBeAbleToTransition {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  
  STAssertEqualObjects(machine.currentState, @"firstState", @"Machine did not start in the first state");
  
  [machine transitionToState:@"secondState"];
  
  STAssertEqualObjects(machine.currentState, @"secondState", @"Machine did not transition");
}

- (void)testMachineShouldFailToTransitionIfInitialStateIsNotSet {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  
  STAssertThrows([machine transitionToState:@"secondState"], @"Machine did not throw an exception when transitioning without an initial state");  
}

- (void)testMachineShouldSuccessfullyCallTheTransitionBlock {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:^(NSString *nextStep){ STAssertEqualObjects(nextStep, @"secondState", @"Machine did not perform exit transition"); }];
  [machine addState:@"secondState" enter:^{ STAssertTrue(YES, @"Machine did enter transition"); } exit:nil];
  [machine setInitialState:@"firstState"];
  [machine transitionToState:@"secondState"]; 
}

- (void)testMachineShouldInvalidateTransitions {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  [machine invalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertThrows([machine transitionToState:@"secondState"], @"Message did not invalidate transition");
}

- (void)testMachineShouldRevalidateInvalidTransitions {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  [machine invalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertThrows([machine transitionToState:@"secondState"], @"Message did not invalidate transition");

  [machine revalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertNoThrow([machine transitionToState:@"secondState"], @"Message did not revalidate the transition");
}

- (void)testMachineShouldAllowReplacementOfStates {
  CBMachine *machine = [CBMachine machine];

  [machine addState:@"firstState"
    enter:nil
    exit:^(NSString *nextStep) {
      STAssertFalse(YES, @"The first state did not replace the exit block");
    }];
  
  [machine addState:@"secondState"
    enter:^{
      STAssertFalse(YES, @"The first state did not replace the enter block");      
    }            
    exit:nil];
  
  [machine setInitialState:@"firstState"];
  
  [machine replaceEnter:nil exit:nil forState:@"firstState"];
  [machine replaceEnter:nil exit:nil forState:@"secondState"];
  
  [machine transitionToState:@"secondState"];
}

@end
