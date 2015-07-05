//
//  Tweet.h
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/1/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (strong, nonatomic) NSString *tweetId;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createAt; //created_at
@property (nonatomic, assign) NSUInteger favoriteCount;//"favorite_count"
@property (nonatomic, assign) BOOL isFavorited;//favorited 0/1
@property (strong, nonatomic) NSString *relativeTime;
@property (nonatomic, assign) NSUInteger retweetCount;//retweet_count
@property (nonatomic, assign) BOOL isRetweeted;//retweeted 0/1
@property (strong, nonatomic) User *user;
- (id)initWithDictionary: (NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
