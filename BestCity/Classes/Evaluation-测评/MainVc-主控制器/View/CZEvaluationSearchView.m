//
//  CZEvaluationSearchView.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEvaluationSearchView.h"

@implementation CZEvaluationSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSeachView];
    }
    return self;
}

- (void)createSeachView
{
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    searchView.x = 14;
    searchView.size = CGSizeMake(SCR_WIDTH - searchView.x * 2, self.height);
    [self addSubview:searchView];

    UILabel *sLabel = [[UILabel alloc] init];
    sLabel.text = @"搜索你感兴趣的内容";
    sLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    sLabel.textColor = UIColorFromRGB(0x9D9D9D);
    [sLabel sizeToFit];
    sLabel.x = 10;
    sLabel.centerY = searchView.height / 2.0;
    [searchView addSubview:sLabel];

    UIImageView *sImage = [[UIImageView alloc] init];
    sImage.image = [UIImage imageNamed:@"search"];
    [sImage sizeToFit];
    sImage.centerY = sLabel.centerY;
    sImage.x = searchView.width - 20 - sImage.size.width;
    [searchView addSubview:sImage];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    !self.didClickedSearchView ? : self.didClickedSearchView();
}


@end
