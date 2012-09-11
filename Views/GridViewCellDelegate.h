//
//  GridViewCellDelegate.h
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridViewCell;

@protocol GridViewCellDelegate <NSObject>

//- (void)gridViewCellSeletedAtIndex:(NSInteger)cellIndex;

@optional
- (void)gridViewDidSeletedAtCell:(GridViewCell *)selectedCell;

- (void)gridViewDidLongPressedAtCell:(GridViewCell *)selectedCell;

@end
