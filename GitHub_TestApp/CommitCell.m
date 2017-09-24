//
//  CommitCell.m
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "CommitCell.h"

@implementation CommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstAppearance = YES;
    self.commiterImageView.backgroundColor = [UIColor lightGrayColor];
    self.commiterImageView.layer.cornerRadius = 4.0;
    [self.commiterImageView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIImage *image = self.commiterImageView.image;
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.commiterImageView.image = image;
    }
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIImage *image = self.commiterImageView.image;
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.commiterImageView.image = image;
    }
}

@end
