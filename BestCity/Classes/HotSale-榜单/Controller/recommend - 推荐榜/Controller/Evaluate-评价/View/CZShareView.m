//
//  CZShareView.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZShareView.h"
#import "Masonry.h"
#import "CZUMConfigure.h"
#define PLACEHOLDERTAG 100
@implementation CZShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}


- (void)setupSubView
{
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(SCR_HEIGHT / 3));
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"一边分享 一边赚钱";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabel.textColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.87];
    [shareView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareView).offset(20);
        make.centerX.equalTo(shareView);
    }];
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"如果好友通过您分享的链接完成购买，您即可获得10%的佣金，并可提现到支付宝账户。";
    subTitleLabel.numberOfLines = 2;
    subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    subTitleLabel.textColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.87];
    [shareView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(shareView).offset(20);
        make.right.equalTo(shareView).offset(-20);
    }];
    CGFloat wh = 50;
    CGFloat space = (SCR_WIDTH - 20 - 5 * wh) / 4;
    NSArray *imageArr = @[@"wechat", @"pyq", @"weibo", @"qq-friend", @"qq-space"];
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%ld", idx);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.tag = idx + PLACEHOLDERTAG;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [imageView addGestureRecognizer:tap];
        imageView.frame = CGRectMake(10 + (wh + space) * idx, 120, 50, 50);
        [shareView addSubview:imageView];
    }];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(shareView.mas_top);
    }];
}

- (void)action:(UITapGestureRecognizer *)tap
{
    
    NSLog(@"%ld", tap.view.tag);
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (tap.view.tag - PLACEHOLDERTAG) {
        case 0:
            type = UMSocialPlatformType_WechatSession;//微信好友
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
            break;
        case 2:
            type = UMSocialPlatformType_Sina;//新浪微博
            break;
        case 3:
            type = UMSocialPlatformType_QQ;//QQ好友
            break;
        case 4:
            type = UMSocialPlatformType_Qzone;//QQ空间
            break;
        default:
            
            break;
    }
    
    [[CZUMConfigure shareConfigure] shareToPlatformType:type currentViewController:(UIViewController *)[self superview].nextResponder];
}

- (void)dismiss
{
    [self removeFromSuperview];
}









@end
