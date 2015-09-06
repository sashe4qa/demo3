//
//  AZTeacher.h
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

@interface AZTeacher : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) AZCourses *course;

@end
