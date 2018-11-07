//
//  CZEvaluateSubController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluateSubController.h"
#import "CZUserEvaluationView.h"
#import "CZAllCriticalController.h"
#import "CZGiveLikeView.h"

@interface CZEvaluateSubController ()<CZUserEvaluationViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation CZEvaluateSubController
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
    
    //设置scrollerView
    [self.view addSubview:self.scrollerView];
    
     CGFloat originY = 0;
    
    /**加载用户评价*/
    CZUserEvaluationView *userEvalua = [[CZUserEvaluationView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 300)];
    userEvalua.delegate = self;
    [self.scrollerView addSubview:userEvalua];
    originY += userEvalua.height + 10;
    
    /**点赞*/
    //加个分隔线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 7)];
    lineView2.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView2];
    originY += 7;
    
    //加载点赞小手
    CZGiveLikeView *likeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 200)];\
    [self.scrollerView addSubview:likeView];
    originY += 200;
    
    
    self.scrollerView.contentSize = CGSizeMake(0, originY);
}

#pragma mark - <CZUserEvaluationViewDelegate>
- (void)userEvaluationActionInView:(UIView *)view
{
    CZAllCriticalController *vc = [[CZAllCriticalController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
