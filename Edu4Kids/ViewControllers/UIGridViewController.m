//
//  UIGridViewController.m
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridViewController.h"

@implementation UIGridViewController

@synthesize gridView = _gridView;
@synthesize gridData = _gridData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _gridView = [[UIGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 460-44-49)];
        _gridView = [[UIGridView alloc] initWithFrame:self.view.bounds];
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
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_gridView setBackgroundColor:[UIColor blackColor]];
    [_gridView setDataSource:self];
    [_gridView setDelegate:self];
    [self.view addSubview:_gridView];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Grid View Data Source

- (NSInteger)gridView:(UIGridView*)gridView numberOfCellsPerRowInRow:(NSInteger)rowIndex
{
    return 5;
}

- (NSInteger)numberOfCellsInGridView:(UIGridView *)gridView
{
    return _gridData.count;
}

- (GridViewCell*)gridView:(UIGridView *)gridView cellAtIndex:(NSInteger)cellIndex
{
    GridViewCell * cell = [_gridView dequeueRecycledView];
    if (cell == nil) {
         cell = [[[GridViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    if (cellIndex % 3 == 0) {
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    else if (cellIndex % 3 == 1)
    {
        [cell setBackgroundColor:[UIColor redColor]];
    }
    else if (cellIndex % 3 == 2)
    {
        [cell setBackgroundColor:[UIColor grayColor]];
    }

    [cell.textLabel setText:[NSString stringWithFormat:@"ABC - %d", cellIndex]];
    [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
    [cell.imageView setImage:[UIImage imageNamed:@"background.png"]];
    
    return cell;
}

#pragma mark - Grid View Delegate

- (void)gridView:(UIGridView *)gridView didSelectedCellAtIndex:(NSInteger)cellIndex
{
    
}

- (void)gridView:(UIGridView *)gridView didSelectRowAtIndex:(NSInteger)rowIndex andColumnAtIndex:(NSInteger)columnIndex
{
    
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
