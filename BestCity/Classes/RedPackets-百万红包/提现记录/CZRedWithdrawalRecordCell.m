//
//  CZRedWithdrawalRecordCell.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedWithdrawalRecordCell.h"
@interface CZRedWithdrawalRecordCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label1;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label2;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label3;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label4;
@end

@implementation CZRedWithdrawalRecordCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZRedWithdrawalRecordCell";
    CZRedWithdrawalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZRedWithdrawalRecordCell class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    self.label1.text = [NSString stringWithFormat:@"%@", _model[@"alipayNickname"]];
    self.label2.text = [NSString stringWithFormat:@"申请时间：%@", _model[@"createTime"]];
    // 状态（-2提现超时,-1审核失败,0未审核,1初审通过,2复审通过,未提现,3延迟审核,4提现成功）
    self.label3.textColor = UIColorFromRGB(0x9D9D9D);
    self.label4.textColor = UIColorFromRGB(0xE25838);
    if ([_model[@"status"] integerValue] == 4) {
        self.label3.text = [NSString stringWithFormat:@"%@", @"已转账"];
    } else if ([_model[@"status"] integerValue] == -2 || [_model[@"status"] integerValue] == -1) {
        self.label3.text = [NSString stringWithFormat:@"%@", @"提现超时"];
        self.label3.textColor = UIColorFromRGB(0xFFB829);
        self.label4.textColor = UIColorFromRGB(0x9D9D9D);
    } else {
        self.label3.text = [NSString stringWithFormat:@"%@", @"审核中"];
    }
    self.label4.text = [NSString stringWithFormat:@"%@元", _model[@"money"]];

}                 

@end
