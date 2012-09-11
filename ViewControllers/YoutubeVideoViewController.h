//
//  YoutubeVideoViewController.h
//  Edu4Kids
//
//  Created by CMC Software on 9/9/12.
//
//

#import <UIKit/UIKit.h>

@interface YoutubeVideoViewController : UIViewController
{
    IBOutlet UIWebView * _videoView;
    NSString * _linkURL;
}

@property (nonatomic, retain) UIWebView * videoView;
@property (nonatomic, retain) NSString * linkURL;

@end
