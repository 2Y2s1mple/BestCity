//
//  CZFestivalCollectOneCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectOneCell.h"
#import "UIImageView+WebCache.h"

// 跳转
#import "CZSubFreeChargeController.h"
#import "CZSubFreePreferentialController.h" // 特惠购

#import "CZFreePushTool.h"

// 滚动广告位
#import "CZScrollAD.h"

// 不是新人的时候显示
#import "CZFestivalCollectMillionsView.h"

@interface CZFestivalCollectOneCell ()

/** 跑马灯 */
@property (weak, nonatomic) IBOutlet CZScrollAD *messageListView;


/** 新人 */
@property (nonatomic, weak) IBOutlet UIView *peopleNewView;
@property (nonatomic, weak) IBOutlet UILabel *peopleNewViewLabel; // 新人大标题
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleNewViewHeight;

@property (nonatomic, weak) IBOutlet UIImageView *image1; // 图片
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;
@property (nonatomic, weak) IBOutlet UIImageView *image4;
@property (nonatomic, weak) IBOutlet UILabel *title1; // 文字
@property (nonatomic, weak) IBOutlet UILabel *title2;
@property (nonatomic, weak) IBOutlet UILabel *title3;
@property (nonatomic, weak) IBOutlet UILabel *title4;
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;
@property (nonatomic, weak) IBOutlet UILabel *label4;

/** 旧人 */
/** 百万返现 */
@property (nonatomic, strong) CZFestivalCollectMillionsView *millionsView;

/** 每日爆款 */
@property (nonatomic, weak) IBOutlet UIView *HotStyleBackView;
@property (nonatomic, weak) IBOutlet UILabel *HotStyleTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *HotStyleSubTitleLabel;
@property (nonatomic, weak) IBOutlet CZScrollAD *HotStyleTop; // 第一个轮播图载体
@property (nonatomic, weak) IBOutlet CZScrollAD *HotStyleBottom; // 第二个轮播图载体


/** 高反专区 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highBackViewTopMargin; // 高反距离新人的距离
@property (nonatomic, weak) IBOutlet UIView *highBackView; // 背景图
@property (nonatomic, weak) IBOutlet UIView *topHighBackView;
@property (nonatomic, weak) IBOutlet UIView *bottomHighBackView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel1; //高反上
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel1;
@property (nonatomic, weak) IBOutlet UIImageView *highImage1_1;
@property (nonatomic, weak) IBOutlet UIImageView *highImage1_2;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel2; //高反下
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel2;
@property (nonatomic, weak) IBOutlet UIImageView *highImage2_1;
@property (nonatomic, weak) IBOutlet UIImageView *highImage2_2;

/** 广告位 */
@property (nonatomic, weak) IBOutlet UIImageView *adImageView;

@end

@implementation CZFestivalCollectOneCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // 跑马灯
    UITapGestureRecognizer *messageListViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMessageListView)];
    [self.messageListView addGestureRecognizer:messageListViewTap];
    self.messageListView.type = 0;
    self.messageListView.layer.cornerRadius = 4;
    self.messageListView.layer.masksToBounds = YES;

    self.peopleNewViewLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    self.title4.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.title1.font = self.title4.font;
    self.title2.font = self.title4.font;
    self.title3.font = self.title4.font;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPeopleNew)];
    self.peopleNewView.userInteractionEnabled = YES;
    [self.peopleNewView addGestureRecognizer:tap];

    // 百万返现
    self.millionsView = [CZFestivalCollectMillionsView festivalCollectMillionsView];
    self.millionsView.width = self.peopleNewView.width;
    self.millionsView.height = 118;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPreferential)];
    self.millionsView.userInteractionEnabled = YES;
    [self.millionsView addGestureRecognizer:tap1];


    // 每日爆款
    UITapGestureRecognizer *HotStyleBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainHighBackViewAction)];
    [self.HotStyleBackView addGestureRecognizer:HotStyleBackViewTap];
    self.HotStyleTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.HotStyleTop.type = 100;
    self.HotStyleBottom.type = 100;

    // 高反专区
    self.titleLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.titleLabel2.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    // 上
    UITapGestureRecognizer *topHighBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHighBackViewAction)];
    [self.topHighBackView addGestureRecognizer:topHighBackViewTap];
    //下
    UITapGestureRecognizer *bottomHighBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomHighBackViewAction)];
    [self.bottomHighBackView addGestureRecognizer:bottomHighBackViewTap];

    // 广告位
    UITapGestureRecognizer *adImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTapAction)];
    self.adImageView.userInteractionEnabled = YES;
    [self.adImageView addGestureRecognizer:adImageViewTap];
}

- (void)setAllowanceGoodsList:(NSArray *)allowanceGoodsList
{
    _allowanceGoodsList = allowanceGoodsList;

    // 跑马灯
    self.messageListView.dataSource = self.messageList;

    // 老人
    if (self.newUser == NO) {
        self.peopleNewViewHeight.constant = 118;
        self.millionsView.allowanceGoodsList = allowanceGoodsList;
        [self.peopleNewView addSubview:self.millionsView];
        self.highBackViewTopMargin.constant = 12;
    } else { // 新人0元购
        [self.millionsView removeFromSuperview];
        self.peopleNewView.hidden = NO;
        self.peopleNewViewHeight.constant = 142;
        self.highBackViewTopMargin.constant = 12;
        for (int i = 0; i < allowanceGoodsList.count; i++) {
            NSDictionary *imageDic = [allowanceGoodsList[i] changeAllValueWithString];
            NSString *image = imageDic[@"img"];
            NSString *text = [NSString stringWithFormat:@"¥%@", imageDic[@"buyPrice"]];
            NSAttributedString *attrText = [text addStrikethroughWithRange:NSMakeRange(0, text.length)];

            switch (i) {
                case 0:
                    [self.image1 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label1.attributedText = attrText;
                    break;
                case 1:
                    [self.image2 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label2.attributedText = attrText;
                    break;
                case 2:
                    [self.image3 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label3.attributedText = attrText;
                    break;
                case 3:
                    [self.image4 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label4.attributedText = attrText;
                    break;
                default:
                    break;
            }
        }
    }

    // 每日爆款
    [self DailyHotStyle];

    // 高反专区
    [self HighCashback];

    // 广告位
    [self createAdImageView];
}

// 每日爆款
- (void)DailyHotStyle
{
    NSDictionary *param =  [self.hotActivity changeAllValueWithString];
    self.HotStyleTitleLabel.text = param[@"title"];
    self.HotStyleSubTitleLabel.text = param[@"smallTitle"];

    if (self.hotActivity.count > 0) {
        self.HotStyleTop.dataSource = self.hotActivity[@"goodsList1"];
        self.HotStyleBottom.dataSource = self.hotActivity[@"goodsList2"];
    }
}


// 高反专区
- (void)HighCashback
{
    for (int i = 0; i < self.activityList.count; i++) {
        NSDictionary *param = [self.activityList[i] changeAllValueWithString];
        switch (i) {
            case 0:
            {
                self.titleLabel1.text = param[@"title"];
                self.subTitleLabel1.text = param[@"smallTitle"];
                [self.highImage1_1 sd_setImageWithURL:[NSURL URLWithString:param[@"img1"]]];
                [self.highImage1_2 sd_setImageWithURL:[NSURL URLWithString:param[@"img2"]]];
                break;
            }
            case 1:
            {
                self.titleLabel2.text = param[@"title"];
                self.subTitleLabel2.text = param[@"smallTitle"];
                [self.highImage2_1 sd_setImageWithURL:[NSURL URLWithString:param[@"img1"]]];
                [self.highImage2_2 sd_setImageWithURL:[NSURL URLWithString:param[@"img2"]]];
                break;
            }
            default:
                break;
        }
    }
}

// 广告位
- (void)createAdImageView
{
    if (self.ad2) {
        self.adImageView.hidden = NO;
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:self.ad2[@"img"]]];
    } else {
        self.adImageView.hidden = YES;
    }
}

#pragma mark - 事件
// 跳转到新人专区
- (void)pushPeopleNew
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_xinren"];
    CURRENTVC(currentVc);
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}


// 跳特惠购
- (void)pushPreferential
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_tehui"];
    CURRENTVC(currentVc);
    CZSubFreePreferentialController *vc = [[CZSubFreePreferentialController alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}

// 跳到极品城购物返现说明
- (void)pushMessageListView
{
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_pmd"];
    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/newZn.html"]];
    vc.titleName = @"极品城省钱攻略";
    CURRENTVC(currentVc);
    [currentVc.navigationController pushViewController:vc animated:YES];
}

// 爆款主
- (void)mainHighBackViewAction
{
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_zhuanti"];
    NSDictionary *dic =  self.hotActivity;
    NSDictionary *param = @{
        @"targetType" : dic[@"type"],
        @"targetId" : dic[@"targetId"],
        @"targetTitle" : dic[@"title"],
    };
    NSLog(@"%@", param);
    [CZFreePushTool categoryPushToVC:param];
}

// 爆款上
- (void)topHighBackViewAction
{
    [self pushVC:0];
}

// 爆款下
- (void)bottomHighBackViewAction
{
    [self pushVC:1];
}

- (void)pushVC:(NSInteger)index
{
    if (self.activityList.count >= 2) {
        NSDictionary *dic =  self.activityList[index];
        NSDictionary *param = @{
            @"targetType" : dic[@"type"],
            @"targetId" : dic[@"targetId"],
            @"targetTitle" : dic[@"title"],
        };
        NSLog(@"%@", param);
        [CZFreePushTool categoryPushToVC:param];
    }
}

// 广告位
- (void)adImageViewTapAction
{
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_banner.huodong"];
    if([self.ad2[@"type"]  isEqual: @(0)]) return;
    NSDictionary *dic = self.ad2;
    NSDictionary *param = @{
        @"targetType" : dic[@"type"],
        @"targetId" : dic[@"objectId"],
        @"targetTitle" : dic[@"name"],
    };
    NSLog(@"%@", param);
    [CZFreePushTool bannerPushToVC:param];
}


@end
