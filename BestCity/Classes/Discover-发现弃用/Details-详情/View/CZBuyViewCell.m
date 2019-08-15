//
//  CZBuyViewCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZBuyViewCell.h"
#import "UIImageView+WebCache.h"

@interface CZBuyViewCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bidImage;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 券后价 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/**  其他平台价格 */
@property (nonatomic, weak) IBOutlet UILabel *otherPrice;
@end

@implementation CZBuyViewCell
- (IBAction)buyAction:(UIButton *)sender {
    
}

- (void)setBuyDataDic:(NSDictionary *)buyDataDic
{
    _buyDataDic = buyDataDic;
    [self. bidImage sd_setImageWithURL:[NSURL URLWithString:buyDataDic[@"img"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.titleLabel.text = buyDataDic[@"goodsName"];
    self.actualPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [buyDataDic[@"actualPrice"] floatValue]];
    if ([buyDataDic[@"status"] isEqualToNumber:@(1)]) {
        self.otherPrice.hidden = NO;
        NSString *therPrice = [NSString stringWithFormat:@"%@ ¥%@", [self platfromNameWithNumber:buyDataDic[@"source"]], buyDataDic[@"otherPrice"]];
        self.otherPrice.attributedText = [therPrice addStrikethroughWithRange:[therPrice rangeOfString:[NSString stringWithFormat:@"¥%@", buyDataDic[@"otherPrice"]]]];
    } else {
        self.otherPrice.hidden = YES;
    }
    
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.actualPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = CZGlobalLightGray.CGColor;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSString *)platfromNameWithNumber:(NSNumber *)platformNumber
{
    // 平台
    NSString *status;
    switch ([platformNumber integerValue]) {
        case 0:
            status = @"原价";
            break;
        case 1:
            status = @"京东价";
            break;
        case 2:
            status = @"淘宝价";
            break;
        case 3:
            status = @"天猫价";
            break;
        default:
            status = @"";
            break;
    }
    return status;
}

@end
