//
//  AZDataClass.m
//  44_CoreData
//
//  Created by alexg on 01.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//

#import "AZDataManager.h"
#import "AZStudent.h"
#import "AZCourses.h"
#import "AZTeacher.h"

@implementation AZDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

+(AZDataManager*) genereteDataManager{
    
   static AZDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AZDataManager alloc] init];

    });
    
    return manager;
}


#pragma  mark - Add Models 

-(AZStudent*) addRandomStudent{
    
    AZStudent* randomStudent = [NSEntityDescription insertNewObjectForEntityForName:@"AZStudent"
                                                             inManagedObjectContext:self.managedObjectContext];
    randomStudent.firstName = firstNames[arc4random_uniform(50)];
    randomStudent.lastName = lastNames[arc4random_uniform(50)];
    randomStudent.score = @((float)arc4random_uniform(201)/100.f + 2.f);
    randomStudent.phone = @"12345";
    randomStudent.eMail = @"email";
    
    return randomStudent;
    
}

-(AZTeacher*) addRandomTeacher{
    
    AZTeacher* randomTeacher = [NSEntityDescription insertNewObjectForEntityForName:@"AZTeacher"
                                                             inManagedObjectContext:self.managedObjectContext];
    randomTeacher.firstName = firstNames[arc4random_uniform(50)];
    randomTeacher.lastName = lastNames[arc4random_uniform(50)];
    
    return randomTeacher;
    
}

-(AZCourses*) addCourseWithName:(NSString*) name{
    AZCourses* course = [NSEntityDescription insertNewObjectForEntityForName:@"AZCourses"
                                                     inManagedObjectContext:self.managedObjectContext];
    course.name = name;
    course.subject = @"computer science";
    course.branch = @"development";
    
    return course;
    
}

-(void) printObjectWithArray:(NSArray*) array{
    
    
    for (id object in array) {
        
        if ([object isKindOfClass:[AZStudent class]]) {
            
            AZStudent* student = (AZStudent*) object;
            NSLog(@"%@ %@ SCORE - %@" ,student.firstName, student.lastName,student.score);
            
        }else if ([object isKindOfClass:[AZTeacher class]]){
        
            AZTeacher* teacher = (AZTeacher*) object;
            NSLog(@"Teacher -  %@ %@" ,teacher.firstName, teacher.lastName);
        
        }
    }
    
    
    
}
-(void) deleteAllObject{
    
    
    NSArray* tempArray = [self allObject];
    for (NSManagedObject* obj in tempArray) {
        [self.managedObjectContext deleteObject:obj];
    }
    
    [self.managedObjectContext save:nil];
    
    
}

-(NSArray*) allObject{
    
    NSEntityDescription* discr = [NSEntityDescription entityForName:@"AZObject"
                                             inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest* delRequest = [[NSFetchRequest alloc] init];
    
    [delRequest setEntity:discr];
    
    NSArray* tempArray = [self.managedObjectContext executeFetchRequest:delRequest error:nil];
    
    return tempArray;
    
}

#pragma mark - Core Data stack



- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "AlexZhilenko._4_CoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"_4_CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"_4_CoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        
        
//        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
//        
//        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
//
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
