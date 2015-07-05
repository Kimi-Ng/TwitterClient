//
//  Tweet.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/1/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//


#import "Tweet.h"
#import "NSDate+RelativeTime.h"

@implementation Tweet
- (id)initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.tweetId = dictionary[@"id"];
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        
        NSString *createdAtStr = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createAt = [formatter dateFromString:createdAtStr];
        self.relativeTime = [self.createAt relativeTime];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];//"favorite_count"
        self.isFavorited = [dictionary[@"favorited"] integerValue] == 1 ? YES: NO;//favorited 0/1
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];//retweet_count
        self.isRetweeted = [dictionary[@"retweeted"] integerValue] == 1 ? YES : NO;//retweeted 0/1
        
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dict]];
    }
    return tweets;
}

@end
