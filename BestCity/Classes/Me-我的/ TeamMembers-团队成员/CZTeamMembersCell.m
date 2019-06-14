//
//  CZTeamMembersCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTeamMembersCell.h"
#import "UIImageView+WebCache.h"

@interface CZTeamMembersCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 副标题 */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
/** 钱 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@end

@interface CZTeamMembersCell ()

@end

@implementation CZTeamMembersCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"CZTeamMembersCell";
    CZTeamMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];

    }
    return cell;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]]];
    self.titleLabel.text = dataDic[@"nickname"];
    self.subTitleLabel.text = [NSString stringWithFormat:@"个人收益 ¥%.2f", [dataDic[@"commission"] floatValue]];;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [dataDic[@"shareCommission"] floatValue]];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
