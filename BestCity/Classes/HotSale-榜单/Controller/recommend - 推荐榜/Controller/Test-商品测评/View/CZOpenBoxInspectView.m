//
//  CZOpenBoxInspectView.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZOpenBoxInspectView.h"

@implementation CZOpenBoxInspectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupOpenBoxInspectWithOriginY:0];
    }
    return self;
}

//开箱测评标题
- (void)setupOpenBoxInspectWithOriginY:(CGFloat)orignY
{
    CGFloat space = 10.0f;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 2 * space, 100, 20)];
    titleLabel.text = @"开箱测评";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [self addSubview:titleLabel];
    //头像
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head3"]];
    iconImage.frame = CGRectMake(space, CZGetY(titleLabel) + (2 * space), 50, 50);
    [self addSubview:iconImage];
    //名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(iconImage) + space, iconImage.y, 70, 20)];
    nameLabel.text = @"资深编辑";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = CZRGBColor(21, 21, 21);
    [self addSubview:nameLabel];
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, CZGetY(nameLabel) + space, 100, 20)];
    timeLabel.text = @"2018.09.21";
    timeLabel.textColor = CZGlobalGray;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:timeLabel];
    //粉丝数
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(nameLabel) + space, nameLabel.y, 100, 20)];
    fansLabel.text = @"粉丝数:376";
    fansLabel.font = [UIFont systemFontOfSize:14];
    fansLabel.textColor = CZGlobalGray;
    [self addSubview:fansLabel];
    //关注按钮
    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [attentionBtn setTitle:@"已关注" forState:UIControlStateHighlighted];
    attentionBtn.frame = CGRectMake(self.width - (space * 2) - 60, iconImage.center.y - 12, 60, 24);
    [attentionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [attentionBtn setTitleColor:CZGlobalGray forState:UIControlStateHighlighted];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    attentionBtn.layer.borderWidth = 0.5;
    attentionBtn.layer.cornerRadius = 13;
    attentionBtn.layer.borderColor = [UIColor redColor].CGColor;
    [self addSubview:attentionBtn];
    
    CGFloat height = [self setupOpenBoxInspectContentWithOrginY:CZGetY(iconImage) + 2 * space superView:self];
    self.height = height;
    
}

#pragma mark - 开箱测评内容
- (CGFloat)setupOpenBoxInspectContentWithOrginY:(CGFloat)orignY superView:(UIView *)superView
{
    //内容文字图片背景
    CGFloat spaceH = 50;
    CGFloat imageH = 350;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, orignY, SCR_WIDTH - 20, 0)];
    [superView addSubview:backView];
    
    CGFloat recordH = 0;
    for (int i = 0; i < 3; i++) {
        //图片
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, recordH, backView.width, imageH)];
        image.layer.cornerRadius = 10;
        image.clipsToBounds = YES;
        image.image = [UIImage imageNamed:@"testImage1"];
        [backView addSubview:image];
        //文字
        NSString *text = @"304不锈钢，一体壶身，防烫设计，\n\n进口不锈钢，一体壶身，\n\n防烫设计，进口不锈钢";
        CGFloat textH = [text boundingRectWithSize:CGSizeMake(image.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CZGetY(image) + 20, image.width, textH)];
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:16];
        [backView addSubview:textLabel];
        
        recordH += (image.height + textH + 20) + spaceH;
        backView.height = CZGetY(textLabel);
    }
    return backView.height + orignY;
}


@end
