//
//  CZCZFreeChargeCell2.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCZFreeChargeCell2.h"
#import "UIImageView+WebCache.h"

@interface CZCZFreeChargeCell2 ()
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
/** 邀请人数 */
@property (nonatomic, weak) IBOutlet UILabel *residueLabel;
@end

@implementation CZCZFreeChargeCell2
- (void)setModel:(NSDictionary *)model
{
    _model = [model changeAllNnmberValue];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:_model[@"img"]]];
    self.titleLabel.text = _model[@"name"];

    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model[@"buyPrice"]];
    NSString *otherPrice = [NSString stringWithFormat:@"¥%@", _model[@"otherPrice"]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
    self.totalLabel.text = [NSString stringWithFormat:@"已抢%ld件", [_model[@"count"] integerValue]];
    self.residueLabel.text = [NSString stringWithFormat:@"需邀请%ld人可享", [_model[@"inviteUserCount"] integerValue]];

    NSString *inviteUserCount = [NSString stringWithFormat:@"(%ld/%ld)", (long)[_model[@"myInviteUserCount"] integerValue], (long)[_model[@"inviteUserCount"] integerValue]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"立即抢%@", inviteUserCount]];
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} range:NSMakeRange(3, inviteUserCount.length)];
    [string addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFFFFF)} range:NSMakeRange(0, string.length)];
    [self.btn setAttributedTitle:string forState:UIControlStateNormal];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZCZFreeChargeCell2";
    CZCZFreeChargeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
