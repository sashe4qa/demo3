//
//  AZCourses.h
//  44_CoreData
//
//  Created by alexg on 05.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "NSManagedObject.h"
#import <CoreData/NSManagedObject.h>

@class AZStudent, AZTeacher;

@interface AZCourses : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * branch;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) AZTeacher *teacher;
@end

@interface AZCourses (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(AZStudent *)value;
- (void)removeStudentsObject:(AZStudent *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
