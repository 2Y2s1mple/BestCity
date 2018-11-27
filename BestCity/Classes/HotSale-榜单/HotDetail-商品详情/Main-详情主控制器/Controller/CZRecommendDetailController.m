//
//  CZRecommendDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZRecommendDetailController.h"
#import "CZCommoditySubController.h"
#import "CZTestSubController.h"
#import "CZEvaluateSubController.h"

#import "CZRecommendDetailModel.h"

#import "CZRecommendNav.h"
#import "CZShareAndlikeView.h"
#import "CZShareView.h"

#import "GXNetTool.h"
#import "MJExtension.h"

@interface CZRecommendDetailController ()<CZRecommendNavDelegate, UIScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 详情数据 */
@property (nonatomic, strong) CZRecommendDetailModel *recommendDetailModel;
/** 商品 */
@property (nonatomic, strong) CZCommoditySubController *commendVC;
/** 评测 */
@property (nonatomic, strong) CZTestSubController *testVc;
/** 评价 */
@property (nonatomic, strong) CZEvaluateSubController *evaluate;
/** 导航栏 */
@property (nonatomic, strong) CZRecommendNav *nav;
@end
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;

@implementation CZRecommendDetailController
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCR_WIDTH, SCR_HEIGHT - 60 - likeAndShareHeight)];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

#pragma mark - 获取数据
- (void)getSourceData
{
    [CZRecommendDetailModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"qualityList" : @"CZRecommendDetailPointModel"
                 };
    }];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = self.model.goodsId;
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodsRankDetailList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"%@", result);
            self.recommendDetailModel = [CZRecommendDetailModel objectWithKeyValues:result[@"GoodsRankdetailEntity"]];
            [self setupRecommendModel];
            [self createSubViews];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

/** 设置标题以及优惠券 */
- (void)setupRecommendModel
{
    // 标题
    self.recommendDetailModel.mainTitle = self.model.goodsName;
    // 券后价
    self.recommendDetailModel.actualPrice = self.model.cutPrice;
    // 平台
    NSString *status;
    switch (self.model.sourceStatus) {
        case 1:
            status = @"京东:";
            break;
        case 2:
            status = @"淘宝:";
            break;
        case 3:
            status = @"天猫:";
            break;
        default:
            status = @"";
            break;
    }
    self.recommendDetailModel.sourcePlatform = status;
    // 平台价格
    self.recommendDetailModel.sourcePlatformPrice = self.model.otherPrice;
    // 优惠券
    self.recommendDetailModel.discountCoupon = self.model.cutPrice;
}

- (void)createSubViews
{
    // 商品
    self.commendVC = [[CZCommoditySubController alloc] init];
    self.commendVC.model = self.recommendDetailModel;
    [self.scrollerView addSubview:self.commendVC.view];
    [self addChildViewController:self.commendVC];
    
    // 测评
    self.testVc = [[CZTestSubController alloc] init];
    self.testVc.view.y = self.commendVC.scrollerView.height;
    [self.scrollerView addSubview:self.testVc.view];
    [self addChildViewController:self.testVc];
    self.testVc.model = self.recommendDetailModel;
    
    // 评价
    self.evaluate = [[CZEvaluateSubController alloc] init];
    self.evaluate.view.y = self.commendVC.scrollerView.height + self.testVc.scrollerView.height;
    [self.scrollerView addSubview:self.evaluate.view];
    [self addChildViewController:self.evaluate];
    self.evaluate.model = self.recommendDetailModel;
    
    self.scrollerView.contentSize = CGSizeMake(0, self.commendVC.scrollerView.height + self.testVc.scrollerView.height +self.evaluate.scrollerView.height);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 创建导航栏
    self.nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, 20, SCR_WIDTH, 40)];
    self.nav.projectId = self.model.goodsId;
    self.nav.delegate = self;
    [self.view addSubview:self.nav];
    
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    
    // 加载数据框
    CZShareAndlikeView *likeView = [[CZShareAndlikeView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - likeAndShareHeight, SCR_WIDTH, likeAndShareHeight) leftBtnAction:^{
        CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:share];
    } rightBtnAction:^{}];
    [self.view addSubview:likeView];
    
    // 获取数据
    [self getSourceData];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBoxInspectWebViewHeightChange:) name:OpenBoxInspectWebHeightKey object:nil];
}

#pragma mark - 监听子控件的frame的变化
- (void)openBoxInspectWebViewHeightChange:(NSNotification *)notfi
{
    self.evaluate.view.y = self.commendVC.scrollerView.height + self.testVc.scrollerView.height;
    self.scrollerView.contentSize = CGSizeMake(0, self.commendVC.scrollerView.height + self.testVc.scrollerView.height + self.evaluate.scrollerView.height);
}

#pragma mark - <CZRecommendNavDelegate>
- (void)recommendNavWithPop:(UIView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickedTitleWithIndex:(NSInteger)index
{
    CGPoint point;
    switch (index) {
        case 0:
            point = CGPointMake(0, 0);
            break;
        case 1:
            point = CGPointMake(0, CGRectGetMinY(self.testVc.view.frame));
            break;
        case 2:
            point = CGPointMake(0, CGRectGetMinY(self.evaluate.view.frame));
            break;
        default:
            point = CGPointMake(0, 0);
            break;
    }
    [self.scrollerView setContentOffset:point animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollerView.contentOffset.y >= -20 && self.scrollerView.contentOffset.y < CGRectGetMinY(self.testVc.view.frame)) {
        self.nav.monitorIndex = 0;
    } else if (self.scrollerView.contentOffset.y >= CGRectGetMinY(self.testVc.view.frame) && self.scrollerView.contentOffset.y < CGRectGetMinY(self.evaluate.view.frame)) {
        self.nav.monitorIndex = 1;
    } else if (self.scrollerView.contentOffset.y >= CGRectGetMinY(self.evaluate.view.frame)) {
        self.nav.monitorIndex = 2;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
