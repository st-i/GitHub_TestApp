//
//  CommitsTableViewController.m
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "CommitsTableViewController.h"
#import "ServerManager.h"
#import "CommitCell.h"
#import "UIKit+AFNetworking.h"
#import "Commit.h"


@interface CommitsTableViewController ()

@property (strong, nonatomic) NSMutableArray *repositoryCommits;
@property (strong, nonatomic) NSString *olderCommitDate;
@property (strong, nonatomic) NSString *repositoryCommitsAmount;
@property (assign, nonatomic) BOOL noMoreCommits;

@end

@implementation CommitsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noMoreCommits = NO;
    
    self.navigationItem.title = self.currentRepository.name;
    
    self.repositoryCommits = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadRepositoryCommits];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadRepositoryCommits
{
    if (self.currentRepository.size.integerValue != 0) {
    
    NSString *requestUntilDate;
    NSString *requestSinceDate;
    NSDate *untilDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    if (self.repositoryCommits.count == 0) {
        untilDate = [dateFormatter dateFromString:self.currentRepository.dateAndTimeOfLastUpdate];
        requestUntilDate = self.currentRepository.dateAndTimeOfLastUpdate;
    }else{
        NSDate *newUntilDate = [dateFormatter dateFromString:self.olderCommitDate];
        newUntilDate = [NSDate dateWithTimeInterval:-1 sinceDate:newUntilDate];
        untilDate = newUntilDate;
        NSString *stringUntilDate = [dateFormatter stringFromDate:untilDate];
        requestUntilDate = [[stringUntilDate substringToIndex:stringUntilDate.length-5] stringByAppendingString:@"Z"];
    }
    
    NSDate *sinceDate = [NSDate dateWithTimeInterval:-126144000 sinceDate:untilDate];
    NSString *stringSinceDate = [dateFormatter stringFromDate:sinceDate];
    requestSinceDate = [[stringSinceDate substringToIndex:stringSinceDate.length-5] stringByAppendingString:@"Z"];
    
    [[ServerManager sharedManager]
     getCommitsOfRepository:self.currentRepository.name
     ofUser:self.currentRepository.ownerName
     since:requestSinceDate
     until:requestUntilDate
     onSuccess:^(NSArray *commits) {
         [self.repositoryCommits addObjectsFromArray:commits];
         if (commits.count == 0) {
             self.noMoreCommits = YES;
             [self.tableView reloadData];
         }
         
         if (commits.count == 30) {
             Commit *lastCommit = [commits lastObject];
             self.olderCommitDate = lastCommit.commitDateAndTime;
         }else{
             self.olderCommitDate = requestSinceDate;
         }
         
         NSMutableArray* newPaths = [NSMutableArray array];
         for (int i = (int)[self.repositoryCommits count] - (int)commits.count; i < (int)[self.repositoryCommits count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
     }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.repositoryCommits.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"originalCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSString *descriptionString = self.currentRepository.repoDescription;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:descriptionString];
        [attributedString addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightThin] range:[descriptionString rangeOfString:descriptionString]];
        
        cell.textLabel.numberOfLines = 1000;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.attributedText = attributedString;
        
        return cell;
        
    }else{
        if (indexPath.row == self.repositoryCommits.count) {
            
            static NSString *identifier = @"loadOlderCommits";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            UIView *lowerSeparator = [[UIView alloc] initWithFrame:CGRectMake(16, cell.contentView.frame.size.height - 0.5, tableView.window.bounds.size.width - 33, 0.5)];
            lowerSeparator.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lowerSeparator];
            
            NSString *lastCellText;
            
            if (self.noMoreCommits) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                lastCellText = [NSString stringWithFormat:@"Amount of commits: %ld", self.repositoryCommits.count];
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }else{
                if (self.currentRepository.size.integerValue == 0) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    lastCellText = @"Repository is empty";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    lastCellText = @"Older commits";
                    cell.textLabel.textColor = [UIColor blueColor];
                }
            }
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lastCellText];
            [attributedString addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:UIFontWeightThin] range:[lastCellText rangeOfString:lastCellText]];
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.attributedText = attributedString;
            
            return cell;
        }else{
            static NSString *identifier = @"commitCell";
            
            CommitCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommitCell" owner:self options:nil];
                cell = [array firstObject];
            }
            
            if (cell.firstAppearance) {
                UIView *lowerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, self.view.frame.size.width, 0.5)];
                lowerSeparator.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lowerSeparator];
                
                cell.firstAppearance = NO;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            Commit *commit = [self.repositoryCommits objectAtIndex:indexPath.row];
            
            NSURLRequest* request = [NSURLRequest requestWithURL:commit.commiterPhotoURL];
            __weak CommitCell* weakCell = cell;
            cell.commiterImageView.image = nil;
            [cell.commiterImageView
             setImageWithURLRequest:request
             placeholderImage:nil
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                 weakCell.commiterImageView.image = image;
                 [weakCell layoutSubviews];
             }
             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             }];
            
            cell.shortCommitMessage.text = commit.shortCommitMessage;
            
            NSString *fullString = [NSString stringWithFormat:@"%@ commited on %@", commit.commiterNickname, commit.commitDate];
            NSMutableAttributedString *fullAttributedString = [[NSMutableAttributedString alloc] initWithString:fullString];
            NSString *boldPart = commit.commiterNickname;
            NSRange boldRange = [fullString rangeOfString:boldPart];
            [fullAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:boldRange];
            [cell.whoAndWhenCommitted setAttributedText: fullAttributedString];
            
            cell.sha.text = [NSString stringWithFormat:@"SHA %@", commit.sha];
            
            return cell;
        }
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == self.repositoryCommits.count &&
        !self.noMoreCommits && self.currentRepository.size.integerValue != 0) {
        [self loadRepositoryCommits];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UIFont* font = [UIFont systemFontOfSize:14.f];
        
        NSShadow* shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowBlurRadius = 0.5;
        
        NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraph setAlignment:NSTextAlignmentLeft];
        
        NSDictionary* attributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
         font, NSFontAttributeName,
         paragraph, NSParagraphStyleAttributeName,
         shadow, NSShadowAttributeName, nil];
        
        CGRect rect = [self.currentRepository.repoDescription boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 32, CGFLOAT_MAX)
                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                      attributes:attributes
                         context:nil];
        
        return CGRectGetHeight(rect) + 40;
        
    }else if (indexPath.section == 1) {
        if (self.repositoryCommits.count > 0) {
            if (indexPath.row == self.repositoryCommits.count) {
                return 44.f;
            }else{
                return 144.f;
            }
        }
    }
    return 44.f;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *newHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    newHeaderView.backgroundColor = [UIColor colorWithRed:246.f/256.f green:246.f/256.f blue:246.f/256.f alpha:1];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [newHeaderView addSubview:titleLabel];
    
    NSString *headerTitle;

    if (section == 0) {
    headerTitle = @"Description";
    }else{
        headerTitle = @"Commits";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:headerTitle];
    [attributedString addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightThin] range:[headerTitle rangeOfString:headerTitle]];
    
    titleLabel.attributedText = attributedString;
    
    return newHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end
