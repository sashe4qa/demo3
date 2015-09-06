//
//  AZCourseInfoCell.h
//  44_CoreData
//
//  Created by alexg on 05.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZCourseInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoField;


+(NSIndexPath*) indexPathCellWithTextField:(UITextField*) textField inTableView:(UITableView*) tableView;
@end
