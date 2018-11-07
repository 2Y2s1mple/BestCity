//
//  CZCommoditySubController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCommoditySubController.h"
#import "JCTopic.h"
#import "CZCommodityView.h"
#import "CZPointView.h"
#import "CZGiveLikeView.h"

@interface CZCommoditySubController ()
/** 轮播图 */
@property(nonatomic,strong)JCTopic *Topic_JC;

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation CZCommoditySubController
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 70 - 55)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

-(JCTopic *)Topic_JC
{
    if(!_Topic_JC)
    {
        // 轮播图
        _Topic_JC = [[JCTopic alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, FSS(410))];
        _Topic_JC.rect = CGRectMake(0, 0, SCR_WIDTH, 410);
        _Topic_JC.backgroundColor = CZGlobalWhiteBg;
        _Topic_JC.totalNum = 3;
        _Topic_JC.type = JCTopicMiddle;
        _Topic_JC.scrollView = self.scrollerView;
    }
    return _Topic_JC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    
    //设置scrollerView
    [self.view addSubview:self.scrollerView];
    
    /**加载商品*/
    //记载轮播图
    [self.scrollerView addSubview:self.Topic_JC];
    self.Topic_JC.pics = @[
                           @{@"pic":IMAGE_NAMED(@"testImage1.png"), @"isLoc":@YES},
                           @{@"pic":IMAGE_NAMED(@"testImage2.png"), @"isLoc":@YES},
                           @{@"pic":IMAGE_NAMED(@"testImage3.png"), @"isLoc":@YES}];
    [self.Topic_JC upDate];
    
    //设置商品的标题
    CZCommodityView *commodity = [[CZCommodityView alloc] init];
    commodity.frame = CGRectMake(0, FSS(410), SCR_WIDTH, commodity.commodityH);
    [self.scrollerView addSubview:commodity];
    CGFloat originY = FSS(410) + commodity.commodityH;
    
    CGFloat Height = [CZPointView pointViewWithFrame:CGRectMake(0, originY, SCR_WIDTH, 0) tilte:@"正品保证" titleImage:@"quality" pointTitles:@[@"平安保险承保", @"官方授权", @"正品保证", @"3C认证"] superView:self.scrollerView];
    originY += Height + 10;
    
    CGFloat Height1 = [CZPointView pointViewWithFrame:CGRectMake(0, originY, SCR_WIDTH, 0) tilte:@"售后服务" titleImage:@"service" pointTitles:@[@"极速退款", @"七天无理由退货", @"电器延保", @"赠送运费险"] superView:self.scrollerView];
    originY += Height1 + 10;
    
    
    CGFloat Height2 = [CZPointView pointFormViewWithFrame:CGRectMake(0, originY, SCR_WIDTH, 0) tilte:@"产品参数" titleImage:@"parameter" formTitles:@[@"容量", @"功能", @"产品材质", @"售后服务", @"型号", @"品名"] subformTitles:@[@"1.2-1.5升", @"全国联保", @"全国联保", @"全国联保", @"全国联保", @"全国联保"] superView:self.scrollerView];
    originY += Height2 + 40;
    
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
