//
//  AZInfoCourseViewController.m
//  44_CoreData
//
//  Created by alexg on 05.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZInfoCourseViewController.h"
#import "AZTeacherViewController.h"
#import "AZStudentsViewController.h"

#import "AZDataManager.h"
#import "AZCourseInfoCell.h"
#import "AZCourses.h"
#import "AZTeacher.h"
#import "AZStudent.h"

@interface AZInfoCourseViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) NSArray* placeholderLabel;
@property (strong, nonatomic) UITextField* activeTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) AZStudentsViewController* studentViewController;
@property (strong, nonatomic) AZTeacherViewController* teachViewController;


@end

@implementation AZInfoCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.saveButton.enabled = NO;
    self.placeholderLabel = @[@"Name:", @"Subject:", @"Branch:",@"Teacher:"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return [self.placeholderLabel count];
    }else{
    
        return [self.studentsAtCourseArray count] + 1;
    
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        AZCourseInfoCell*cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
        cell.infoLabel.text = [self.infoAboutCourse objectAtIndex:indexPath.row];
        
        cell.infoField.borderStyle = UITextBorderStyleRoundedRect;
        cell.infoField.layer.cornerRadius = 5.f;
        cell.infoField.textAlignment = NSTextAlignmentLeft;
        cell.infoField.delegate = self;
        
        cell.infoLabel.text = [self.placeholderLabel objectAtIndex:indexPath.row];
        
        if (self.infoAboutCourse) {  //если студент уже существует, тогда заполняем поля его данными
            
            id object = [self.infoAboutCourse objectAtIndex:indexPath.row];
            
            if ([object isKindOfClass:[NSString class]]) {
                cell.infoField.text = object;
            }
        }
        
        return cell;
    }
    
    static NSString* identifier = @"cellForSecondCection";
    static NSString* addStudent = @"addStudent";
  

    if (indexPath.row == 0) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addStudent];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudent];
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.bounds), CGRectGetHeight(cell.contentView.bounds))];
            
            label.textColor = [UIColor orangeColor];
            label.text = [NSString stringWithFormat:@" + Add student"];
            label.textAlignment = NSTextAlignmentCenter;

            [cell.contentView addSubview:label];

        }
        
        return cell;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString* studentsString = @"no students";
    
    if (self.studentsAtCourseArray != nil && [self.studentsAtCourseArray count] > 0) {
        
        AZStudent* student = [self.studentsAtCourseArray objectAtIndex:indexPath.row - 1];
        studentsString = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    }
    
    cell.textLabel.text = studentsString;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    
    if (section == 0) {
        return @"Course settings";
    }else if (section == 1){
    return @"Learn course students";
    
    }
    return nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && indexPath.section == 1) {
        [self removeObserverFromStudentController];
        
        AZStudentsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AZStudentsViewController"];
        
        vc.navigationItem.title = @"Select students";
        vc.currentItems = self.currentCourse.students;

        self.studentViewController = vc;
        
        [self.studentViewController addObserver:self
                                   forKeyPath:@"currentItems"
                                      options:NSKeyValueObservingOptionNew
                                      context:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


#pragma mark - Action
- (IBAction)actionSave:(UIBarButtonItem *)sender {
    
    if ([self.activeTextField isFirstResponder]) {
        [self.activeTextField resignFirstResponder];
    }
    
    if ([self.infoAboutCourse containsObject:@""]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Fill in all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    if (self.editingCourseBlock) {
        self.editingCourseBlock();
    }
    
    [self removeObserverTeachController];
    [self removeObserverFromStudentController];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    [self removeObserverTeachController];
    [self removeObserverFromStudentController];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.activeTextField = textField;
    self.saveButton.enabled = YES;
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    NSIndexPath* indexPath = [AZCourseInfoCell indexPathCellWithTextField:textField inTableView:self.tableView];
    
    if (indexPath.row == 3) {
        
        [self removeObserverTeachController];
        
        AZTeacherViewController* teachVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AZTeacherViewController"];
        teachVC.navigationItem.title = @"Teachers";
        
        self.teachViewController = teachVC;
        AZTeacher* teacher = [self.currentCourse valueForKey:@"teacher"];
        if (teacher) {
            teachVC.currentItem = teacher;
        }
        
        [self.teachViewController addObserver:self
                  forKeyPath:@"currentItem"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
        
        [self.navigationController pushViewController:teachVC animated:YES];
        return NO;
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.activeTextField resignFirstResponder];
    
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    
    NSIndexPath *indexPath = [AZCourseInfoCell indexPathCellWithTextField:textField inTableView:self.tableView];
    NSMutableArray* stringArray = [NSMutableArray arrayWithArray:self.infoAboutCourse];
    NSString* currentString = nil;
    
    switch (indexPath.row) {
        case 0:
            NSLog(@"%@", stringArray);
            currentString = [@"" stringByAppendingString:textField.text];
            [stringArray removeObjectAtIndex:indexPath.row];
            [stringArray insertObject:currentString atIndex:indexPath.row];
            NSLog(@"%@", stringArray);
            break;
        case 1:
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        case 2:
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        case 3:
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        case 4:
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        default:
            break;
    }
    self.infoAboutCourse = stringArray;
    NSLog(@"%@", self.infoAboutCourse);
    
}

-(void) replaseString:(NSString*) string AtIndex:(NSInteger) index fromArray:(NSMutableArray*) array withEnotherString:(NSString*) enotherStr{
    
    string = [@"" stringByAppendingString:enotherStr];
    [array removeObjectAtIndex:index];
    [array insertObject:string atIndex:index];
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

   //NSLog(@"keyPath - %@ object - %@ class - %@ change - %@", keyPath, object, [object class], change);
    
    NSManagedObjectContext* newContext = [[AZDataManager genereteDataManager] managedObjectContext];
    
        if (self.currentCourse != nil) {
            
            id value = [change objectForKey:NSKeyValueChangeNewKey];
            
            if([value isKindOfClass:[AZTeacher class]]){
                [self.currentCourse setValue:value forKey:@"teacher"];
                NSString* teacher = [NSString stringWithFormat:@"%@ %@", [self.currentCourse valueForKeyPath:@"teacher.firstName"],
                                                                        [self.currentCourse valueForKeyPath:@"teacher.lastName"]];
                
                NSMutableArray* tempArray = [self mutableArrayValueForKey:@"infoAboutCourse"];
                [tempArray removeLastObject];
                [tempArray addObject:teacher];
                
                NSError* contError = nil;
                [newContext save:&contError];
                [self.tableView reloadData];
            }
            
            if ([value isKindOfClass:[NSSet class]]) {
                NSSet* valueSet = (NSSet*) value;

                [self.currentCourse setValue:value forKey:@"students"];
                NSSortDescriptor* sortDecription = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];

                self.studentsAtCourseArray = [[valueSet allObjects] sortedArrayUsingDescriptors:@[sortDecription]];
                
                [[AZDataManager genereteDataManager] printObjectWithArray:self.studentsAtCourseArray];
                
                NSError* contError = nil;
                [newContext save:&contError];
                [self.tableView reloadData];
                
            }
            
        }
    
}

-(void) removeObserverTeachController{
    
    if (self.teachViewController) {
        
        [self.teachViewController removeObserver:self forKeyPath:@"currentItem"];
        
        NSLog(@"self.teachViewController removeObserver");
    }
    
}

-(void) removeObserverFromStudentController{

    if (self.studentViewController) {
        
        [self.studentViewController removeObserver:self forKeyPath:@"currentItems"];
        
        NSLog(@"self.teachViewController removeObserver");
    }

}

#pragma mark - Dealloc
-(void) dealloc{

    NSLog(@"AZInfoCourseViewController is deallocated");
}

@end
