//
//  CZFreeChargeCell4.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell4.h"
#import "UIImageView+WebCache.h"
#import "CZBusinessTool.h"

@interface CZFreeChargeCell4 ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;
/** 已抢多少件 */
@property (nonatomic, weak) IBOutlet UILabel *qiangLabel;
/** 即将开启 */
@property (nonatomic, weak) IBOutlet UIButton *btn;
/** 新人价 */
@property (nonatomic, weak) IBOutlet UILabel *residueLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end

@implementation CZFreeChargeCell4



- (void)setModel:(CZSubFreeChargeModel *)model
{
    _model = model;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    self.titleLabel.text = _model.goodsName;

    NSString *otherPrice = [NSString stringWithFormat:@"淘宝价¥%@", _model.otherPrice];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];

    ;
    [self.progressView setProgress:(model.count / 100.0) animated:YES];

    self.qiangLabel.text = [NSString stringWithFormat:@"已抢%.0lf%%", (self.progressView.progress * 100)];
  

    _model.cellHeight = 140;
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
    for (UIImageView * imageview in self.progressView.subviews) {
        imageview.layer.cornerRadius = 3;
        imageview.clipsToBounds = YES;
    }
}

- (IBAction)bugBtnClicked:(UIButton *)sender {
    NSLog(@"----");
    [CZBusinessTool buyBtnActionWithId:self.model.Id];
}


- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.x = 10;
    rect.size.width -= 20;
    [super setFrame:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
