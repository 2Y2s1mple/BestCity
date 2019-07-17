//
//  CZMHSDQuestCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDQuestCell.h"
#import "UIImageView+WebCache.h"

@interface CZMHSDQuestCell ()
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImage;
@property (nonatomic, weak) IBOutlet UILabel *answerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UILabel *moreLabel;
/** 回答问题 */
@property (nonatomic, weak) IBOutlet UIView *answerView;
/** 参与回答 */
@property (nonatomic, weak) IBOutlet UILabel *partInLabel;
@end

@implementation CZMHSDQuestCell

- (void)setModel:(CZMHSDQuestModel *)model
{
    _model = model;
    self.questionLabel.text = model.title;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.answer[@"userAvatar"]]];
    self.answerNameLabel.text = model.answer[@"userNickname"];
    self.answerLabel.text = model.answer[@"content"];
    self.moreLabel.text = [NSString stringWithFormat:@"查看全部%@条回答", model.answerCount];

    if ([model.answerCount integerValue] == 0) {
        self.answerView.hidden = YES;
        [self layoutIfNeeded];
        model.cellHeight = CZGetY(self.partInLabel) + 20;
    } else {
        self.answerView.hidden = NO;
        [self layoutIfNeeded];
        model.cellHeight = CZGetY(self.answerView) + 1;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.questionLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.answerNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12];
    self.answerLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 14];
    self.moreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];

    self.questionLabel.preferredMaxLayoutWidth = SCR_WIDTH - 64;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
