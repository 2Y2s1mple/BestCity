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
    searchView.size = CGSizeMake(self.width, self.height);
    searchView.layer.cornerRadius = self.height / 2.0;
    [self addSubview:searchView];

    UILabel *sLabel = [[UILabel alloc] init];
    sLabel.text = @"搜索你感兴趣的内容";
    sLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    sLabel.textColor = UIColorFromRGB(0x9D9D9D);
    [sLabel sizeToFit];
    sLabel.x = 10;
    sLabel.centerY = searchView.height / 2.0;
    [searchView addSubview:sLabel];

    UIImageView *sImage = [[UIImageView alloc] init];
    sImage.image = [UIImage imageNamed:@"search-1"];
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
