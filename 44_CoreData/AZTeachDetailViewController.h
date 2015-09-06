//
//  AZTeachDetailViewController.h
//  44_CoreData
//
//  Created by alexg on 04.09.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZTeacher, AZCourses;

@interface AZTeachDetailViewController : UITableViewController


@property(copy, nonatomic) void(^newTeacherBlock)();
@property(copy, nonatomic) void(^editingTeacherBlock)();

@property (strong, nonatomic) NSArray* stringWithDataArray;
@property (strong, nonatomic) NSArray* infoTeacherForTextField;
@property (strong, nonatomic) NSArray* coursesArray;

@property (assign, nonatomic) BOOL teacherIsEditing;
@property (assign, nonatomic) BOOL textFieldIsEditing;

@property (nonatomic, strong) AZTeacher * teacher;
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

@end
