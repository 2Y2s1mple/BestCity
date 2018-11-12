//
//  CZPointView.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/26.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZPointView.h"

@implementation CZPointView

+ (CGFloat)pointViewWithFrame:(CGRect)frame tilte:(NSString *)mainTitle titleImage:(NSString *)imageName pointTitles:(NSArray *)pointTitles superView:(UIView *)superView
{
    CZPointView *backView = [[self alloc] initWithFrame:frame];
    [superView addSubview:backView];
    UIImageView *qualityImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    qualityImage.frame = CGRectMake(10, 10, 25, 22);
    [backView addSubview:qualityImage];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(qualityImage.frame) + 10, qualityImage.y, 70, qualityImage.height)];
    title.text = mainTitle;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:16];
    [backView addSubview:title];
    
    CGFloat pointX = title.center.x - 10;
    CGFloat pointY = CGRectGetMaxY(title.frame) + 20;
    CGFloat spaceH = 50;
    CGFloat finallyH = 0.0;
    
    for (int i = 0; i < pointTitles.count; i++) {
        UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(pointX, pointY + (i * spaceH), 8, 8)];
        pointView.layer.cornerRadius = 4;
        pointView.layer.borderWidth = 0.5;
        pointView.layer.borderColor = CZGlobalGray.CGColor;
        [backView addSubview:pointView];
        
        if (i < pointTitles.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(pointView.center.x - 0.5, pointView.center.y + 4, 0.5, spaceH - 8)];
            line.backgroundColor = CZGlobalGray;
            [backView addSubview:line];
        }
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pointView.frame) + 10, CGRectGetMinY(pointView.frame) - 6, 120, 20)];
        titleName.text = pointTitles[i];
        titleName.textColor = CZGlobalGray;
        titleName.font = [UIFont systemFontOfSize:15];
        [backView addSubview:titleName];
        
        UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check out"]];
        checkMark.frame = CGRectMake(backView.width - 80, pointView.y, 13, 8);
        [backView addSubview:checkMark];
        
        UILabel *titleAffirm = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkMark.frame) + 10, CGRectGetMinY(titleName.frame), 50, 20)];
        titleAffirm.text = @"已确认";
        titleAffirm.textColor = CZGlobalGray;
        titleAffirm.font = [UIFont systemFontOfSize:15];
        titleAffirm.textColor = [UIColor redColor];
        [backView addSubview:titleAffirm];
        finallyH = CGRectGetMaxY(titleAffirm.frame) + 10;
    }
    backView.frame = CGRectMake(0, frame.origin.y, frame.size.width, finallyH);
    return finallyH ? finallyH : 22;
}

+ (CGFloat)pointFormViewWithFrame:(CGRect)frame tilte:(NSString *)mainTitle titleImage:(NSString *)imageName formTitles:(NSArray *)formTitles subformTitles:(NSArray *)subformTitles superView:(UIView *)superView
{
    //承载的View
    CZPointView *backView = [[self alloc] initWithFrame:frame];
    backView.backgroundColor = RANDOMCOLOR;
    [superView addSubview:backView];
    
    //图片和标题
    UIImageView *qualityImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    qualityImage.frame = CGRectMake(10, 10, 25, 22);
    [backView addSubview:qualityImage];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(qualityImage.frame) + 10, qualityImage.y, 70, qualityImage.height)];
    title.text = mainTitle;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:16];
    [backView addSubview:title];
    
    //创建表格
    CGFloat formH = 40;
    UIView *formView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame) + 20, SCR_WIDTH - 20, formTitles.count * formH)];
    formView.layer.borderWidth = 0.5;
    formView.layer.borderColor = CZGlobalLightGray.CGColor;
    [backView addSubview:formView];
    
    //画一条竖线
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 0.5, formView.height)];
    verticalLine.backgroundColor = CZGlobalLightGray;
    [formView addSubview:verticalLine];
    
    //循环画横线
    for (int i = 0; i < formTitles.count; i++) {
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, formH * i, formView.width, 0.5)];
        horizontalLine.backgroundColor = CZGlobalLightGray;
        [formView addSubview:horizontalLine];
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, formH * i, 90, formH)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = CZGlobalGray;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = formTitles[i];
        [formView addSubview:titleLabel];
        //内容
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(verticalLine.x + 20, titleLabel.y, formView.width - 140, formH)];
        subTitleLabel.textAlignment = NSTextAlignmentLeft;
        subTitleLabel.font = [UIFont systemFontOfSize:15];
        subTitleLabel.text = subformTitles[i];
        [formView addSubview:subTitleLabel];
    }
    return CGRectGetMaxY(formView.frame);
}

@end
