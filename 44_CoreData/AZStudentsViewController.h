//
//  AZStudentsViewController.h
//  44_CoreData
//
//  Created by alexg on 07.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZStudentsViewController : UITableViewController

@property (strong, nonatomic) NSSet* currentItems;

@property (strong, nonatomic) NSIndexPath* checkPath;

@end
