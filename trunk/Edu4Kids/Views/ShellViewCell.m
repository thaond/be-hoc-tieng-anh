//
//  ShellViewCell.m
//  Edu4Kids
//
//  Created by CMC Software on 9/8/12.
//
//

#import "ShellViewCell.h"
#import "EGOImageView.h"

@implementation ShellViewCell

@synthesize delegate = _delegate;
@synthesize img0 = _img0;
@synthesize img1 = _img1;
@synthesize img2 = _img2;
@synthesize img3 = _img3;
@synthesize img4 = _img4;

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
    if (index > 5)
    {
        return;
    }
}

- (void)addToRowAnItemWithImageURL:(NSURL *)imageURL
{
    if (_itemCounter >= 5) {
        return;
    }
    
    
}

- (void)addImageWithURL:(NSURL*)imageURL atIndex:(NSInteger)index
{
    if (index % 5 == 0) {
        [_img0 setImageURL:imageURL];
        [_img0 setTag:(index % 5)];
    }
    if (index % 5 == 1) {
        [_img1 setImageURL:imageURL];
        [_img1 setTag:(index % 5)];
    }
    if (index % 5 == 2) {
        [_img2 setImageURL:imageURL];
        [_img2 setTag:(index % 5)];
    }
    if (index % 5 == 3) {
        [_img3 setImageURL:imageURL];
        [_img3 setTag:(index % 5)];
    }
    if (index % 5 == 4) {
        [_img4 setImageURL:imageURL];
        [_img4 setTag:(index % 5)];
    }
}

- (IBAction)cellDidSelectButtonAtIndex:(id)sender
{
    UIButton * button = sender;
    if ([_delegate respondsToSelector:@selector(shellDidSelectItemAtRow:andColumnIndex:)]) {
        [_delegate shellDidSelectItemAtRow:self andColumnIndex:button.tag];
    }
}

@end
