//
//  CZParameterScoreView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZParameterScoreView.h"
#import "CZGoodsParameterView.h"
#import "CZGoodsScoreView.h"


@interface CZParameterScoreView ()
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *detailModel;
/** <#注释#> */
@property (nonatomic, strong) NSString *titleName;
@end

@implementation CZParameterScoreView

+ (instancetype)parameterScoreViewImage:(NSString *)iconName title:(NSString *)titleName contextList:(NSArray *)list detailModel:(NSDictionary *)detailModel
{
    CZParameterScoreView *view = [[CZParameterScoreView alloc] init];
    view.width = SCR_HEIGHT;
    view.detailModel = detailModel;
    view.titleName = titleName;
    [view functionScoresViewImage:iconName title:titleName contextList:list];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(action:)];
    [view addGestureRecognizer:tap];
    return view;
}


// 创建产品参数
- (void)functionScoresViewImage:(NSString *)iconName title:(NSString *)titleName contextList:(NSArray *)list 
{
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    iconImageView.x = 14;
    iconImageView.y = 14;
    iconImageView.size = CGSizeMake(19, 19);
    [self addSubview:iconImageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleName;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [titleLabel sizeToFit];
    titleLabel.centerY = iconImageView.centerY;
    titleLabel.x = CZGetX(iconImageView) + 3;
    [self addSubview:titleLabel];


    UIScrollView *scoresView = [[UIScrollView alloc] init];
    [self addSubview:scoresView];
    scoresView.y = CZGetY(iconImageView) + 15;
    scoresView.width = SCR_WIDTH;
    scoresView.height = 85;
    scoresView.backgroundColor = [UIColor whiteColor];

    NSInteger count;
    if ([titleName isEqualToString:@"功能评分"]) {
        count = list.count + 1;

    } else {
        count = list.count;
    }
    for (int i = 0; i < count; i++) {
        CGFloat width = 75;
        CGFloat height  = 85;
        UIView *view = [[UIView alloc] init];
        view.x = 14 + i * width;
        view.height = height;
        view.width = width;
        view.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [scoresView addSubview:view];
        scoresView.contentSize = CGSizeMake(CZGetX(view) + 14, 0);

        UILabel *label = [[UILabel alloc] init];
        UILabel *label1 = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label1.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label1.textAlignment = NSTextAlignmentCenter;
        label.height = view.height / 2.0 - 0.75;
        label1.height = label.height;

        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        if (i == (count - 1)) {
            label.x = 0.5;
            label.y = 0.5;
            label.width = view.width - 1;

            label1.x = label.x;
            label1.y = CZGetY(label) + 0.5;
            label1.width = view.width - 1;
        } else {
            label.x = 0.5;
            label.y = 0.5;
            label.width = view.width - 0.5;

            label1.x = label.x;
            label1.y = CZGetY(label) + 0.5;
            label1.width = view.width - 0.5;
        }


        [view addSubview:label];
        [view addSubview:label1];

        if ([titleName isEqualToString:@"功能评分"]) {
            if (i == 0) {
                label.textColor = UIColorFromRGB(0x565252);
                label.text = @"综合评分";

                label1.textColor = UIColorFromRGB(0xE25838);
                label1.text = [NSString stringWithFormat:@"%.1lf分", [self.detailModel[@"score"] floatValue]];
            } else {
                NSDictionary *dic = list[i - 1];
                label.textColor = UIColorFromRGB(0x9D9D9D);
                label.text = dic[@"name"];

                label1.textColor = UIColorFromRGB(0x565252);
                label1.text = [dic[@"score"] stringByAppendingString:@"分"];
            }
        } else {
            NSDictionary *dic = list[i];
            label.textColor = UIColorFromRGB(0x9D9D9D);
            label.text = dic[@"name"];

            label1.textColor = UIColorFromRGB(0x565252);
            label1.text = [dic[@"value"] stringByAppendingString:@"分"];
        }
    }
    self.height = CZGetY(scoresView) + 14;
}

- (void)action:(UITapGestureRecognizer *)tap
{
    CURRENTVC(currentVc);
   if ([self.titleName isEqualToString:@"功能评分"]) {
       CZGoodsScoreView *parameterView = [CZGoodsScoreView goodsScoreView];
       parameterView.detailModel = self.detailModel;
       parameterView.titleName = @"功能评分";
       [currentVc.view addSubview:parameterView];
    } else {
        CZGoodsParameterView *parameterView = [CZGoodsParameterView goodsParameterView];
        parameterView.detailModel = self.detailModel;
        parameterView.titleName = @"产品参数";
        [currentVc.view addSubview:parameterView];
    }
}


@end
