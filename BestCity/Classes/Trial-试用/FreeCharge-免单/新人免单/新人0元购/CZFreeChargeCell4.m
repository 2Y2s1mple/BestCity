//
//  CZFreeChargeCell4.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell4.h"
#import "UIImageView+WebCache.h"
#import "CZJIPINSynthesisTool.h"

#import "CZSubFreePreferentialController.h"

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

/** 已抢光 */
@property (nonatomic, strong) UIView *maskView;

@end

@implementation CZFreeChargeCell4
- (UIView *)maskView
{
    if (_maskView == nil) {
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        maskView.layer.cornerRadius = 5;
        maskView.x = 10;
        maskView.y = 15;
        maskView.size = self.bigImageView.size;
        UIImageView *maskImage = [[UIImageView alloc] init];
        maskImage.contentMode = UIViewContentModeScaleAspectFit;
        maskImage.size = self.bigImageView.size;
        maskImage.image = [UIImage imageNamed:@"festival-qiang-2"];
        [maskView addSubview:maskImage];
        _maskView = maskView;
    }
    return _maskView;
}

- (void)setModel:(CZSubFreeChargeModel *)model
{
    _model = model;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    self.titleLabel.text = _model.goodsName;

    NSString *otherPrice = [NSString stringWithFormat:@"淘宝价¥%.2f", [_model.otherPrice floatValue]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
    
    if ([model.total integerValue] > 0 ) {
        [self.progressView setProgress:(model.count / 100.0) animated:YES];
        self.qiangLabel.text = [NSString stringWithFormat:@"已抢%.0lf%%", (self.progressView.progress * 100)];
        [self.btn setTitle:@"0元购" forState:UIControlStateNormal];
        [self.btn setBackgroundColor:UIColorFromRGB(0xE25838)];
        [self.maskView removeFromSuperview];
    } else { // 抢光
        [self.progressView setProgress:0.0 animated:YES];
        self.qiangLabel.text = @"已抢完";
        [self.btn setTitle:@"已抢完" forState:UIControlStateNormal];
        [self.btn setBackgroundColor:UIColorFromRGB(0x9D9D9D)];
        [self.contentView addSubview:self.maskView];
    }
    _model.cellHeight = 140;
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
{
    static NSString *ID = @"CZFreeChargeCell4";
    CZFreeChargeCell4 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    if (indexPath.row == 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 20 , 140) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *maskLayer = [[CAShapeLayer  alloc]  init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
        } else if (indexPath.row == 6) {
    //        UIBezierPath *bezierPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 40, 60) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    //        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    //        mask.frame = cell.bounds;
    //        mask.path = bezierPath.CGPath;
    //        cell.layer.mask = mask;
        } else {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 20 , 140) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(0, 0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer  alloc]  init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
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
    self.btn.enabled = NO;
}

- (IBAction)bugBtnClicked:(UIButton *)sender {
    NSLog(@"----");
    
    [CZJIPINSynthesisTool buyBtnActionWithId:self.model.Id alertTitle:nil];
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
