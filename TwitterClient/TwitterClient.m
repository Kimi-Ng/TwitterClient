//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/1/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"yJJLBQWeQKWPTLgUcGtF9dD2k";
NSString * const kTwitterConsumerSecret = @"AxKykdOP8BX3BGumjtnEh0IJ3zN6GXFtj4LFTdYcmopyG45usf";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@implementation TwitterClient
+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void(^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL];
        NSLog(@"got request token");
    } failure:^(NSError *error) {
        //add err handling
        NSLog(@"err when login to Twitter");
        self.loginCompletion(nil, error);
    }];

}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[[BDBOAuth1Credential alloc] initWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token");
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.loginCompletion(nil, error);
        }];
        
        /*
        [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"tweet: %@", responseObject);
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            for (Tweet *tweet in tweets) {
                NSLog(@"tweet: %@, created: %@", tweet.text, tweet.createAt);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error getting tweet");
        }];
        */
        
        
    } failure:^(NSError *error) {
        NSLog(@"err getting the access token");
        self.loginCompletion(nil, error);
    }];

}


- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);

        //for (Tweet *tweet in tweets) {
        //    NSLog(@"tweet: %@, created: %@", tweet.text, tweet.createAt);
        //}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error getting tweet");
        completion(nil, error);
    }];
}


- (void)replyWithParams:(NSDictionary*) params completion:(void (^)(NSArray *response, NSError *error))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}
 
- (void)retweetWithId:(NSInteger) tweetId completion:(void (^)(NSArray *response, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", tweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}
 

- (void)addFavoriteWithId:(NSInteger)tweetId completion:(void (^)(NSArray *response, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/favorites/create.json?id=%ld", tweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

@end
