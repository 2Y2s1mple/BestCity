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
       [self addSubview:[self createHeaderTableView]];
    }
    return self;
}


#pragma mark - UI创建
- (UIView *)createHeaderTableView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.width = SCR_WIDTH;
    
    // 添加轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(15, 0, SCR_WIDTH - 30, 150)];
    [headerView addSubview:imageView];
    imageView.layer.cornerRadius = 15;
    imageView.layer.masksToBounds = YES;
    
    NSArray *colors = @[@"0x143030", @"0xE25838", @"0x565252"];
    [imageView setSelectedIndexBlock:^(NSInteger index) {
        UIColor *currentColor = [UIColor gx_colorWithHexString:colors[index]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mainImageColorChange" object:nil userInfo:@{@"color" : currentColor}];
    }];

    NSMutableArray *imgs = [NSMutableArray array];
    for (NSString *imgDic in @[@"http://jipincheng.cn/article/img/20190716/528523b1dcec436ba7e46e99e446fd54", @"http://jipincheng.cn/article/img/20190402/dc8eb31f7c1043c0bcf5b9c9cd9ffa37", @"http://jipincheng.cn/activity/img/20191112/fef7ade9ed284829bf615685e1edaf4c"]) {
        [imgs addObject:imgDic];
    }
    imageView.imgList = imgs;
    [headerView addSubview:imageView];

    // 分类的按钮
    UIScrollView *categoryView = [[UIScrollView alloc] init];
    categoryView.frame = CGRectMake(0, 170, SCR_WIDTH, 70);
    [headerView addSubview:categoryView];
    categoryView.pagingEnabled = YES;
    categoryView.showsHorizontalScrollIndicator = NO;
    categoryView.delegate = self;

    CGFloat width = 45;
    CGFloat height = width + 30;
    CGFloat leftSpace = 24;
    NSInteger cols = 4;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    NSInteger count = 8;
    for (int i = 0; i < count; i++) {
        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = width;
        btn.height = height;
        btn.categoryId = @"0";
        btn.x = leftSpace + i * (width + space);

        [btn sd_setImageWithURL:[NSURL URLWithString:@"http://jipincheng.cn/category/img/20190820/d19d9670eb0544f2ac458ddaa069608a"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [btn setTitle:@"电动牙刷" forState:UIControlStateNormal];
        [categoryView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        categoryView.height = CZGetY(btn);

        CGFloat contentWith = i <= 3 ? : SCR_WIDTH * 2;
        categoryView.contentSize = (CGSizeMake(contentWith, 0));
    }


    // 指示器
    UIView *redLine = [[UIView alloc] init];
    redLine.width = 46;
    redLine.height = 3;
    redLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
    [headerView addSubview:redLine];
    redLine.centerX = headerView.centerX;
    redLine.y = 170 + 70 + 10;

    UIView *minline = [[UIView alloc] init];
    minline.width = redLine.width / 2.0;
    minline.height = redLine.height;
    [redLine addSubview:minline];
    minline.backgroundColor = UIColorFromRGB(0xE25838);
    self.minline = minline;



    UIView *lineView = [[UIView alloc] init];
    lineView.y = 250 + 10;
    lineView.width = SCR_WIDTH;
    lineView.height = 10;
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [headerView addSubview:lineView];

    headerView.height = 260 + 10;
    return headerView;
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
