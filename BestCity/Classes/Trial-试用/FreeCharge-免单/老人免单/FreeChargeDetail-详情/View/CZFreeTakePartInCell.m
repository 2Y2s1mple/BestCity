//
//  CZFreeTakePartInCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeTakePartInCell.h"
#import "UIImageView+WebCache.h"

@interface CZFreeTakePartInCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *headerImage;
/** 注释 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *likeCount;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *timerLabel;

@end

@implementation CZFreeTakePartInCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeTakePartInCell";
    CZFreeTakePartInCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]]];
    self.nameLabel.text = dic[@"nickname"];
    self.timerLabel.text = dic[@"createTime"];
    self.likeCount.text = [NSString stringWithFormat:@"到手￥%.0lf", [dic[@"buyPrice"] floatValue]];
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
