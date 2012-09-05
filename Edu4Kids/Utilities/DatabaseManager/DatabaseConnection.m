////
////  DatabaseConnection.m
////  WiseFans
////
////  Created by Liennh@wisekey.com on 5/7/12.
////  Copyright (c) 2012 WISeKey SA. All rights reserved.
////

#import "DatabaseConnection.h"

#import "AppDelegate.h"

@implementation DatabaseConnection

#pragma mark - General Methods for Accessing Core Data
#pragma mark - Read From An Entity

+ (NSMutableDictionary*)readFromManagedItem:(NSManagedObject*)managedItem withKeys:(NSArray*)keyArray
{
    NSMutableDictionary * item = [[NSMutableDictionary alloc] init];
    NSEntityDescription * entityDesc = [[NSEntityDescription alloc] init];
    entityDesc = managedItem.entity;
    item = (NSMutableDictionary*)[entityDesc attributesByName];
    
    return [item autorelease];
}

+ (NSMutableArray*)readItemsFromEntity:(NSString*)entityName whereKeys:(NSMutableArray*)keys isEqualValues:(NSMutableArray*)values sortByKey:(NSString*)sortKey ascending:(BOOL)ascending
{
    NSMutableArray * results = [[NSMutableArray alloc] init];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [fetchRequest setEntity:entity];

    NSArray * allKeysArray = [[entity attributesByName] allKeys];
    
    if (keys != nil) {
        NSString * predicateString = nil;
        
        for (int i = 0; i < keys.count; i++)
        {
            NSString * key = [keys objectAtIndex:i];
            if (key != nil && ![key isEqualToString:@""])
            {
                if ([values objectAtIndex:i] != nil) {
                    predicateString = [NSString stringWithFormat:@"%@%@ = '%@' AND ", 
                                       predicateString,
                                       key,
                                       [values objectAtIndex:i]];
                }
            }
        }
    
        predicateString = [predicateString substringToIndex:(predicateString.length - 5)];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString]];
    }
    NSSortDescriptor *sortDescriptor = nil;
    NSArray * sortDescriptors = nil;
    if (sortKey != nil && ![sortKey isEqualToString:@""]) 
    {
        // Edit the sort key as appropriate.
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSError *error = nil;
    [fetchRequest setReturnsObjectsAsFaults:NO];
	NSMutableArray *mutableFetchResults = [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
	if (mutableFetchResults != nil) {
        for (int i = 0; i < [mutableFetchResults count]; i++) {
            [results addObject:[self readFromManagedItem:[mutableFetchResults objectAtIndex:i] withKeys:keys]];
        }
	}
    
    [fetchRequest release];
    [mutableFetchResults release];
    if (sortDescriptor != nil) {
        [sortDescriptor release];
    }
    if (sortDescriptors != nil) {
        [sortDescriptors release];
    }
    
    return [results autorelease];
}

+ (NSMutableArray*)readAllItemsFromEntity:(NSString*)entityName sortWithKey:(NSString*)key ascending:(BOOL)ascending
{
    return [self readItemsFromEntity:entityName withConditionString:nil sortWithKey:key ascending:ascending];
}

+ (NSMutableArray*)readItemsFromEntity:(NSString*)entityName withConditionString:(NSString*)condition sortWithKey:(NSString*)key ascending:(BOOL)ascending
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSArray * keyArray = [[entity attributesByName] allKeys];
    
    if (condition) {
        NSString * predicateString = condition;
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@", predicateString]]];
    }
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSError *error = nil;
    [fetchRequest setReturnsObjectsAsFaults:NO];
	NSMutableArray *mutableFetchResults = [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    NSMutableArray * itemsArr = [[NSMutableArray alloc] init];
    
	if (mutableFetchResults != nil) {
        for (int i = 0; i < [mutableFetchResults count]; i++) {
            [itemsArr addObject:[self readFromManagedItem:[mutableFetchResults objectAtIndex:i] withKeys:keyArray]];
        }
	}
    
    [fetchRequest release];
    [mutableFetchResults release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return [itemsArr autorelease];
}

#pragma mark - Write To An Entity

+ (BOOL)writeAnItem:(NSMutableDictionary*)item ToEntity:(NSString*)entityName Immediatly:(BOOL)now
{
    NSError * error;
    NSManagedObject * managedItem = nil;
    managedItem = [NSEntityDescription
                   insertNewObjectForEntityForName:entityName
                   inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    
    NSArray * keyArray = [item allKeys];
    
    for (int i = 0; i < keyArray.count; i++) {
        NSString * value = [item valueForKey:[keyArray objectAtIndex:i]];
        if (value) {
            if (![value isEqual:[NSNull null]]) {
                [managedItem setValue:[NSString stringWithFormat:@"%@", value] forKey:[keyArray objectAtIndex:i]];
            }
        }
    }

    if (!now) {
        return YES;
    }
    if (![[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&error]) 
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    return YES;
}

+ (BOOL)updateAnItem:(NSMutableDictionary*)item ToManagedItem:(NSManagedObject*)managedItem Immediatly:(BOOL)now
{
    NSError * error;

    NSArray * keyArray = [item allKeys];
    
    for (int i = 0; i < keyArray.count; i++) {
        NSString * value = [item valueForKey:[keyArray objectAtIndex:i]];
        if (value) {
            if (![value isEqual:[NSNull null]]) {
                //                if (![value isEqualToString:@""]) {
                [managedItem setValue:[NSString stringWithFormat:@"%@", value] forKey:[keyArray objectAtIndex:i]];
                //                }
            }
        }
    }
        
    if (!now) {
        return YES;
    }
    if (![[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&error]) 
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    return YES;
}

+ (BOOL)updateAnItem:(NSMutableDictionary*)item inEntityWithName:(NSString *)entityName withKey:(NSString*)key
{
    NSError *error = nil;
    NSManagedObjectContext * context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    //This is your NSManagedObject subclass
    NSManagedObject * aManagedItem = nil;
    
    //Set up to get the thing you want to update
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName 
                                   inManagedObjectContext:context]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@='%@'", key, [item valueForKey:key]]];
    
    //Ask for it
    aManagedItem = [[context executeFetchRequest:request error:&error] lastObject];
    [request release];
    
    if (error) {
        //Handle any errors
        return NO;
    }
    
    if (!aManagedItem) {
        //Nothing there to update
        return NO;
    }
    
    //Update the object
    [self updateAnItem:item ToManagedItem:aManagedItem Immediatly:YES];
    return YES;
}

+ (void)writeListItems:(NSMutableArray*)list toEntity:(NSString*)entityName withPrimaryKey:(NSString*)primaryKey
{
    //    assert([NSThread isMainThread]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *ent = [NSEntityDescription entityForName:entityName inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [fetchRequest setEntity:ent];
    if (list.count <= 0) {
        [fetchRequest release];
        return;
    }
    NSError *error = nil;
    NSMutableDictionary * item = [list objectAtIndex:0];
    
    NSArray * keyArray = [item allKeys];
    
    // narrow the fetch to these two properties
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:primaryKey, nil];
    
    for (int i=0;i<[list count];i++) 
    {
        item = [list objectAtIndex:i];
        
        fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'", 
                                  primaryKey, [item valueForKey:primaryKey]]];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:[keyArray objectAtIndex:0] ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSArray *fetchedItems = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"err:%@",[error description]);
        }
        if ([fetchedItems count] == 0)
        {
            // Insert
            if (![self writeAnItem:item ToEntity:entityName Immediatly:NO])
            {
                [fetchRequest release];
                [sortDescriptors release];
                [sortDescriptor release];
                return;
            }
        }
        else {
            // Update
            if(![self updateAnItem:item ToManagedItem:[fetchedItems objectAtIndex:0] Immediatly:NO])
            {
                [fetchRequest release];
                [sortDescriptors release];
                [sortDescriptor release];
                return;
            }
        }
        [sortDescriptors release];
        [sortDescriptor release];
    }
    if (![[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&error]) 
    {
        [fetchRequest release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return;
    }
    [fetchRequest release];
    return;
}

@end
