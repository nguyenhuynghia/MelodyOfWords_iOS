//
//  AppDelegate.m
//  HBTHackathon
//
//  Created by NghiaNH on 12/16/17.
//  Copyright © 2017 NghiaNH. All rights reserved.
//

#import "AppDelegate.h"
#import "TGChatViewController.h"
#import "NOCMessageManager.h"
#import "CustomNavigationController.h"
#import "NOCChat.h"
#import "Service.h"
#import "FileEntity.h"
#import "MIDIManager.h"

@interface AppDelegate () 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NOCMessageManager manager] play];
    // Override point for customization after application launch.
    NOCChat *chat = [self botChat];
    TGChatViewController *chatVC = [[TGChatViewController alloc] initWithChat:chat];
    CustomNavigationController *rootNavi = [[CustomNavigationController alloc] initWithRootViewController:chatVC];
    self.window.rootViewController = rootNavi;
    return YES;
}

- (NOCChat *)botChat
    {
        static NOCChat *_botChat = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _botChat = [[NOCChat alloc] init];
            _botChat.type = @"bot";
            _botChat.targetId = @"89757";
            _botChat.chatId = [NSString stringWithFormat:@"%@_%@", _botChat.type, _botChat.targetId];
            _botChat.title = @"Gothons From Planet Percal #25";
            _botChat.detail = @"bot";
        });
        return _botChat;
    }


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
