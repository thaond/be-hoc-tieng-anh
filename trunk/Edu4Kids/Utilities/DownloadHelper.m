//
//  Download.m
//  eBook
//
//  Created by Hai Le Dang on 8/30/11.
//  Copyright 2011 CMCSoft. All rights reserved.
//

#import "DownloadHelper.h"
#import "ASIHTTPRequest.h"
//#import "Constants.h"

@implementation DownloadHelper
@synthesize method;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
/*
 function for download file and save to folder that is sub folder of Documents Directory
 */
- (void)downloadFile:(NSString*)_fileName
    toFolderWithName:(NSString*)_folderName
             withURL:(NSURL*)_url
andSuccessNotification:(NSString*)_successNotification
 andFailNotification:(NSString*)_failNotification
{
    fileName=[_fileName retain];
    successNotification=[_successNotification retain];
    failNotification=[_failNotification retain];
    if (_folderName==nil) {
        saveFolder=nil;
    }
    else{
        saveFolder=[_folderName retain];
    }
    
    _request = [[ASIHTTPRequest alloc] initWithURL:_url];
    [_request setUseSessionPersistence:YES];
    [_request setValidatesSecureCertificate:NO];
    [_request setTimeOutSeconds:30];
    [_request setDelegate:self];
    
    [_request startAsynchronous];
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"DownloadHelper - requestFinished [%d]- %@",request.responseStatusCode,successNotification);

    BOOL success= NO;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *targetPath;
    if (saveFolder==nil) {
        targetPath=[documentPath mutableCopy];
    }
    else{
        targetPath=[documentPath stringByAppendingPathComponent:saveFolder];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    UIImage *img=[UIImage imageWithData:request.responseData];
    if (img) {
        NSFileManager *fm=[[[NSFileManager alloc] init] autorelease];
        if ([fm createFileAtPath:[targetPath stringByAppendingPathComponent:fileName] contents:request.responseData attributes:nil]){
            success = YES;
        }
        
    }
    if (!success){
        [[NSNotificationCenter defaultCenter]postNotificationName:failNotification object:@"FAIL"];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:successNotification object:[request.url lastPathComponent]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"DownloadHelper - requestFailed - %@ - %@",failNotification,[error localizedDescription]);
    [[NSNotificationCenter defaultCenter]postNotificationName:failNotification object:[error localizedDescription]];

}

- (void)dismissRequest
{
    // Cancels an asynchronous request
    [_request cancel];
    // Cancels an asynchronous request, clearing all delegates and blocks first
    [_request clearDelegatesAndCancel];
}

- (void)dealloc
{
    [super dealloc];
}
@end
