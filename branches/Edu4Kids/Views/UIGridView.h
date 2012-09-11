//
//  UIGridView.h
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell+DownloadImage.h"

@class GridViewCellDelegate;
@class UIGridView;

@protocol UIGridViewDelegate <NSObject, UIScrollViewDelegate>

@optional

// Display customization

- (void)gridView:(UIGridView *)gridView willDisplayCell:(GridViewCell *)cell forRowAtIndex:(NSInteger)rowIndex andColumnAtIndex:(NSInteger)columnIndex;

// Accessories (disclosures). 
- (void)gridView:(UIGridView *)gridView didLongPressCellAtIndex:(NSInteger)cellIndex;

- (UITableViewCellAccessoryType)gridView:(UIGridView *)gridView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0);
- (void)gridView:(UIGridView *)gridView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)gridView:(UIGridView *)gridView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)gridView:(UIGridView *)gridView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Called after the user changes the selection.
- (void)gridView:(UIGridView*)gridView didSelectedCellAtIndex:(NSInteger)cellIndex;

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)gridView:(UIGridView *)gridView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)gridView:(UIGridView *)gridView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)gridView:(UIGridView *)gridView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)gridView:(UIGridView *)gridView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gridView:(UIGridView *)gridView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (void)gridView:(UIGridView *)gridView targetIndexCellForMoveFromIndexCell:(NSInteger)sourceIndexCell toProposedIndexCell:(NSInteger)proposedDestinationIndexCell;

// Indentation

- (NSInteger)gridView:(UIGridView *)gridView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)gridView:(UIGridView *)gridView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (BOOL)gridView:(UIGridView *)gridView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)gridView:(UIGridView *)gridView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);

// Scrolling Delegate

- (void)gridViewDidScroll:(UIGridView*)gridView;

@end

@protocol UIGridViewDataSource <NSObject>

@required
- (GridViewCell*)gridView:(UIGridView*)gridView cellAtIndex:(NSInteger)cellIndex;

- (NSInteger)gridView:(UIGridView*)gridView numberOfCellsPerRowInRow:(NSInteger)rowIndex;

- (NSInteger)numberOfCellsInGridView:(UIGridView*)gridView;

@optional
- (BOOL)gridView:(UIGridView*)gridView canMoveAtRow:(NSInteger)row andColumn:(NSInteger)column;

- (BOOL)canPerformLongPressInGridView:(UIGridView*)gridView;

// Variable height support

- (CGFloat)gridView:(UIGridView *)gridView heightForRowAtIndex:(NSInteger)rowIndex;

- (NSString *)gridView:(UIGridView *)gridView imageURLStringOfCellAtIndex:(NSInteger)cellIndex;

@end


@interface UIGridView : UIScrollView <NSCoding, GridViewCellDelegate, GridViewCellDataSource>
{
    UIView * headerView;
    
    NSMutableSet * visibleViews;
    NSMutableSet * recycledViews;
    
    NSMutableArray * gridData;
    NSMutableArray * cellIDArray;
    
    NSUInteger capacityPerType;
    
    NSMutableDictionary * allViews;
    
    NSInteger numberOfRows;
    NSInteger numberOfColumns;
    NSInteger numberOfCells;
    
    int firstNeededViewIndex;
    int lastNeededViewIndex;
    
    CGFloat cellWidth;
    CGFloat cellHeight;
    CGFloat headerHeight;
    
    NSInteger moveFromCellIndex;
    NSInteger moveToCellIndex;
    NSInteger selectedCellIndex;
    
    BOOL enableLongPress;
    BOOL enableMultipleSelection;
    BOOL enableReOrderring;
    
    id<UIGridViewDataSource> dataSource;
    id<UIGridViewDelegate> delegate;
}

@property (unsafe_unretained, nonatomic) id<UIGridViewDataSource> dataSource;
@property (assign, nonatomic) id<UIGridViewDelegate> delegate;
@property (nonatomic, assign) BOOL enableMultipleSelection;
@property (nonatomic, assign) BOOL enableReOrderring;

- (void)reloadData;

- (GridViewCell *)cellAtIndex:(NSInteger)cellIndex;

- (GridViewCell *)dequeueRecycledView;

- (void)tileViews;

- (void)setHeaderView:(UIView *)newHeaderView;

@end
