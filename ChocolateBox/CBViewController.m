//
//  CBViewController.m
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBViewController.h"

@interface CBViewController()
@property (nonatomic, retain) CBMachine *machine;
@end

@implementation CBViewController
@synthesize machine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      machine = [[CBMachine alloc] initWithIdentifier:NSStringFromClass([self class])];
  }
  return self;
}

- (void)dealloc {
  [machine release];
  [super dealloc];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  if ([machine respondsToSelector:[invocation selector]]) {
    [invocation invokeWithTarget:machine];
  } else {
    [super forwardInvocation:invocation];
  }
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
  NSMethodSignature* signature = [super methodSignatureForSelector:selector];
  if (!signature) {
    signature = [machine methodSignatureForSelector:selector];
  }
    
  return signature;
}

@end
