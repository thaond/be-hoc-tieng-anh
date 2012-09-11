//
//  UIGridViewCell+DownloadImage.m
//  reacticons
//
//  Created by Admin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridViewCell+DownloadImage.h"
#import "DownloadHelper.h"
#import "Utilities.h"
#import "EGOImageView.h"

@implementation UIGridViewCell_DownloadImage

@synthesize gridViewCellDownloadImageDelegate = _gridViewCellDownloadImageDelegate;
@synthesize imageURLString = _imageURLString;
@synthesize imageName = _imageName;
@synthesize egoImageView;

- (id)init
{
    self = [super init];
    if (self) {
        downloadManager = [[DownloadHelper alloc] init];
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicatorView setCenter:self.center];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        downloadManager = [[DownloadHelper alloc] init];
//        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.egoImageView = [[EGOImageView alloc] initWithFrame:frame];
    }
    
    return self;
}

- (id)initWithCellIdentity:(NSString *)cellIdentifier
{
    self = [super initWithCellIdentity:cellIdentifier];
    if (self) {
        downloadManager = [[DownloadHelper alloc] init];
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView setCenter:self.center];
    }
    return self;
}

- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    [self.egoImageView setFrame:CGRectMake(2, 2, newFrame.size.width-4, newFrame.size.height-4)];
    self.imageView = self.egoImageView;
    [self.egoImageView setContentMode:self.imageView.contentMode];
//    [indicatorView setCenter:CGPointMake(newFrame.size.width/2, newFrame.size.height/2)];
}

- (void)setGridViewCellDownloadImageDelegate:(id<UIGridViewCellDownloadImageDelegate>)newGridViewCellDownloadImageDelegate
{
    _gridViewCellDownloadImageDelegate = newGridViewCellDownloadImageDelegate;
    [super setDelegate:_gridViewCellDownloadImageDelegate];
}

- (void)setImageURLString:(NSString *)newImageURLString
{
    // Get image URL
    _imageURLString = [newImageURLString retain];
    
    // Get image file name
    _imageName = [[_imageURLString lastPathComponent] retain];
    
    [self.egoImageView setImageURL:[NSURL URLWithString:newImageURLString]];
    self.imageView = self.egoImageView;
}

//- (void)downloadFinished:(NSNotification *)notifier
//{
//    [gridViewCellDownloadImageDelegate downloadFinished:notifier];
//    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [documentPath stringByAppendingPathComponent:_imageName];
////    [indicatorView removeFromSuperview];
//
//    [self setImage:[Utilities resizedImage:[UIImage imageWithContentsOfFile:filePath] withRect:CGRectMake(0, 0, 100, 100)]]; 
//
////    [self setImage:[UIImage imageWithContentsOfFile:filePath]];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:_imageName object:nil];
//}
//
//- (void)downloadFailed:(NSNotification *)notifier
//{
//    [gridViewCellDownloadImageDelegate downloadFailed];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifier.name object:nil];
//    [TestFlight passCheckpoint:@"download failed: @%"];
////    [indicatorView removeFromSuperview];
//}
//
- (void)dealloc
{
//    [indicatorView release];
//    [downloadManager release];
    [self.egoImageView release];
    [super dealloc];
}

@end
