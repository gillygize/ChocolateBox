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

@interface CBMachine(ExposePrivateAPIS)
- (id)initWithName:(NSString*)name;
@end

@implementation CBMachineTests

- (void)testMachineShouldInitialize
{
  CBMachine *machine = [[CBMachine alloc] initWithName:@"testName"];
  
  STAssertNotNil(machine, @"The machine is nil");
  STAssertTrue([machine isMemberOfClass:[CBMachine class]], @"The machine is not an member of CBMachine");
}

- (void)testMachineShouldInitializeWithAName
{
  CBMachine *machine = [[CBMachine alloc] initWithName:@"testName"];
  
  STAssertEqualObjects([machine name], @"testName", @"The machine did not set the correct name");
}

- (void)testMachineShouldLoadFromItsConvenienceMethod
{
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  
  STAssertNotNil(machine, @"The machine is nil");
  STAssertTrue([machine isMemberOfClass:[CBMachine class]], @"The machine is not an member of CBMachine");
  STAssertEqualObjects([machine name], @"testName", @"The machine did not set the correct name");
}

- (void)testMachineShouldBeAbleToAddAState
{
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  
  STAssertEquals([machine.states count], (NSUInteger) 1, @"Adding a state did not result in one state");
  STAssertTrue([machine hasState:@"firstState"], @"Machine did not have one state");
}

- (void)testMachineShouldBeAbleToRemoveAState
{
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
    
  STAssertTrue([machine hasState:@"firstState"], @"Machine did not have one state");

  [machine removeState:@"firstState"];
    
  STAssertFalse([machine hasState:@"firstState"], @"Machine did not not remove its state");
}

- (void)testMachineShouldSetTheInitialStateToTheFirstStateWhichHasBeenAdded
{
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState"
    enter:nil
    exit:nil];
  
  STAssertEqualObjects(machine.currentState, @"firstState", @"Machine did not set its initial state to the first state");  
}

- (void)testMachineShouldAllowTheInitialStateToBeChangedIfItHasNotBeenEntered
{
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
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
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  
  [machine addState:@"firstState"
    enter:^{
      STAssertTrue(YES, @"Machine allowed the first state to be entered");
    }
    exit:nil];
    
  [machine enterInitialState];
}

- (void)testMachineShouldNotAllowTheInitialStateToBeSetAfterItIsEntered {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine enterInitialState];
  
  STAssertThrows([machine setInitialState:@"secondState"], @"Machine allowed the initial state to be set after it is entered");
}

- (void)testMachineShouldSuccessfullyCallTheTransitionBlock {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState" enter:nil exit:^(NSString *nextStep){ STAssertEqualObjects(nextStep, @"secondState", @"Machine did not perform exit transition"); }];
  [machine addState:@"secondState" enter:^{ STAssertTrue(YES, @"Machine did enter transition"); } exit:nil];
  [machine setInitialState:@"firstState"];
  [machine transitionToState:@"secondState"]; 
}

- (void)testMachineShouldEnterTheInitialStateAtTheFirstTransitionIfItHasNotDoneSo {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  
  [machine addState:@"firstState"
    enter:^{
      STAssertTrue(YES, @"Machine successfully entered the first state");
    }
    exit:nil];
    
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine transitionToState:@"secondState"];
}

- (void)testMachineShouldInvalidateTransitions {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  [machine invalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertThrows([machine transitionToState:@"secondState"], @"Message did not invalidate transition");
}

- (void)testMachineShouldRevalidateInvalidTransitions {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  [machine invalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertThrows([machine transitionToState:@"secondState"], @"Message did not invalidate transition");

  [machine revalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertNoThrow([machine transitionToState:@"secondState"], @"Message did not revalidate the transition");
}

- (void)testMachineShouldDoNothingForTransitionToItself {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addState:@"firstState"
    enter:nil
    exit:^(NSString *nextState) {
      STAssertFalse(YES, @"Machine did not do nothing for a transition to itself");
    }];
  [machine setInitialState:@"firstState"];
  [machine transitionToState:@"firstState"];
}

- (void)testMachineShouldAllowReplacementOfStates {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];

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

- (void)testMachineShouldAllowAddingSubmachines {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  CBMachine *submachine = [machine addSubmachineWithName:@"testName2"];
  
  STAssertNotNil(submachine, @"The submachine is nil");
  STAssertEqualObjects([submachine name], @"testName2", @"The submachine does not have the correct name");
}

- (void)testMachineShouldBeAbleToRetriveSubmachinesByName {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addSubmachineWithName:@"testName2"];
  
  CBMachine *submachine = [machine submachineWithName:@"testName2"];
  
  STAssertNotNil(submachine, @"The submachine is nil");
  STAssertEqualObjects([submachine name], @"testName2", @"The submachine does not have the correct name");
}

- (void)testMachineShouldReturnNilSubmachineIfTheSubmachineNameWithThatNameWasNeverAdded {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addSubmachineWithName:@"testName2"];
  
  CBMachine *submachine = [machine submachineWithName:@"invalidName"];
  
  STAssertNil(submachine, @"The submachine is not nil");
}

- (void)testMachineShouldBeAbleToReportIfItContainsASubmachineOrNot {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  [machine addSubmachineWithName:@"testName2"];
  
  STAssertTrue([machine containsSubmachineWithName:@"testName2"], @"The machine does not contain a submachine which was added");
  STAssertFalse([machine containsSubmachineWithName:@"invalidName"], @"The machine contains a submachine which was not added");
}

- (void)testMachineShouldBeAbleToRemoveASubmachine {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  CBMachine *submachine = [machine addSubmachineWithName:@"testName2"];

  STAssertNotNil(submachine, @"The submachine is nil");
  STAssertEqualObjects([submachine name], @"testName2", @"The submachine does not have the correct name");
  
  [machine removeSubmachineWithName:@"testName2"];
  submachine = [machine submachineWithName:@"testName2"];
  
  STAssertNil([submachine supermachine], @"The supermachine was not nil after being removed");
  STAssertNil(submachine, @"The submachine was not nil after being removed");
}

- (void)testSubmachineShouldBeAbleToRemoveItselfFromASupermachine {
  CBMachine *machine = [CBMachine machineWithName:@"testName"];
  CBMachine *submachine = [machine addSubmachineWithName:@"testName2"];

  STAssertNotNil(submachine, @"The submachine is nil");
  STAssertEqualObjects([submachine name], @"testName2", @"The submachine does not have the correct name");
  
  [submachine removeFromSupermachine];
  
  STAssertNil([submachine supermachine], @"The supermachine was not nil after being removed");
  STAssertNil([machine submachineWithName:@"testName2"], @"The machine still returns the submachine after it has been removed");
}

@end
