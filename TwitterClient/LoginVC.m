//
//  LoginVC.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/1/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "LoginVC.h"
#import "TwitterClient.h"
#import "HomePageTableVC.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginInAction:(UIButton *)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
            NSLog(@"login completed!!");
        if (user) {
            //modify present tweets view
            //HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
//            [self presentViewController:homeController animated:YES completion:nil];
            //---------------
            HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];

            [self presentViewController:navigationController animated:YES completion:nil];
            
            //    HomePageTableVC *homeController = [[HomePageTableVC alloc] init];
            //    self.navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
            
            
            //self.window.rootViewController = self.navigationController;
            //    [self.window makeKeyAndVisible];
            
            
        }
        else {
            //present error view
        }
    }];
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
