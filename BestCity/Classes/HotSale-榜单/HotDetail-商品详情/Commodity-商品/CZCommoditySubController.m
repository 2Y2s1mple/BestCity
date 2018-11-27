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
#import "CZRecommendDetailModel.h"
#import "CZRecommendListModel.h"

@interface CZCommoditySubController ()
/** 轮播图 */
@property(nonatomic,strong)JCTopic *Topic_JC;


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
        _Topic_JC.scrollView = self.scrollerView;
        self.Topic_JC.pics = @[
                                   @{@"pic":IMAGE_NAMED(@"testImage1.png"), @"isLoc":@YES},
                                   @{@"pic":IMAGE_NAMED(@"testImage2.png"), @"isLoc":@YES},
                                   /**@{@"pic":IMAGE_NAMED(@"testImage3.png"), @"isLoc":@YES}*/];
        [self.Topic_JC upDate];
    }
    return _Topic_JC;
}

- (void)setModel:(CZRecommendDetailModel *)model
{
    _model = model;
    [self setupView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 设置scrollerView
    [self.view addSubview:self.scrollerView];
    // 加载轮播图
    [self.scrollerView addSubview:self.Topic_JC];
}

- (void)setupView
{
    /**加载商品*/
//    if (self.model.imgList.count > 0) {
//        NSMutableArray *imagePaths = [NSMutableArray array];
//        for (NSDictionary *dic in self.model.imgList) {
//            NSDictionary *subDic = @{
//                                     @"pic" : dic[@"imgPath"],
//                                     @"isLoc" : @NO
//                                     };
//            [imagePaths addObject:subDic];
//        }
//        _Topic_JC.pics = imagePaths;
//        [self.Topic_JC upDate];
//        
//    }
    
    
    //设置商品的标题
    CZCommodityView *commodity = [[CZCommodityView alloc] init];
    commodity.frame = CGRectMake(0, FSS(410), SCR_WIDTH, commodity.commodityH);
    commodity.model = self.model;
    [self.scrollerView addSubview:commodity];
    CGFloat originY = FSS(410) + commodity.commodityH;
    
    NSMutableArray *qualityList = [NSMutableArray array];
    for (CZRecommendDetailPointModel *model in self.model.qualityList) {
        [qualityList addObject:model.name];
    }
    CGFloat Height = [CZPointView pointViewWithFrame:CGRectMake(0, originY, SCR_WIDTH, 0) tilte:@"正品保证" titleImage:@"quality" pointTitles:qualityList superView:self.scrollerView];
    originY += Height + 10;
    
    NSMutableArray *serviceList = [NSMutableArray array];
    for (NSDictionary *dic in self.model.serviceList) {
        [serviceList addObject:dic[@"name"]];
    }
    CGFloat Height1 = [CZPointView pointViewWithFrame:CGRectMake(0, originY, SCR_WIDTH, 0) tilte:@"售后服务" titleImage:@"service" pointTitles:serviceList superView:self.scrollerView];
    originY += Height1 + 10;
    
    NSMutableArray *parametersList1 = [NSMutableArray array];
    for (NSDictionary *dic in self.model.parametersList) {
        [parametersList1 addObject:dic[@"name"]];
    }
    NSMutableArray *parametersList2 = [NSMutableArray array];
    for (NSDictionary *dic in self.model.parametersList) {
        [parametersList2 addObject:dic[@"value"]];
    }
    CGFloat Height2 = [CZPointView pointFormViewWithFrame:CGRectMake(0, originY, SCR_WIDTH, 0) tilte:@"产品参数" titleImage:@"parameter" formTitles:parametersList1 subformTitles:parametersList2 superView:self.scrollerView];
    originY += Height2 + 40;
    
    /**点赞*/
    //加个分隔线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, 7)];
    lineView2.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView2];
    originY += 7;
    
    self.scrollerView.contentSize = CGSizeMake(0, originY);
    self.scrollerView.height = originY;
    self.view.height = self.scrollerView.height;
}

@end
