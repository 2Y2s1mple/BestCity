//
//  CZMyTrialApplyForFailedCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyTrialApplyForFailedCell.h"
#import "UIImageView+WebCache.h"

@interface CZMyTrialApplyForFailedCell ()
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 第一行文字 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 第二行文字 */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
@end

@implementation CZMyTrialApplyForFailedCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZMyTrialApplyForFailedCell";
    CZMyTrialApplyForFailedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setDicData:(NSDictionary *)dicData
{
    _dicData = dicData;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:dicData[@"img"]]];
    self.titleLabel.text = dicData[@"name"];
    if (dicData[@"remark"]) {
        self.subTitleLabel.text = dicData[@"remark"];
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
