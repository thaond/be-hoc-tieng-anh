//
//  Lessons.h
//  Edu4Kids
//
//  Created by Admin on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lessons : NSObject
{
    NSString * _lessonId;
    NSString * _lessonName;
    NSString * _lessonContent;
    NSString * _lessonAudio;
    NSString * _lessonVideo;
    NSString * _lessonPhoto;
    NSString * _lessonURL;
    NSString * _lessonCategory;
    NSString * _lessonType;
    
    NSMutableDictionary * _dictionary;
}

@property (nonatomic, retain) NSString * lessonId;
@property (nonatomic, retain) NSString * lessonName;
@property (nonatomic, retain) NSString * lessonContent;
@property (nonatomic, retain) NSString * lessonAudio;
@property (nonatomic, retain) NSString * lessonVideo;
@property (nonatomic, retain) NSString * lessonPhoto;
@property (nonatomic, retain) NSString * lessonURL;
@property (nonatomic, retain) NSString * lessonCategory;
@property (nonatomic, retain) NSString * lessonType;

- (void)parseFromDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)convertToDictionary;

@end
