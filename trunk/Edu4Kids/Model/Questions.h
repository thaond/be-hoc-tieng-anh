//
//  Questions.h
//  Edu4Kids
//
//  Created by Admin on 8/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Questions : NSManagedObject

@property (nonatomic, retain) NSString * questionAudio;
@property (nonatomic, retain) NSString * questionContent;
@property (nonatomic, retain) NSString * questionForItemId;
@property (nonatomic, retain) NSString * questionId;
@property (nonatomic, retain) NSString * questionPhoto;
@property (nonatomic, retain) NSString * questionType;
@property (nonatomic, retain) NSString * questionVideo;

@end
