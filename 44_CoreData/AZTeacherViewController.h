//
//  AZTeacherViewController.h
//  44_CoreData
//
//  Created by alexg on 06.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZTeacher;
@interface AZTeacherViewController : UITableViewController

@property (strong, nonatomic) AZTeacher* currentItem;

@end
