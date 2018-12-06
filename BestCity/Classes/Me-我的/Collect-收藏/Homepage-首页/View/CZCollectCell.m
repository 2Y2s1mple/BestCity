//
//  CZCollectCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCollectCell.h"
#import "UIImageView+WebCache.h"
#import "CALayer+LayerColor.h"

@interface CZCollectCell ()
/** 收藏图片 */
@property (nonatomic, weak) IBOutlet UIImageView *icon;
/** 收藏标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 现价 */
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
/** 原价 */
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
/** 访问量 */
@property (weak, nonatomic) IBOutlet UIButton *lookNumber;
/** 标签1 */
@property (weak, nonatomic) IBOutlet UIButton *tag1;
@property (weak, nonatomic) IBOutlet UIButton *tag2;
@property (weak, nonatomic) IBOutlet UIButton *tag3;
@property (weak, nonatomic) IBOutlet UIButton *tag4;


@end


@implementation CZCollectCell

+(instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"collectCell";
    CZCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(CZCollectionModel *)model
{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.product_img] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.titleLabel.text = model.collect_message;
    self.nowPrice.text = [@"¥" stringByAppendingString:model.collect_price];
    self.oldPrice.text = [@"天猫：¥" stringByAppendingString:model.product_price];
    [self.lookNumber setTitle:model.collect_nubmer forState:UIControlStateNormal];
    if (model.product_tabs.count >= 4) {
        [self.tag1 setTitle:model.product_tabs[0] forState:UIControlStateNormal];
        [self.tag2 setTitle:model.product_tabs[1] forState:UIControlStateNormal];
        [self.tag3 setTitle:model.product_tabs[2] forState:UIControlStateNormal];
        [self.tag4 setTitle:model.product_tabs[3] forState:UIControlStateNormal];
    }
    
}

- (void)setCommodityData:(NSDictionary *)commodityData
{
    _commodityData = commodityData;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:commodityData[@"rankGoodImg"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.titleLabel.text = commodityData[@"goodsName"];
    self.nowPrice.text = [NSString stringWithFormat:@"¥%.2f", [commodityData[@"actualPrice"] floatValue]];
    NSString *source;
    switch ([commodityData[@"sourceStatusg"] integerValue]) {
        case 1: // 京东
            source = @"京东";
            break;
        case 2: // 淘宝
            source = @"淘宝";
            break;
        case 3: // 天猫
            source = @"天猫";
            break;
        default:
            source = @"淘宝";
            break;
    }
    
    NSString *otherPrice = [NSString stringWithFormat:@"%@：¥%@", source, commodityData[@"otherPrice"]];
    
    self.oldPrice.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:[NSString stringWithFormat:@"%@", commodityData[@"otherPrice"]]]];
    
    [self.lookNumber setTitle:commodityData[@"visitCount"] forState:UIControlStateNormal];
    
   
    
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    self.tag4.hidden = YES;
    NSArray *goodsTypeList = commodityData[@"goodstypeList"];
    for (int i = 0; i < goodsTypeList.count; i++) {
        switch (i) {
            case 0:
                self.tag1.hidden = NO;
                self.tag2.hidden = YES;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                [self.tag1 setTitle:goodsTypeList[i][@"name"] forState:UIControlStateNormal];
                break;
            case 1:
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                [self.tag2 setTitle:goodsTypeList[i][@"name"] forState:UIControlStateNormal];
                break;
            case 2:
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = YES;
                [self.tag3 setTitle:goodsTypeList[i][@"name"] forState:UIControlStateNormal];
                break;
            case 3:
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = NO;
                [self.tag4 setTitle:goodsTypeList[i][@"name"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (void)setDiscoverData:(NSDictionary *)discoverData
{
    _discoverData = discoverData;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:discoverData[@"imgId"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.titleLabel.text = discoverData[@"title"];
    
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    self.tag4.hidden = YES;
    self.nowPrice.text = @"";
    self.oldPrice.text = discoverData[@"publishTime"];
    [self.lookNumber setTitle:discoverData[@"visitCount"] forState:UIControlStateNormal];
    
}

- (void)setEvalwayData:(NSDictionary *)evalwayData
{
    _evalwayData = evalwayData;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:evalwayData[@"imgId"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.titleLabel.text = evalwayData[@"evalWayName"];
    
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    self.tag4.hidden = YES;
    self.nowPrice.text = @"";
    self.oldPrice.text = evalwayData[@"publishTime"];
    [self.lookNumber setTitle:evalwayData[@"visitCount"] forState:UIControlStateNormal];
}


@end
