//
//  HomeViewController.m
//  Edu4Kids
//
//  Created by Admin on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "UIGridView.h"
#import "GridViewCell.h"
#import "DatabaseConnection.h"
#import "Lessons.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _gridView = [[UIGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 460-44-49)];
//        _gridView = [[UIGridView alloc] initWithFrame:self.view.bounds];
        _gridData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_gridData release];
    [_gridView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [_gridData removeAllObjects];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_gridView setDataSource:self];
//    [_gridView setDelegate:self];
    [self.view addSubview:_gridView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSInteger)numberOfCellsInGridView:(UIGridView *)gridView
{
    return _gridData.count;
}

- (NSInteger)gridView:(UIGridView *)gridView numberOfCellsPerRowInRow:(NSInteger)rowIndex
{
    return 4;
}

- (GridViewCell*)gridView:(UIGridView *)gridView cellAtIndex:(NSInteger)cellIndex
{
    GridViewCell * cellOfGrid = [_gridView dequeueRecycledView];
    if (cellOfGrid == nil)
    {
        cellOfGrid = [[[GridViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    Lessons * lesson = [_gridData objectAtIndex:cellIndex];
    if (lesson.lessonPhoto != nil) {
        [cellOfGrid setImage:[UIImage imageNamed:lesson.lessonPhoto]];
    }
    
    return cellOfGrid;
}

@end
