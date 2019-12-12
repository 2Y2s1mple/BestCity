//
//  CZMainViewSearch.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainViewSearch.h"

@implementation CZMainViewSearch



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = SCR_WIDTH;
        self.userInteractionEnabled = YES;
       [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    UIView *searchView = [[UIView alloc] init];
    [self addSubview:searchView];
    searchView.x = 15;
    searchView.width = SCR_WIDTH - 30;
    searchView.height = 36;
    searchView.layer.cornerRadius =  18;
    searchView.backgroundColor = UIColorFromRGB(0xF5F5F5);

    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"search_search"];
    [image sizeToFit];
    image.x = 83;
    image.centerY = searchView.height / 2.0;
    [searchView addSubview:image];

    UILabel *title = [[UILabel alloc] init];
    title.text = @"搜商品名称或粘贴标题";
    title.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    title.textColor = UIColorFromRGB(0x565252);
    [searchView addSubview:title];
    [title sizeToFit];
    title.x = CZGetX(image) + 5;
    title.centerY = image.centerY;

    self.height = searchView.height;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    !self.block ? : self.block();
}


@end
