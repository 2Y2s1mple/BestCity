//
//  CZGoodsScoreView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGoodsScoreView.h"
@interface CZGoodsScoreView ()

@end

@implementation CZGoodsScoreView

+ (instancetype)goodsScoreView
{
    CZGoodsScoreView *backView = [[CZGoodsScoreView alloc] init];
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
    view.backgroundColor = [UIColor whiteColor];
    view.height = 388;
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

    CZGoodsScoreView *score = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZGoodsScoreView class]) owner:nil options:nil] firstObject];
    score.y = CZGetY(title) + 17;
    score.width = view.width;
    score.height = view.height - 80 - score.y;
    [view addSubview:score];


    //底部退出按钮
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(30, view.height - 60, SCR_WIDTH - 60, 40);
    loginOut.layer.cornerRadius = 20;
    loginOut.userInteractionEnabled = NO;
    [view addSubview:loginOut];
    [loginOut setTitle:@"完成" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZREDCOLOR;


    // 综合评分
    NSArray *list = self.detailModel[@"scoreOptionsList"];
       if (list.count >= 4 && ![list[0][@"name"]  isEqual: @""]) {
           score.pointView.hidden = NO;
           score.comprehensiveScoreLabel.text = [NSString stringWithFormat:@"%.1f", [self.detailModel[@"score"] floatValue]];
           NSInteger maxScore = 150;
           CGFloat everScore = maxScore / 10.0;

           score.scoreFirstImageConstraint.constant = 150 - [list[0][@"score"] integerValue] * everScore;
           score.scoreFirstName.text = [list[0][@"name"] setupTextRowSpace];
           score.score1.text = [NSString stringWithFormat:@"%.1f", [list[0][@"score"] floatValue]];

           score.scoreSecondImageConstraint.constant = 150 - [list[1][@"score"] integerValue] * everScore;
           score.scoreSecondName.text = [list[1][@"name"] setupTextRowSpace];
           score.score2.text = [NSString stringWithFormat:@"%.1f", [list[1][@"score"] floatValue]];

           score.scoreThreeImageConstraint.constant = 150 - [list[2][@"score"] integerValue] * everScore;
           score.scoreThreeName.text = [list[2][@"name"] setupTextRowSpace];
           score.score3.text = [NSString stringWithFormat:@"%.1f", [list[2][@"score"] floatValue]];

           score.scoreThirdImageConstraint.constant = 150 - [list[3][@"score"] integerValue] * everScore;
           score.scoreThirdName.text = [list[3][@"name"] setupTextRowSpace];
           score.score4.text = [NSString stringWithFormat:@"%.1f", [list[3][@"score"] floatValue]];

           if (list.count == 5) {
               score.scoreFiveImageConstraint.constant = 150 - [list[4][@"score"] integerValue] * everScore;
               score.scoreFiveName.text = [list[4][@"name"] setupTextRowSpace];
               score.score5.text = [NSString stringWithFormat:@"%.1f", [list[4][@"score"] floatValue]];
           } else {
               score.score5.hidden = YES;
               score.scoreFiveName.hidden = YES;
               score.scoreFiveView.hidden = YES;
           }
       } else {
           score.pointView.hidden = YES;
       }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
