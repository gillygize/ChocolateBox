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

- (void)testMachineShouldInitializeWithAnIdentifier
{
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  
  STAssertNotNil(machine, @"The machine is nil");
  STAssertTrue([machine isMemberOfClass:[CBMachine class]], @"The machine is not an member of CBMachine");
  STAssertEqualObjects([machine machineIdentifier], @"testName", @"The machine did not set the correct name");
  
  [machine release];
}

- (void)testMachineShouldBeAbleToAddAState
{
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  
  STAssertEquals([machine.states count], (NSUInteger) 1, @"Adding a state did not result in one state");
  STAssertTrue([machine hasState:@"firstState"], @"Machine did not have one state");

  [machine release];
}

- (void)testMachineShouldBeAbleToRemoveAState
{
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
    
  STAssertTrue([machine hasState:@"firstState"], @"Machine did not have one state");

  [machine removeState:@"firstState"];
    
  STAssertFalse([machine hasState:@"firstState"], @"Machine did not not remove its state");
  
  [machine release];
}

- (void)testMachineShouldSetTheInitialStateToTheFirstStateWhichHasBeenAdded
{
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState"
    enter:nil
    exit:nil];
  
  STAssertEqualObjects(machine.currentState, @"firstState", @"Machine did not set its initial state to the first state");
  
  [machine release];
}

- (void)testMachineShouldAllowTheInitialStateToBeChangedIfItHasNotBeenEntered
{
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
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
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  
  [machine addState:@"firstState"
    enter:^{
      STAssertTrue(YES, @"Machine allowed the first state to be entered");
    }
    exit:nil];
    
  [machine enterInitialState];

  [machine release];
}

- (void)testMachineShouldNotAllowTheInitialStateToBeSetAfterItIsEntered {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine enterInitialState];
  
  STAssertThrows([machine setInitialState:@"secondState"], @"Machine allowed the initial state to be set after it is entered");
  
  [machine release];
}

- (void)testMachineShouldDoNothingIfItIsAskedToTransitionToAnUnknownState {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine enterInitialState];
  
  STAssertNoThrow([machine transitionToState:@"unknownState"], @"Machine threw an exception when asked to transition to an unknown state");
  
  [machine release];
}

- (void)testMachineShouldSuccessfullyCallTheTransitionBlock {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState"
    enter:nil
    exit:^(NSString *nextStep){
    STAssertEqualObjects(nextStep, @"secondState", @"Machine did not perform exit transition");
  }];
  [machine addState:@"secondState" enter:^{
    STAssertTrue(YES, @"Machine did enter transition");
    }
    exit:nil];
  [machine setInitialState:@"firstState"];
  [machine transitionToState:@"secondState"];
  
  [machine release];
}

- (void)testMachineShouldEnterTheInitialStateAtTheFirstTransitionIfItHasNotDoneSo {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  
  [machine addState:@"firstState"
    enter:^{
      STAssertTrue(YES, @"Machine successfully entered the first state");
    }
    exit:nil];
    
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine transitionToState:@"secondState"];
  
  [machine release];
}

- (void)testMachineShouldInvalidateTransitions {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  [machine invalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertThrows([machine transitionToState:@"secondState"], @"Message did not invalidate transition");

  [machine release];
}

- (void)testMachineShouldRevalidateInvalidTransitions {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState" enter:nil exit:nil];
  [machine addState:@"secondState" enter:nil exit:nil];
  [machine setInitialState:@"firstState"];
  [machine invalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertThrows([machine transitionToState:@"secondState"], @"Message did not invalidate transition");

  [machine revalidateTransitionFromState:@"firstState" toState:@"secondState"];
  
  STAssertNoThrow([machine transitionToState:@"secondState"], @"Message did not revalidate the transition");

  [machine release];
}

- (void)testMachineShouldDoNothingForTransitionToItsCurrentState {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  [machine addState:@"firstState"
    enter:nil
    exit:^(NSString *nextState) {
      STAssertFalse(YES, @"Machine did not do nothing for a transition to itself");
    }];
  [machine setInitialState:@"firstState"];
  [machine transitionToState:@"firstState"];

  [machine release];
}

- (void)testMachineShouldAllowReplacementOfStates {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];

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
  
  [machine release];
}

- (void)testMachineShouldAllowAddingSubmachines {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  CBMachine *submachine = [[CBMachine alloc] initWithIdentifier:@"testName2"];
  [machine addSubmachine:submachine];
  
  STAssertNotNil(submachine, @"The submachine is nil");
  STAssertEqualObjects([submachine machineIdentifier], @"testName2", @"The submachine does not have the correct identifier");
  
  [submachine release];
  [machine release];
}

- (void)testMachineShouldBeAbleToRetriveSubmachinesByIdentifier {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  CBMachine *submachine = [[CBMachine alloc] initWithIdentifier:@"testName2"];
  [machine addSubmachine:submachine];
  
  CBMachine *testSubmachine = (CBMachine*)[machine submachineWithIdentifier:@"testName2"];
  
  STAssertNotNil(testSubmachine, @"The submachine is nil");
  STAssertEqualObjects([testSubmachine machineIdentifier], @"testName2", @"The submachine does not have the correct identifier");

  [submachine release];  
  [machine release];
}

- (void)testMachineShouldReturnNilSubmachineIfTheSubmachineWithThatIdentifierWasNeverAdded {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  
  STAssertNil([machine submachineWithIdentifier:@"invalidName"], @"The submachine is not nil");
  
  [machine release];
}

- (void)testMachineShouldBeAbleToReportIfItContainsASubmachineOrNot {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  CBMachine *addedSubmachine = [[CBMachine alloc] initWithIdentifier:@"testName2"];
  CBMachine *notAddedSubmachine = [[CBMachine alloc] initWithIdentifier:@"testName3"];

  [machine addSubmachine:addedSubmachine];
  
  STAssertTrue([machine containsSubmachine:addedSubmachine], @"The machine does not contain a submachine which was added");
  STAssertFalse([machine containsSubmachine:notAddedSubmachine], @"The machine contains a submachine which was not added");
  
  [addedSubmachine release];
  [notAddedSubmachine release];
  [machine release];
}

- (void)testMachineShouldBeAbleToRemoveASubmachine {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  CBMachine *submachine = [[CBMachine alloc] initWithIdentifier:@"testName2"];;
  [machine addSubmachine:submachine];

  STAssertTrue([machine containsSubmachine:submachine], @"The machine does not contain a submachine which was added");
  
  [machine removeSubmachine:submachine];
  
  STAssertNil([submachine supermachine], @"The supermachine was not nil after being removed");
  STAssertFalse([machine containsSubmachine:submachine], @"The submachine was not nil after being removed");
  
  [machine release];
}

- (void)testSubmachineShouldBeAbleToRemoveItselfFromASupermachine {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  CBMachine *submachine = [[CBMachine alloc] initWithIdentifier:@"testName2"];;
  [machine addSubmachine:submachine];

  STAssertTrue([machine containsSubmachine:submachine], @"The machine does not contain a submachine which was added");
   
  [submachine removeFromSupermachine];
  
  STAssertNil([submachine supermachine], @"The supermachine was not nil after being removed");
  STAssertFalse([machine containsSubmachine:submachine], @"The machine still returns the submachine after it has been removed");

  [machine release];
}

- (void)testMachineShouldForwardTransitionSignalsToItsSubmachines {
  CBMachine *machine = [[CBMachine alloc] initWithIdentifier:@"testName"];
  CBMachine *submachine = [[CBMachine alloc] initWithIdentifier:@"testName2"];
  
  [machine addState:@"unusedState"
    enter:nil
    exit:nil];
  
  [submachine addState:@"initialState" enter:nil exit:nil];
  [submachine addState:@"testState" enter:^{
    STAssertTrue(YES, @"The submachine received the transition signal from its supermachine");
    }
    exit:nil];
    
  [machine addSubmachine:submachine];
  [submachine enterInitialState];
  [submachine release];
  
  [machine transitionToState:@"testState"];
  [machine release];
}

@end
