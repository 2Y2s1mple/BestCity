//
//  CZMHSDQuestCell1.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDQuestCell1.h"

@interface CZMHSDQuestCell1 ()
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
/** 审核中 */
@property (nonatomic, weak) IBOutlet UILabel *reviewLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@end

@implementation CZMHSDQuestCell1

+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZMHSDQuestCell1";
    CZMHSDQuestCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)setModel:(CZMHSDQuestModel *)model
{
    _model = model;

    self.answerLabel.text = model.title;

    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.lineView);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.answerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    /** 审核中 */
    self.reviewLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
