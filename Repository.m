//
//  Repository.m
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Repository.h"
#import <UIKit/UIKit.h>

@implementation Repository

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        NSDictionary *ownerDictionary = [responseObject objectForKey:@"owner"];
        NSObject *loginObject = [ownerDictionary objectForKey:@"login"];
        if ([loginObject isKindOfClass:[NSString class]]) {
            self.ownerName = [NSString stringWithFormat:@"%@", loginObject];
        }else{
            self.ownerName = @"Автор не указан";
        }
        
        NSString *photoURL = [ownerDictionary objectForKey:@"avatar_url"];
        if (photoURL) {
            self.ownerPhotoURL = [NSURL URLWithString:photoURL];
        }
        
        //Возвращались некорректные данные относительно Watchers. Вместо этого показывается количество звезд.
        NSNumber *stars = [responseObject objectForKey:@"stargazers_count"];
        CGFloat starsFloat = stars.floatValue;
        if (starsFloat > 99999 && starsFloat < 1000000) {
            starsFloat = starsFloat / 1000;
            self.starsCount = [NSString stringWithFormat:@"%.1fk", starsFloat];
        }else if (starsFloat > 999999 && starsFloat < 10000000) {
            starsFloat = starsFloat / 1000000;
            self.starsCount = [NSString stringWithFormat:@"%.1fm", starsFloat];
        }else{
            self.starsCount = [NSString stringWithFormat:@"%.0f", starsFloat];
        }
        
        NSNumber *forks = [responseObject objectForKey:@"forks_count"];
        CGFloat forksFloat = forks.floatValue;
        if (forksFloat > 99999 && forksFloat < 1000000) {
            forksFloat = forksFloat / 1000;
            self.forkCount = [NSString stringWithFormat:@"%.1fk", forksFloat];
        }else if (forksFloat > 999999 && forksFloat < 10000000) {
            forksFloat = forksFloat / 1000000;
            self.forkCount = [NSString stringWithFormat:@"%.1fm", forksFloat];
        }else{
            self.forkCount = [NSString stringWithFormat:@"%.0f", forksFloat];
        }
        
        NSObject *descriptionResponse = [responseObject objectForKey:@"description"];
        if ([descriptionResponse isKindOfClass:[NSNull class]]) {
            self.repoDescription = @"Описание отсутствует.";
        }else{
            self.repoDescription = [NSString stringWithFormat:@"%@", descriptionResponse];
        }
        
        NSObject *nameObject = [responseObject objectForKey:@"name"];
        if ([nameObject isKindOfClass:[NSString class]]) {
            self.name = [NSString stringWithFormat:@"%@", nameObject];
        }else{
            self.name = @"Some GitHub Project";
        }
        
        NSObject *languageObject = [responseObject objectForKey:@"language"];
        if ([languageObject isKindOfClass:[NSString class]]) {
            self.language = [NSString stringWithFormat:@"%@", languageObject];
        }else{
            self.language = @"Нет информации";
        }
        
        NSString *ISODate = [responseObject objectForKey:@"pushed_at"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *commitDateAndTime = [dateFormatter dateFromString:ISODate];
        
        NSString *stringDate = [dateFormatter stringFromDate:commitDateAndTime];
        NSString *requestDate = [[stringDate substringToIndex:stringDate.length-5] stringByAppendingString:@"Z"];
        
        self.dateAndTimeOfLastUpdate = requestDate;
        
        NSString *year = [requestDate substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [requestDate substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [requestDate substringWithRange:NSMakeRange(8, 2)];
        self.dateOfLastUpdate = [NSString stringWithFormat:@"%@.%@.%@", day, month, year];
        
        self.size = [responseObject objectForKey:@"size"];
        
    }
    return self;
}

@end
