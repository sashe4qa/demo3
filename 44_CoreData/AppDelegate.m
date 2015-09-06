//
//  AppDelegate.m
//  44_CoreData
//
//  Created by alexg on 01.08.15.
//  Copyright (c) 2015 alexg. All rights reserved.
//


//////////////////////////////////////////////////////////////////////////////
//Описание приложения:                                                      //
//1. Есть база студентов, преподавателей, курсов                            //
//2. Студентов можно записывать на курсы, а курсам ставить преподавателя    //
//3. Редактировать информацию о студентах, о курсе, о преподавателях        //
//3. Добавлять новых студентов, новые курсы, новых преподавателей           //
//////////////////////////////////////////////////////////////////////////////


#import "AppDelegate.h"
#import "AZDataManager.h"
//#import "AZStudent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
   /*
    

    AZDataManager* manager = [AZDataManager genereteDataManager];
   [manager deleteAllObject];
    
    for (int i = 0; i < 30; i++) {
        
        AZStudent* student = [manager addRandomStudent];        // создание случайных студентов
        
    }
    
    NSError* error = nil;

    [manager addCourseWithName:@"IOS Development"];             // создание курсов
    [manager addCourseWithName:@"Android Development"];
    [manager addCourseWithName:@"Javascript Development"];
    [manager addCourseWithName:@"HTML Development"];
    [manager addCourseWithName:@"PHP development"];


    [manager addRandomTeacher];                                 // создание случайных учителей
    [manager addRandomTeacher];
    [manager addRandomTeacher];
    [manager addRandomTeacher];
    [manager addRandomTeacher];

    
    if(![manager.managedObjectContext save:&error]){
    
        NSLog(@"%@", [error localizedDescription]);
    }
    */
    
    
    
    /*
          //для проверки кол-ва эл-тов в массивах
     
    NSManagedObjectContext* manadgedObjectContext = [manager managedObjectContext];
    NSEntityDescription* discriotion = [NSEntityDescription entityForName:@"AZStudent" inManagedObjectContext:manadgedObjectContext];
    
    NSFetchRequest* reaquest = [[NSFetchRequest alloc] init];
    [reaquest setEntity:discriotion];
    
    NSArray* array = [manadgedObjectContext executeFetchRequest:reaquest error:nil];
    
    NSLog(@"count - %li", [array count]);
    
    NSEntityDescription* discriotion2 = [NSEntityDescription entityForName:@"AZCourses" inManagedObjectContext:manadgedObjectContext];
    
    NSFetchRequest* reaquest2 = [[NSFetchRequest alloc] init];
    [reaquest2 setEntity:discriotion2];
    
    NSArray* array2 = [manadgedObjectContext executeFetchRequest:reaquest2 error:nil];
    
    
    NSLog(@"count - %i", (int)[array2 count]);
    

    NSEntityDescription* discriotion3 = [NSEntityDescription entityForName:@"AZTeacher" inManagedObjectContext:manadgedObjectContext];
    
    NSFetchRequest* request3 = [[NSFetchRequest alloc] init];
    [request3 setEntity:discriotion3];
    
    NSArray* array3 = [manadgedObjectContext executeFetchRequest:request3 error:nil];
    
    
    NSLog(@"count - %i", (int)[array3 count]);*/

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[AZDataManager genereteDataManager] saveContext];
}


@end
