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

@interface CZFestivalCollectOneCell ()
/** 新人 */
@property (nonatomic, weak) IBOutlet UIView *peopleNewView;
/** 新人大标题 */
@property (nonatomic, weak) IBOutlet UILabel *peopleNewViewLabel;
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;
@property (nonatomic, weak) IBOutlet UIImageView *image4;

/** 文字 */
@property (nonatomic, weak) IBOutlet UILabel *title1;
@property (nonatomic, weak) IBOutlet UILabel *title2;
@property (nonatomic, weak) IBOutlet UILabel *title3;
@property (nonatomic, weak) IBOutlet UILabel *title4;


@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;
@property (nonatomic, weak) IBOutlet UILabel *label4;

/** 高反专区 */
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
@property (nonatomic, weak) IBOutlet UILabel *HotStyleTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *HotStyleSubTitleLabel;

/** 广告位 */
@property (nonatomic, weak) IBOutlet UIImageView *adImageView;

@end

@implementation CZFestivalCollectOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.peopleNewViewLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    self.title4.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.title1.font = self.title4.font;
    self.title2.font = self.title4.font;
    self.title3.font = self.title4.font;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPeopleNew)];
    self.peopleNewView.userInteractionEnabled = YES;
    [self.peopleNewView addGestureRecognizer:tap];


    // 高反专区
    self.titleLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.titleLabel2.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];

    // 每日爆款
    self.HotStyleTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    
}

- (void)setFreeGoodsList:(NSArray *)freeGoodsList
{
    _freeGoodsList = freeGoodsList;

    // 新人0元购

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

    // 每日爆款
    [self DailyHotStyle];

    // 高反专区
    [self HighCashback];

    // 广告位
    [self createAdImageView];
}


// 跳转到新人
- (void)pushPeopleNew
{
    CURRENTVC(currentVc);
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}

// 每日爆款
- (void)DailyHotStyle
{
    NSDictionary *param =  [self.hotActivity changeAllValueWithString];
    self.HotStyleTitleLabel.text = param[@"title"];
    self.HotStyleSubTitleLabel.text = param[@"smallTitle"];
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




@end
