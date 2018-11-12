//
//  CZRecommendDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZRecommendDetailController.h"
#import "CZRecommendNav.h"
#import "CZCommoditySubController.h"
#import "CZTestSubController.h"
#import "CZEvaluateSubController.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "CZRecommendDetailModel.h"
#import "CZShareAndlikeView.h"
#import "CZShareView.h"

@interface CZRecommendDetailController ()<CZRecommendNavDelegate>
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
@end
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;

@implementation CZRecommendDetailController
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCR_WIDTH, SCR_HEIGHT - 60 - likeAndShareHeight)];
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

- (void)getSourceData
{
    [CZRecommendDetailModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"qualityList" : @"CZRecommendDetailPointModel"
                 };
    }];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = @"545363931984";
    
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodsRankDetailList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"%@", result);
            self.recommendDetailModel = [CZRecommendDetailModel objectWithKeyValues:result[@"GoodsRankdetailEntity"]];
            [self createSubViews];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)createSubViews
{
    // 商品
    CZCommoditySubController *commendVC = [[CZCommoditySubController alloc] init];
    self.commendVC = commendVC;
    [self.scrollerView addSubview:commendVC.view];
    [self addChildViewController:commendVC];
    commendVC.model = self.recommendDetailModel;
    
    // 测评
    CZTestSubController *testVc = [[CZTestSubController alloc] init];
    self.testVc = testVc;
    testVc.view.y = commendVC.scrollerView.height;
    [self.scrollerView addSubview:testVc.view];
    [self addChildViewController:testVc];
    testVc.model = self.recommendDetailModel;
    
    // 评价
    CZEvaluateSubController *evaluate = [[CZEvaluateSubController alloc] init];
    self.evaluate = evaluate;
    evaluate.view.y = commendVC.scrollerView.height + testVc.scrollerView.height;
    [self.scrollerView addSubview:evaluate.view];
    [self addChildViewController:evaluate];
    
    self.scrollerView.contentSize = CGSizeMake(0, commendVC.scrollerView.height + testVc.scrollerView.height + evaluate.scrollerView.height);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 创建导航栏
    CZRecommendNav *nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, 20, SCR_WIDTH, 40)];
    nav.delegate = self;
    [self.view addSubview:nav];
    
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    
    // 加载数据框
    CZShareAndlikeView *likeView = [[CZShareAndlikeView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - likeAndShareHeight, SCR_WIDTH, likeAndShareHeight) leftBtnAction:^{
        CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:share];
    } rightBtnAction:^{
        
    }];
    [self.view addSubview:likeView];
    
    // 获取数据
    [self getSourceData];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBoxInspectWebViewHeightChange:) name:OpenBoxInspectWebHeightKey object:nil];
    
}

- (void)openBoxInspectWebViewHeightChange:(NSNotification *)notfi
{
    self.evaluate.view.y = self.commendVC.scrollerView.height + self.testVc.scrollerView.height;
    self.scrollerView.contentSize = CGSizeMake(0, self.commendVC.scrollerView.height + self.testVc.scrollerView.height + self.evaluate.scrollerView.height);
    NSLog(@"openBoxInspectWebViewHeightChange - %@", notfi.userInfo);
}

#pragma mark - <CZRecommendNavDelegate>
- (void)recommendNavWithPop:(UIView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
