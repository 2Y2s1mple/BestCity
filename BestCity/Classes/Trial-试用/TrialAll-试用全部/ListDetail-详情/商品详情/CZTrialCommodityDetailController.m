//
//  CZTrialCommodityDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialCommodityDetailController.h"
#import "UIImageView+WebCache.h"

@interface CZTrialCommodityDetailController ()

@end

@implementation CZTrialCommodityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSDictionary *dic in self.goodsContentList) {
        if ([dic[@"type"]  isEqual: @"1"]) { // 文字
            UILabel *label = [self setupTitleView];
            label.text = dic[@"value"];
            [label sizeToFit];
            label.y = CZGetY([self.view.subviews lastObject]) + 20;
            [self.view addSubview:label];
        } else {
            UIImageView *bigImage = [self setupImageView];
            [self.view addSubview:bigImage];
            [bigImage sd_setImageWithURL:[NSURL URLWithString:dic[@"value"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                CGFloat imageHeight = bigImage.width * image.size.height / image.size.width;
                bigImage.height = imageHeight;
                
                for (int i = 0; i < self.view.subviews.count; i++) {
                    UIView *view = self.view.subviews[i];
                    if (i == 0) {
                        view.y = 20;
                        continue;
                    }
                    view.y = CZGetY(self.view.subviews[i - 1]) + 20;
                }
                self.view.height = CZGetY([self.view.subviews lastObject]);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CZTrialCommodityDetailControllerNoti" object:nil userInfo:@{@"height" : @(self.view.height)}];
            }];
           
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.y = CZGetY([self.view.subviews lastObject]) + 20;
    lineView.height = 6;
    lineView.width = SCR_WIDTH;
    [self.view addSubview:lineView];
    lineView.backgroundColor = CZGlobalLightGray;
    
    
    self.view.width = SCR_WIDTH;
    self.view.height = CZGetY(lineView);
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

@end
