//
//  WISeFansWebServices.h
//  Best Player iOS App
//
//  Created by Admin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class ASIFormDataRequest;
@class Reachability;


@interface WISeFansWebServices : NSObject <ASIHTTPRequestDelegate>
{
    ASIFormDataRequest * _request;
    
    Reachability * internetReachable;
    Reachability * hostReachable;
    
    id _observer;
    SEL _selector;
    id _object;
    NSString * _notify;
    NSString * _failNotify;
    
    BOOL internetActive;
    BOOL hostActive;
}

@property (nonatomic,retain) ASIFormDataRequest * request;
@property (nonatomic,readonly) BOOL internetActive;
@property (nonatomic,readonly) BOOL hostActive;

//+ (WISeFansWebServices *)sharedInstance;

- (void)setObserver:(id)observer selector:(SEL)selector;

//- (id)initWithObserver:(id)observer selector:(SEL)selector notificationWhenSuccessful:(NSString*)notify andNotificationWhenFailed:(NSString*)failNotify;

@end
