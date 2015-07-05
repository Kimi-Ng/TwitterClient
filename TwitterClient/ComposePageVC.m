//
//  ReplyPageVC.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/3/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "ComposePageVC.h"
#import "Tweet.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"

@interface ComposePageVC ()
@property (strong, nonatomic) Tweet *tweet;
//@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UITextView *replyTextView;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *tweetButton;
@end

@implementation ComposePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.replyTextView.delegate = self;
    [self setupNavigationBar];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithTweetData:(Tweet *)tweet {
    self = [super initWithNibName:@"ComposePageVC" bundle:nil];
    if (self) {
        self.tweet = tweet;
    }
    return  self;
}

- (void)setupData{
    //User *user = (User *)self.tweet.user;
    self.nameLabel.text = [User currentUser].name;
    self.screenNameLabel.text = [User currentUser].screenname;
    [self.mainImage setImageWithURL:[NSURL URLWithString:[User currentUser].profileImageUrl]];
    
}

- (void)setupNavigationBar {
    [self setTitle:@"Compose"];
    
    [self setupTweetButton:@"Tweet"];
    //UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    //[self.navigationItem setLeftBarButtonItem:cancelBarItem];
    UIBarButtonItem *tweetBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.tweetButton];
    [self.navigationItem setRightBarButtonItem:tweetBarItem];
    
}

- (void)setupTweetButton:(NSString *)buttonTitle {
    self.tweetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [self.tweetButton setBackgroundColor:[UIColor redColor]];
    [self.tweetButton.layer setBorderWidth:1.5f];
    [self.tweetButton.layer setBorderColor:[UIColor brownColor].CGColor];
    [self.tweetButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.tweetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.tweetButton addTarget:self action:@selector(tweetButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tweetButtonAction {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.tweet.tweetId forKey:@"in_reply_to_status_id"];
    [params setValue:self.replyTextView.text forKey:@"status"];
    [self.replyTextView resignFirstResponder];
    self.replyTextView.text = @"";
    BOOL isNewTweet = NO;
    if (isNewTweet) {
        //send requst for newTweet
    } else {
        [[TwitterClient sharedInstance] replyWithParams:params completion:^(NSArray *response, NSError *error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }

    
    
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

@end
