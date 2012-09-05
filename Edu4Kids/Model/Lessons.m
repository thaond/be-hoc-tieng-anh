//
//  Lessons.m
//  Edu4Kids
//
//  Created by Admin on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Lessons.h"

@implementation Lessons

@synthesize lessonId        = _lessonId;
@synthesize lessonName      = _lessonName;
@synthesize lessonContent   = _lessonContent;
@synthesize lessonAudio     = _lessonAudio;
@synthesize lessonVideo     = _lessonVideo;
@synthesize lessonPhoto     = _lessonPhoto;
@synthesize lessonURL       = _lessonURL;
@synthesize lessonCategory  = _lessonCategory;
@synthesize lessonType      = _lessonType;

- (id)init
{
    self = [super init];
    if (self) {
        //  Initialization code
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_dictionary release];
    [super dealloc];
}

- (void)parseFromDictionary:(NSDictionary *)dictionary
{
    _lessonId = [dictionary valueForKey:@"lessonId"];
    _lessonName = [dictionary valueForKey:@"lessonName"];
    _lessonContent = [dictionary valueForKey:@"lessonContent"];
    _lessonAudio = [dictionary valueForKey:@"lessonAudio"];
    _lessonVideo = [dictionary valueForKey:@"lessonVideo"];
    _lessonPhoto = [dictionary valueForKey:@"lessonPhoto"];
    _lessonURL = [dictionary valueForKey:@"lessonURL"];
    _lessonCategory = [dictionary valueForKey:@"lessonCategory"];
    _lessonType = [dictionary valueForKey:@"lessonType"];
}

- (NSMutableDictionary *)convertToDictionary
{
    [_dictionary setValue:_lessonId forKey:@"lessonId"];
    [_dictionary setValue:_lessonName forKey:@"lessonName"];
    [_dictionary setValue:_lessonContent forKey:@"lessonContent"];
    [_dictionary setValue:_lessonAudio forKey:@"lessonAudio"];
    [_dictionary setValue:_lessonVideo forKey:@"lessonVideo"];
    [_dictionary setValue:_lessonPhoto forKey:@"lessonPhoto"];
    [_dictionary setValue:_lessonURL forKey:@"lessonURL"];
    [_dictionary setValue:_lessonCategory forKey:@"lessonCategory"];
    [_dictionary setValue:_lessonType forKey:@"lessonType"];
    
    return _dictionary;
}

@end
