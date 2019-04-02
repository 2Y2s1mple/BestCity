//
//  CZTrialApplySuccessCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialApplySuccessCell.h"
#import "UIImageView+WebCache.h"

@interface CZTrialApplySuccessCell ()
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 第一行文字 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 第二行文字 */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
/** 第三行文字 */
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
/** 失败原因 */
@property (nonatomic, weak) IBOutlet UILabel *remarkLabel;
/** 下面按钮 */
@property (nonatomic, weak) IBOutlet UIButton *shareBtn;
@end

@implementation CZTrialApplySuccessCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZTrialApplySuccessCell";
    CZTrialApplySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setDicData:(NSDictionary *)dicData
{
    _dicData = dicData;
    [self.bigImage sd_setImageWithURL:dicData[@"img"]];
    self.titleLabel.text = dicData[@"name"];
    self.subTitleLabel.text = [NSString stringWithFormat:@"请在%@前确认", dicData[@"reportEndTime"]];
    self.statusLabel.text = dicData[@"remark"];
    self.remarkLabel.text = dicData[@""];
    
}

/** 写报告 */
- (IBAction)shareBtnAction
{
    NSLog(@"---写报告---");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
