//
//  UIGridViewController.h
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "MPAdView.h"

@interface UIGridViewController : UIViewController <UIGridViewDelegate, UIGridViewDataSource,UIScrollViewDelegate, MPAdViewDelegate>
{
    UIGridView * gridView;
    UIView * _headerView;
    NSMutableArray * _gridData;
    NSString * _parentId;
    MPAdView * _adView;
}

@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) UIGridView * gridView;
@property (nonatomic, retain) NSMutableArray * gridData;

@end
