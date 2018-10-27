//
//  CZUserEvaluationView.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZUserEvaluationView.h"
#import "CZMutContentButton.h"

@implementation CZUserEvaluationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUserEvaluation];
    }
    return self;
}

#pragma mark - 用户评价
- (CGFloat)setupUserEvaluation
{
    CGFloat space = 10.0f;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 2 * space, 100, 20)];
    titleLabel.text = @"用户评价";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [self addSubview:titleLabel];
    
    //评分小星星
    for (int i = 0; i < 5; i++) {
        UIImageView *starNor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score-nor"]];
        starNor.frame = CGRectMake(space + (17 + space) * i, CZGetY(titleLabel) + 2 * space, 17, 17);
        [self addSubview:starNor];
        if (i > 3) continue;
        UIImageView *starSel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score-sel"]];
        starSel.frame = CGRectMake(space + (17 + space) * i, CZGetY(titleLabel) + 2 * space, 17, 17);
        [self addSubview:starSel];
    }
    
    CZMutContentButton *userEvaluBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
    [userEvaluBtn setTitle:@"5800人参与评分" forState:UIControlStateNormal];
    [userEvaluBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    userEvaluBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [userEvaluBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self addSubview:userEvaluBtn];
    userEvaluBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    userEvaluBtn.frame = CGRectMake(self.width - 150 - 10, CZGetY(titleLabel) + 2 * space, 150, 25);
    [userEvaluBtn addTarget:self action:@selector(didClickallCritical) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CZGetY(userEvaluBtn) + 20, SCR_WIDTH - 20, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self addSubview:line];
    CGFloat height = [self userEvaluationContentWithSuperView:self originY:CZGetY(line)];
    
    self.height = height + CZGetY(line);
    return self.height + 10;
}

- (void)didClickallCritical
{
    [self.delegate userEvaluationActionInView:self];
}

- (CGFloat)userEvaluationContentWithSuperView:(UIView *)view originY:(CGFloat)originY
{
    CGFloat height = 0;
    
    for (int i = 0; i < 3; i++) {
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, originY + height, SCR_WIDTH, 100)];
        [view addSubview:backview];
        
        CGFloat space = 10.0;
        //图片
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
        icon.frame = CGRectMake(space, 2 * space, 50, 50);
        [backview addSubview:icon];
        
        //名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(icon) + space, icon.center.y - 15, 100, 30)];
        name.text = @"李丹妮";
        name.font = [UIFont systemFontOfSize:16];
        name.textColor = CZRGBColor(21, 21, 21);
        [backview addSubview:name];
        
        //点赞小手
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(backview.width - 10 - 80, icon.center.y - 15, 80, 30);
        [likeBtn setTitle:@"245" forState:UIControlStateNormal];
        [likeBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"appreciate-nor"]
                 forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"appreciate-sel"]
                 forState:UIControlStateHighlighted];
        [backview addSubview:likeBtn];
        
        // 内容
        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(name.x, CZGetY(icon) + 10, backview.width - name.x - 10, 50)];
        contentlabel.text = @"与水直接接触的内胆、不锈钢材质安全放心，不易生锈、结垢、无异味、易清洁。";
        contentlabel.font = [UIFont systemFontOfSize:15];
        contentlabel.textColor = CZRGBColor(21, 21, 21);
        contentlabel.numberOfLines = 0;
        [backview addSubview:contentlabel];
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentlabel.x, CZGetY(contentlabel) + 10, 80, 20)];
        timeLabel.text = @"2018.09.21";
        timeLabel.textColor = CZGlobalGray;
        timeLabel.font = [UIFont systemFontOfSize:14];
        [backview addSubview:timeLabel];
        
        //回复
        UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        replyBtn.frame = CGRectMake(CZGetX(timeLabel), timeLabel.center.y - 10, 80, 20);
        [replyBtn setTitle:@"·   回复"forState:UIControlStateNormal];
        replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [replyBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [backview addSubview:replyBtn];
        
        backview.height = CZGetY(replyBtn);
        
        height += backview.height;
    }
    
    return height;
}


@end
