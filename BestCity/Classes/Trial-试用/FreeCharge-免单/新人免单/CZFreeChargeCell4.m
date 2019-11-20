//
//  CZFreeChargeCell4.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell4.h"
#import "UIImageView+WebCache.h"

@interface CZFreeChargeCell4 ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;
/** 一共多少件 */
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
/** 即将开启 */
@property (nonatomic, weak) IBOutlet UIButton *btn;
/** 新人价 */
@property (nonatomic, weak) IBOutlet UILabel *residueLabel;
@end

@implementation CZFreeChargeCell4
- (void)setModel:(NSDictionary *)model
{
    _model = [model changeAllNnmberValue];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:_model[@"img"]]];
    self.titleLabel.text = _model[@"name"];

    NSString *otherPrice = [NSString stringWithFormat:@"淘宝价¥%@", _model[@"otherPrice"]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
    self.totalLabel.text = [NSString stringWithFormat:@"已抢%ld件", [_model[@"count"] integerValue]];
    self.residueLabel.text = [NSString stringWithFormat:@"需邀请%ld人可享", [_model[@"inviteUserCount"] integerValue]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeChargeCell4";
    CZFreeChargeCell4 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.residueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
