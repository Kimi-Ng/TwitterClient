//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/1/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

@property (strong, nonatomic) void(^loginCompletion)(User *user, NSError *error);

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void(^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)replyWithParams:(NSDictionary*) params completion:(void (^)(NSArray *response, NSError *error))completion;
- (void)retweetWithId:(NSInteger) tweetId completion:(void (^)(NSArray *response, NSError *error))completion;
- (void)addFavoriteWithId:(NSInteger)tweetId completion:(void (^)(NSArray *response, NSError *error))completion;
@end
