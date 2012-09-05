//
//  Download.h
//  eBook
//
//  Created by Hai Le Dang on 8/30/11.
//  Copyright 2011 CMCSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

typedef enum
{
    DOWNLOAD_BOOK,
    DOWNLOAD_IMAGE,
    DOWNLOAD_IMAGE_AT_IMAGEVIEWDETAIL,
    DOWNLOAD_RECENTLY,
    DOWNLOAD_IMAGE_TO_FAVORITE,
    DOWNLOAD_IMAGE_FOR_SHARING
} DownloadMethod;

@interface DownloadHelper : NSObject
{
    ASIHTTPRequest *_request;
    NSString *successNotification;
    NSString *failNotification;
    NSString *saveFolder;
    NSString *fileName;
}
@property (nonatomic, assign) DownloadMethod method;

- (void)downloadFile:(NSString*)_fileName
    toFolderWithName:(NSString*)_folderName
             withURL:(NSURL*)_url
andSuccessNotification:(NSString*)_successNotification
 andFailNotification:(NSString*)_failNotification;

@end
