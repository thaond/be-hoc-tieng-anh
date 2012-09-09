//
//  YoutubeVideoViewController.m
//  Edu4Kids
//
//  Created by CMC Software on 9/9/12.
//
//

#import "YoutubeVideoViewController.h"

@interface YoutubeVideoViewController ()

@end

@implementation YoutubeVideoViewController

@synthesize videoView = _videoView;
@synthesize linkURL = _linkURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    
    NSURL * url = [NSURL URLWithString:_linkURL];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    [_videoView loadRequest:urlRequest];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
