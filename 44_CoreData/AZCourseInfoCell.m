//
//  AZCourseInfoCell.m
//  44_CoreData
//
//  Created by alexg on 05.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZCourseInfoCell.h"

@implementation AZCourseInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(NSIndexPath*) indexPathCellWithTextField:(UITextField*) textField inTableView:(UITableView*) tableView{

    id textFieldSuper = textField;
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        textFieldSuper = [textFieldSuper superview];
    }
    
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)textFieldSuper];
return indexPath;
}
@end
