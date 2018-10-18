//
//  CZMessageCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMessageCell.h"

@interface CZMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CZMessageCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"messageCell";
    CZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setMessages:(NSDictionary *)messages
{
    _messages = messages;
    self.iconImageView.image = [UIImage imageNamed:messages[@"icon"]];
    self.titleName.text = _messages[@"title"];
    self.subTitle.text = _messages[@"subTitle"];
    self.timeLabel.text = _messages[@"time"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
