//
//  ManagedLessons.h
//  Edu4Kids
//
//  Created by Admin on 8/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ManagedLessons : NSManagedObject

@property (nonatomic, retain) NSString * lessonId;
@property (nonatomic, retain) NSString * lessonName;
@property (nonatomic, retain) NSString * lessonContent;
@property (nonatomic, retain) NSString * lessonAudio;
@property (nonatomic, retain) NSString * lessonVideo;
@property (nonatomic, retain) NSString * lessonPhoto;
@property (nonatomic, retain) NSString * lessonURL;
@property (nonatomic, retain) NSString * lessonCategory;
@property (nonatomic, retain) NSString * lessonType;

@end
