//
//  AccessToken.m
//  GitHub_TestApp
//
//  Created by iStef on 25.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "AccessToken.h"

@implementation AccessToken

-(id)initWithServerResponse:(NSDictionary*)responseObject
{
    self = [super init];
    
    if (self) {
        self.token = [responseObject objectForKey:@"access_token"];
        
        self.tokenType = [responseObject objectForKey:@"token_type"];
        
        NSString *stringScope = [responseObject objectForKey:@"scope"];
        if ([stringScope containsString:@","]) {
            self.scope = [stringScope componentsSeparatedByString:@","];
        }else{
            self.scope = [NSArray arrayWithObject:stringScope];
        }
    }
    return self;
}

@end
