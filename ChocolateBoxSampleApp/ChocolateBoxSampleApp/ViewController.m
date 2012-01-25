//
//  ViewController.m
//  ChocolateBoxSampleApp
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize firstButton = _firstButton;
@synthesize secondButton = _secondButton;

- (void)dealloc
{
  [_firstButton release];
  [_secondButton release];
  
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  [self addState:@"firstState"
    enter:^{
      _firstButton.alpha = 1.0f;
      _secondButton.alpha = 0.0f;
    }
    
    exit:nil];
    
  [self addState:@"secondState"
    enter:^{
      _firstButton.alpha = 0.0f;
      _secondButton.alpha = 1.0f;
    }
    
    exit:nil];
    
  [self enterInitialState];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  
  self.firstButton = nil;
  self.secondButton = nil;
}

#pragma mark - IBActions
-(IBAction)firstButtonPressed:(id)sender {
  [self transitionToState:@"secondState" animated:YES duration:1.0f];
}

-(IBAction)secondButtonPressed:(id)sender {
  [self transitionToState:@"firstState" animated:YES duration:1.0f];
}

@end
