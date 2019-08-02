//
//  CZCommonRecommendCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCommonRecommendCell.h"
#import "UIImageView+WebCache.h"


@interface CZCommonRecommendCell ()
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** subTitle */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
@end

@implementation CZCommonRecommendCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZCommonRecommendCell";
    CZCommonRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.titleLabel.text = dataDic[@"title"];
    self.subTitleLabel.text = dataDic[@"createTime"];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
}

- (void)setArticleDic:(NSDictionary *)articleDic
{
    _articleDic = articleDic;
    self.titleLabel.text = articleDic[@"title"];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@阅读", articleDic[@"pv"]];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:articleDic[@"img"]]];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
