//
//  CZFestivalCollectHeaderView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectHeaderView.h"

#import "CZScollerImageTool.h"
#import "CZSubButton.h"
#import "UIButton+WebCache.h"

@interface CZFestivalCollectHeaderView () <UIScrollViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIView *minline;

/** <#注释#> */
@property (nonatomic, strong) UIView *headerView;
/** 轮播图 */
@property (nonatomic, strong) CZScollerImageTool *imageView;
/** 宫格 */
@property (nonatomic, strong) UIScrollView *categoryView;
/** 最下面条 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CZFestivalCollectHeaderView

- (void)prepareForReuse
{
    [super prepareForReuse];
    NSLog(@"%s", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headerView];

    }
    return self;
}

- (void)setAd1List:(NSArray *)ad1List
{
    _ad1List = ad1List;
    if (ad1List.count > 0) {
        [self createHeaderTableView];
    }

}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.width = SCR_WIDTH;
        _headerView.height = 260 + 10;
    }
    return _headerView;
}

#pragma mark - UI创建
- (void)createHeaderTableView
{
    // 添加轮播图
    if (self.imageView == nil) {
        CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(15, 0, SCR_WIDTH - 30, 150)];
        self.imageView = imageView;
        [self.headerView addSubview:imageView];
        imageView.layer.cornerRadius = 15;
        imageView.layer.masksToBounds = YES;

        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *imgs = [NSMutableArray array];
        
        for (NSDictionary *imgDic in self.ad1List) {
            [imgs addObject:imgDic[@"img"]];
            [colors addObject:[@"0x" stringByAppendingString:imgDic[@"color"]]];
        }
        [imageView setScrollViewCurrentBlock:^(NSInteger index) {
            UIColor *currentColor = [UIColor gx_colorWithHexString:colors[index]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mainImageColorChange" object:nil userInfo:@{@"color" : currentColor}];
        }];

        imageView.imgList = imgs;
    }

    // 分类的按钮
    if (self.categoryView == nil) {
        UIScrollView *categoryView = [[UIScrollView alloc] init];
        self.categoryView = categoryView;
        categoryView.frame = CGRectMake(0, 170, SCR_WIDTH, 70);
        [self.headerView addSubview:categoryView];
        categoryView.pagingEnabled = YES;
        categoryView.showsHorizontalScrollIndicator = NO;
        categoryView.delegate = self;

        CGFloat width = 45;
        CGFloat height = width + 30;
        CGFloat leftSpace = 24;
        NSInteger cols = 4;
        CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
        NSInteger count = self.boxList.count;
        for (int i = 0; i < count; i++) {
            NSDictionary *paramDic = self.boxList[i];

            // 创建按钮
            CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 100;
            btn.width = width;
            btn.height = height;
            btn.categoryId = @"0";
            btn.x = leftSpace + i * (width + space);

            [btn sd_setImageWithURL:[NSURL URLWithString:paramDic[@"iconUrl"]] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
            [btn setTitle:paramDic[@"title"] forState:UIControlStateNormal];
            [categoryView addSubview:btn];
            // 点击事件
            [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
            categoryView.height = CZGetY(btn);

            CGFloat contentWith = i <= 3 ? : SCR_WIDTH * 2;
            categoryView.contentSize = (CGSizeMake(contentWith, 0));
        }
    }

    // 指示器
    if (self.minline == nil && self.boxList.count > 4) {
        UIView *redLine = [[UIView alloc] init];
        redLine.width = 46;
        redLine.height = 3;
        redLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [self.headerView addSubview:redLine];
        redLine.centerX = self.headerView.centerX;
        redLine.y = 170 + 70 + 10;

        UIView *minline = [[UIView alloc] init];
        minline.width = redLine.width / 2.0;
        minline.height = redLine.height;
        [redLine addSubview:minline];
        minline.backgroundColor = UIColorFromRGB(0xE25838);
        self.minline = minline;
    }

    if (self.lineView == nil) {
        UIView *lineView = [[UIView alloc] init];
        self.lineView = lineView;
        lineView.y = 250 + 10;
        lineView.width = SCR_WIDTH;
        lineView.height = 10;
        lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.headerView addSubview:lineView];
    }
}



#pragma mark - 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index =  scrollView.contentOffset.x / SCR_WIDTH;
    NSLog(@"%ld", index);

    [UIView animateWithDuration:0.25 animations:^{
        if (index == 0) {
            self.minline.transform = CGAffineTransformIdentity;
        } else {
            self.minline.transform = CGAffineTransformMakeTranslation(self.minline.width, 0);
        }
    }];
}



#pragma mark - 事件
// 分类的点击
- (void)headerViewDidClickedBtn:(CZSubButton *)sender
{
    NSLog(@"%s", __func__);
}

@end
