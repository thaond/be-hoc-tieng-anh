//
//  HomeViewController.h
//  Edu4Kids
//
//  Created by Admin on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"

@interface HomeViewController : UIViewController <UIGridViewDataSource, UIGridViewDelegate>
{
    UIGridView * _gridView;
    NSMutableArray * _gridData;
}

@end
