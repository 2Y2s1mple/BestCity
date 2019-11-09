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
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;


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

//    self.freePrice.text = [NSString stringWithFormat:@"免50%，预估返：¥199.80", _model[@"actualPrice"]];

    if ([_model[@"applyStatus"] isEqualToString:@"1"]) { // 1待确认，2已结算，3已失效
        self.statusLabel.text = @"待确认";
    } else if ([_model[@"status"] isEqualToString:@"2"]) {
        self.statusLabel.text = @"已结算";
    } else if ([_model[@"status"] isEqualToString:@"3"]) {
        self.statusLabel.text = @"已失效";

    }





}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
