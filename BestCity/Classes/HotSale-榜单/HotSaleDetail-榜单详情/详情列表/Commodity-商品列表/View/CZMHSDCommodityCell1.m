//
//  CZMHSDCommodityCell1.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDCommodityCell1.h"
// 跳转
#import "CZMHSDetailBkController.h" // 百科
#import "CZMHSDQuestController.h" // 问答


@interface CZMHSDCommodityCell1 ()
/** 百科 */
@property (nonatomic, weak) IBOutlet UILabel *BKTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *BKSubTitle1;
@property (nonatomic, weak) IBOutlet UILabel *BKSubTitle2;
@property (nonatomic, weak) IBOutlet UILabel *BKSubTitle3;

/** 话题问答 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTitle1;
@property (nonatomic, weak) IBOutlet UILabel *subTitle2;
@property (nonatomic, weak) IBOutlet UILabel *subTitle3;
/** 跳转 */
@property (nonatomic, weak) IBOutlet UIButton *questionBtn;
@end

@implementation CZMHSDCommodityCell1
- (void)setBkDataDic:(NSDictionary *)bkDataDic
{
    _bkDataDic = bkDataDic;
    self.BKSubTitle1.hidden = YES;
    self.BKSubTitle2.hidden = YES;
    self.BKSubTitle3.hidden = YES;
    self.BKTitleLabel.text = [NSString stringWithFormat:@"%@百科", self.titleText];
    NSString *str = bkDataDic[@"subtitle"];
    NSArray *dataList = [str componentsSeparatedByString:@"|"];

    for (int i = 0; i < dataList.count; i++) {
        switch (i) {
            case 0:
                self.BKSubTitle1.text = dataList[i];
                self.BKSubTitle1.hidden = NO;
                self.BKSubTitle2.hidden = YES;
                self.BKSubTitle3.hidden = YES;
                break;
            case 1:
                self.BKSubTitle2.text = dataList[i];
                self.BKSubTitle1.hidden = NO;
                self.BKSubTitle2.hidden = NO;
                self.BKSubTitle3.hidden = YES;
                break;
            case 2:
                self.BKSubTitle3.text = dataList[i];
                self.BKSubTitle1.hidden = NO;
                self.BKSubTitle2.hidden = NO;
                self.BKSubTitle3.hidden = NO;
                break;
            default:
                break;
        }
    }
}


- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    self.subTitle1.hidden = YES;
    self.subTitle2.hidden = YES;
    self.subTitle3.hidden = YES;

    for (int i = 0; i < dataList.count; i++) {
        switch (i) {
            case 0:
                self.subTitle1.text = dataList[i][@"title"];
                self.subTitle1.hidden = NO;
                self.subTitle2.hidden = YES;
                self.subTitle3.hidden = YES;
                break;
            case 1:
                self.subTitle2.text = dataList[i][@"title"];
                self.subTitle1.hidden = NO;
                self.subTitle2.hidden = NO;
                self.subTitle3.hidden = YES;
                break;
            case 2:
                self.subTitle3.text = dataList[i][@"title"];
                self.subTitle1.hidden = NO;
                self.subTitle2.hidden = NO;
                self.subTitle3.hidden = NO;
                break;
            default:
                break;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 26];
    self.BKTitleLabel.font = self.titleLabel.font;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)bkAction:(UITapGestureRecognizer *)sender {
    if (self.bkDataDic[@"articleId"]) {
        CZMHSDetailBkController *toVc = [[CZMHSDetailBkController alloc] init];
        toVc.titleText = [NSString stringWithFormat:@"%@百科", self.titleText];
        toVc.dataDic = self.bkDataDic;
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *nav = tabbar.selectedViewController;
        UIViewController *vc = nav.topViewController;
        [vc.navigationController pushViewController:toVc animated:YES];
    }
}

- (IBAction)questionAction:(UITapGestureRecognizer *)sender {
    CZMHSDQuestController *toVc = [[CZMHSDQuestController alloc] init];
    toVc.titleText = [NSString stringWithFormat:@"%@问答区", self.titleText];
    toVc.dataArr = self.dataList;
    toVc.ID = self.ID;
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    [vc.navigationController pushViewController:toVc animated:YES];
}


@end
