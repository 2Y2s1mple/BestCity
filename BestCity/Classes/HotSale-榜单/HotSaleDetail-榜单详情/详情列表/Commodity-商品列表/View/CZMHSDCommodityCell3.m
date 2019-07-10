//
//  CZMHSDCommodityCell3.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDCommodityCell3.h"
#import "UIImageView+WebCache.h"
#import "CZMHSDRecommendController.h"

@interface CZMHSDCommodityCell3 ()
/** 主要的大标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 更多按钮 */
@property (nonatomic, weak) IBOutlet UIButton *moreBtn;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleSubLabel;
/** 阅读数 */
@property (nonatomic, weak) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@end

@implementation CZMHSDCommodityCell3
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.titleSubLabel.text = dataDic[@"title"];
    NSString *actualPrice = [NSString stringWithFormat:@"%@阅读", dataDic[@"pv"]];
    self.readLabel.text = actualPrice;
}

- (void)setIsFirstOne:(BOOL)isFirstOne
{
    _isFirstOne = isFirstOne;
    if (isFirstOne) {
        self.titleLabel.hidden = NO;
        self.moreBtn.hidden = NO;
        self.topMargin.constant = 25;
    } else {
        self.titleLabel.hidden = YES;
        self.moreBtn.hidden = YES;
        self.topMargin.constant = -9;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 19];
    self.moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    [self.moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)moreBtnAction
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    // 更多
    CZMHSDRecommendController *toVc = [[CZMHSDRecommendController alloc] init];
    toVc.ID = self.ID;
    toVc.titleText = self.titleText;
    [vc.navigationController pushViewController:toVc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
