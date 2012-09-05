//
//  UIGridViewController.h
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"

@interface UIGridViewController : UIViewController <UIGridViewDelegate, UIGridViewDataSource,UIScrollViewDelegate>
{
    UIGridView * gridView;
    NSMutableArray * _gridData;
}

@property (nonatomic, retain) UIGridView * gridView;
@property (nonatomic, retain) NSMutableArray * gridData;

@end
