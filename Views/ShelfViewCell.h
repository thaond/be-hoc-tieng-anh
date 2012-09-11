//
//  ShellViewCell.h
//  Edu4Kids
//
//  Created by CMC Software on 9/8/12.
//
//

#import <UIKit/UIKit.h>

@class EGOImageView;

@protocol ShelfViewCellDelegate <NSObject>

- (void)shelfDidSelectItemAtRow:(id)cell andColumnIndex:(NSInteger)columnIndex;

@end

@interface ShelfViewCell : UITableViewCell
{
    IBOutlet EGOImageView * _img0;
    IBOutlet EGOImageView * _img1;
    IBOutlet EGOImageView * _img2;
    IBOutlet EGOImageView * _img3;
    IBOutlet EGOImageView * _img4;
    
    IBOutlet UILabel * _lbl0;
    IBOutlet UILabel * _lbl1;
    IBOutlet UILabel * _lbl2;
    IBOutlet UILabel * _lbl3;
    IBOutlet UILabel * _lbl4;
    
    NSInteger _itemCounter;
    
    id<ShelfViewCellDelegate> _delegate;
}

@property (nonatomic, assign) id<ShelfViewCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet EGOImageView * img0;
@property (nonatomic, retain) IBOutlet EGOImageView * img1;
@property (nonatomic, retain) IBOutlet EGOImageView * img2;
@property (nonatomic, retain) IBOutlet EGOImageView * img3;
@property (nonatomic, retain) IBOutlet EGOImageView * img4;

@property (nonatomic, retain) UILabel * lbl0;
@property (nonatomic, retain) UILabel * lbl1;
@property (nonatomic, retain) UILabel * lbl2;
@property (nonatomic, retain) UILabel * lbl3;
@property (nonatomic, retain) UILabel * lbl4;

- (void)setItemOfColumnIndex:(NSInteger)index;

- (void)addToRowAnItemWithImageURL:(NSURL *)imageURL;

- (void)addImageWithURL:(NSURL*)imageURL atIndex:(NSInteger)index;

@end
