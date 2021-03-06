//
//  CZMainHotSaleHeaderView.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainHotSaleHeaderView.h"
#import "UIButton+CZExtension.h" // 按钮扩展

@interface CZMainHotSaleHeaderView ()
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
@end

@interface CZMainHotSaleHeaderView ()
@property (nonatomic, strong) void (^actionBlock)(void);
@end

@implementation CZMainHotSaleHeaderView
- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(void))action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.actionBlock = action;
        self.size = CGSizeMake(SCR_WIDTH, 209 + (IsiPhoneX ? 24 : 0));
        self.backgroundColor = UIColorFromRGB(0xE25838);
        [self setupSubViews];
    }
    return self;
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 44 : 20), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
//        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
//        _popButton.layer.cornerRadius = 15;
//        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

- (void)popAction
{
    CURRENTVC(currentVc);
    [currentVc.navigationController popViewControllerAnimated:YES];
}

- (void)setupSubViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];

    [self addSubview:self.popButton];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"榜单";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 36];
    [label sizeToFit];
    label.x = 14;
    label.y = 46 + (IsiPhoneX ? 24 : 0);
    [self addSubview:label];

    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = @"回归产品本质，拒绝竞价排名";
    otherLabel.textColor = [UIColor whiteColor];
    otherLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    [otherLabel sizeToFit];
    otherLabel.x = label.x;
    otherLabel.y = CZGetY(label);
    [self addSubview:otherLabel];

    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = CZGlobalWhiteBg;
    searchView.x = 14;
    searchView.y = CZGetY(otherLabel) + 30;
    searchView.size = CGSizeMake(SCR_WIDTH - searchView.x * 2, 45);
    [self addSubview:searchView];

    UILabel *sLabel = [[UILabel alloc] init];
    sLabel.text = @"输入查询商品名称";
    sLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    sLabel.textColor = UIColorFromRGB(0xD8D8D8);
    [sLabel sizeToFit];
    sLabel.x = 10;
    sLabel.centerY = searchView.height / 2.0;
    [searchView addSubview:sLabel];

    UIImageView *sImage = [[UIImageView alloc] init];
    sImage.image = [UIImage imageNamed:@"search"];
    [sImage sizeToFit];
    sImage.centerY = sLabel.centerY;
    sImage.x = searchView.width - 20 - sImage.size.width;
    [searchView addSubview:sImage];
}

- (instancetype)initWithFrame:(CGRect)frame pushAction:(void (^)(void))action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.actionBlock = action;
        self.size = CGSizeMake(SCR_WIDTH, (IsiPhoneX ? 44 : 20) + 10 + 35);
        self.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self createNavigation];
    }
    return self;
}

- (void)createNavigation
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];

    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = CZGlobalWhiteBg;
    searchView.x = 14;
    searchView.y = (IsiPhoneX ? 44 : 20) + 5;
    searchView.size = CGSizeMake(SCR_WIDTH - searchView.x * 2, 35);
    [self addSubview:searchView];

    UILabel *sLabel = [[UILabel alloc] init];
    sLabel.text = @"输入查询商品名称";
    sLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    sLabel.textColor = UIColorFromRGB(0xD8D8D8);
    [sLabel sizeToFit];
    sLabel.x = 10;
    sLabel.centerY = searchView.height / 2.0;
    [searchView addSubview:sLabel];

    UIImageView *sImage = [[UIImageView alloc] init];
    sImage.image = [UIImage imageNamed:@"search"];
    [sImage sizeToFit];
    sImage.centerY = sLabel.centerY;
    sImage.x = searchView.width - 20 - sImage.size.width;
    [searchView addSubview:sImage];
}

- (void)action:(UITapGestureRecognizer *)tap
{
    NSLog(@"%s", __func__);
    !self.actionBlock ? : self.actionBlock();
}


@end
