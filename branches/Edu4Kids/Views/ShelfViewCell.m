//
//  ShellViewCell.m
//  Edu4Kids
//
//  Created by CMC Software on 9/8/12.
//
//

#import "ShelfViewCell.h"
#import "EGOImageView.h"

#define NumberOfLessonPerRow 4

@implementation ShelfViewCell

@synthesize delegate = _delegate;
@synthesize img0 = _img0;
@synthesize img1 = _img1;
@synthesize img2 = _img2;
@synthesize img3 = _img3;
@synthesize img4 = _img4;

@synthesize lbl0 = _lbl0;
@synthesize lbl1 = _lbl1;
@synthesize lbl2 = _lbl2;
@synthesize lbl3 = _lbl3;
@synthesize lbl4 = _lbl4;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad2-home_giasach_hang2_ngoai.png"]];
        [self setBackgroundView:imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemOfColumnIndex:(NSInteger)index
{
    if (index > NumberOfLessonPerRow)
    {
        return;
    }
}

- (void)addToRowAnItemWithImageURL:(NSURL *)imageURL
{
    if (_itemCounter >= NumberOfLessonPerRow) {
        return;
    }
    
    
}

- (void)addImageWithURL:(NSURL*)imageURL atIndex:(NSInteger)index
{
    if (index % NumberOfLessonPerRow == 0) {
        [_img0 setImageURL:imageURL];
        [_img0 setTag:(index % NumberOfLessonPerRow)];
    }
    if (index % NumberOfLessonPerRow == 1) {
        [_img1 setImageURL:imageURL];
        [_img1 setTag:(index % NumberOfLessonPerRow)];
    }
    if (index % NumberOfLessonPerRow == 2) {
        [_img2 setImageURL:imageURL];
        [_img2 setTag:(index % NumberOfLessonPerRow)];
    }
    if (index % NumberOfLessonPerRow == 3) {
        [_img3 setImageURL:imageURL];
        [_img3 setTag:(index % NumberOfLessonPerRow)];
    }
//    if (index % 5 == 4) {
//        [_img4 setImageURL:imageURL];
//        [_img4 setTag:(index % 5)];
//    }
}

- (IBAction)cellDidSelectButtonAtIndex:(id)sender
{
    UIButton * button = sender;
    if ([_delegate respondsToSelector:@selector(shellDidSelectItemAtRow:andColumnIndex:)]) {
        [_delegate shelfDidSelectItemAtRow:self andColumnIndex:button.tag];
    }
}

@end
