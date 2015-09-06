//
//  AZTeachersController.m
//  44_CoreData
//
//  Created by Alex Zh. on 03.09.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZTeachersController.h"
#import "AZDataManager.h"
#import "AZTeacher.h"
#import "AZTeachDetailViewController.h"

@interface AZTeachersController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButonItem;
@property (strong, nonatomic) NSArray* myArray;

@end

@implementation AZTeachersController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Teachers";
    self.navigationItem.rightBarButtonItem = self.addButonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action

- (IBAction)insertNewObject:(id)sender {

    UINavigationController* nc = [self.storyboard instantiateViewControllerWithIdentifier:@"TeachDetailNavController"];
    AZTeachDetailViewController* vc = [nc.viewControllers firstObject];
    vc.navigationItem.title = @"New teacher";
    
    __weak AZTeachDetailViewController* weakVC = vc;
    __weak AZTeachersController *weakSelf = self;
    vc.teacherIsEditing = NO;
    vc.textFieldIsEditing = NO;
    
    vc.infoTeacherForTextField = nil;
    
    vc.coursesArray = [self arrayFromDataBaseWithEntityName:@"AZCourses" sortArrayWithKey:@"name"];
    
    vc.newTeacherBlock = ^{
        
        NSManagedObjectContext *context = [weakSelf.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[weakSelf.fetchedResultsController fetchRequest] entity];
        AZTeacher *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        [weakSelf setValueForStudent:newManagedObject withContext:context andArray:weakVC.stringWithDataArray];
        
    };
    
    
    [nc setModalPresentationStyle:UIModalPresentationPageSheet];
    [nc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
    
}



#pragma mark - UITableView

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%i. %@ %@",(int)indexPath.row + 1,[object valueForKey:@"firstName"],[object valueForKey:@"lastName"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
        [request setSortDescriptors:sortDescriptors];
    NSArray* entitiesArray = [context executeFetchRequest:request error:nil];
    AZTeacher* teacher = [entitiesArray objectAtIndex:indexPath.row];
    
    
    NSString *firstName = [teacher valueForKey:@"firstName"];
    NSString *lastName = [teacher valueForKey:@"lastName"];
    
        
    UINavigationController* nc = [self.storyboard instantiateViewControllerWithIdentifier:@"TeachDetailNavController"];
    AZTeachDetailViewController* vc = [nc.viewControllers firstObject];
    
    vc.navigationItem.title = @"Editing teacher";
    vc.infoTeacherForTextField = [[NSArray alloc] initWithObjects:firstName, lastName, nil];
    vc.teacherIsEditing = YES;
    vc.textFieldIsEditing = NO;
    vc.teacher = teacher;
    vc.coursesArray = [self arrayFromDataBaseWithEntityName:@"AZCourses" sortArrayWithKey:@"name"];
    
    __weak AZTeachDetailViewController* weakVC = vc;
    __weak AZTeachersController* weakSelf = self;

    vc.editingTeacherBlock = ^{
        
        [weakSelf setValueForStudent:teacher withContext:context andArray:weakVC.stringWithDataArray];
    };
    
    
    [nc setModalPresentationStyle:UIModalPresentationPageSheet];
    [nc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
    
}

-(void) setValueForStudent:(AZTeacher*) teacher withContext:(NSManagedObjectContext*) context andArray:(NSArray*) arrayWithStudentInfo {
    
    [teacher setValue:[arrayWithStudentInfo objectAtIndex:0] forKey:@"firstName"];
    [teacher setValue:[arrayWithStudentInfo objectAtIndex:1] forKey:@"lastName"];
    
    [self saveContext:context];
}

-(NSArray*) arrayFromDataBaseWithEntityName:(NSString*) entityName sortArrayWithKey:(NSString*) key{
    
    NSArray* array = nil;
    NSEntityDescription* description = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    
    NSFetchRequest* request = [[NSFetchRequest alloc]  init];
    [request setEntity:description];
    [request setSortDescriptors:@[sortDescriptor]];
    array = [self.managedObjectContext executeFetchRequest:request error:nil];
    return array;

}



#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AZTeacher" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:@"Master"];
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
