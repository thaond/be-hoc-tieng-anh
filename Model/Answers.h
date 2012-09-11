//
//  Answers.h
//  Edu4Kids
//
//  Created by Admin on 8/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answers : NSManagedObject

@property (nonatomic, retain) NSString * answerAudio;
@property (nonatomic, retain) NSString * answerCategory;
@property (nonatomic, retain) NSString * answerContent;
@property (nonatomic, retain) NSString * answerForQuestionId;
@property (nonatomic, retain) NSString * answerId;
@property (nonatomic, retain) NSString * answerPhoto;
@property (nonatomic, retain) NSString * answerURL;
@property (nonatomic, retain) NSString * answerVideo;

@end
