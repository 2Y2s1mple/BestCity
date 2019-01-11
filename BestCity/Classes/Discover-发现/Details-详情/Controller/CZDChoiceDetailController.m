//
//  CZDChoiceDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDChoiceDetailController.h"
#import "GXNetTool.h"
#import "CZRecommendNav.h" // 导航
#import "CZTestSubController.h" // 测评
#import "CZEvaluateSubController.h" // 评论
#import "MJExtension.h"

/** 模型 */
#import "CZTestDetailModel.h"

@interface CZDChoiceDetailController () <CZRecommendNavDelegate, UIScrollViewDelegate>
/** 数据 */
@property (nonatomic, strong) CZTestDetailModel *dicDataModel;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 导航栏 */
@property (nonatomic, strong) CZRecommendNav *nav;
/** 评测 */
@property (nonatomic, strong) CZTestSubController *testVc;
/** 评价 */
@property (nonatomic, strong) CZEvaluateSubController *evaluate;

@end

@implementation CZDChoiceDetailController
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;
/** 文章的类型: 1商品，2评测, 3发现，4试用 */
static NSString * const type = @"3";
#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20) + 40, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 44 : 20) - 40)];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

- (CZRecommendNav *)nav
{
    if (_nav == nil) {
        self.nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 40) type:CZRecommendNavDiscover];
        self.nav.type = type;
        self.nav.projectId = self.findgoodsId;
        self.nav.delegate = self;
    }
    return _nav;
}

#pragma mark - 获取数据
- (void)obtainDetailData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.findgoodsId;
    param[@"type"] = type;
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/article/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dicDataModel = [CZTestDetailModel objectWithKeyValues:result[@"data"]];
            // 创建内容视图
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
    
    // 测评
    self.testVc = [[CZTestSubController alloc] init];
    self.testVc.view.y = 0;
    [self.scrollerView addSubview:self.testVc.view];
    [self addChildViewController:self.testVc];
    self.testVc.type = type;
    self.testVc.model = self.dicDataModel;
    
    // 评价
//    self.evaluate = [[CZEvaluateSubController alloc] init];
//    self.evaluate.view.y = self.commendVC.scrollerView.height + self.testVc.scrollerView.height;
//    [self.scrollerView addSubview:self.evaluate.view];
//    [self addChildViewController:self.evaluate];
//    self.evaluate.targetId = self.detailModel.goodsDetailEntity.goodsId;
    
    // 设置滚动高度
    self.scrollerView.contentSize = CGSizeMake(0, self.testVc.scrollerView.height + self.evaluate.scrollerView.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 获取数据
    [self obtainDetailData];
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    // 创建导航栏
    [self.view addSubview:self.nav];
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBoxInspectWebViewHeightChange:) name:OpenBoxInspectWebHeightKey object:nil];
    
}

#pragma mark - 监听子控件的frame的变化
- (void)openBoxInspectWebViewHeightChange:(NSNotification *)notfi
{
    self.evaluate.view.y = self.testVc.scrollerView.height;
    self.scrollerView.contentSize = CGSizeMake(0, self.testVc.scrollerView.height + self.evaluate.scrollerView.height);
}

#pragma mark - <UIScrollViewDelegate>
/** 子控制器会用到 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - <CZRecommendNavDelegate>
- (void)recommendNavWithPop:(UIView *)view
{
    [CZProgressHUD hideAfterDelay:0];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
