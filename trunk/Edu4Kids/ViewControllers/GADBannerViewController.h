//
//  GADBannerViewController.h
//  Edu4Kids
//
//  Created by CMC Software on 9/8/12.
//
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface GADBannerViewController : UIViewController
{
    GADBannerView * _banner;
    BOOL didCloseWebsiteView_;
    BOOL isLoaded_;
    id currentDelegate_;
}

@end
