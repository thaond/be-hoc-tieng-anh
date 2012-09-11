//
//  Utilities.h
//  CategoryDemo
//
//  Created by Pham Vu Duong on 5/22/12.
//  Copyright (c) 2012 CMC Software Solution Company Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#undef CLog

#if __cplusplus
extern "C" { 
#endif
    void CLog(NSString *format, ...);   
#if __cplusplus
}
#endif


typedef enum
{
    UtilityFileSavingExisted,
    UtilityFileSavingSucceeded,
    UtilityFileSavingError
} UtilityMethodStatus;

@interface Utilities : NSObject

+ (NSString*)MD5Encodine:(NSString*)inputString;

+ (NSString*)CategoryEncrypt:(NSString*)inputString;

/*-------------------------------------------------------------------*
 *  Nong Trung Nghia -  May 2012
 *  Crop a image in specify rect
 *  - This method is used crop a Image with specify rect
 ________________________
 |                      |
 |      IMAGE           |
 |                      |
 |         ___________  |
 |        |           | |
 |        | RECT      | |
 |        |           | |
 |        ------------  |
 -----------------------
 *  return a image croped
 *-------------------------------------------------------------------*/
+(UIImage*)cropImage:(UIImage*)inputImage withRect:(CGRect)cropRect;

/*-------------------------------------------------------------------*
 *  Nong Trung Nghia -  May 2012
 *  Rotate a image in specify orientation
 *  - This method is used rotate a Image with specify orientation
 *  - Orientation will be a number:
 *    + 90: rotate left 90 degree
 *    + 180: rotate left 180 degree
 *    + 270: rotate right 90 degree
 *  return a image rotated
 *-------------------------------------------------------------------*/
+(UIImage*)rotateImage:(UIImage*)inputImage withOrientation:(UIImageOrientation)orientation;

/*-------------------------------------------------------------------*
 *  Nong Trung Nghia -  May 2012
 *  Create MEME on image with specify text
 *  - Create MEME on image with specify text
 *  - Input:
 *      + Input image
 *      + A string that will be write on input image
 *      + Position will be top if isTop = YES, if not, position will be bottom
 *  - Output:
 *      +a image that was wrote meme text
 *-------------------------------------------------------------------*/
+(UIImage*)createMeme:(NSString*)memeText withImage:(UIImage*)inputImage atTop:(BOOL)isTop;

/*-------------------------------------------------------------------*
 *  Nong Trung Nghia -  May 2012
 *  COPY Image to clipboard
 *  - COPY Image to clipboard
 *  - Input:
 + Input image
 *  - Output:
 YES if copy success
 *-------------------------------------------------------------------*/
+(BOOL)copyImageToClipboard:(UIImage*)inputImage;

+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;

+(NSArray*)getListStringFrom:(NSString*)inputString withTextHeight:(float)height andFrameWidth:(float)width;

+(UIImage*)resizedImage:(UIImage *)inImage withRect:( CGRect) thumbRect;

+ (UtilityMethodStatus)saveFileAtDocumentWithName:(NSString*)fileName toSubFolder:(NSString*)folderName andNewName:(NSString*)newName;

+(NSString*)uniqueStringWithPrefix:(NSString*)prefix;

+(BOOL)deleteFileAtURL:(NSURL*)url;

+(BOOL)checkFavoriteAdded:(NSString*)fileName;

+ (void) showTabBar:(UITabBarController *) tabbarcontroller ;
+ (void) hideTabBar:(UITabBarController *) tabbarcontroller ;


+(BOOL)saveImage:(UIImage*)inputImage toDocumentSubFolder:(NSString*)folderName withName:(NSString*)name;

+ (unsigned long long int)sizeOfDirectory:(NSString *)folderPath;
+(UIImage*)resizedImage2:(UIImage *)inImage withRect:( CGRect) thumbRect;
+(UIImage*)resizedImage:(UIImage *)inImage withRatio:( CGFloat) ratio;
+(UIImage*)cropImage:(UIImage*)inputImage withSize:(CGSize)cropSize;


@end
