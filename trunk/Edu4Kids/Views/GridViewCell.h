//
//  GridViewCell.h
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewCellDelegate.h"

@class EGOImageView;

typedef enum
{
    UIGridViewCellAccessoryNone, 
    UIGridViewCellAccessoryBlue,
    UIGridViewCellAccessoryBordered,
    UIGridViewCellAccessorySelected
} UIGridViewCellAccessoryType;

@protocol GridViewCellDataSource <NSObject>

- (UIGridViewCellAccessoryType)accessoryTypeOfGridViewCellAtIndex:(NSInteger)cellIndex;

@end

@interface GridViewCell : UIView <UIGestureRecognizerDelegate>
{
    UIImageView * imageView;
    UILabel * textLabel;
    UIImageView * accessoryImage;
    
    NSInteger rowIndex;
    NSInteger columnIndex;
    NSInteger cellIndex;
    
    BOOL isSelected;
    
    UIGridViewCellAccessoryType accessoryType;
    
    id <GridViewCellDelegate> delegate;
    id <GridViewCellDataSource> dataSource;
}

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel * textLabel;
@property (nonatomic) NSInteger rowIndex;
@property (nonatomic) NSInteger columnIndex;
@property (nonatomic) NSInteger cellIndex;
@property (nonatomic) BOOL isSelected;

@property (unsafe_unretained, nonatomic) id<GridViewCellDelegate> delegate;
@property (unsafe_unretained, nonatomic) id<GridViewCellDataSource> dataSource;
@property (nonatomic, assign) UIGridViewCellAccessoryType accessoryType;

- (void)setFrame:(CGRect)newFrame;
- (void)setImage:(UIImage *)image;

@end
