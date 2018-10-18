//
//  CZEvaluationChoicenessCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationChoicenessCell.h"
@interface CZEvaluationChoicenessCell ()
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@end

@implementation CZEvaluationChoicenessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [_attentionBtn setTitle:@"已关注" forState:UIControlStateHighlighted];
    [_attentionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_attentionBtn setTitleColor:CZGlobalGray forState:UIControlStateHighlighted];
    _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _attentionBtn.layer.borderWidth = 0.5;
    _attentionBtn.layer.cornerRadius = 13;
    _attentionBtn.layer.borderColor = [UIColor redColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"evaluationChoicenessCell";
    CZEvaluationChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
