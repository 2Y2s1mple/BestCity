//
//  CZCollectCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCollectCell.h"
#import "UIImageView+WebCache.h"

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
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;
@property (weak, nonatomic) IBOutlet UILabel *tag3;
@property (weak, nonatomic) IBOutlet UILabel *tag4;


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
        self.tag1.text = model.product_tabs[0];
        self.tag2.text = model.product_tabs[1];
        self.tag3.text = model.product_tabs[2];
        self.tag4.text = model.product_tabs[3];
    }
    
}

@end
