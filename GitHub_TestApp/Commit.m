//
//  Commit.m
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Commit.h"

@implementation Commit

-(id)initWithServerResponse:(NSDictionary*)responseObject
{
    self = [super init];
    if (self) {
        
        NSDictionary *commitDictionary = [responseObject objectForKey:@"commit"];
        NSObject *nameObject = [commitDictionary objectForKey:@"message"];
        if ([nameObject isKindOfClass:[NSString class]]) {
            NSString *shortAndLongMessage = [NSString stringWithFormat:@"%@", nameObject];
            NSString *shortMessage;
            if ([shortAndLongMessage containsString:@"\n"]) {
                NSRange endRange = [shortAndLongMessage rangeOfString:@"\n"];
                shortMessage = [shortAndLongMessage substringToIndex:endRange.location];
                self.shortCommitMessage = shortMessage;
            }else{
                shortMessage = shortAndLongMessage;
            }
            
            if (shortMessage.length == 0) {
                self.shortCommitMessage = @"Some Commit";
            }else{
                self.shortCommitMessage = shortMessage;
            }
        }else{
            self.shortCommitMessage = @"Some Commit";
        }
        
        NSDictionary *nestedCommiterDictionary = [commitDictionary objectForKey:@"committer"];
        
        NSString *ISODate = [nestedCommiterDictionary objectForKey:@"date"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *commitDateAndTime = [dateFormatter dateFromString:ISODate];
        
        NSString *stringDate = [dateFormatter stringFromDate:commitDateAndTime];
        NSString *requestDate = [[stringDate substringToIndex:stringDate.length-5] stringByAppendingString:@"Z"];
        
        self.commitDateAndTime = requestDate;
        
        NSString *year = [requestDate substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [requestDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [requestDate substringWithRange:NSMakeRange(8, 2)];
        self.commitDate = [NSString stringWithFormat:@"%@.%@.%@", day, month, year];
        
        NSObject *authorDictionary = [responseObject objectForKey:@"author"];
        
        if ([authorDictionary isKindOfClass:[NSDictionary class]]) {
            NSDictionary *approvedAuthorDictionary = [responseObject objectForKey:@"author"];
            NSObject *nicknameObject = [approvedAuthorDictionary objectForKey:@"login"];
            
            NSString *photoURL = [approvedAuthorDictionary objectForKey:@"avatar_url"];
            if (photoURL) {
                self.commiterPhotoURL = [NSURL URLWithString:photoURL];
            }
            
            if ([nicknameObject isKindOfClass:[NSString class]]) {
                self.commiterNickname = [NSString stringWithFormat:@"%@", nicknameObject];
            }else{
                self.commiterNickname = @"Автор не указан";
                
            }
        }else{
            NSObject *committerName = [nestedCommiterDictionary objectForKey:@"name"];
            self.commiterPhotoURL = [NSURL URLWithString:@"https://avatars1.githubusercontent.com/u/31770218?v=4"];
            if ([committerName isKindOfClass:[NSString class]]) {
                self.commiterNickname = [NSString stringWithFormat:@"%@", committerName];
            }else{
                self.commiterNickname = @"Unknown";
            }
        }
        
        NSObject *shaObject = [responseObject objectForKey:@"sha"];
        if ([shaObject isKindOfClass:[NSString class]]) {
            self.sha = [NSString stringWithFormat:@"%@", shaObject];
        }else{
            self.sha = @"не указан";
        }

    }
    return self;
}

@end
