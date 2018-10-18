//
//  CZTestSubController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTestSubController.h"
#import "CZOpenBoxInspectView.h"
#import "CZGiveLikeView.h"

@interface CZTestSubController ()
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation CZTestSubController

- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 70 - 55)];
        scrollerView.backgroundColor = CZGlobalBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CZGlobalBg;
    
    //设置scrollerView
    [self.view addSubview:self.scrollerView];
    
    /**加载开箱测评*/
    CGFloat originY = 0;
    
    CZOpenBoxInspectView *openBox = [[CZOpenBoxInspectView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 1)];
    [self.scrollerView addSubview:openBox];
    originY += openBox.height + 10;
    
    /**点赞*/
    //加个分隔线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 7)];
    lineView2.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView2];
    originY += 7;
    
    
    //加载点赞小手
    CZGiveLikeView *likeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 200)];
    [self.scrollerView addSubview:likeView];
    originY += 200;
    

    self.scrollerView.contentSize = CGSizeMake(0, originY);
}



@end
