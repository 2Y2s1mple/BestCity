//
//  CZRecommendNav.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZRecommendNav.h"
#import "UIButton+CZExtension.h"
#import "Masonry.h"

@interface CZRecommendNav ()
@property (nonatomic, strong) NSArray *mainTitles;
/** 上部的滑动条 */
@property (nonatomic, strong)UIView *scrollerLine;
/** 记录点击的标题 */
@property (nonatomic, strong) UIButton *recordBtn;
@end

@implementation CZRecommendNav
/** 主标题数组 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"商品", @"评测", @"评价"];
    }
    return _mainTitles;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupNavigateView];
    }
    return self;
}


//自定义的导航栏
- (void)setupNavigateView
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.width.equalTo(@(FSS(60)));
        make.height.equalTo(@(FSS(20)));
    }];
    
    CGFloat btnX = 70;
    CGFloat btnW = (SCR_WIDTH - 127) / 3.0;
    CGFloat btnH = 20;
    for (int i = 0; i < self.mainTitles.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(btnX + i * btnW, 0, btnW, btnH);
        [self addSubview:titleBtn];
        titleBtn.center = CGPointMake(titleBtn.center.x, self.height / 2);
        [titleBtn setTitle:self.mainTitles[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if (i == 0) titleBtn.selected = YES;
        titleBtn.tag = i + 100;
        [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *scrollerLine = [[UIView alloc] init];
    scrollerLine.backgroundColor = [UIColor redColor];
    self.scrollerLine = scrollerLine;
    [self addSubview:scrollerLine];
    [scrollerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([self viewWithTag:100]);
        make.bottom.equalTo(self).offset(-2);
        make.height.equalTo(@2);
        make.width.equalTo(@20);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"nav-favor"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(0);
        make.width.equalTo(@(FSS(40)));
        make.height.equalTo(@(FSS(20)));
    }];
    
}

- (void)popAction
{
    [self.delegate recommendNavWithPop:self];
}

- (void)titleBtnAction:(UIButton *)sender
{
    self.recordBtn.selected = NO;
    sender.selected = YES;
    
    CGFloat btnW = (SCR_WIDTH - 127) / 3.0;
    switch (sender.tag) {
        case 100: btnW = 0;
            break;
        case 102: btnW = 2 * btnW;
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollerLine.transform = CGAffineTransformMakeTranslation(btnW, 0);
    }];
    self.recordBtn = sender;
}


@end
