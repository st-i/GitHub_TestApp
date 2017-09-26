//
//  AccessToken.h
//  GitHub_TestApp
//
//  Created by iStef on 25.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *tokenType;
@property (strong, nonatomic) NSArray *scope;

-(id)initWithServerResponse:(NSDictionary*)responseObject;

@end
