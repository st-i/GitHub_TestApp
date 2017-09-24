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

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;


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
        
        NSURL* url = [NSURL URLWithString:@"https://api.github.com"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void)getReposOfUser:(NSString *)username
            onSuccess:(void (^)(NSArray *))success
            onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSString *requestString = [NSString stringWithFormat:@"/users/%@/repos", username];
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"pushed", @"sort",
     @"desc",    @"direction", nil];
    
    [self.sessionManager GET:requestString
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
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                         
                         if (failure) {
                             failure(error, task.taskIdentifier);
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
    NSString *requestString = [NSString stringWithFormat:@"/repos/%@/%@/commits", username, repositoryName];
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     sinceDate, @"since",
     untilDate, @"until", nil];
    
    [self.sessionManager GET:requestString
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
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                         
                         if (failure) {
                             failure(error, task.taskIdentifier);
                         }
                     }];
}


@end
