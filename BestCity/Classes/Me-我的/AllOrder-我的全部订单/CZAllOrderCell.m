//
//  CZAllOrderCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAllOrderCell.h"
#import "UIImageView+WebCache.h"

@interface CZAllOrderCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *tkCreateTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *itemImgView;
@property (nonatomic, weak) IBOutlet UILabel *itemTitle;
@property (nonatomic, weak) IBOutlet UILabel *itemNum;
@property (nonatomic, weak) IBOutlet UILabel *alipayTotalPrice;
@property (nonatomic, weak) IBOutlet UILabel *preFee;
@property (nonatomic, weak) IBOutlet UILabel *tradeId;
@property (nonatomic, weak) IBOutlet UILabel *appEarningTime;

@end

@implementation CZAllOrderCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZAllOrderCell";
    CZAllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(NSDictionary *)model {
    _model = [model changeAllNnmberValue];
    if ([_model[@"status"] integerValue] == 1) { // 0全部 1即将到账，2已到账，3订单失效
        self.statusLabel.text = @"即将到账";
        self.appEarningTime.text = @"收货后次月结算";
    } else if ([_model[@"status"] integerValue] == 2) {
        self.statusLabel.text = @"已到账";
        self.appEarningTime.text = [NSString stringWithFormat:@"%@已到账", _model[@"appEarningTime"]];
    } else if ([_model[@"status"] integerValue] == 3) {
        self.statusLabel.text = @"订单失效";
        self.appEarningTime.text = @"失效订单无返现";
    }

    self.tkCreateTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@", _model[@"tkCreateTime"]]; //下单时间
    [self.itemImgView sd_setImageWithURL:[NSURL URLWithString:_model[@"itemImg"]]];
    self.itemTitle.text = _model[@"itemTitle"];
    self.itemNum.text = [NSString stringWithFormat:@"x%@", _model[@"itemNum"]];
    self.alipayTotalPrice.text = [NSString stringWithFormat:@"付款：%@元", _model[@"alipayTotalPrice"]];
    self.preFee.text = [NSString stringWithFormat:@"返现：%@元", _model[@"preFee"]];
    self.tradeId.text = [NSString stringWithFormat:@"订单号：%@", _model[@"tradeId"]];
}

/** 复制到剪切板 */
- (IBAction)generalPaste
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = _model[@"tradeId"];
    [CZProgressHUD showProgressHUDWithText:@"复制成功"];
    [CZProgressHUD hideAfterDelay:1.5];
    [recordSearchTextArray addObject:posteboard.string];
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
