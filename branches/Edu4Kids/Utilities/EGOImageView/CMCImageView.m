//
//  EGOImageView.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 9/15/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CMCImageView.h"
#import "Utilities.h"
@implementation CMCImageView
@synthesize imageURL, placeholderImage, delegate;

- (id)initWithPlaceholderImage:(UIImage*)anImage {
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<CMCImageViewDelegate>)aDelegate {
	if((self = [super initWithImage:anImage])) {
		self.placeholderImage = anImage;
		self.delegate = aDelegate;
	}
	
	return self;
}

- (void)setImageURL:(NSURL *)aURL {
	if(imageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		[imageURL release];
		imageURL = nil;
	}
	
	if(!aURL) {
//		self.image = self.placeholderImage;
//        [self setContentMode:UIViewContentModeCenter];
        self.animationImages=[NSArray arrayWithObjects:
                              [UIImage imageNamed:@"out0.png"],
                              [UIImage imageNamed:@"out1.png"],
                              [UIImage imageNamed:@"out2.png"],
                              [UIImage imageNamed:@"out3.png"],
                              [UIImage imageNamed:@"out4.png"],
                              [UIImage imageNamed:@"out5.png"],
                              [UIImage imageNamed:@"out6.png"],
                              [UIImage imageNamed:@"out7.png"],
                              nil];
        self.animationDuration=1.0f;
        self.animationRepeatCount=0;
        [self startAnimating];
		imageURL = nil;
		return;
	} else {
		imageURL = [aURL retain];
	}
    
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
	
	if(anImage) {
        [self stopAnimating];
		self.image = [Utilities cropImage:anImage withSize:CGSizeMake(200, 200)];

		// trigger the delegate callback if the image was found in the cache
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
			[self.delegate imageViewLoadedImage:self];
		}
	} else {
        self.animationImages=[NSArray arrayWithObjects:
                              [UIImage imageNamed:@"out0.png"],
                              [UIImage imageNamed:@"out1.png"],
                              [UIImage imageNamed:@"out2.png"],
                              [UIImage imageNamed:@"out3.png"],
                              [UIImage imageNamed:@"out4.png"],
                              [UIImage imageNamed:@"out5.png"],
                              [UIImage imageNamed:@"out6.png"],
                              [UIImage imageNamed:@"out7.png"],
                              nil];
        self.animationDuration=1.0f;
        self.animationRepeatCount=0;
        [self startAnimating];
//		self.image = self.placeholderImage;
	}
}

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad {
	[[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification {
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;

	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
    [self stopAnimating];
    self.image = [Utilities cropImage:anImage withSize:CGSizeMake(200, 200)];

	[self setNeedsDisplay];
	
	if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
		[self.delegate imageViewLoadedImage:self];
	}	
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if([self.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)]) {
		[self.delegate imageViewFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
	}
}

#pragma mark -
- (void)dealloc {
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	self.delegate = nil;
	self.imageURL = nil;
	self.placeholderImage = nil;
    [super dealloc];
}

@end
