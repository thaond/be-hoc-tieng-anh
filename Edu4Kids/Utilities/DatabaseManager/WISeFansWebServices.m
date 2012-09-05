//
//  WISeFansWebServices.m
//  Best Player iOS App
//
//  Created by Admin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WISeFansWebServices.h"
#import "ProjectConstant.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "SBJSON.h"
#import "Utilities.h"

//#define USING_SHARED_INSTANCE 1

@implementation WISeFansWebServices

@synthesize request = _request;
@synthesize internetActive;
@synthesize hostActive;

#ifdef USING_SHARED_INSTANCE

static WISeFansWebServices *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (WISeFansWebServices *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
//-(void)dealloc
//{
//    // I'm never called!
//    [super dealloc];
//}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

#endif

- (void)dealloc
{
    [_request release];
    if (internetReachable) {
        [internetReachable stopNotifier];
        [internetReachable release];
    }
    if (hostReachable) {
        [hostReachable stopNotifier];
        [hostReachable release];
    }
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(checkInternetConnection:) 
                                                     name:kReachabilityChangedNotification 
                                                   object:nil];
        internetReachable = [[Reachability reachabilityForInternetConnection] retain];
        [internetReachable startNotifier];
        
        hostReachable = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
        [hostReachable startNotifier];
    }
    
    return self;
}

- (void)setObserver:(id)observer selector:(SEL)selector
{
    _selector = selector;
    _observer = observer;
}

#pragma mark - HTTPRequestHelper Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"OK: %@, %@, %@", [request responseString], _notify, [_observer class]);
    [[NSNotificationCenter defaultCenter] addObserver:_observer selector:_selector name:_notify object:nil];
    NSDate * today = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'.000Z'"];
    NSString * dateString = [dateFormatter stringFromDate:today];
    
    [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"vote_item_lastUpdatedTime"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_notify object:[request responseString]];
    [dateFormatter release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [[NSNotificationCenter defaultCenter] addObserver:_observer selector:_selector name:_failNotify object:nil];
    NSLog(@"request Failed: %@",error);
    NSLog(@"request Failed: %@",[request responseString]);
    [[NSNotificationCenter defaultCenter] postNotificationName:_failNotify object:[request responseString]];
}

@end
