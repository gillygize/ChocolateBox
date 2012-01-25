//
//  CBViewController.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBMachine+UIKit.h"

@interface CBViewController : UIViewController <ChocolateBoxUIProtocol> {
@private
  CBMachine *machine;
}

@end
