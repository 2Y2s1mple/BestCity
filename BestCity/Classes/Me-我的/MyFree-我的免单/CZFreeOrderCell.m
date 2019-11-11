//
//  CZFreeOrderCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeOrderCell.h"
#import "UIImageView+WebCache.h"

@interface CZFreeOrderCell ()

@property (nonatomic, weak) IBOutlet UIImageView *shopImg;
@property (nonatomic, weak) IBOutlet UILabel *shopName;
@property (nonatomic, weak) IBOutlet UILabel *createTime;
@property (nonatomic, weak) IBOutlet UIImageView *itemImgView;
@property (nonatomic, weak) IBOutlet UILabel *itemTitle;
@property (nonatomic, weak) IBOutlet UILabel *alipayTotalPrice;
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *freePrice;


@end

@implementation CZFreeOrderCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeOrderCell";
    CZFreeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(NSDictionary *)model {
    _model = [model changeAllNnmberValue];

    [self.shopImg sd_setImageWithURL:[NSURL URLWithString:_model[@"shopImg"]]];
    self.shopName.text = [NSString stringWithFormat:@"%@赞助", _model[@"shopName"]];
    self.createTime.text = _model[@"createTime"];
    [self.itemImgView sd_setImageWithURL:[NSURL URLWithString:_model[@"img"]]];
    self.itemTitle.text = _model[@"name"];
    self.alipayTotalPrice.text = [NSString stringWithFormat:@"¥%@", _model[@"actualPrice"]];
    NSString *otherPrice = [NSString stringWithFormat:@"¥%@", _model[@"otherPrice"]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];

    self.freePrice.text = [NSString stringWithFormat:@"免%ld%%，预估返：¥%@", [_model[@"freeRate"] integerValue] * 100, _model[@"freePrice"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
