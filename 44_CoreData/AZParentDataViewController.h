//
//  AZParentDataViewController.h
//  44_CoreData
//
//  Created by alexg on 06.09.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AZParentDataViewController : UITableViewController<NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void) saveContext:(NSManagedObjectContext*) context;

@end
