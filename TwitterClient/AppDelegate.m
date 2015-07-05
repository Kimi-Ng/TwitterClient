//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/1/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageTableVC.h"
#import "LoginVC.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
@interface AppDelegate ()
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UINavigationController *navigationController;
@end

@implementation AppDelegate

/*******
 Login page ---<log in> --> Home page ---<log out> --> Login page
 
 
 ********/


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        NSLog(@"didFish===============");
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];
    
    User *user = [User currentUser];
    
    if (user!=nil) {
        //登入完成, 導到第二頁
        NSLog(@"Welcome %@", user.name);
        //show another view for logged-in user
        //self.window.rootViewController = [[LoginVC alloc] init];
        
        HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];

        
        self.window.rootViewController = self.navigationController;
        [self.window makeKeyAndVisible];
    }
    else {
        NSLog(@"Not logged in");
        self.window.rootViewController = [[LoginVC alloc] init];
    }
    
    /*
    HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    self.window.rootViewController = navigationController;
    */
    //LoginVC *loginController = [[LoginVC alloc] init];
    //self.window.rootViewController = loginController;
    
    /*
    HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
//    UINavigationController *navigationController = [[UINavigationController alloc] init];
//    homeController.title = @"home title";
    [navigationController setTitle:@"Title"];

    navigationController.navigationItem.title = @"ItemTitle";
    navigationController.navigationBar.hidden = NO;
    navigationController.navigationBarHidden = NO;
    [navigationController addChildViewController:homeController];
    
    self.window.rootViewController = navigationController;
    */
//    self.window.rootViewController = homeController;
//    [navigationController.navigationBar setTintColor:[UIColor blackColor]];

    
    
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)userDidLogout {
    self.window.rootViewController = [[LoginVC alloc] init];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //called when user login
    [[TwitterClient sharedInstance] openURL:url];
    
    //HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    
    NSLog(@"openURL===============");
    /*
    self.window.rootViewController = self.navigationController;
    HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    
    

        
    //    HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
    //    self.navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
        
        
        self.window.rootViewController = self.navigationController;
    */
    //    [self.window makeKeyAndVisible];
    

//self.window.rootViewController = [[HomePageTableVC alloc] init];
    return YES;
}



@end
