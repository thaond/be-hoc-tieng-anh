//
//  Utilities.m
//  CategoryDemo
//
//  Created by Pham Vu Duong on 5/22/12.
//  Copyright (c) 2012 CMC Software Solution Company Ltd. All rights reserved.
//

#import "Utilities.h"
#import "UIImage+CMCUtilities.h"
#import <CommonCrypto/CommonDigest.h>
//#import "TestFlight.h"

#define MEME_TEXT_RATIO 10/100
#define FONT_NAME @"Impact"
#define FONT_SIZE 20

@interface Utilities (internal)
CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);
@end

@implementation Utilities

+ (NSString*)MD5Encodine:(NSString*)inputString
{
    const char *cStr = [inputString UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

+ (NSString*)Base64Encoding:(NSString*)inputString
{
    return inputString;
}

+ (NSString*)CategoryEncrypt:(NSString*)inputString
{
    NSString * encryptString = [NSString stringWithString:@""];
    
    // Do something here
    int code;
    for (int i = 0; i < [inputString length]; i++) {
        code = 180 - [inputString characterAtIndex:i];
        encryptString = [NSString stringWithFormat:@"%@%c", encryptString, code];
    }
    
//    NSLog(@"%@",encryptString);
    return  inputString;
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}
CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180/M_PI;
}


+(UIImage*)cropImage:(UIImage*)inputImage withRect:(CGRect)cropRect{

//    NSLog(@"Utilities - Crop Start:%f|%f with Rect:%f|%f|%f|%f",inputImage.size.width,inputImage.size.height,cropRect.origin.x,cropRect.origin.y,cropRect.size.width,cropRect.size.height);
    if (!inputImage) {
        NSLog(@"cropImage - withRect - image nil");
        return nil;
    }
    
    CGImageRef imageRef =inputImage.CGImage;
    UIImage* subImage ;
    UIImageOrientation orientation;
    
    switch (inputImage.imageOrientation) {
        case UIImageOrientationDown:
            orientation=UIImageOrientationDown;
            break;
        case UIImageOrientationLeft:
            orientation=UIImageOrientationRight;
            break;
        case UIImageOrientationRight:
            orientation=UIImageOrientationLeft;
            break;
        default:
            break;
    }
    imageRef= CGImageCreateWithImageInRect(inputImage.CGImage, cropRect);

    
//    imageRef= CGImageCreateWithImageInRect([self rotateImage:[UIImage imageWithCGImage: imageRef] withOrientation:orientation].CGImage, cropRect);
    subImage= [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
//    NSLog(@"Utilities - Crop Finish:%f|%f",subImage.size.width,subImage.size.height);
    return subImage;
}

+(UIImage*)cropImage:(UIImage*)inputImage withSize:(CGSize)cropSize{
    if (!inputImage) {
        NSLog(@"cropImage - image nil");
        return nil;
    }
//    NSLog(@"InputImage:%f|%f",inputImage.size.width,inputImage.size.height);
//    NSLog(@"CropSize:%f|%f",cropSize.width,cropSize.height);
    CGSize originalSize=inputImage.size;
    
    CGSize imageSize=inputImage.size;
    
    if (imageSize.width/cropSize.width>imageSize.height/cropSize.height) {
        //height
        imageSize.width= imageSize.width *(cropSize.height/imageSize.height);
        imageSize.height=cropSize.height;
    }
    else{
        //width
        imageSize.height= imageSize.height *(cropSize.width/imageSize.width);
        imageSize.width=cropSize.width;
    }
    
//    NSLog(@"NewImageSize:%f|%f",imageSize.width,imageSize.height);

    UIImage *tempImage=[Utilities resizedImage:inputImage withRatio:imageSize.width/originalSize.width];

//    NSLog(@"ResizeImage:%f|%f",tempImage.size.width,tempImage.size.height);

    CGRect resultRect=CGRectMake(imageSize.width/2.0-cropSize.width/2.0, imageSize.height/2.0-cropSize.height/2.0, cropSize.width, cropSize.height);
    
//    NSLog(@"ResultRect:%f|%f|%f|%f",resultRect.origin.x,resultRect.origin.y,resultRect.size.width,resultRect.size.height);
    
    return [Utilities cropImage:tempImage withRect:resultRect];
    
}

+(UIImage*)rotateImage:(UIImage*)inputImage withOrientation:(UIImageOrientation)orientation{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,inputImage.size.width, inputImage.size.height)];
    
    //    UIImageOrientationUp,          
    //    UIImageOrientationDown        
    //    UIImageOrientationLeft        
    //    UIImageOrientationRight 
    
    float degrees=0.0;
    switch (orientation) {
        case UIImageOrientationDown:
            degrees=180.0;
            break;
        case UIImageOrientationLeft:
            degrees=90.0;
            break;
        case UIImageOrientationRight:
            degrees=-90.0;
            break;
        default:
            break;
    }
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-inputImage.size.width / 2, -inputImage.size.height / 2, inputImage.size.width, inputImage.size.height), [inputImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)createMeme:(NSString*)memeText withImage:(UIImage*)inputImage atTop:(BOOL)isTop{
    CGFloat w = inputImage.size.width;
    CGFloat h = inputImage.size.height;
    if (w<500.0||h<500.0) {
        if (w>h) {
            w=(500.0/h)*w;
            h=500.0;
        }
        else{
            h=(500.0/w)*h;
            w=500.0;
        }
    }
    inputImage=[inputImage scaleToSize:CGSizeMake(w, h)];
    CGFloat textHeight=((w>h)?w:h)*MEME_TEXT_RATIO;
    
//    NSLog(@"%d",textHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    size_t pixelsWide = CGImageGetWidth(inputImage.CGImage);
    size_t pixelsHigh = CGImageGetHeight(inputImage.CGImage);
    
    CGContextRef context = CGBitmapContextCreate(NULL, 
                                                 pixelsWide, 
                                                 pixelsHigh, 
                                                 8.0,
                                                 4.0 * pixelsWide,
                                                 colorSpace, 
                                                 kCGImageAlphaPremultipliedFirst);
    
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, w, h), inputImage.CGImage);
    
    //
    CGContextSetInterpolationQuality(context, kCGInterpolationDefault);

    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    
    CGContextSelectFont(context, [FONT_NAME UTF8String], textHeight, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( 0.0 ));
    NSArray *memeArray=[self getListStringFrom:memeText withTextHeight:textHeight andFrameWidth:w];
	if (!isTop && memeArray.count*textHeight < h) {
        for (int i=0; i<memeArray.count; i++) {
            char* text	= (char *)[[memeArray objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
            CGSize size=[[memeArray objectAtIndex:i] sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]];
//            NSLog(@"w[%d]:s[%f]:%f",w,size.width*(textHeight/FONT_SIZE),(w-size.width*(textHeight/FONT_SIZE)));
            CGFloat width= (CGFloat)w;
            CGFloat height=(CGFloat)textHeight;
            CGFloat padding=((width-size.width*(height/FONT_SIZE)))/2.0;
//            NSLog(@"padding:%f",padding);
            CGContextShowTextAtPoint(context, 
                                     padding,
                                     textHeight*(memeArray.count-i-1)+20.0,
                                     text, 
                                     strlen(text));
        } 
        
    }
    else {
        for (int i=0; i<memeArray.count; i++) {
            CGSize size=[[memeArray objectAtIndex:i] sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]];
            CGFloat width= (CGFloat)w;
            CGFloat height=(CGFloat)textHeight;
            CGFloat padding=((width-size.width*(height/FONT_SIZE)))/2;
            char* text	= (char *)[[memeArray objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
            CGContextShowTextAtPoint(context, 
                                     padding, 
                                     h-textHeight*(i+1)-5, 
                                     text, 
                                     strlen(text));
        }
        
    }
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
    
}


+(BOOL)copyImageToClipboard:(UIImage*)inputImage{
    return YES;
}


+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize
{
    return nil;
}

+(NSArray*)getListStringFrom:(NSString*)inputString withTextHeight:(float)height andFrameWidth:(float)width{
    NSMutableArray *result=[[NSMutableArray alloc] init];
    NSArray *arr =[inputString componentsSeparatedByString:@"\n"];
    for ( NSString * subStr in arr) {
        NSMutableArray *subArr=[[subStr componentsSeparatedByString:@" "] mutableCopy];
        NSMutableArray *resultSubArr=[[NSMutableArray alloc] init];
        for (int i=0; i<subArr.count; i++) {
//            NSLog(@"%@",[subArr objectAtIndex:i]);
            CGSize size=[[subArr objectAtIndex:i] sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]];
            if (width >= size.width*(height/FONT_SIZE)) {
                [resultSubArr addObject:[subArr objectAtIndex:i]];
            }
            else {
                int j=0;
                int k=0;
                while (j+k<[[subArr objectAtIndex:i] length]) {
                    k++;
                    //                    NSLog(@"%d|%d",j,k);
                    CGSize msize=[[[subArr objectAtIndex:i] substringWithRange:NSMakeRange(j, k)] sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]];
                    //                    NSLog(@"%f,%f",width,msize.width*(height/FONT_SIZE));
                    if (width < msize.width*(height/FONT_SIZE)) {
                        [resultSubArr addObject:[[subArr objectAtIndex:i] substringWithRange:NSMakeRange(j, k-1)]];
                        j=j+k-1;
                        k=0;
                    }
                    else if(j+k==[[subArr objectAtIndex:i] length]){
                        [resultSubArr addObject:[[subArr objectAtIndex:i] substringWithRange:NSMakeRange(j, k)]];
                    }
                }
                
            }
            
        }
        BOOL right=YES;
        while (right) {
            right=NO;
            for (int i=1; i<resultSubArr.count;i++) {
//                NSLog(@"%d",i);
                NSString *sstr=[NSString stringWithFormat:@"%@ %@",[resultSubArr objectAtIndex:i-1],[resultSubArr objectAtIndex:i]];
                CGSize size=[sstr sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]];
                
                if (width >= size.width*(height/FONT_SIZE)) {
//                    NSLog(@"remove:%d",i-1);
                    [resultSubArr removeObjectAtIndex:i-1];
                    [resultSubArr removeObjectAtIndex:i-1];
                    [resultSubArr insertObject:sstr atIndex:i-1];
//                    NSLog(@"%@",resultSubArr);
                    right=YES;
                    break;
                }
            }
        }
        for (NSString * sstr in resultSubArr) {
            [result addObject:sstr];
        }
    }
    return result;
}

+(UIImage*)resizedImage2:(UIImage *)inImage withRect:( CGRect) thumbRect
{
    if (inImage==nil) {
        [TestFlight passCheckpoint:@"resizedImage - image nil"];
        return nil;
    }
	CGImageRef			imageRef = CGImageCreateCopy([inImage CGImage]);
//	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    CGRect rect;
//    
//    CGRectMake(0,
//               0,
//               inImage.size.width,
//               inImage.size.height);
    
    if (inImage.size.width>inImage.size.height) {
        rect=CGRectMake((inImage.size.width-inImage.size.height)/2, 
                        0, 
                        inImage.size.height, 
                        inImage.size.height);
    }
    else {
        rect=CGRectMake(0, 
                        (inImage.size.height-inImage.size.width)/2, 
                        inImage.size.width, 
                        inImage.size.width);
        
    }
//	if (alphaInfo == kCGImageAlphaNone)
//		alphaInfo = kCGImageAlphaNoneSkipLast;
    
	// Build a bitmap context that's the size of the thumbRect
    imageRef = CGImageCreateWithImageInRect(imageRef, rect);
//    NSLog(@"1");
//    size_t pixelsWide = ;
//    size_t pixelsHigh = CGImageGetHeight(inputImage.CGImage);
    
	CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                thumbRect.size.width,		// width
                                                thumbRect.size.height,		// height
                                                CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8//CGImageGetBitsPerComponent(imageRef)
                                                4 * thumbRect.size.width,	// rowbytes
                                                CGColorSpaceCreateDeviceRGB(),
                                                kCGImageAlphaPremultipliedFirst
                                                );
    
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);
	// Get an image from the context and a UIImage
    imageRef = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:imageRef];
	CGContextRelease(bitmap);	// ok if NULL
    CGImageRelease(imageRef);
	return result;
}


+(UIImage*)resizedImage:(UIImage *)inImage withRect:( CGRect) thumbRect
{
    if (inImage==nil) {
        NSLog(@"Utilities - image nil");
        return nil;
    }
    CGSize rect;
        
    if (inImage.size.width>inImage.size.height) {
        rect=CGSizeMake(200,
                        inImage.size.height*(200/inImage.size.width));
    }
    else {
        rect=CGSizeMake(inImage.size.width *(200/inImage.size.height), 
                        200);        
    }
    return [inImage scaleToSize:rect];
}

+(UIImage*)resizedImage:(UIImage *)inImage withRatio:( CGFloat) ratio
{
    if (inImage==nil) {
        NSLog(@"Utilities - image nil");
        return nil;
    }
    
    return [inImage scaleToSize:CGSizeMake(inImage.size.width*ratio, inImage.size.height*ratio)];
}


#pragma mark - Saving Files

+ (UtilityMethodStatus)saveFileAtDocumentWithName:(NSString*)fileName toSubFolder:(NSString*)folderName andNewName:(NSString*)newName
{
    NSFileManager *fm=[[[NSFileManager alloc] init] autorelease];
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *targetPath=[documentPath stringByAppendingPathComponent:folderName];
    
    //check and create folder
    if (![fm fileExistsAtPath:targetPath]) {
        [fm createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //check exists
    NSArray *favoriteList=[fm contentsOfDirectoryAtPath:targetPath error:nil];
    
    for (NSString *item in favoriteList) {
        if ([[[fileName componentsSeparatedByString:@"_"] objectAtIndex:1] 
             isEqualToString:
             [[[[item componentsSeparatedByString:@"_"] objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0]]) {
            return UtilityFileSavingExisted;
        }
    }
    
    if ([fm fileExistsAtPath:[targetPath stringByAppendingPathComponent:newName]]) {
        return UtilityFileSavingExisted;
    }
    
    //copy
    NSError *error=nil;
    if ([fm copyItemAtPath:[documentPath stringByAppendingPathComponent:fileName] 
                    toPath:[targetPath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@_%@.png",newName,
                             [[fileName componentsSeparatedByString:@"_"] objectAtIndex:1]]] 
                     error:&error]) {
        return UtilityFileSavingSucceeded;
    }
    NSLog(@"Error:%@",[error description]);
    return UtilityFileSavingError;
}

+(BOOL)checkFavoriteAdded:(NSString*)fileName{
//    NSLog(@"Utilities - checkFavoriteAdded:%@",fileName);
    NSFileManager *fm=[[[NSFileManager alloc] init] autorelease];
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *targetPath=[documentPath stringByAppendingPathComponent:@"Favorites"];
    
    NSArray *favoriteList=[fm contentsOfDirectoryAtPath:targetPath error:nil];
//    NSLog(@"%@",favoriteList);
    for (NSString *item in favoriteList) {
        if ([[[fileName componentsSeparatedByString:@"_"] objectAtIndex:1] 
             isEqualToString:
             [[[[item componentsSeparatedByString:@"_"] objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0]]) {
            return YES;
        }
    }
    return NO;
}


+(NSString*)uniqueStringWithPrefix:(NSString*)prefix{
    
    NSDate *now=[NSDate date];
    NSDateFormatter *dFormat=[[NSDateFormatter alloc] init];
    [dFormat setDateFormat:@"yyyyMMddHHmmss"];
    return [NSString stringWithFormat:@"%@%@",prefix,[dFormat stringFromDate:now]];
    
}

+(BOOL)deleteFileAtURL:(NSURL*)url{
    NSFileManager *fm=[[[NSFileManager alloc] init] autorelease];
    if ([fm removeItemAtURL:url error:nil]) {
        NSLog(@"DELETE OK");
        return YES;
    }
    NSLog(@"DELETE FAILED");
    return NO;
}

+ (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
        
    }
    
    //    [UIView commitAnimations];
    
    
    
    
    
}

+ (void) showTabBar:(UITabBarController *) tabbarcontroller {
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
        
        
    }
    
    //    [UIView commitAnimations]; 
}

+(BOOL)saveImage:(UIImage*)inputImage toDocumentSubFolder:(NSString*)folderName withName:(NSString*)name{
    NSFileManager *fm=[[[NSFileManager alloc] init] autorelease];
    
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *targetPath=[documentPath stringByAppendingPathComponent:folderName];
    BOOL err;
    if (![fm fileExistsAtPath:targetPath isDirectory:&err]) {
        [fm createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fm createFileAtPath:[targetPath stringByAppendingPathComponent:name] contents:UIImagePNGRepresentation(inputImage) attributes:nil]){
        return YES;
    }
    return NO;
}

+ (unsigned long long int)sizeOfDirectory:(NSString *)folderPath {
    NSLog(@"SizeFolder:%@",folderPath);
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        BOOL isDirectory=NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[folderPath stringByAppendingPathComponent:fileName] isDirectory:&isDirectory]) {
            if (isDirectory) {
                fileSize+=[Utilities sizeOfDirectory:[folderPath stringByAppendingPathComponent:fileName]];
            }
            else{
                NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
                
                fileSize += [fileDictionary fileSize];
//                NSLog(@"%@:%lld",[folderPath stringByAppendingPathComponent:fileName],[fileDictionary fileSize]);

            }
        }
        
    }
    
    return fileSize;
}

@end
