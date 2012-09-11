//
//  EGOCropImageView.m
//  reacticons
//
//  Created by Admin on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EGOCropImageView.h"
#import "Utilities.h"
#import "EGOCache.h"

@implementation EGOCropImageView

@synthesize croppedRect = _croppedRect;
@synthesize croppedSize = _croppedSize;

- (void)setImageURL:(NSURL *)imageURL
{
    NSString * fileName = [imageURL lastPathComponent];
    NSArray * fileNameArray = [fileName componentsSeparatedByString:@"."];
    fileName = @"";
    
    for (int i = 0; i < fileNameArray.count - 1; i++)
    {
        fileName = [NSString stringWithFormat:@"%@%@", fileName, [fileNameArray objectAtIndex:0]];
    }
    
    fileName = [NSString stringWithFormat:@"%@_%@.%@", fileName, 
                [_cropList objectAtIndex:0], 
                [fileNameArray objectAtIndex:(fileNameArray.count-1)]];
    
    UIImage * anImage = [UIImage imageWithContentsOfFile:fileName];
    
    if (anImage) {
        [self setImage:anImage];
        return;
    }
    
    [super setImageURL:imageURL];
    
    if (!_URLList) {
        _URLList = [[NSMutableArray alloc] init];
    }
    
    [_URLList removeAllObjects];
    [_URLList addObject:imageURL];
    
    if (_cropList.count > 0) {
        for (NSString * extString in _cropList)
        {
            [_URLList addObject:[NSString stringWithFormat:@"%@_%@", imageURL, extString]];
        }
    }
}

- (void)imageLoaderDidLoad:(NSNotification *)notification
{
//    NSLog(@"EGOCropImageView - imageLoaderDidLoad");
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL])
        return;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];

    if (_cropList.count > 0) {
//        NSLog(@"EGOCropImageView - imageLoaderDidLoad - %d",_cropList.count);

//        [super setImageURL:[_URLList objectAtIndex:0]];
        UIImage * croppedImage = [Utilities resizedImage2:[[notification userInfo] objectForKey:@"image"] withRect:_croppedRect];
//        NSLog(@"EGOCropImageView - imageLoaderDidLoad - %@",croppedImage);
        
        
        // File name will be added the extent: extString = [_cropList objectAtIndex:0];
        NSString *tagThumbnail=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"TagThumbnail"];

        
        if (![[NSFileManager defaultManager] fileExistsAtPath:tagThumbnail]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:tagThumbnail withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *fileName=[NSString stringWithFormat:@"%@_%@.png",[[[self.imageURL lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0],[_cropList objectAtIndex:0]];
        
        [[NSFileManager defaultManager] createFileAtPath:[tagThumbnail stringByAppendingPathComponent:fileName] contents:UIImagePNGRepresentation(croppedImage) attributes:nil];
        [super setImageURL:[NSURL fileURLWithPath:[tagThumbnail stringByAppendingPathComponent:fileName]]];
    }
    
    // Replace new path here
    
	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
    [self stopAnimating];
	self.image = anImage;
	[self setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
        [self.delegate imageViewLoadedImage:self];
    }
}

- (void)imageLoaderDidFailToLoad:(NSNotification *)notification
{
    NSLog(@"EGO Image View Did Fail To Load");
}

- (void)setCroppedRect:(CGRect)croppedRect
{
    _croppedRect = croppedRect;
    _croppedSize = croppedRect.size;
    
    if (!_cropList) {
        _cropList = [[NSMutableArray alloc] init];
    }
    [_cropList addObject:[NSString stringWithFormat:@"%d_%d", (int)_croppedSize.width, (int)_croppedSize.height]];
}

@end
