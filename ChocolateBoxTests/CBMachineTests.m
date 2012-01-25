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

- (void)testMachineShouldSetTheInitialStateToTheFirstStateWhichHasBeenAdded
{
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState"
    enter:nil
    exit:nil];
  
  STAssertEqualObjects(machine.currentState, @"firstState", @"Machine did not set its initial state to the first state");  
}

- (void)testMachineShouldAllowTheInitialStateToBeChangedIfItHasNotBeenEntered
{
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState"
    enter:nil
    exit:nil];
  [machine addState:@"secondState"
    enter:nil
    exit:nil];
    
  STAssertNoThrow([machine setInitialState:@"secondState"], @"Machine allowed setting this state");
  STAssertEqualObjects(machine.currentState, @"secondState", @"Machine did not change its initial state");  
}

- (void)testMachineShouldEnterTheInitialState
{
  CBMachine *machine = [CBMachine machine];
  
  [machine addState:@"firstState"
    enter:^{
      STAssertTrue(YES, @"Machine allowed the first state to be entered");
    }
    exit:nil];
    
  [machine enterInitialState];
}

- (void)testMachineShouldNotAllowTheInitialStateToBeSetAfterItIsEntered {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine enterInitialState];
  
  STAssertThrows([machine setInitialState:@"secondState"], @"Machine allowed the initial state to be set after it is entered");
}

- (void)testMachineShouldSuccessfullyCallTheTransitionBlock {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState" enter:nil exit:^(NSString *nextStep){ STAssertEqualObjects(nextStep, @"secondState", @"Machine did not perform exit transition"); }];
  [machine addState:@"secondState" enter:^{ STAssertTrue(YES, @"Machine did enter transition"); } exit:nil];
  [machine setInitialState:@"firstState"];
  [machine transitionToState:@"secondState"]; 
}

- (void)testMachineShouldEnterTheInitialStateAtTheFirstTransitionIfItHasNotDoneSo {
  CBMachine *machine = [CBMachine machine];
  
  [machine addState:@"firstState"
    enter:^{
      STAssertTrue(YES, @"Machine successfully entered the first state");
    }
    exit:nil];
    
  [machine addState:@"secondState" enter:nil exit:nil];
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

- (void)testMachineShouldDoNothingForTransitionToItself {
  CBMachine *machine = [CBMachine machine];
  [machine addState:@"firstState"
    enter:nil
    exit:^(NSString *nextState) {
      STAssertFalse(YES, @"Machine did not do nothing for a transition to itself");
    }];
  [machine setInitialState:@"firstState"];
  [machine transitionToState:@"firstState"];
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
