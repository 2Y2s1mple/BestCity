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
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
       [self addSubview:[self createHeaderTableView]];
    }
    return self;
}

- (UIView *)createHeaderTableView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    headerView.width = SCR_WIDTH;
    headerView.height = 350;
    // 添加轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(15, 0, SCR_WIDTH - 30, 150)];
    [headerView addSubview:imageView];
    
    [imageView setSelectedIndexBlock:^(NSInteger index) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mainImageColorChange" object:nil userInfo:@{@"index" : @(index)}];
    }];

    NSMutableArray *imgs = [NSMutableArray array];
    for (NSString *imgDic in @[@"http://jipincheng.cn/article/img/20190716/528523b1dcec436ba7e46e99e446fd54", @"http://jipincheng.cn/article/img/20190402/dc8eb31f7c1043c0bcf5b9c9cd9ffa37", @"http://jipincheng.cn/activity/img/20191112/fef7ade9ed284829bf615685e1edaf4c"]) {
        [imgs addObject:imgDic];
    }
    imageView.imgList = imgs;
    [headerView addSubview:imageView];

    // 添加官网声明的条
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"Main-icon5"];
    [headerView addSubview:icon];
    [icon sizeToFit];
    icon.centerX = SCR_WIDTH / 2.0;
    icon.y = CZGetY(imageView) + 10;

    // 分类的按钮
    UIView *categoryView = [[UIView alloc] init];
    categoryView.frame = CGRectMake(0, CZGetY(icon) + 10, SCR_WIDTH, 0);
    [headerView addSubview:categoryView];

    CGFloat width = 50;
    CGFloat height = width + 30;
    CGFloat leftSpace = 24;
    NSInteger cols = 4;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    NSInteger count = 4;
    for (int i = 0; i < count; i++) {
        NSInteger col = i % cols;
        NSInteger row = i / cols % 2;

        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = width;
        btn.height = height;
        btn.categoryId = @"0";
        btn.x = leftSpace + col * (width + space) + (i / 10) * SCR_WIDTH;
        btn.y = 12 + row * (height + 25);
        [btn sd_setImageWithURL:[NSURL URLWithString:@"http://jipincheng.cn/category/img/20190820/d19d9670eb0544f2ac458ddaa069608a"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [btn setTitle:@"电动牙刷" forState:UIControlStateNormal];
        [categoryView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        categoryView.height = CZGetY(btn);
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.y = CZGetY(categoryView) + 15;
    lineView.width = SCR_WIDTH;
    lineView.height = 10;
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [headerView addSubview:lineView];

    headerView.height = CZGetY(lineView);
    return headerView;
}

@end
