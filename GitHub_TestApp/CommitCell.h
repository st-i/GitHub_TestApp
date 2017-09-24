//
//  CommitCell.h
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commiterImageView;
@property (weak, nonatomic) IBOutlet UILabel *shortCommitMessage;
@property (weak, nonatomic) IBOutlet UILabel *whoAndWhenCommitted;
@property (weak, nonatomic) IBOutlet UILabel *sha;

@property (assign, nonatomic) BOOL firstAppearance;

@end
