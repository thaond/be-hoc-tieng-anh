//
//  DatabaseConnection.h
//  WiseFans
//
//  Created by Liennh@wisekey.com on 5/7/12.
//  Copyright (c) 2012 WISeKey SA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseConnection : NSObject {

}

#pragma mark - CMC structure
+ (NSMutableArray*)readAllItemsFromEntity:(NSString*)entityName sortWithKey:(NSString*)key ascending:(BOOL)ascending;

+ (NSMutableArray*)readItemsFromEntity:(NSString*)entityName withConditionString:(NSString*)condition sortWithKey:(NSString*)key ascending:(BOOL)ascending;

+ (NSMutableArray*)readItemsFromEntity:(NSString*)entityName whereKeys:(NSMutableArray*)keys isEqualValues:(NSMutableArray*)values sortByKey:(NSString*)sortKey ascending:(BOOL)ascending;

+ (BOOL)writeAnItem:(NSMutableDictionary*)item ToEntity:(NSString*)entityName Immediatly:(BOOL)now;

+ (void)writeListItems:(NSMutableArray*)list toEntity:(NSString*)entityName withPrimaryKey:(NSString*)primaryKey;

@end
