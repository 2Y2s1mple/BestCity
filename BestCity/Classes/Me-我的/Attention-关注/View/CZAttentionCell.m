//
//  CZAttentionCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionCell.h"
#import "CZAttentionBtn.h"
#import "UIImageView+WebCache.h"

@interface CZAttentionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
/** 关注头像 */
@property (nonatomic, weak) IBOutlet UIImageView *headerImage;
/** 关注名字*/
@property (weak, nonatomic) IBOutlet UILabel *attentionNameLabel;
@end

@implementation CZAttentionCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"attentionCell";
    CZAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    //添加关注按钮
    CZAttentionBtn *btn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(SCR_WIDTH - 70, (60 - 24) / 2.0, 60, 24) didClickedAction:^{
        NSLog(@"点击了%@按钮", self.title);
    }];
    [self.contentView addSubview:btn];
    
}

- (void)setModel:(CZAttentionsModel *)model
{
    _model = model;
    self.attentionNameLabel.text = model.from_nickname;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.from_thumb_img] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
