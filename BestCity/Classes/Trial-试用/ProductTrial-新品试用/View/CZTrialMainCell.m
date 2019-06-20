//
//  CZTrialMainCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialMainCell.h"
#import "UIImageView+WebCache.h"

@interface CZTrialMainCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/** 免费申请 */
@property (nonatomic, weak) IBOutlet UIButton *reply;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@end

@implementation CZTrialMainCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"CZTrialMainCell";
    CZTrialMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setTrailModel:(CZTrailModel *)trailModel
{
    _trailModel = trailModel;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:trailModel.img]];
    self.nameLabel.text = trailModel.name;
    self.countLabel.text = trailModel.count;
    self.actualPriceLabel.text = [NSString stringWithFormat:@"¥%@", trailModel.actualPrice];
    
    /** （1即将开始，2进行中，3试用中，4 结束 5结束） */
    switch ([trailModel.status integerValue]) {
        case 2:
            self.reply.hidden = NO;
            self.statusLabel.hidden = YES;
            break;
        case 3:
            self.reply.hidden = YES;
            self.statusLabel.hidden = NO;
            self.statusLabel.text = @"试用中";
            break;
        case 4:
            self.reply.hidden = YES;
            self.statusLabel.hidden = NO;
            self.statusLabel.text = @"已结束";
            break;
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib]; 
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.countLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
    self.actualPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
    self.reply.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.size.height -= 5;
//    [super setFrame:frame];
//}

@end
