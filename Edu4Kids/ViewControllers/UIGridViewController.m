//
//  UIGridViewController.m
//  reacticons
//
//  Created by Admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridViewController.h"
#import "DatabaseConnection.h"
#import "MPConstants.h"

@interface UIGridViewController ()

- (void)showMopub:(int)y;
- (void)hideMopub;

@end

@implementation UIGridViewController

@synthesize gridView = _gridView;
@synthesize gridData = _gridData;
@synthesize parentId = _parentId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _gridView = [[UIGridView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44-49)];
//        _gridView = [[UIGridView alloc] initWithFrame:self.view.bounds];
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
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    [self setTitle:@"Be hoc tieng Anh"];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 100)];
    UIImageView * headerBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad2-home-banner_01"]];
    [_headerView addSubview:headerBgImg];
    [self.view addSubview:_headerView];
    _gridView = [[UIGridView alloc] initWithFrame:CGRectMake(0, 100, 1024, 668)];
    [_gridView setDataSource:self];
    [_gridView setDelegate:self];
    [self.view addSubview:_gridView];
    [_gridView setBackgroundColor:[UIColor blackColor]];
//    _banner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
//    [_banner setCenter:self.view.center];
//    [self.view addSubview:_banner];
//    [_banner setDelegate:self];
    [headerBgImg release];
    _adView = [[MPAdView alloc] initWithAdUnitId:DEFAULT_PUB_ID size:MOPUB_LEADERBOARD_SIZE];
    [self showMopub:668];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_gridData == nil)
    {
        _gridData = [[NSMutableArray alloc] init];
    }
    
    [_gridData removeAllObjects];
    _gridData = [[DatabaseConnection readItemsFromEntity:@"ManagedLessons" withConditionString:[NSString stringWithFormat:@"lessonCategory = '%@'", _parentId] sortWithKey:@"lessonName" ascending:YES] retain];
    
    [_gridView reloadData];
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

#pragma mark - Grid View Data Source

- (NSInteger)gridView:(UIGridView*)gridView numberOfCellsPerRowInRow:(NSInteger)rowIndex
{
    return 5;
}

- (NSInteger)numberOfCellsInGridView:(UIGridView *)gridView
{
    return 20;//_gridData.count;
}

- (GridViewCell*)gridView:(UIGridView *)gridView cellAtIndex:(NSInteger)cellIndex
{
    GridViewCell * cell = [_gridView dequeueRecycledView];
    if (cell == nil) {
         cell = [[[GridViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    if (cellIndex % 5 == 0) {
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    else if (cellIndex % 5 == 1)
    {
        [cell setBackgroundColor:[UIColor redColor]];
    }
    else if (cellIndex % 5 == 2)
    {
        [cell setBackgroundColor:[UIColor grayColor]];
    }
    else if (cellIndex % 5 == 3)
    {
        [cell setBackgroundColor:[UIColor redColor]];
    }
    else if (cellIndex % 5 == 4)
    {
        [cell setBackgroundColor:[UIColor grayColor]];
    }

    [cell.textLabel setText:[NSString stringWithFormat:@"ABC - %d", cellIndex]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
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

#pragma mark - Mopub Configuration

- (void)showMopub:(int)y{
    [_adView removeFromSuperview];
    CGRect frame = _adView.frame;
    frame.origin.y = y;
    _adView.frame = frame;
    [self.view insertSubview:_adView atIndex:[self.view.subviews count]];
}

- (void)hideMopub{
    //[_adView removeFromSuperview];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

@end
