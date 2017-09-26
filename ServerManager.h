//
//  ServerManager.h
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessToken.h"

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

-(void) authorizeUserWithCode:(NSString *) responseCode
                     andState:(NSString *) state
                    onSuccess:(void(^)(AccessToken *accessToken)) success
                    onFailure:(void(^)(NSError* error)) failure;

- (void) getReposOfAuthorizedUser:(NSString *) username
                           onPage:(NSInteger) page
                        onSuccess:(void(^)(NSArray *repos)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getReposOfSomeUser:(NSString *) username
                     onPage:(NSInteger) page
                  onSuccess:(void(^)(NSArray *repos)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCommitsOfRepository:(NSString *) repositoryName
                         ofUser:(NSString *) username
                          since:(NSString *)sinceDate
                          until:(NSString *)untilDate
              onSuccess:(void(^)(NSArray *commits)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
