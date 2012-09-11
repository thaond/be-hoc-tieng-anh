//
//  EGOCropImageView.h
//  reacticons
//
//  Created by Admin on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EGOImageView.h"

@interface EGOCropImageView : EGOImageView
{
    CGRect _croppedRect;
    CGSize _croppedSize;
    NSMutableArray * _URLList;
    NSMutableArray * _cropList;
}

@property (nonatomic, assign) CGRect croppedRect;
@property (nonatomic, assign) CGSize croppedSize;

- (void)setImageURL:(NSURL *)imageURL;
- (void)setCroppedRect:(CGRect)croppedRect;

@end
