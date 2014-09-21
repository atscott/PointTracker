//
//  AppDelegate.m
//  PointTracker
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "AppDelegate.h"
#import "TableListViewController.h"
#import "LogViewController.h"
#import "MyLogInViewController.h"
#import "WeekPickerViewController.h"
#import "MainLandingViewController.h"
#import "CurrentRosterViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Magic string for connecting to Parse servers
    [Parse setApplicationId:@"nudxR7T6WonMVuXtp7R7Hao2B0VURfTHqa8gPWyk"
                  clientKey:@"eG3RuQZQiiu8spXM1uBdlIloPE7EZY1udg8WD9aL"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *mainViewNavController =[[UINavigationController alloc] initWithRootViewController:[[MainLandingViewController alloc] init]];
    
    WeekPickerViewController *scheduleViewController = [[WeekPickerViewController alloc] init];
    UINavigationController *scheduleNavController = [[UINavigationController alloc] initWithRootViewController:scheduleViewController];
    
    CurrentRosterViewController *currentRosterViewController = [[CurrentRosterViewController alloc] init];
    UINavigationController *currentRosterNavController = [[UINavigationController alloc] initWithRootViewController:currentRosterViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[mainViewNavController, scheduleNavController, currentRosterNavController];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end