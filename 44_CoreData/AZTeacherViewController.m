//
//  AZTeacherViewController.m
//  44_CoreData
//
//  Created by alexg on 06.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZTeacherViewController.h"
#import "AZInfoCourseViewController.h"
#import "AZDataManager.h"
#import "AZTeacher.h"

@interface AZTeacherViewController ()

@property (strong, nonatomic) NSArray* teachersArray;
@property (strong, nonatomic) NSIndexPath* checkPath;


@end

@implementation AZTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    NSManagedObjectContext* context = [[AZDataManager genereteDataManager] managedObjectContext];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"AZTeacher" inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSError* error = nil;
    NSArray* array = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        
    }
    
    self.teachersArray = array;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.teachersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    
    AZTeacher *teacher = [self.teachersArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [teacher valueForKey:@"firstName"],[teacher valueForKey:@"lastName"]];
    
    if ([self.currentItem isEqual:teacher]) {
        
        self.checkPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.checkPath) {
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:self.checkPath];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    if ([self.checkPath isEqual:indexPath]) {
        
        self.checkPath = nil;
        
    }else{
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        self.checkPath = indexPath;
        
        self.currentItem  = [self.teachersArray objectAtIndex:indexPath.row];
        
    }
}


#pragma mark - dealloc

-(void) dealloc{
    
    NSLog(@"AZTeacherViewController is deallocated");
}

@end
