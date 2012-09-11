//
//  UIGridViewCell+DownloadImage.h
//  reacticons
//
//  Created by Admin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridViewCell.h"
#import "GridViewCellDelegate.h"

@class DownloadHelper;

@protocol UIGridViewCellDownloadImageDelegate <NSObject, GridViewCellDelegate>

//- (void)downloadFinished:(NSNotification*)notifier;
//
//- (void)downloadFailed;

@end

@interface UIGridViewCell_DownloadImage : GridViewCell
{
    NSString * imageURLString;
    NSString * imageName;
    
    EGOImageView * egoImageView;
    
    DownloadHelper * downloadManager;
    UIActivityIndicatorView * indicatorView;
    
    id<UIGridViewCellDownloadImageDelegate> gridViewCellDownloadImageDelegate;
}

@property (nonatomic, assign) id<UIGridViewCellDownloadImageDelegate> gridViewCellDownloadImageDelegate;
@property (nonatomic, retain) NSString * imageURLString;
@property (nonatomic, readonly) NSString * imageName;
@property (nonatomic, retain) EGOImageView * egoImageView;

- (id)initWithCellIdentity:(NSString *)cellIdentifier;

- (id)initWithFrame:(CGRect)frame;

@end
