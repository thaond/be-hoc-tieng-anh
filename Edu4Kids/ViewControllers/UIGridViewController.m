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
#import "ShellViewCell.h"
#import "YoutubeVideoViewController.h"

#define LessonCategory  @"category"
#define LessonLink      @"link"
#define LessonVideo     @"video"
#define LessonAudio     @"audio"
#define LessonPhoto     @"photo"

#define kSampleAdUnitID @"a1504c824b46835"

@interface UIGridViewController ()

- (void)showMopub:(int)y;
- (void)hideMopub;

@end

@implementation UIGridViewController

@synthesize gridData = _gridData;
@synthesize parentId = _parentId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 1024, 648) style:UITableViewStylePlain];
        _tableData = [[NSMutableArray alloc] init];
        
        _banner = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(1024 - GAD_SIZE_728x90.width,
                                            768 - 20 - 90,
                                            GAD_SIZE_728x90.width,
                                            GAD_SIZE_728x90.height)];
        isLoaded_ = NO;
    }
    return self;
}

- (void)dealloc
{
    [_tableData release];
    [_tableView release];
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
    
    // TODO: configure Data of View
    _tableData = [[DatabaseConnection readItemsFromEntity:@"ManagedLessons" withConditionString:[NSString stringWithFormat:@"lessonCategory = '%@'", _parentId] sortWithKey:@"lessonName" ascending:YES] retain];
    
    for (NSMutableDictionary * dict in _tableData) {
        NSLog(@"%@ %@,", [dict valueForKey:@"lessonId"], [dict valueForKey:@"lessonPhoto"]);
    }

    // TODO: configure Header View with Title
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 100)];
    UIImageView * headerBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad2-home-banner_01"]];
    [_headerView addSubview:headerBgImg];
    // TODO: add back button to view
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(500, 0, 73, 100)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"menu_1.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonWasClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:backButton];
    
    [self.view addSubview:_headerView];
    
    
    //TODO: configure table view
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    // TODO: add Banner for Advertising
    _adView = [[MPAdView alloc] initWithAdUnitId:DEFAULT_PUB_ID size:MOPUB_LEADERBOARD_SIZE];
    _adView.delegate = self;
    [_adView loadAd];
    [self showMopub:668];
    
    [headerBgImg release];
//    [backButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self resetAdView:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table View Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 216;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((_tableData.count / 5) > 3 ? _tableData.count/5 : 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ShellItemID";
    ShellViewCell * cell = (ShellViewCell*)[_tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[ShellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ShellViewCell" owner:nil options:nil];
        cell = (ShellViewCell*)[nib objectAtIndex:0];
    }
    
    for (int i = 0; i < 5; i++) {
        if (indexPath.row * 5 + i < _tableData.count)
        {
            NSMutableDictionary * lessonDict = [[NSMutableDictionary alloc] init];
            lessonDict = [[_tableData objectAtIndex:(indexPath.row * 5 + i)] retain];
            NSString * lessonPhoto = [lessonDict valueForKey:@"lessonPhoto"];
            NSLog(@"Lesson Photo: %@", lessonPhoto);
            if (![[lessonDict valueForKey:@"lessonPhoto"] isEqualToString:@""])
            {
                if (i == 0)
                {
                    [cell.img0 setImage:[UIImage imageNamed:[lessonDict valueForKey:@"lessonPhoto"]]];
                }
                else if (i == 1)
                {
                    [cell.img1 setImage:[UIImage imageNamed:[lessonDict valueForKey:@"lessonPhoto"]]];
                }
                else if (i == 2)
                {
                    [cell.img2 setImage:[UIImage imageNamed:[lessonDict valueForKey:@"lessonPhoto"]]];
                }
                else if (i == 3)
                {
                    [cell.img3 setImage:[UIImage imageNamed:[lessonDict valueForKey:@"lessonPhoto"]]];
                }
                else if (i == 4)
                {
                    [cell.img4 setImage:[UIImage imageNamed:[lessonDict valueForKey:@"lessonPhoto"]]];
                }
                [cell setDelegate:self];
            }
            else
            {
                if (i == 0)
                {
                    [cell.img0 setImage:[UIImage imageNamed:@"Cover1-0.png"]];
                }
                else if (i == 1)
                {
                    [cell.img1 setImage:[UIImage imageNamed:@"Cover1-0.png"]];
                }
                else if (i == 2)
                {
                    [cell.img2 setImage:[UIImage imageNamed:@"Cover1-0.png"]];
                }
                else if (i == 3)
                {
                    [cell.img3 setImage:[UIImage imageNamed:@"Cover1-0.png"]];
                }
                else if (i == 4)
                {
                    [cell.img4 setImage:[UIImage imageNamed:@"Cover1-0.png"]];
                }
                [cell setDelegate:self];
            }
            [lessonDict release];
        }
    }
    
    
    return cell;
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

#pragma mark - Shell View Cell Delegate

- (void)shellDidSelectItemAtRow:(id)cell andColumnIndex:(NSInteger)columnIndex
{
    ShellViewCell * shellRow = cell;
    NSIndexPath * indexPath = [_tableView indexPathForCell:shellRow];
    
    NSInteger cellIndex = indexPath.row * 5 + columnIndex;
    
    NSLog(@"Row %d and column %d, cell index %d of %d ", indexPath.row, columnIndex, cellIndex, _tableData.count);

    NSMutableDictionary * lessonDict = [[[NSMutableDictionary alloc] init] autorelease];
    lessonDict = [_tableData objectAtIndex:cellIndex];
    
    NSLog(@"Type: %@", [lessonDict valueForKey:@"lessonType"]);
    
    if ([[lessonDict valueForKey:@"lessonType"] isEqualToString:LessonCategory])
    {
        UIGridViewController * categoryDetailView = [[[UIGridViewController alloc] init] autorelease];
        [categoryDetailView setParentId:[lessonDict valueForKey:@"lessonId"]];
        [self.navigationController pushViewController:categoryDetailView animated:YES];
    }
    else if ([[lessonDict valueForKey:@"lessonType"] isEqualToString:LessonLink])
    {
        YoutubeVideoViewController * videoView = [[[YoutubeVideoViewController alloc] init] autorelease];
        [videoView setLinkURL:[lessonDict valueForKey:@"lessonURL"]];
        [self.navigationController pushViewController:videoView animated:YES];
    }
}

- (void)buttonWasClicked:(id)sender
{
//    GADBannerViewController * GADView = [[GADBannerViewController alloc] init];
//    [self.navigationController pushViewController:GADView animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)resetAdView:(UIViewController *)rootViewController {
    // Always keep track of currentDelegate for notification forwarding
    currentDelegate_ = rootViewController;
    
    // Ad already requested, simply add it into the view
    if (isLoaded_) {
        [rootViewController.view addSubview:_banner];
    } else {
        
        _banner.delegate = self;
        _banner.rootViewController = rootViewController;
        _banner.adUnitID = kSampleAdUnitID;
        
        GADRequest *request = [GADRequest request];
        [_banner loadRequest:request];
        [rootViewController.view addSubview:_banner];
        isLoaded_ = YES;
    }
}

@end
