//
//  CLAppDelegate.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLAppDelegate.h"
#import "TestFlight.h"

@implementation CLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // TestFlight Analytics
    [TestFlight takeOff:@"775460fc-c740-4d49-bc8a-a84744b4d14a"];
    
    // Google Analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:@"AIzaSyDBsKmsXMSmdde6j-dAcg94qeClrCTPg80"];

    UIImage *navBgImage = [[UIImage imageNamed:@"nav_bg"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [[UINavigationBar appearance] setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iphone"
                                                         bundle:nil];
    
    UIViewController *homeController = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"];
    UIViewController *menuController = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    
    PKRevealController *revealController =
    [[PKRevealController alloc] initWithFrontViewController:homeController
                                         leftViewController:menuController
                                                    options:nil];
    
    self.window.rootViewController = revealController;
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.

}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
