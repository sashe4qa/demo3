//
//  AZStudent.h
//  44_CoreData
//
//  Created by alexg on 05.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "NSManagedObject.h"
#import <CoreData/NSManagedObject.h>


@class AZCourses;

@interface AZStudent : NSManagedObject

@property (nonatomic, retain) NSString * eMail;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSSet *course;
@end

@interface AZStudent (CoreDataGeneratedAccessors)

- (void)addCourseObject:(AZCourses *)value;
- (void)removeCourseObject:(AZCourses *)value;
- (void)addCourse:(NSSet *)values;
- (void)removeCourse:(NSSet *)values;

@end
