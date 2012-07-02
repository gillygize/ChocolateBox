//
//  CBView.h
//  ChocolateBox
//
//  Created by matthew.gillingham on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChocolateBoxProtocol.h"

@interface CBView : UIView <ChocolateBoxUIProtocol>
@end

@interface CBScrollView : UIScrollView <ChocolateBoxUIProtocol>
@end