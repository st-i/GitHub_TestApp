//
//  ServerManager.m
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "Repository.h"
#import "Commit.h"
#import <UIKit/UIKit.h>

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *originalSessionManager;
@property (strong, nonatomic) AFHTTPSessionManager *authSessionManager;
@property (strong, nonatomic) AccessToken *accessToken;

@end


@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* originalUrl = [NSURL URLWithString:@"https://api.github.com/"];
        self.originalSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:originalUrl];
        
        
        NSURL* authUrl = [NSURL URLWithString:@"https://github.com/login/oauth/"];
        self.authSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:authUrl];
        self.authSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.authSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}
    return self;
}

-(void)authorizeUserWithCode:(NSString *)responseCode
                     andState:(NSString *)state
                    onSuccess:(void (^)(AccessToken *))success
                    onFailure:(void (^)(NSError *))failure
{
    NSDictionary *parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"059d85c41579fffa15d6", @"client_id",
     @"441bda68cb9aeac8561a0ba94f88d158a6c554c4", @"client_secret",
     responseCode, @"code",
     state, @"state", nil];
    
    [self.authSessionManager
     POST:@"access_token"
     parameters:parameters
     progress:^(NSProgress * _Nonnull uploadProgress) {
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         self.accessToken = [[AccessToken alloc]initWithServerResponse:responseObject];
         
         if (success) {
             success(self.accessToken);
         }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
        if (failure) {
            failure(error);
        }
    }];
}

-(void) getReposOfAuthorizedUser:(NSString *)username
                          onPage:(NSInteger) page
                       onSuccess:(void (^)(NSArray *))success
                       onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSString *requestString = @"user/repos";
    
    NSString *repoPage = [NSString stringWithFormat:@"%ld", (long)page];
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.accessToken.token, @"access_token",
     @"pushed", @"sort",
     @"desc",   @"direction",
     repoPage,  @"page",
     @"10",      @"per_page", nil];
    
    [self.originalSessionManager
     GET:requestString
     parameters:parameters
     progress:^(NSProgress * _Nonnull downloadProgress) {
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSMutableArray *repos = [NSMutableArray array];
         
         for (NSDictionary *dictionary in responseObject) {
             Repository *newRepository = [[Repository alloc]initWithServerResponse:dictionary];
             [repos addObject:newRepository];
         }
         
         if (success) {
             success(repos);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (failure) {
             failure(error, error.code);
         }
     }];
    
}

-(void)getReposOfSomeUser:(NSString *)username
                   onPage:(NSInteger) page
                onSuccess:(void (^)(NSArray *))success
                onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSString *requestString = [NSString stringWithFormat:@"users/%@/repos", username];
    
    NSString *repoPage = [NSString stringWithFormat:@"%ld", (long)page];
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"pushed", @"sort",
     @"desc",   @"direction",
     repoPage,  @"page",
     @"10",     @"per_page", nil];
    
    [self.originalSessionManager GET:requestString
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                         NSMutableArray *repos = [NSMutableArray array];
                         
                         for (NSDictionary *dictionary in responseObject) {
                             Repository *newRepository = [[Repository alloc]initWithServerResponse:dictionary];
                             [repos addObject:newRepository];
                         }
                         
                         if (success) {
                             success(repos);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(error, error.code);
                         }
                     }];
}

-(void)getCommitsOfRepository:(NSString *)repositoryName
                       ofUser:(NSString *)username
                        since:(NSString *)sinceDate
                        until:(NSString *)untilDate
                    onSuccess:(void (^)(NSArray *))success
                    onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSString *requestString = [NSString stringWithFormat:@"repos/%@/%@/commits", username, repositoryName];
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     sinceDate, @"since",
     untilDate, @"until", nil];
    
    [self.originalSessionManager GET:requestString
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSMutableArray *commits = [NSMutableArray array];
                         
                         for (NSDictionary *commitDictionary in responseObject) {
                             
                             Commit *commit = [[Commit alloc]initWithServerResponse:commitDictionary];
                             
                             [commits addObject:commit];
                         }
                         
                         if (success) {
                             success(commits);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(error, error.code);
                         }
                     }];
}


@end
