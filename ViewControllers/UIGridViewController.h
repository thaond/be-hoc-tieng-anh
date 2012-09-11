//
//  UIGridViewController.h
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPAdView.h"
#import "ShelfViewCell.h"
#import "GADBannerView.h"

@interface UIGridViewController : UIViewController <UIScrollViewDelegate, MPAdViewDelegate, UITableViewDataSource, UITableViewDelegate, ShelfViewCellDelegate>
{
    UITableView * _tableView;
    UIView * _headerView;
    NSMutableArray * _gridData;
    NSMutableArray * _tableData;
    NSString * _parentId;
    MPAdView * _adView;
    
    GADBannerView * _banner;
    BOOL isLoaded_;
    id currentDelegate_;
}

@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSMutableArray * gridData;

@end
