//
//  CZFestivalController.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/29.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalController.h"
#import "CZScollerImageTool.h" // 轮播图
#import "CZSubButton.h"
#import "UIButton+WebCache.h"

@interface CZFestivalController () <UIScrollViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation CZFestivalController
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49))];
        _scrollerView.backgroundColor = UIColorFromRGB(0xE74434);
        self.scrollerView.delegate = self;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 滚动视图
    [self.view addSubview:self.scrollerView];

    // 添加轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 300)];
    [self.view addSubview:imageView];
    NSString *imageUrl = @"http://jipincheng.cn/category/img/20190820/d19d9670eb0544f2ac458ddaa069608a";

    imageView.imgList = @[imageUrl, imageUrl];
    [self.scrollerView addSubview:imageView];

    // 添加官网声明的条
    UIView *officialLine = [[UIView alloc] init];
    officialLine.frame = CGRectMake(10, CZGetY(imageView) + 10, SCR_WIDTH - 20, 28);
    officialLine.backgroundColor = UIColorFromRGB(0xF9E0CD);
    officialLine.layer.cornerRadius = 5;
    [self.scrollerView addSubview:officialLine];

    // 分类的按钮
    UIView *categoryView = [[UIView alloc] init];
    categoryView.frame = CGRectMake(0, CZGetY(officialLine) + 25, SCR_WIDTH, 0);
    [self.scrollerView addSubview:categoryView];

    CGFloat width = 50;
    CGFloat height = width + 30;
    CGFloat leftSpace = 24;
    NSInteger cols = 4;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    NSInteger count = 8;
    for (int i = 0; i < count; i++) {
        NSInteger col = i % cols;
        NSInteger row = i / cols % 2;

        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = width;
        btn.height = height;

        btn.x = leftSpace + col * (width + space) + (i / 10) * SCR_WIDTH;
        btn.y = 12 + row * (height + 25);
        [btn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        [btn setTitle:@"双11精选" forState:UIControlStateNormal];
        [categoryView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        categoryView.height = CZGetY(btn);
    }








}

@end
