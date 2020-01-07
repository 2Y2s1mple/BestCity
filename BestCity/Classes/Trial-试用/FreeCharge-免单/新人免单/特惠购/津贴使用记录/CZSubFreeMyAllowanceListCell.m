//
//  CZSubFreeMyAllowanceListCell.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/7.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSubFreeMyAllowanceListCell.h"
#import "UIImageView+WebCache.h"

@interface CZSubFreeMyAllowanceListCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;
/** 优惠券 */
@property (nonatomic, weak) IBOutlet UILabel *couponsLabel;
/** 创建时间 */
@property (nonatomic, weak) IBOutlet UILabel *createTimeLabel;
@end


@implementation CZSubFreeMyAllowanceListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZSubFreeMyAllowanceListCell";
    CZSubFreeMyAllowanceListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    self.createTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@", _model[@"createTime"]];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:_model[@"img"]]];
    self.titleLabel.text = _model[@"goodsName"];
    self.couponsLabel.text = [NSString stringWithFormat:@"津贴 ¥%@", _model[@"useAllowancePrice"]];
    NSString *otherPrice = [NSString stringWithFormat:@"淘宝价¥%@", _model[@"otherPrice"]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model[@"buyPrice"]];
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.x = 10;
    rect.size.width -= 20;

    rect.origin.y += 5;
    rect.size.height -= 10;
    [super setFrame:rect];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
