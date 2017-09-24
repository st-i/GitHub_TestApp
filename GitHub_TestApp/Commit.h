//
//  Commit.h
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commit : NSObject

-(id)initWithServerResponse:(NSDictionary*)responseObject;

@property (strong, nonatomic) NSURL *commiterPhotoURL;

@property (strong, nonatomic) NSString *shortCommitMessage;
@property (strong, nonatomic) NSString *commiterNickname;
@property (strong, nonatomic) NSString *commitDateAndTime;
@property (strong, nonatomic) NSString *commitDate;
@property (strong, nonatomic) NSString *sha;

@end
