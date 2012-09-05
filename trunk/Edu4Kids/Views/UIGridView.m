//
//  UIGridView.m
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridView.h"

@interface UIGridView (internal)

- (BOOL)isDisplayingCellForIndex:(NSInteger)index;
- (void)tileViewsWithRefresh:(BOOL)refresh;

@end

@implementation UIGridView

@synthesize dataSource = _dataSource;
@synthesize delegate;
@synthesize enableMultipleSelection = _enableMultipleSelection;
@synthesize enableReOrderring = _enableReOrderring;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        gridData = [[NSMutableArray alloc] init];
        moveFromCellIndex = -1;
        visibleViews= [[NSMutableSet alloc] init];
        recycledViews=[[NSMutableSet alloc] init];
        super.delegate = self;
        selectedCellIndex = -1;
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString*)identifier
{
    self = [super init];
    if (self) {
        // Initialization code
        gridData = [[NSMutableArray alloc] init];
        moveFromCellIndex = -1;
        visibleViews= [[NSMutableSet alloc] init];
        recycledViews=[[NSMutableSet alloc] init];
        selectedCellIndex = -1;
    }
    
    return self;
}

- (void)dealloc
{
    [gridData release];
    visibleViews=nil;
    [visibleViews release];
    recycledViews=nil;
    [recycledViews release];
    [headerView release];
    [super dealloc];
}

#pragma mark - Life Cycle

// Must implement this method to have respondsToSelector of Data Soure Delegate
- (void)setDataSource:(id<UIGridViewDataSource>)newDataSource
{
    dataSource = newDataSource;
}

- (void)setDelegate:(id<UIGridViewDelegate>)newDelegate
{
    delegate = newDelegate;
    
}

- (void)setEnableMultipleSelection:(BOOL)newEnableMultipleSelection
{
    _enableMultipleSelection = newEnableMultipleSelection;
}

- (GridViewCell *)cellAtIndex:(NSInteger)cellIndex
{
    int row = cellIndex / numberOfColumns;
    int col = cellIndex % numberOfColumns;

    GridViewCell * cell = [dataSource gridView:self cellAtIndex:cellIndex];
    [cell setFrame:CGRectMake(col * cellWidth, 
                              row * cellHeight + headerHeight + 1, 
                              cellWidth, 
                              cellHeight)];
    return cell;
}

- (void)setHeaderView:(UIView *)newHeaderView
{
    if (headerView) {
        [headerView removeFromSuperview];
    }
    else
        headerView = [[UIView alloc] init];
    headerView = newHeaderView;
    [self addSubview:headerView];
    headerHeight = headerView.frame.size.height;
}

#pragma mark - Draw and Re-draw Grid View

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if ([dataSource respondsToSelector:@selector(numberOfCellsInGridView:)]) 
    {
        numberOfCells = [dataSource numberOfCellsInGridView:self];
    }
    if (numberOfCells <= 0) {
        return;
    }
    if ([dataSource respondsToSelector:@selector(gridView:numberOfCellsPerRowInRow:)])
    {
        numberOfColumns = [dataSource gridView:self numberOfCellsPerRowInRow:0];
    }
    if (numberOfCells % numberOfColumns > 0) {
        numberOfRows = numberOfCells / numberOfColumns + 1;
    }
    else {
        numberOfRows = numberOfCells / numberOfColumns;
    }
    
    cellWidth = 320 / numberOfColumns;
    cellHeight = cellWidth * 3.0 / 4;
    
    if ([dataSource respondsToSelector:@selector(gridView:heightForRowAtIndex:)]) {
        cellHeight = [dataSource gridView:self heightForRowAtIndex:0];
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, cellHeight * numberOfRows + headerHeight)];
    
    if ([dataSource respondsToSelector:@selector(canPerformLongPressInGridView:)]) {
        enableLongPress = [dataSource canPerformLongPressInGridView:self];
    }
    
    [self tileViews];
}

- (void)reloadData
{
    [visibleViews removeAllObjects];
    [visibleViews release];
    visibleViews=nil;
    visibleViews = [[NSMutableSet alloc] init];
    [recycledViews removeAllObjects];
    [recycledViews release];
    recycledViews=nil;
    recycledViews = [[NSMutableSet alloc] init];
    
    if ([dataSource respondsToSelector:@selector(numberOfCellsInGridView:)]) 
    {
        numberOfCells = [dataSource numberOfCellsInGridView:self];
    }
    if ([dataSource respondsToSelector:@selector(gridView:numberOfCellsPerRowInRow:)])
    {
        numberOfColumns = [dataSource gridView:self numberOfCellsPerRowInRow:0];
    }
    if (numberOfCells % numberOfColumns > 0) {
        numberOfRows = numberOfCells / numberOfColumns + 1;
    }
    else {
        numberOfRows = numberOfCells / numberOfColumns;
    }
    
    cellWidth = 320 / numberOfColumns;
    cellHeight = cellWidth * 3.0 / 4;
    
    if ([dataSource respondsToSelector:@selector(gridView:heightForRowAtIndex:)]) {
        cellHeight = [dataSource gridView:self heightForRowAtIndex:0];
    }
    
   
    if ([dataSource respondsToSelector:@selector(canPerformLongPressInGridView:)]) {
        enableLongPress = [dataSource canPerformLongPressInGridView:self];
    }
    for (GridViewCell *cell in self.subviews) {
        [cell removeFromSuperview];
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, cellHeight * numberOfRows + headerHeight)];
//    [self scrollRectToVisible:CGRectMake(0, self.contentSize.height-self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:NO];

    [self addSubview:headerView];
    
    [self tileViewsWithRefresh:YES];
}

- (void)tileViewsWithRefresh:(BOOL)refresh
{
	CGRect visibleBounds = self.bounds;
    
    firstNeededViewIndex = floorf(CGRectGetMinY(visibleBounds) / cellHeight - 1-1) * numberOfColumns;
    lastNeededViewIndex = (floorf(CGRectGetMaxY(visibleBounds) / cellHeight) + 1 + 1) * numberOfColumns - 1;    
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex = MIN(lastNeededViewIndex, numberOfCells - 1);
    
    // Recycle no-longer-needed views
    for (GridViewCell * cell in visibleViews) {
        if (cell.cellIndex < firstNeededViewIndex || cell.cellIndex > lastNeededViewIndex)
        {
            [recycledViews addObject:cell];
            [cell removeFromSuperview];
        }
    }
    [visibleViews minusSet:recycledViews];
    
    // add missing views
    for (int index = firstNeededViewIndex; index <= lastNeededViewIndex; index++) {
        if (![self isDisplayingCellForIndex:index]) {
            GridViewCell * cell = [self dequeueRecycledView];
            if (cell == nil) {
                cell = [[[GridViewCell alloc] init] autorelease];
            }
            int row = index / numberOfColumns;
            int col = index % numberOfColumns;
            cell = [dataSource gridView:self cellAtIndex:index];
            [cell setFrame:CGRectMake(col * cellWidth, 
                                      row * cellHeight + headerHeight + 1, 
                                      cellWidth, 
                                      cellHeight)];
            if (refresh) {
                [cell setIsSelected:NO];
            }
            [cell setCellIndex:index];
            [cell setDelegate:self];
            [cell setDataSource:self];
            [self addSubview:cell];
            [visibleViews addObject:cell];
        }
    }
}

- (void)tileViews
{
    [self tileViewsWithRefresh:NO];
}

- (GridViewCell *)dequeueRecycledView
{
    GridViewCell * cell = [recycledViews anyObject];
    if (cell) {
        [[cell retain] autorelease];
        [recycledViews removeObject:cell];
    }
    
    return cell;
}

- (BOOL)isDisplayingCellForIndex:(NSInteger)index
{
    BOOL foundPage = NO;
    for (GridViewCell *cell in visibleViews) {
        if (cell.cellIndex == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

#pragma mark - NSCoding Delegate

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return nil;
}

#pragma mark - Grid View Cell Delegate

- (void)gridViewDidSeletedAtCell:(GridViewCell *)selectedCell
{
    if (!_enableMultipleSelection && !_enableReOrderring)
    {
        if (selectedCellIndex >= 0) {
            if (selectedCellIndex >= firstNeededViewIndex && selectedCellIndex <= lastNeededViewIndex) {
                for (GridViewCell * cell in visibleViews) {
                    if (selectedCell.cellIndex == cell.cellIndex) {
                        [cell setIsSelected:YES];
                    }
                    else
                        [cell setIsSelected:NO];
                }
            }
        }
        selectedCellIndex = selectedCell.cellIndex;
        [delegate gridView:self didSelectedCellAtIndex:selectedCell.cellIndex];
    }
    else if (_enableMultipleSelection)
    {
        selectedCellIndex = selectedCell.cellIndex;
        [delegate gridView:self didSelectedCellAtIndex:selectedCell.cellIndex];
    }
    else if (_enableReOrderring)
    {
        if (moveFromCellIndex == -1) {
            moveFromCellIndex = selectedCell.cellIndex;
            [selectedCell setAccessoryType:UIGridViewCellAccessorySelected];
        }
        else
        {
            [delegate gridView:self targetIndexCellForMoveFromIndexCell:moveFromCellIndex toProposedIndexCell:selectedCell.cellIndex];
            moveFromCellIndex = -1;
        }
    }
}

- (void)gridViewDidLongPressedAtCell:(GridViewCell *)selectedCell
{
    //    [selectedCell setAccessoryType:UIGridViewCellAccessorySelected];
    [delegate gridView:self didLongPressCellAtIndex:selectedCell.cellIndex];
}

#pragma mark - Grid View Cell Data Source

- (UIGridViewCellAccessoryType)accessoryTypeOfGridViewCellAtIndex:(NSInteger)cellIndex
{
    if (_enableMultipleSelection) {
        return UIGridViewCellAccessorySelected;
    }
    return UIGridViewCellAccessoryNone;
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self tileViews];
    if ([self.delegate respondsToSelector:@selector(gridViewDidScroll:)])
        [self.delegate gridViewDidScroll:self];
}

@end
