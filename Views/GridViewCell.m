//
//  GridViewCell.m
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridViewCell.h"
#import "EGOImageView.h"

@implementation GridViewCell

@synthesize imageView = _image;
@synthesize textLabel = _textLabel;
@synthesize rowIndex = _rowIndex;
@synthesize columnIndex = _columnIndex;

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize cellIndex = _cellIndex;
@synthesize accessoryType = _accessoryType;
@synthesize isSelected;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        CGRect frame = self.frame;
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width-4, frame.size.height-4)];
        [_image setContentMode:UIViewContentModeScaleAspectFill];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 , frame.size.height - 27, frame.size.width-4, 27)];
        [_textLabel setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_textLabel setTextAlignment:UITextAlignmentCenter];
        UITapGestureRecognizer * singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                               action:@selector(cellSelected:)];
        [singleTapRecognizer setDelegate:self];
        [singleTapRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapRecognizer];
        
        UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
        [longPressRecognizer setMinimumPressDuration:1];
        [longPressRecognizer setDelegate:self];
        [longPressRecognizer setEnabled:YES];
        [longPressRecognizer setCancelsTouchesInView:NO];
        [self addGestureRecognizer:longPressRecognizer];
        
        accessoryImage = [[UIImageView alloc] initWithFrame:_image.frame];
        [accessoryImage setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.4]];
        [accessoryImage setImage:[UIImage imageNamed:@"checked.png"]];
        [accessoryImage setContentMode:UIViewContentModeCenter];
        [accessoryImage setHidden:YES];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frame = self.frame;
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width-4, frame.size.height-4)];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 , frame.size.height - 27, frame.size.width-4, 27)];
        [_textLabel setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_textLabel setTextAlignment:UITextAlignmentCenter];
        
        UITapGestureRecognizer * singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                               action:@selector(cellSelected:)];
        [singleTapRecognizer setDelegate:self];
        [singleTapRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapRecognizer];
        
        UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
        [longPressRecognizer setMinimumPressDuration:1];
        [longPressRecognizer setDelegate:self];
        [longPressRecognizer setEnabled:YES];
        [longPressRecognizer setCancelsTouchesInView:NO];
        [self addGestureRecognizer:longPressRecognizer];
        
        accessoryImage = [[UIImageView alloc] initWithFrame:_image.frame];
        [accessoryImage setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.4]];
        [accessoryImage setImage:[UIImage imageNamed:@"checked.png"]];
        [accessoryImage setContentMode:UIViewContentModeCenter];
        accessoryType = UIGridViewCellAccessoryNone;
        [accessoryImage setHidden:YES];
    }
    return self;
}

- (void)dealloc
{
    [_image release];
    [_textLabel release];
    [accessoryImage release];
    [super dealloc];
}

- (void)cellSelected:(id)sender
{
    self.isSelected = !self.isSelected;
    if ([_dataSource respondsToSelector:@selector(accessoryTypeOfGridViewCellAtIndex:)]) {
        accessoryType = [_dataSource accessoryTypeOfGridViewCellAtIndex:cellIndex];
    }
    if (self.isSelected) {
        switch (accessoryType) {
            case UIGridViewCellAccessoryBlue:
                [self setBackgroundColor:[UIColor blueColor]];
                [accessoryImage setHidden:YES];
                break;
                
            case UIGridViewCellAccessorySelected:
                [accessoryImage setHidden:NO];
                [self setBackgroundColor:[UIColor clearColor]];
                break;
                
            case UIGridViewCellAccessoryNone:
                [self setBackgroundColor:[UIColor clearColor]];
                [accessoryImage setHidden:YES];
                break;
                
            case UIGridViewCellAccessoryBordered:
                break;
                
            default:
                break;
        }
    }
    else
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [accessoryImage setHidden:YES];
    }
    [_delegate gridViewDidSeletedAtCell:self];
}

- (void)cellLongPressed:(id)sender
{
    [_delegate gridViewDidLongPressedAtCell:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for (UIView * subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self addSubview:_image];
    [self addSubview:_textLabel];
    [self addSubview:accessoryImage];
    if (!isSelected) {
        [self setBackgroundColor:[UIColor clearColor]];
        [accessoryImage setHidden:YES];
    }
    else {
        switch (accessoryType) {
            case UIGridViewCellAccessoryBlue:
                [self setBackgroundColor:[UIColor blueColor]];
                [accessoryImage setHidden:YES];
                break;
                
            case UIGridViewCellAccessorySelected:
                [accessoryImage setHidden:NO];
                [self setBackgroundColor:[UIColor clearColor]];
                break;
                
            case UIGridViewCellAccessoryNone:
                [self setBackgroundColor:[UIColor clearColor]];
                [accessoryImage setHidden:YES];
                break;
                
            case UIGridViewCellAccessoryBordered:
                break;
                
            default:
                break;
        }
    }
}

- (void)setCellIndex:(NSInteger)newCellIndex
{
    _cellIndex = newCellIndex;
}

- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    [_image setFrame:CGRectMake(2, 2, newFrame.size.width-4, newFrame.size.height-4)];
    [_textLabel setFrame:CGRectMake(2 , newFrame.size.height - 23, newFrame.size.width - 4, 21)];
    [accessoryImage setFrame:_image.frame];
}

- (void)setAccessoryType:(UIGridViewCellAccessoryType)newAccessoryType
{
    accessoryType = newAccessoryType;
    if (!isSelected) {
        [self setBackgroundColor:[UIColor clearColor]];
        [accessoryImage setHidden:YES];
    }
    else {
        switch (accessoryType) {
            case UIGridViewCellAccessoryBlue:
                [self setBackgroundColor:[UIColor blueColor]];
                [accessoryImage setHidden:YES];
                break;
                
            case UIGridViewCellAccessorySelected:
                [accessoryImage setHidden:NO];
                [self setBackgroundColor:[UIColor clearColor]];
                break;
                
            case UIGridViewCellAccessoryNone:
                [self setBackgroundColor:[UIColor clearColor]];
                [accessoryImage setHidden:YES];
                break;
                
            case UIGridViewCellAccessoryBordered:
                break;
                
            default:
                break;
        }
    }
}

- (void)setImage:(UIImage *)image
{
    [_image setImage:image];
}

@end
