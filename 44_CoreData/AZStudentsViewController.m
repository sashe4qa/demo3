//
//  AZStudentsViewController.m
//  44_CoreData
//
//  Created by alexg on 07.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZStudentsViewController.h"
#import "AZDataManager.h"
#import "AZStudent.h"

@interface AZStudentsViewController ()
@property (strong, nonatomic) NSArray* studentsArray;
@property (strong, nonatomic) NSMutableSet* checkPathSet;
@property (strong, nonatomic) NSMutableSet* currentStudents;

@end

@implementation AZStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSManagedObjectContext* context = [[AZDataManager genereteDataManager] managedObjectContext];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"AZStudent" inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSSortDescriptor* sortDecription = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [request setSortDescriptors:@[sortDecription]];
    NSError* error = nil;
    NSArray* array = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        
    }
    
    [[AZDataManager genereteDataManager] printObjectWithArray:array];
    
    self.studentsArray = array;
    self.checkPathSet = [NSMutableSet set];
    self.currentStudents = [NSMutableSet set];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        
        self.currentItems = self.currentStudents;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.studentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell"];
    
    AZStudent *student = [self.studentsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [student valueForKey:@"firstName"],[student valueForKey:@"lastName"]];
    
    if ([self.currentItems containsObject:student]) {
        [self.checkPathSet addObject:indexPath];
        [self.currentStudents addObject:student];
    }
    
    if ([self.checkPathSet containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AZStudent* student = [self.studentsArray objectAtIndex:indexPath.row];

    
    if ([self.checkPathSet containsObject:indexPath] && [self.currentStudents containsObject:student]) {
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.checkPath = nil;
        [self.checkPathSet removeObject:indexPath];
        [self.currentStudents removeObject:student];
        
    }else{
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.checkPathSet addObject:indexPath];
        [self.currentStudents addObject:student];

    }
 
}

-(void) dealloc{
    
    NSLog(@"AZStudentsViewController is deallocated");
}

@end
