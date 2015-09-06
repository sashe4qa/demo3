//
//  AZCoursesViewController.m
//  44_CoreData
//
//  Created by alexg on 05.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZCoursesViewController.h"
#import "AZInfoCourseViewController.h"

#import "AZDataManager.h"
#import "AZCourses.h"
#import "AZStudent.h"
#import "AZTeacher.h"


@interface AZCoursesViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButtonItem;

@end

@implementation AZCoursesViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.navigationItem.title = @"Courses";
    self.navigationItem.rightBarButtonItem = self.addButtonItem;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)insertNewObject:(id)sender {
    
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    AZCourses *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    newManagedObject.name = @"New course";
    newManagedObject.subject = @"subject";
    newManagedObject.branch = @"branch";
   
    
    [self saveContext:context];

}


-(void) setValueForStudent:(AZCourses*) course withContext:(NSManagedObjectContext*) context andArray:(NSArray*) arrayWithCourseInfo {
    
    [course setValue:[arrayWithCourseInfo objectAtIndex:0] forKey:@"name"];
    [course setValue:[arrayWithCourseInfo objectAtIndex:1] forKey:@"subject"];
    [course setValue:[arrayWithCourseInfo objectAtIndex:2] forKey:@"branch"];
    
    [self saveContext:context];
}

#pragma mark - Table View


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setEntity:entity];
    [request setSortDescriptors:sortDescriptors];
    NSArray* entitiesArray = [context executeFetchRequest:request error:nil];
    
    AZCourses* course = [entitiesArray objectAtIndex:indexPath.row];
    
    NSString *name = [course valueForKey:@"name"];
    NSString *subject = [course valueForKey:@"subject"];
    NSString *branch = [course valueForKey:@"branch"];
    NSString* teacher =  @"unknown";
    
    if (course.teacher != nil) {
        teacher = [NSString stringWithFormat:@"%@ %@", [course valueForKeyPath:@"teacher.firstName"], [course valueForKeyPath:@"teacher.lastName"]];
    }
    
    UINavigationController* nc = [self.storyboard instantiateViewControllerWithIdentifier:@"AZInfoNavigationController"];
    AZInfoCourseViewController* vc = [nc.viewControllers firstObject];
    vc.navigationItem.title = @"Course info";
    vc.infoAboutCourse = [[NSArray alloc] initWithObjects:name, subject, branch, teacher, nil];
    vc.currentCourse = course;
    
    
    if (course.students != nil) {
        NSSortDescriptor* sortDecription = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];

        vc.studentsAtCourseArray = [[course.students allObjects] sortedArrayUsingDescriptors:@[sortDecription]];
    }else{
        vc.studentsAtCourseArray = nil;
    }
    
    __weak AZInfoCourseViewController* weakVC = vc;
    __weak AZCoursesViewController* weakSelf = self;
    
    vc.editingCourseBlock = ^{
        
        [weakSelf setValueForStudent:course withContext:context andArray:weakVC.infoAboutCourse];
    };
    
    [nc setModalPresentationStyle:UIModalPresentationPageSheet];
    [nc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AZCourses" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}



@end
