//
//  Repository.h
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

-(id)initWithServerResponse:(NSDictionary*)responseObject;

@property (strong, nonatomic) NSURL *ownerPhotoURL;
@property (strong, nonatomic) NSString *ownerName;

@property (strong, nonatomic) NSString *name;

@property (assign, nonatomic) NSString *starsCount;
@property (assign, nonatomic) NSString *forkCount;

@property (strong, nonatomic) NSString *repoDescription;

@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *dateAndTimeOfLastUpdate;
@property (strong, nonatomic) NSString *dateOfLastUpdate;

@property (strong, nonatomic) NSNumber *size;

@end
