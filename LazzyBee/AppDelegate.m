//
//  AppDelegate.m
//  LazzyBee
//
//  Created by nobody on 7/31/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RearViewController.h"
#import "JASidePanelController.h"
#import "CommonDefine.h"
#import "Common.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self copyDatabaseIntoDocumentsDirectory];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        
    RearViewController *rearViewController = [[RearViewController alloc] init];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    JASidePanelController *jaSidePanel = [[JASidePanelController alloc] init];
    jaSidePanel.leftPanel = rearNavigationController;
    jaSidePanel.centerPanel = homeNav;
    
    self.window.rootViewController = jaSidePanel;
    [self.window makeKeyAndVisible];
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
}


-(void)copyDatabaseIntoDocumentsDirectory {
    NSString *destinationPath = [[[Common sharedCommon] documentsFolder] stringByAppendingPathComponent:DATABASENAME];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
    
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASENAME];

        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];

        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

@end
