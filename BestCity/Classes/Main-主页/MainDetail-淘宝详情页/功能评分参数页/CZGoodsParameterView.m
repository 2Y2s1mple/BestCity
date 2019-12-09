//
//  CZGoodsParameterView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGoodsParameterView.h"

@implementation CZGoodsParameterView

+ (instancetype)goodsParameterView
{
    CZGoodsParameterView *backView = [[CZGoodsParameterView alloc] init];
    backView.width = SCR_WIDTH;
    backView.height = SCR_HEIGHT;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

    return backView;
}

- (void)setTitleName:(NSString *)titleName
{
    _titleName = titleName;
    [self createSubViews];
}

- (void)createSubViews
{
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    view.height = 525 + 5;
    view.y = SCR_HEIGHT - view.height;
    view.width = self.width;
    [self addSubview:view];

    UILabel *title = [[UILabel alloc] init];
    title.text = self.titleName;
    [view addSubview:title];
    title.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    [title sizeToFit];
    title.centerX = self.width / 2.0;
    title.y = 18;


    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.x = 30;
    scrollView.y = CZGetY(title) + 17;
    scrollView.width = view.width - 60;
    scrollView.height = view.height - 80 - scrollView.y;
    [view addSubview:scrollView];

    

    double height = [self createPointOriginY:0 list:self.detailModel[@"parametersList"] backView:scrollView];
    scrollView.contentSize = CGSizeMake(0, height);



    //底部退出按钮
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(30, CZGetY(scrollView) + 20, SCR_WIDTH - 60, 40);

    loginOut.layer.cornerRadius = 20;
    loginOut.userInteractionEnabled = NO;
    [view addSubview:loginOut];
    [loginOut setTitle:@"完成" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZREDCOLOR;


}

- (double)createPointOriginY:(CGFloat)y list:(NSArray *)list backView:(UIView *)backView
{
    //创建表格
    CGFloat formH = 40;
    UIView *formView = [[UIView alloc] initWithFrame:CGRectMake(10, y, SCR_WIDTH - 20, list.count * formH)];
    formView.layer.borderWidth = 0.5;
    formView.layer.borderColor = CZGlobalLightGray.CGColor;
    [backView addSubview:formView];

    //画一条竖线
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 0.5, formView.height)];
    verticalLine.backgroundColor = CZGlobalLightGray;
    [formView addSubview:verticalLine];

    //循环画横线
    for (int i = 0; i < list.count; i++) {
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, formH * i, formView.width, 0.5)];
        horizontalLine.backgroundColor = CZGlobalLightGray;
        [formView addSubview:horizontalLine];
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, formH * i, 90, formH)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = CZGlobalGray;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        titleLabel.text = list[i][@"name"];
        [formView addSubview:titleLabel];
        //内容
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(verticalLine.x + 20, titleLabel.y, formView.width - 140, formH)];
        subTitleLabel.textAlignment = NSTextAlignmentLeft;
        subTitleLabel.font = titleLabel.font;
        subTitleLabel.numberOfLines = 2;
        subTitleLabel.text = list[i][@"value"];
        [formView addSubview:subTitleLabel];
    }

    return CZGetY(formView);

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}


@end
