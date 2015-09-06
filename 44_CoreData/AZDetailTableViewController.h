//
//  AZDetailTableViewController.h
//  44_CoreData
//
//  Created by alexg on 01.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZStudent.h"

@interface AZDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property(copy, nonatomic) void(^newStudentBlock)();
@property(copy, nonatomic) void(^editingStudentBlock)();

@property (strong, nonatomic) NSArray* stringWithStudentDataArray;
@property (strong, nonatomic) NSArray* infoStudentForTextField;
@property (assign, nonatomic) BOOL studentIsEditing;
@property (assign, nonatomic) BOOL textFieldIsEditing;

@property (nonatomic, strong) AZStudent * student;

@end
