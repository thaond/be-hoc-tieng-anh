//
//  ShellViewCell.h
//  Edu4Kids
//
//  Created by CMC Software on 9/8/12.
//
//

#import <UIKit/UIKit.h>

@class EGOImageView;

@protocol ShellViewCellDelegate <NSObject>

- (void)shellDidSelectItemAtRow:(id)cell andColumnIndex:(NSInteger)columnIndex;

@end

@interface ShellViewCell : UITableViewCell
{
    IBOutlet EGOImageView * _img0;
    IBOutlet EGOImageView * _img1;
    IBOutlet EGOImageView * _img2;
    IBOutlet EGOImageView * _img3;
    IBOutlet EGOImageView * _img4;
    
    NSInteger _itemCounter;
    
    id<ShellViewCellDelegate> _delegate;
}

@property (nonatomic, assign) id<ShellViewCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet EGOImageView * img0;
@property (nonatomic, retain) IBOutlet EGOImageView * img1;
@property (nonatomic, retain) IBOutlet EGOImageView * img2;
@property (nonatomic, retain) IBOutlet EGOImageView * img3;
@property (nonatomic, retain) IBOutlet EGOImageView * img4;

- (void)setItemOfColumnIndex:(NSInteger)index;

- (void)addToRowAnItemWithImageURL:(NSURL *)imageURL;

- (void)addImageWithURL:(NSURL*)imageURL atIndex:(NSInteger)index;

@end
