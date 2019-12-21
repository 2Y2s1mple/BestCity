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

#import "CZFreePushTool.h"

// 滚动广告位
#import "CZScrollAD.h"

@interface CZFestivalCollectOneCell ()

/** 跑马灯Label */
@property (nonatomic, weak) IBOutlet UIView *messageListView;

/** 新人 */
@property (nonatomic, weak) IBOutlet UIView *peopleNewView;
// 新人大标题
@property (nonatomic, weak) IBOutlet UILabel *peopleNewViewLabel;
// 图片
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;
@property (nonatomic, weak) IBOutlet UIImageView *image4;
// 文字
@property (nonatomic, weak) IBOutlet UILabel *title1;
@property (nonatomic, weak) IBOutlet UILabel *title2;
@property (nonatomic, weak) IBOutlet UILabel *title3;
@property (nonatomic, weak) IBOutlet UILabel *title4;
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;
@property (nonatomic, weak) IBOutlet UILabel *label4;

/** 高反专区 */
// 背景图
@property (nonatomic, weak) IBOutlet UIView *highBackView;
@property (nonatomic, weak) IBOutlet UIView *topHighBackView;
@property (nonatomic, weak) IBOutlet UIView *bottomHighBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highBackViewTopMargin;

//1.
@property (nonatomic, weak) IBOutlet UILabel *titleLabel1;
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel1;
@property (nonatomic, weak) IBOutlet UIImageView *highImage1_1;
@property (nonatomic, weak) IBOutlet UIImageView *highImage1_2;
//2.
@property (nonatomic, weak) IBOutlet UILabel *titleLabel2;
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel2;
@property (nonatomic, weak) IBOutlet UIImageView *highImage2_1;
@property (nonatomic, weak) IBOutlet UIImageView *highImage2_2;

/** 每日爆款 */
@property (nonatomic, weak) IBOutlet UIView *HotStyleBackView;
@property (nonatomic, weak) IBOutlet UILabel *HotStyleTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *HotStyleSubTitleLabel;
// 上
@property (nonatomic, weak) IBOutlet UIView *HotStyleTop;
// 下
@property (nonatomic, weak) IBOutlet UIView *HotStyleBottom;

/** 广告位 */
@property (nonatomic, weak) IBOutlet UIImageView *adImageView;

@end

@implementation CZFestivalCollectOneCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // 跑马灯
    UITapGestureRecognizer *messageListViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMessageListView)];
    [self.messageListView addGestureRecognizer:messageListViewTap];
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


    // 每日爆款
    UITapGestureRecognizer *HotStyleBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainHighBackViewAction)];
    [self.HotStyleBackView addGestureRecognizer:HotStyleBackViewTap];
    self.HotStyleTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];

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

- (void)setFreeGoodsList:(NSArray *)freeGoodsList
{
    _freeGoodsList = freeGoodsList;

    // 跑马灯
    if (self.messageList.count > 0) {
        CZScrollAD *scollLabel =  [[CZScrollAD alloc] initWithFrame:self.messageListView.bounds dataSource:self.messageList type:0];
        [self.messageListView addSubview:scollLabel];
    }

    // 新人0元购
    if (freeGoodsList.count == 0) {
        self.peopleNewView.hidden = YES;
        self.highBackViewTopMargin.constant = - 142;
    } else {
        self.peopleNewView.hidden = NO;
        self.highBackViewTopMargin.constant = 12;
        for (int i = 0; i < freeGoodsList.count; i++) {
            NSDictionary *imageDic = [freeGoodsList[i] changeAllValueWithString];
            NSString *image = imageDic[@"img"];
            NSString *text = [@"¥" stringByAppendingString:imageDic[@"otherPrice"]];

            switch (i) {
                case 0:
                    [self.image1 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label1.text = text;
                    break;
                case 1:
                    [self.image2 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label2.text = text;
                    break;
                case 2:
                    [self.image3 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label3.text = text;
                    break;
                case 3:
                    [self.image4 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.label4.text = text;
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
        CZScrollAD *scollView1 =  [[CZScrollAD alloc] initWithFrame:self.HotStyleTop.bounds dataSource:self.hotActivity[@"goodsList1"] type:1];
        [self.HotStyleTop addSubview:scollView1];

        CZScrollAD *scollView2 =  [[CZScrollAD alloc] initWithFrame:self.HotStyleBottom.bounds dataSource:self.hotActivity[@"goodsList2"] type:1];
        [self.HotStyleBottom addSubview:scollView2];
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
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:self.ad2[@"img"]]];
}

#pragma mark - 事件
// 跳转到新人专区
- (void)pushPeopleNew
{
    CURRENTVC(currentVc);
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}

// 跳到极品城购物补贴说明
- (void)pushMessageListView
{
    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/fee-rule.html"]];
    vc.titleName = @"极品城购物补贴说明";
    CURRENTVC(currentVc);
    [currentVc.navigationController pushViewController:vc animated:YES];
}

// 爆款主
- (void)mainHighBackViewAction
{
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
