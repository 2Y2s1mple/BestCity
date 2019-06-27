//
//  CZFreeSubOneController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeSubOneController.h"
#import "UIImageView+WebCache.h"

@interface CZFreeSubOneController () <UIScrollViewDelegate>

@end

@implementation CZFreeSubOneController
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 50 - (IsiPhoneX ? 83 : 49) - (IsiPhoneX ? 44 : 20))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = [UIColor whiteColor];
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.scrollEnabled = NO;
        _scrollerView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//        _scrollerView.bounces = NO;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.view.backgroundColor = CZREDCOLOR;
    [self.view addSubview:self.scrollerView];


    for (NSDictionary *dic in self.goodsContentList) {
        if ([dic[@"type"]  isEqual: @"1"]) { // 文字
            UILabel *label = [self setupTitleView];
            label.text = dic[@"value"];
            [label sizeToFit];
            label.y = CZGetY([self.scrollerView.subviews lastObject]) + 20;
            [self.scrollerView addSubview:label];
        } else {
            UIImageView *bigImage = [self setupImageView];
            [self.scrollerView addSubview:bigImage];
            [bigImage sd_setImageWithURL:[NSURL URLWithString:dic[@"value"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image == nil) {
                    return ;
                };
                CGFloat imageHeight = bigImage.width * image.size.height / image.size.width;
                bigImage.height = imageHeight;

                for (int i = 0; i < self.scrollerView.subviews.count; i++) {
                    UIView *view = self.scrollerView.subviews[i];
                    if (i == 0) {
                        view.y = 20;
                        continue;
                    }
                    view.y = CZGetY(self.scrollerView.subviews[i - 1]) + 20;
                }
                self.scrollerView.contentSize = CGSizeMake(0, CZGetY([self.scrollerView.subviews lastObject]));
            }];

        }
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.y = CZGetY([self.scrollerView.subviews lastObject]) + 20;
    lineView.height = 6;
    lineView.width = SCR_WIDTH;
    [self.scrollerView addSubview:lineView];
    lineView.backgroundColor = CZGlobalLightGray;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentViewIsScroll:) name:@"CZFreeDetailsubViewNoti" object:nil];

}

- (void)currentViewIsScroll:(NSNotification *)noti
{
    NSLog(@"%@", noti.userInfo[@"isScroller"]);
    if ([noti.userInfo[@"isScroller"]  isEqual: @(1)]) {
        _scrollerView.scrollEnabled = YES;
    } else {
        _scrollerView.scrollEnabled = NO;
    }
}

- (UIImageView *)setupImageView
{
    UIImageView *bigImage = [[UIImageView alloc] init];
    bigImage.x = 14;
    bigImage.width = SCR_WIDTH - 24;
    bigImage.height = 200;
    return bigImage;
}

- (UILabel *)setupTitleView
{
    UILabel *label = [[UILabel alloc] init];
    label.x = 14;
    label.width = SCR_WIDTH - 24;
    label.textColor = CZBLACKCOLOR;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    return label;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat scrollOffsetY = 0.0;
    NSLog(@"%s %lf", __func__, scrollView.contentOffset.y);
    if (scrollOffsetY > self.scrollerView.contentOffset.y) {
        NSLog(@"向下");
        if (scrollView.contentOffset.y <= 0) {
            _scrollerView.scrollEnabled = NO; // 不滚
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeChargeDetailControllerNoti" object:nil userInfo:@{@"isScroller" : @(YES)}];
        }
    } else {
        NSLog(@"向上");
    }
    scrollOffsetY = self.scrollerView.contentOffset.y;


}

- (void)scrollTop
{
    [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self scrollTop];
}

@end
