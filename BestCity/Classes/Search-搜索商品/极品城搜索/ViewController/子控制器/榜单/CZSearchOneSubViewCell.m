//
//  CZSearchOneSubViewCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZSearchOneSubViewCell.h"
#import "UIImageView+WebCache.h"


@interface CZSearchOneSubViewCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** tag1 */
@property (nonatomic, weak) IBOutlet UIButton *tag1;
/** tag2 */
@property (nonatomic, weak) IBOutlet UIButton *tag2;
/** tag3 */
@property (nonatomic, weak) IBOutlet UIButton *tag3;
/** tag4 */
@property (nonatomic, weak) IBOutlet UIButton *tag4;
/** 当前价格 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
@end

@implementation CZSearchOneSubViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZSearchOneSubViewCell";
    CZSearchOneSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.titleLabel.text = dataDic[@"goodsName"];
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    self.tag4.hidden = YES;

    NSArray *tagsArr = dataDic[@"goodsTagsList"];
    if (![tagsArr isKindOfClass:[NSArray class]]) {
        tagsArr = @[];
    }
    for (int i = 0; i < tagsArr.count; i++) {
        switch (i) {
            case 0:
                [self.tag1 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                self.tag1.hidden = NO;
                self.tag2.hidden = YES;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 1:
                [self.tag2 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                [self layoutIfNeeded];
                if (CGRectGetMaxX(self.tag2.frame) > SCR_WIDTH) {
                    break;
                }
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 2:
                [self.tag3 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                [self layoutIfNeeded];
                if (CGRectGetMaxX(self.tag3.frame) > SCR_WIDTH) {
                    break;
                }
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = YES;
                break;
            case 3:
                //                [self.tag4 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                //                self.tag1.hidden = NO;
                //                self.tag2.hidden = NO;
                //                self.tag3.hidden = NO;
                //                self.tag4.hidden = NO;
                break;
            default:
                break;
        }
    }
    NSString *actualPrice = [NSString stringWithFormat:@"¥%.2f", [dataDic[@"otherPrice"] floatValue]];
    self.actualPriceLabel.text = actualPrice;

}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.actualPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
