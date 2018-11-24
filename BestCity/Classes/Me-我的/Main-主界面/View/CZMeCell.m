//
//  CZMeCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeCell.h"
@interface CZMeCell ()
/** 总钱数 */
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
/** 处理中 */
@property (weak, nonatomic) IBOutlet UILabel *beingProcessed;
/** 可提现 */
@property (weak, nonatomic) IBOutlet UILabel *withdraw;
/** 待结算 */
@property (weak, nonatomic) IBOutlet UILabel *settleAccount;
/** 已提现 */
@property (weak, nonatomic) IBOutlet UILabel *afterSettleAccount;

@end

@implementation CZMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"meCell";
    CZMeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZMeCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
//    self.totalMoney.text =[NSString stringWithFormat:@"总佣金¥%@", data[@"total_account"] == nil ? @"0" : [NSString stringWithFormat:@"%0.2f", [data[@"total_account"] floatValue]]];
//    self.beingProcessed.text = data[@"state"] == nil ? @"0" : data[@"state"];
//    self.settleAccount.text = @"0";
//    self.withdraw.text = [NSString stringWithFormat:@"%@", data[@"use_account"] == nil ? @"0" : data[@"use_account"]];
//    self.afterSettleAccount.text = [NSString stringWithFormat:@"%@", data[@"unuse_account"] == nil ? @"0" : data[@"unuse_account"]];
    
//    [self setupMoney:data];
}

- (void)setupMoney:(NSDictionary *)result
{
    // 总金额
    NSString *total = [self changeStr:result[@"total_account"] ? result[@"total_account"] : @""];
    // 已体现
    NSString *afterAccount = [self changeStr:result[@"use_account"]];
    
    self.totalMoney.text = [@"总佣金¥" stringByAppendingString:total];
    self.beingProcessed.text = result[@"state"];
    self.withdraw.text = total;
    self.settleAccount.text = @"0";
    self.afterSettleAccount.text = afterAccount;
    
}

- (NSString *)changeStr:(id)value
{
    return [NSString stringWithFormat:@"%0.2f", [value floatValue]];
}

@end
