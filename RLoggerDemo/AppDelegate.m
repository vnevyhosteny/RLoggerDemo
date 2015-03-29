//
//  AppDelegate.m
//  RLoggerDemo
//
//  Created by Vladimír Nevyhoštěný on 07.03.15.
//  Copyright (c) 2015 nefa. All rights reserved.
//

#import <RemoteLogger/RemoteLogger.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    static dispatch_once_t __once_token__ = 0;
    dispatch_once( &__once_token__, ^{
        
        LogMode  logMode;
        LogLevel logLevel;
        
#if TARGET_IPHONE_SIMULATOR
    #ifdef DEBUG
        logMode  = LogModeConsole;
        logLevel = log_level_all;
    #else
        logMode  = LogModeFile | LogModeRemote;
        logLevel = log_level_error;
    #endif
#else
    #ifdef DEBUG
        logMode  = LogModeRemote | LogModeFile;
        logLevel = log_level_all;
    #else
        logMode  = LogModeFile;
        logLevel = log_level_error;
    #endif
#endif
        [RemoteLogger createLoggerWithLogFolderName:nil logFileName:nil logMode:logMode logLevel:logLevel];
    });
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

@end
