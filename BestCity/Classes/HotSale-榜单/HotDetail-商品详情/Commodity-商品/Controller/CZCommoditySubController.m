//
//  CZCommoditySubController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCommoditySubController.h"

#import "CZCommodityView.h"
#import "CZPointView.h"
#import "CZRecommendListModel.h"
#import "PlanADScrollView.h"


@interface CZCommoditySubController ()

@end

@implementation CZCommoditySubController
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 70 - 55)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 设置scrollerView
    [self.view addSubview:self.scrollerView];
}

- (void)setCouponData:(CZCouponsModel *)couponData
{
    _couponData = couponData;
     [self setupView];
}


- (void)setupView
{
    // 创建轮播图
    if ([self.detailData.imgList count] > 0) {
        NSMutableArray *imagePaths = [NSMutableArray array];
        for (NSString *imgPath in self.detailData.imgList) {
            [imagePaths addObject:imgPath];
        }
        if (imagePaths.count == 1) {
            //初始化控件
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imagePaths firstObject]] placeholderImage:IMAGE_NAMED(@"headDefault")];
            imageView.frame = CGRectMake(0, 0, SCR_WIDTH, 410);
            [self.view addSubview:imageView];
        } else {
            //初始化控件
            PlanADScrollView *ad =[[PlanADScrollView alloc]initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 410)imageUrls:imagePaths placeholderimage:IMAGE_NAMED(@"headDefault")];
            [self.view addSubview:ad];
        }
    } else {
        //初始化控件
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headDefault"]];
        imageView.frame = CGRectMake(0, 0, SCR_WIDTH, 410);
        [self.view addSubview:imageView];
    }

    // 创建标题附标题
    CZCommodityView *commodity = [[CZCommodityView alloc] init];
    commodity.frame = CGRectMake(0, 410, SCR_WIDTH, commodity.commodityH);
    commodity.couponModel = self.couponData;
    commodity.model = self.detailData;
    
    [self.scrollerView addSubview:commodity];
    CGFloat originY = 420 + commodity.commodityH;
 
    NSMutableArray *parametersList1 = [NSMutableArray array];
    for (NSDictionary *dic in self.commodityDetailData.parametersList) {
        [parametersList1 addObject:dic[@"name"]];
    }
    NSMutableArray *parametersList2 = [NSMutableArray array];
    for (NSDictionary *dic in self.commodityDetailData.parametersList) {
        [parametersList2 addObject:dic[@"value"]];
    }
    CGFloat Height2 = [CZPointView pointFormViewWithFrame:CGRectMake(0, originY, SCR_WIDTH, 0) tilte:@"产品参数" titleImage:@"parameter" formTitles:parametersList1 subformTitles:parametersList2 superView:self.scrollerView];
    originY += Height2 + 40;
    
    // 创建分隔线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 7)];
    lineView2.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView2];
    originY += 7;
    
    self.scrollerView.contentSize = CGSizeMake(0, originY);
    self.scrollerView.height = originY;
    self.view.height = self.scrollerView.height;
}



@end
