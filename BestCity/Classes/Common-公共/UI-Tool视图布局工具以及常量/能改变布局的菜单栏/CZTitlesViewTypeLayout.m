//
//  CZTitlesViewTypeLayout.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/17.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTitlesViewTypeLayout.h"

@implementation CZTitlesViewTypeLayout

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)createTitles
{

    CGFloat leftRightSpace = 20;
    CGFloat itemWidth = 42;
    CGFloat space = (SCR_WIDTH - 2 *leftRightSpace - itemWidth * 5) / 4;

    NSArray *list = @[@"综合", @"价格", @"补贴", @"销量", @""];
    for (int i = 0; i < list.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 105 + i;
        btn.x = leftRightSpace + i * (itemWidth + space);
        [btn setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        btn.width = itemWidth;
        btn.height = 38;
        [btn setTitle:list[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        self.orderByType = @"0"; // 0综合，1价格，2补贴，3销量
        self.asc = @"1"; // (1正序，0倒序)
        if (i == 0) {
            [btn setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
            self.recordBtn = btn;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
        }

        if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"search_asc_non"] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        }
        if (i == 4) {
            [btn setImage:[UIImage imageNamed:@"search_line"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"search_cols"] forState:UIControlStateSelected];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }

    // 获取数据
}


- (void)titleAction:(UIButton *)sender
{
    if (sender.tag != 106) {
        self.recoredBtnClick = 0;
    }
    if (self.recordBtn.tag == 106) {
        [self.recordBtn setImage:[UIImage imageNamed:@"search_asc_non"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"search_asc_non"] forState:UIControlStateSelected];
    }
    //（0综合，1价格，2补贴，3销量）
    switch (sender.tag) {
        case 105:
            self.orderByType = @"0";
            break;
        case 106:
        {
            self.recoredBtnClick++;
            if (self.recoredBtnClick == 1) {
                [sender setImage:[UIImage imageNamed:@"search_asc"] forState:UIControlStateNormal];
                sender.selected = NO;
                self.asc = @"1"; // (1正序，0倒序)
            } else if(self.recoredBtnClick == 2) {
                [sender setImage:[UIImage imageNamed:@"search_nasc"] forState:UIControlStateSelected];
                sender.selected = YES;
                self.asc = @"0"; // (1正序，0倒序)
                self.recoredBtnClick = 0;
            }
            self.orderByType = @"1";
            break;
        }
        case 107:
            self.orderByType = @"2";
            break;
        case 108:
            self.orderByType = @"3";
            break;
        case 109:
        {
//            self.collectView.contentOffset = CGPointMake(0, 0);
            if (sender.isSelected) {
                sender.selected = NO; // 条
                self.layoutType = YES;
            } else {
                sender.selected = YES; // 块
                self.layoutType = NO;
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:@"mainSameTitleAction" object:nil userInfo:@{@"orderByType" : self.orderByType, @"asc" : self.asc, @"layoutType" : @(self.layoutType)}];


            return;
        }
        default:
            break;
    }

    [self.recordBtn setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
    self.recordBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    [sender setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    self.recordBtn = sender;


    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainSameTitleAction" object:nil userInfo:@{@"orderByType" : self.orderByType, @"asc" : self.asc, @"layoutType" : @(self.layoutType)}];
}
@end
