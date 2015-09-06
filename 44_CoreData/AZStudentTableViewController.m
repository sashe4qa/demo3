//
//  AZStudentTableViewController.m
//  44_CoreData
//
//  Created by alexg on 01.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZStudentTableViewController.h"
#import "AZDataManager.h"
#import "AZDetailTableViewController.h"
#import "AZStudent.h"
@interface AZStudentTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButonItem;
@property (strong, nonatomic) NSArray* myArray;
@end

@implementation AZStudentTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Students";

     self.navigationItem.rightBarButtonItem = self.addButonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)insertNewObject:(id)sender {
    
    UINavigationController* nc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNavigationController"];
    AZDetailTableViewController* vc = [nc.viewControllers firstObject];
    vc.navigationItem.title = @"New student";
 
    __weak AZDetailTableViewController* weakVC = vc;
    __weak AZStudentTableViewController *weakSelf = self;
    vc.studentIsEditing = NO;
    vc.textFieldIsEditing = NO;
    vc.infoStudentForTextField = nil;
    vc.newStudentBlock = ^{
        
        NSManagedObjectContext *context = [weakSelf.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[weakSelf.fetchedResultsController fetchRequest] entity];
        AZStudent *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

        [weakSelf setValueForStudent:newManagedObject withContext:context andArray:weakVC.stringWithStudentDataArray];
    
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
    
     AZStudent* student = [entitiesArray objectAtIndex:indexPath.row];
    
    
    NSString *firstName = [student valueForKey:@"firstName"];
    NSString *lastName = [student valueForKey:@"lastName"];
    NSNumber *score = [student valueForKey:@"score"];
    NSString *phone = [student valueForKey:@"phone"];
    NSString *eMail = [student valueForKey:@"eMail"];
    
    
    UINavigationController* nc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNavigationController"];
    AZDetailTableViewController* vc = [nc.viewControllers firstObject];
    vc.navigationItem.title = @"Editing student";
    
    vc.infoStudentForTextField = [[NSArray alloc] initWithObjects:firstName, lastName, score, phone, eMail, nil];
    vc.studentIsEditing = YES;
    vc.textFieldIsEditing = NO;

    __weak AZDetailTableViewController* weakVC = vc;
    __weak AZStudentTableViewController* weakSelf = self;
    
    vc.editingStudentBlock = ^{
    
        [weakSelf setValueForStudent:student withContext:context andArray:weakVC.stringWithStudentDataArray];
    };
    
    
    [nc setModalPresentationStyle:UIModalPresentationPageSheet];
    [nc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController presentViewController:nc animated:YES completion:nil];

}

-(void) setValueForStudent:(AZStudent*) student withContext:(NSManagedObjectContext*) context andArray:(NSArray*) arrayWithStudentInfo {
    
    [student setValue:[arrayWithStudentInfo objectAtIndex:0] forKey:@"firstName"];
    [student setValue:[arrayWithStudentInfo objectAtIndex:1] forKey:@"lastName"];
    [student setValue:[arrayWithStudentInfo objectAtIndex:3] forKey:@"phone"];
    [student setValue:[arrayWithStudentInfo objectAtIndex:4] forKey:@"eMail"];
    
    NSString* stringScore = [arrayWithStudentInfo objectAtIndex:2];
    float scoreFromString = [stringScore floatValue];
    
    [student setValue:@(scoreFromString) forKey:@"score"];
    
    [self saveContext:context];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AZStudent" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray* aaa = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    [[AZDataManager genereteDataManager]  printObjectWithArray:aaa];
    
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
