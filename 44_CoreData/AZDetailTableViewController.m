//
//  AZDetailTableViewController.m
//  44_CoreData
//
//  Created by alexg on 01.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZDetailTableViewController.h"
#import "AZLeftView.h"
#import "AZTableViewCell.h"



@interface AZDetailTableViewController ()


@property (strong,nonatomic) NSArray* allLeftView;
@property (strong, nonatomic) UITextField* activeTextField;
@property (strong, nonatomic) NSArray* imagesArray;
@property (strong, nonatomic) NSMutableArray* tempArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)actionSave:(UIBarButtonItem *)sender;

@end

static NSString* cellIdentifier = @"detailCell";


@implementation AZDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stringWithStudentDataArray = [NSArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    self.tempArray = [NSMutableArray array];
        [self createImage];
    self.textFieldIsEditing = NO;
    
    NSLog(@"infoStudentForTextField - %@",self.infoStudentForTextField);
    
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.allLeftView count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    cell.myTextField.layer.cornerRadius = 5.f;
    
    NSArray* plaseholders = @[@"Enter first name", @"Enter last name",@"Enter your score",@"Enter phone", @"email"];
    cell.myTextField.placeholder = [plaseholders objectAtIndex:indexPath.row];
    cell.myTextField.textAlignment = NSTextAlignmentLeft;
    cell.myTextField.leftViewMode = UITextFieldViewModeAlways;
    cell.myTextField.leftView = [self.allLeftView objectAtIndex:indexPath.row];
    cell.myTextField.delegate = self;
    
    if (self.infoStudentForTextField) {  //если студент уже существует, тогда заполняем поля его данными
                
        id object = [self.infoStudentForTextField objectAtIndex:indexPath.row];
        
        if ([object isKindOfClass:[NSString class]]) {
            cell.myTextField.text = object;
            [self.tempArray addObject:object];
        }else if ([object isKindOfClass:[NSNumber class]]){
        
            cell.myTextField.text = [NSString stringWithFormat:@"%@", object];
            [self.tempArray addObject:[NSString stringWithFormat:@"%@", object]];
        }
           }
    
    
    if (self.studentIsEditing) {
        self.stringWithStudentDataArray = self.tempArray;
        //проверяем редактируется сущ. студент или доб. новый. Если сущ-й студент то чтобы инфа не обнулилась, ее же и будем отправлять обратно в этом массиве, либо отредактированную, что не будет редактироваться - сохранится.
    }
    [cell.myTextField.leftView setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
}



#pragma mark - Create view vs images for textField


-(void) createImage{
    
    UIImage* name = [UIImage imageNamed:@"User.png"];
    UIImage* secondName = [UIImage imageNamed:@"User.png"];
    UIImage* age = [UIImage imageNamed:@"age.png"];
    UIImage* phone = [UIImage imageNamed:@"telephone_yellow.png"];
    UIImage* mail = [UIImage imageNamed:@"mail_yellow.png"];
    
    self.imagesArray = @[name,secondName, age,phone,mail];
    
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
    AZLeftView* ageLeftView = [AZLeftView viewWithImage:age
                                               andFrame:rectSubView
                                      andRectParentView:rectParent
                                               andColor:color];
    AZLeftView* phoneLeftView = [AZLeftView viewWithImage:phone
                                                 andFrame:rectSubView
                                        andRectParentView:rectParent
                                                 andColor:color];
    AZLeftView* mailLeftView = [AZLeftView viewWithImage:mail
                                                andFrame:rectSubView
                                       andRectParentView:rectParent
                                                andColor:color];
    
    
    self.allLeftView=[NSArray arrayWithObjects:nameLeftView, secondNameLeftView, ageLeftView, phoneLeftView, mailLeftView,  nil];
    
    
}



#pragma mark - Actions 

- (IBAction)actionSave:(UIBarButtonItem *)sender {
    
    if ([self.activeTextField isFirstResponder]) {
        [self.activeTextField resignFirstResponder];
    }
    
    if ([self.stringWithStudentDataArray containsObject:@""]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Fill in all the fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.newStudentBlock) {
        self.newStudentBlock();
    }
    

    if (self.editingStudentBlock) {
        self.editingStudentBlock();
    }
}


- (IBAction)actionCansel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma  mark - UITextFieldDelegate 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    id textFieldSuper = textField;
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        textFieldSuper = [textFieldSuper superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textFieldSuper];

    if (indexPath.row == 2) {
        
        NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]*)(\\.([0-9]+)?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger noOfMatches = [regex numberOfMatchesInString:newStr
                                                        options:0
                                                          range:NSMakeRange(0, [newStr length])];
        if (noOfMatches==0){
            return NO;
        }
        
        if (newStr.length > 6) {
            return NO;
        }
    }else if (indexPath.row == 3) {
        
        
        NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        
        if ([components count] > 1) {
            return NO;
        }
        NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        //+XX (XXX) XXX-XXXX
        
        NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
        
        newString = [validComponents componentsJoinedByString:@""];
        
        // XXXXXXXXXXXX
        
        static const int localNumberMaxLength = 7;
        static const int areaCodeMaxLength = 3;
        static const int countryCodeMaxLength = 2;
        
        if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
            return NO;
        }
        
        
        NSMutableString* resultString = [NSMutableString string];
        
        /*
         XXXXXXXXXXXX
         +XX (XXX) XXX-XXXX
         */
        
        NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
        
        if (localNumberLength > 0) {
            
            NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
            
            [resultString appendString:number];
            
            if ([resultString length] > 3) {
                [resultString insertString:@"-" atIndex:3];
            }
            
        }
        
        if ([newString length] > localNumberMaxLength) {
            
            NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
            
            NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
            
            NSString* area = [newString substringWithRange:areaRange];
            
            area = [NSString stringWithFormat:@"(%@) ", area];
            
            [resultString insertString:area atIndex:0];
        }
        
        if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
            
            NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
            
            NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
            
            NSString* countryCode = [newString substringWithRange:countryCodeRange];
            
            countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
            
            [resultString insertString:countryCode atIndex:0];
        }
        
        
        textField.text = resultString;
        
        return NO;
        
    }
        
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{

    self.activeTextField = textField;
    self.textFieldIsEditing = YES; // button Save became active when anyone textField will editing, else is not
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
    NSMutableArray* stringArray = [NSMutableArray arrayWithArray:self.stringWithStudentDataArray];
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
        case 4:
            [self replaseString:currentString AtIndex:indexPath.row fromArray:stringArray withEnotherString:textField.text];
            break;
        default:
            break;
    }
    self.stringWithStudentDataArray = stringArray;
    NSLog(@"%@", self.stringWithStudentDataArray);
    
}

-(void) replaseString:(NSString*) string AtIndex:(NSInteger) index fromArray:(NSMutableArray*) array withEnotherString:(NSString*) enotherStr{

    string = [@"" stringByAppendingString:enotherStr];
    [array removeObjectAtIndex:index];
    [array insertObject:string atIndex:index];

}
@end
