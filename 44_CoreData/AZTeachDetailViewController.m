//
//  AZTeachDetailViewController.m
//  44_CoreData
//
//  Created by alexg on 04.09.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZTeachDetailViewController.h"
#import "AZTeacherViewCell.h"
#import "AZLeftView.h"
#import "AZCourses.h"
#import "AZTeacher.h"

@interface AZTeachDetailViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray* allLeftView;
@property (strong, nonatomic) NSArray* imagesArray;
@property (strong, nonatomic) NSMutableArray* tempArray;
@property (strong, nonatomic) UITextField* activeTextField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (copy, nonatomic) void(^currentCourseForTeacherBlock)();

- (IBAction)actionSave:(UIBarButtonItem *)sender;

@end

static NSString* cellIdentifier = @"Cell";


@implementation AZTeachDetailViewController


#pragma mark - ViewController life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createImage];

    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    
    AZCourses *course = [self.teacher valueForKey:@"Course"];
    if (course != nil) {
        [self.myPickerView selectRow:[self.coursesArray indexOfObject:course] inComponent:0 animated:YES];
    }
    self.stringWithDataArray = [NSArray arrayWithObjects:@"",@"", nil];
    self.tempArray = [NSMutableArray array];
    self.textFieldIsEditing = NO;
    
    UITapGestureRecognizer* tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [self.tableView addGestureRecognizer:tapGesture];

    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.textFieldIsEditing) {
        self.saveButton.enabled = NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tapGesture

- (void) handleTap:(UITapGestureRecognizer*) tapGesture {
    
        [self resignFirstResponderField:self.activeTextField onTapGesture:tapGesture];
}

-(void) resignFirstResponderField:(UITextField*) textField onTapGesture:(UITapGestureRecognizer*) gesture{
    
    if ([textField isFirstResponder] && ![textField isEqual:gesture.view]) {
        
        [textField resignFirstResponder];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allLeftView count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    AZTeacherViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* plaseholders = @[@"Enter first name", @"Enter last name"];

    cell.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    cell.myTextField.layer.cornerRadius = 5.f;
    cell.myTextField.placeholder = [plaseholders objectAtIndex:indexPath.row];
    cell.myTextField.textAlignment = NSTextAlignmentLeft;
    cell.myTextField.leftViewMode = UITextFieldViewModeAlways;
    cell.myTextField.leftView = [self.allLeftView objectAtIndex:indexPath.row];
    cell.myTextField.delegate = self;
    
    if (self.infoTeacherForTextField) {  //если преподаватель уже существует, тогда заполняем поля его данными
        
        id object = [self.infoTeacherForTextField objectAtIndex:indexPath.row];
        
        if ([object isKindOfClass:[NSString class]]) {
            cell.myTextField.text = object;
            [self.tempArray addObject:object];
        }else if ([object isKindOfClass:[NSNumber class]]){
            
            cell.myTextField.text = [NSString stringWithFormat:@"%@", object];
            [self.tempArray addObject:[NSString stringWithFormat:@"%@", object]];
        }
    }
    
    
    if (self.teacherIsEditing) {
        self.stringWithDataArray = self.tempArray;
        //по аналогии со студентами
    }
    [cell.myTextField.leftView setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;        
        
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([tableView rectForFooterInSection:section]), CGRectGetHeight([tableView rectForFooterInSection:section]));
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:0.65];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Select course";
    return label;

}



#pragma mark - Create view vs images for textField


-(void) createImage{
    
    UIImage* name = [UIImage imageNamed:@"User.png"];
    UIImage* secondName = [UIImage imageNamed:@"User.png"];

    
    self.imagesArray = @[name,secondName];
    
    CGRect rectParent = CGRectMake(0, 0, 30, 30);
    CGRect rectSubView = CGRectInset(rectParent, 4, 4);
    UIColor* color = [UIColor clearColor];
    
    AZLeftView* nameLeftView = [AZLeftView viewWithImage:name
                                                andFrame:rectSubView
                                       andRectParentView:rectParent
                                                andColor:color];
    AZLeftView* secondNameLeftView = [AZLeftView viewWithImage:secondName
                                                      andFrame:rectSubView
                                             andRectParentView:rectParent
                                                      andColor:color];
    
    self.allLeftView=[NSArray arrayWithObjects:nameLeftView, secondNameLeftView, nil];

}



#pragma mark - Actions

- (IBAction)actionSave:(UIBarButtonItem *)sender {
    
    if ([self.activeTextField isFirstResponder]) {
        [self.activeTextField resignFirstResponder];
    }
    
    if ([self.stringWithDataArray containsObject:@""]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Fill in all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.currentCourseForTeacherBlock) {
        self.currentCourseForTeacherBlock();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if (self.newTeacherBlock) {
        self.newTeacherBlock();
    }
    
    
    if (self.editingTeacherBlock) {
        self.editingTeacherBlock();
    }
}


- (IBAction)actionCansel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma  mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return [self.coursesArray count];

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    AZCourses* course = [self.coursesArray objectAtIndex:row];
    NSString* string = [NSString stringWithFormat:@"%@", course.name];
    
    return string;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    self.saveButton.enabled = YES;
     AZCourses* course = [self.coursesArray objectAtIndex:row];
    __weak AZTeacher* weakTeacher = self.teacher;
    
    self.currentCourseForTeacherBlock = ^{
        
        [weakTeacher setValue:course forKey:@"course"];
    };

}
#pragma  mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.activeTextField = textField;
    self.textFieldIsEditing = YES; // button "Save" became active when anyone textField will editing, else is not
    self.saveButton.enabled = YES;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.activeTextField resignFirstResponder];
    
    return YES;
}



-(void) textFieldDidEndEditing:(UITextField *)textField{
    
    // Получение ячейки где наход. textField
    id textFieldSuper = textField;
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        textFieldSuper = [textFieldSuper superview];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textFieldSuper];
    NSMutableArray* stringArray = [NSMutableArray arrayWithArray:self.stringWithDataArray];
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
            NSLog(@"%@", stringArray);
            
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        case 2:
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        case 3:
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        default:
            break;
    }
    self.stringWithDataArray = stringArray;
    //NSLog(@"%@", self.stringWithStudentDataArray);
    
}

-(void) replaseString:(NSString*) string AtIndex:(NSInteger) index fromArray:(NSMutableArray*) array withEnotherString:(NSString*) enotherStr{
    
    string = [@"" stringByAppendingString:enotherStr];
    [array removeObjectAtIndex:index];
    [array insertObject:string atIndex:index];
    
}
@end
