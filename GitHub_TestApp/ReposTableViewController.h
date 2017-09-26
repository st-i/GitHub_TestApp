//
//  ReposTableViewController.h
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ReposTableViewController : UITableViewController

@property (strong, nonatomic) NSString *currentUsername;
@property (strong, nonatomic) User *authorizedUser;

@end
