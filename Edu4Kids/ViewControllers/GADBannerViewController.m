//
//  GADBannerViewController.m
//  Edu4Kids
//
//  Created by CMC Software on 9/8/12.
//
//

#import "GADBannerViewController.h"

#define kSampleAdUnitID @"Thay ID cua Google Adv vao day"

static GADBannerViewController *shared;

@interface GADBannerViewController ()

@end

@implementation GADBannerViewController

+ (GADBannerViewController *)singleton
{
    static dispatch_once_t pred;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[GADBannerViewController alloc] init];
    });
    return shared;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _banner = [[GADBannerView alloc]
                     initWithFrame:CGRectMake(0.0,
                                              0.0,
                                              GAD_SIZE_320x50.width,
                                              GAD_SIZE_320x50.height)];
        // Has an ad request already been made
        isLoaded_ = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    shared = [GADBannerViewController singleton];
    [shared resetAdView:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
