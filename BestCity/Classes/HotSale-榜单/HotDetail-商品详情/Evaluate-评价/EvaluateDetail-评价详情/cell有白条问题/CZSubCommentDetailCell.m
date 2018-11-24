//
//  CZSubCommentDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/22.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZSubCommentDetailCell.h"

@interface CZSubCommentDetailCell ()
/** 谁回复的 */
@property (nonatomic, weak) IBOutlet UILabel *replyNameLabel;
/** 回复内容 */
@property (nonatomic, strong) UILabel *replyContentLabel;
/** 回复的label计算用 */
@property (nonatomic, weak) IBOutlet UILabel *label;
/** 父视图计算用 */
@property (nonatomic, weak) IBOutlet UIView *backView;
/** 带尖的图片 */
@property (nonatomic, weak) IBOutlet UIImageView *arrowImage;
@end

@implementation CZSubCommentDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZSubCommentDetailCell";
    CZSubCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // 创建回复的内容
    self.replyContentLabel = [[UILabel alloc] init];
    self.replyContentLabel.textColor = [UIColor blackColor];
    self.replyContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.replyContentLabel.numberOfLines = 0;
    [self.backView addSubview:self.replyContentLabel];
}

- (void)setContentDic:(NSDictionary *)contentDic
{
    _contentDic = contentDic;
    
    if (contentDic[@"isArrow"]) {
        self.arrowImage.hidden = NO;
    } else {
        self.arrowImage.hidden = YES;
    }
    self.replyNameLabel.text = contentDic[@"userShopmember"][@"userNickName"];
    
    // 更新一下
    [self layoutIfNeeded];
    self.replyContentLabel.text = contentDic[@"content"]; //@"与水直接接触的内胆、不锈钢材质安全放心，不易生锈、结垢、无异味、易清洁。与水直接接触的内胆、不锈钢材质安全放心，不易生锈、结垢、无异味、易清洁。与水直接接触的内胆、不锈钢材质安全放心，不易生锈、结垢、无异味、易清洁。与水直接接触的内胆、不锈钢材质安全放心，不易生锈、结垢、无异味、易清洁。与水直接接触的内胆、不锈钢材质安全放心，不易生锈、结垢、无异味、易清洁。";
    self.replyContentLabel.x = CZGetX(self.label);
    self.replyContentLabel.y = self.label.y;
    self.replyContentLabel.width = (SCR_WIDTH - 68) - self.replyContentLabel.x - 10;
    self.replyContentLabel.height = [self.replyContentLabel.text getTextHeightWithRectSize:CGSizeMake(self.replyContentLabel.width, 1000) andFont:self.replyContentLabel.font];
    // 计算cell高度
    self.cellHeight = 30 + 20;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
