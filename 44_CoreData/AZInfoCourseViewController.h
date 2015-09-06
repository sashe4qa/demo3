//
//  AZInfoCourseViewController.h
//  44_CoreData
//
//  Created by alexg on 05.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AZCourses;

@interface AZInfoCourseViewController : UITableViewController

@property (copy, nonatomic) void(^editingCourseBlock)();
@property (strong, nonatomic) AZCourses* currentCourse;
@property (strong, nonatomic) NSArray* studentsAtCourseArray;
@property (strong, nonatomic) NSArray* infoAboutCourse;

- (IBAction)actionSave:(UIBarButtonItem *)sender;
- (IBAction)actionCancel:(UIBarButtonItem *)sender;


@end
