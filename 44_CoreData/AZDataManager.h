//
//  AZDataClass.h
//  44_CoreData
//
//  Created by alexg on 01.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AZStudent, AZCourses, AZTeacher;

@interface AZDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(AZDataManager*) genereteDataManager;
-(AZStudent*) addRandomStudent;
-(AZCourses*) addCourseWithName:(NSString*) name;
-(AZTeacher*) addRandomTeacher;

-(void) deleteAllObject;
-(void) printObjectWithArray:(NSArray*) array;

@end
