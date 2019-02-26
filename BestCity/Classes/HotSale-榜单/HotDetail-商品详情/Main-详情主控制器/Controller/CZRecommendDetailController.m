//
//  CZRecommendDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZRecommendDetailController.h"
#import "CZCommoditySubController.h" // 商品
#import "CZTestSubController.h" // 测评
#import "CZEvaluateSubController.h" // 评论

#import "CZRecommendNav.h" // 导航
#import "CZCollectButton.h"
#import "CZShareAndlikeView.h" // 分享

#import "GXNetTool.h" // 网络请求

#import "UIButton+CZExtension.h" // 按钮扩展
#import "CZHotSaleDetailModel.h" // 当前数据模型

@interface CZRecommendDetailController ()<CZRecommendNavDelegate, UIScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 详情数据 */
@property (nonatomic, strong) CZHotSaleDetailModel *detailModel;
/** 商品 */
@property (nonatomic, strong) CZCommoditySubController *commendVC;
/** 评测 */
@property (nonatomic, strong) CZTestSubController *testVc;
/** 评价 */
@property (nonatomic, strong) CZEvaluateSubController *evaluate;
/** 导航栏 */
@property (nonatomic, strong) CZRecommendNav *nav;
/** 分享购买按钮 */
@property (nonatomic, strong) CZShareAndlikeView *likeView;
/** 分享参数 */
@property (nonatomic, strong) NSDictionary *shareParam;
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
/** 收藏 */
@property (nonatomic, strong) CZCollectButton *collectButton;
@end
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;
static NSString * const type = @"1";

@implementation CZRecommendDetailController
#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

- (CZShareAndlikeView *)likeView
{
    if (_likeView == nil) {
        __weak typeof(self) weakSelf = self;
        _likeView = [[CZShareAndlikeView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight), SCR_WIDTH, likeAndShareHeight) leftBtnAction:^{
            if ([JPTOKEN length] <= 0)
            {
                CZLoginController *vc = [CZLoginController shareLoginController];
                [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
                return;
            }
            CZShareView *share = [[CZShareView alloc] initWithFrame:weakSelf.view.frame];
            share.param = weakSelf.shareParam;
            [weakSelf.view addSubview:share];
        } rightBtnAction:^{
            if ([JPTOKEN length] <= 0)
            {
                CZLoginController *vc = [CZLoginController shareLoginController];
                [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
                return;
            }
            // 打开淘宝
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:weakSelf.detailModel.goodsDetailEntity.goodsBuyLink parentController:self];
            
        }];
        
    }
    return _likeView;
}

- (CZRecommendNav *)nav
{
    if (_nav == nil) {
        self.nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 40) type:CZRecommendNavDefault];
        self.nav.type = @"1"; /** 类型: 1商品，2评测, 3发现，4试用 */
        self.nav.projectId = self.goodsId;
        self.nav.delegate = self;
    }
    return _nav;
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

- (CZCollectButton *)collectButton
{
    if (_collectButton == nil) {
        _collectButton = [CZCollectButton collectButton];
        _collectButton.frame = CGRectMake(SCR_WIDTH - 14 - 30, (IsiPhoneX ? 54 : 30), 30, 30);
        [_collectButton setImage:[UIImage imageNamed:@"hot-list-favor"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"nav-favor-sel"] forState:UIControlStateSelected];
        _collectButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _collectButton.layer.cornerRadius = 15;
        _collectButton.layer.masksToBounds = YES;
        _collectButton.type = @"1";
        _collectButton.commodityID = self.goodsId;
    }
    return _collectButton;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 获取数据
    [self getSourceData];
     
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    
    // 加载pop按钮
    [self.view addSubview:self.popButton];
    
    // 加载收藏按钮
    [self.view addSubview:self.collectButton];
    
    // 创建导航栏
    [self.view addSubview:self.nav];
    self.nav.alpha = 0;
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBoxInspectWebViewHeightChange:) name:OpenBoxInspectWebHeightKey object:nil];
    // 添加收藏监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectChange) name:collectNotification object:nil];
}

- (void)collectChange
{
    _collectButton.type = @"1";
    _collectButton.commodityID = self.goodsId;
    self.nav.projectId = self.goodsId;
}

#pragma mark - 获取数据
- (void)getSourceData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = self.goodsId;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.detailModel = [CZHotSaleDetailModel objectWithKeyValues:result[@"data"]];
           
            [self createSubViews];
            // 创建分享购买视图
            NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
            shareDic[@"shareTitle"] =  self.detailModel.goodsDetailEntity.shareTitle;
            shareDic[@"shareContent"] = self.detailModel.goodsDetailEntity.shareContent;
            shareDic[@"shareUrl"] = self.detailModel.goodsDetailEntity.shareUrl;
            shareDic[@"shareImg"] = self.detailModel.goodsDetailEntity.shareImg;
            self.shareParam = shareDic;
            
            if ([self.detailModel.goodsCouponsEntity.dataFlag isEqual:@(-1)]) {
                self.likeView.titleData = @{@"left" : @"分享给好友", @"right" : @"立即购买"};
            } else {
                self.likeView.titleData = @{@"left" : @"分享给好友", @"right" : @"领券并购买"};
            };
            [self.view addSubview:self.likeView];
        }
    } failure:^(NSError *error) {}];
}

- (void)createSubViews
{
    // 商品
    self.commendVC = [[CZCommoditySubController alloc] init];
    self.commendVC.detailData = self.detailModel.goodsEntity;
    self.commendVC.commodityDetailData = self.detailModel.goodsDetailEntity;
    self.commendVC.couponData = self.detailModel.goodsCouponsEntity;
    self.commendVC.view.y = (IsiPhoneX ? -44 : -20);
    [self.scrollerView addSubview:self.commendVC.view];
    [self addChildViewController:self.commendVC];
    
    // 测评
    self.testVc = [[CZTestSubController alloc] init];
    self.testVc.view.y = self.commendVC.scrollerView.height;
    [self.scrollerView addSubview:self.testVc.view];
    [self addChildViewController:self.testVc];
    self.testVc.detailTtype = @"1"; /** 类型: 1商品，2评测, 3发现，4试用 */
    self.testVc.model = self.detailModel.evaluationEntity;
    
    // 评价
    self.evaluate = [[CZEvaluateSubController alloc] init];
    self.evaluate.view.y = self.commendVC.scrollerView.height + self.testVc.scrollerView.height;
    [self.scrollerView addSubview:self.evaluate.view];
    [self addChildViewController:self.evaluate];
    self.evaluate.type = type;
    self.evaluate.targetId = self.detailModel.goodsDetailEntity.goodsId;
    
    // 设置滚动高度
    self.scrollerView.contentSize = CGSizeMake(0, self.commendVC.scrollerView.height + self.testVc.scrollerView.height + self.evaluate.scrollerView.height);
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
    [CZProgressHUD hideAfterDelay:0];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickedTitleWithIndex:(NSInteger)index
{
    self.scrollerView.delegate = nil;
    CGPoint point;
    switch (index) {
        case 0:
            point = CGPointMake(0, 0);
            break;
        case 1:
            point = CGPointMake(0, CGRectGetMinY(self.testVc.view.frame) - 60 - (IsiPhoneX ? 44 : 20));
            break;
        case 2:
            point = CGPointMake(0, CGRectGetMinY(self.evaluate.view.frame) - 40 - (IsiPhoneX ? 44 : 20));
            break;
        default:
            point = CGPointMake(0, 0);
            break;
    }
    
    self.nav.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollerView.contentOffset = point;
    } completion:^(BOOL finished) {
        self.scrollerView.delegate = self;
    }];
    
}

#pragma mark - <UIScrollViewDelegate>
/** 子控制器会用到 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL offset1 = self.scrollerView.contentOffset.y >= -20 && self.scrollerView.contentOffset.y < (CGRectGetMinY(self.testVc.view.frame) - 60 - (IsiPhoneX ? 44 : 20));
    
    BOOL offset2 = self.scrollerView.contentOffset.y >= (CGRectGetMinY(self.testVc.view.frame) - 60 - (IsiPhoneX ? 44 : 20)) && self.scrollerView.contentOffset.y < (CGRectGetMinY(self.evaluate.view.frame) - 60 - (IsiPhoneX ? 44 : 20));
    
    BOOL offset3 = self.scrollerView.contentOffset.y >= (CGRectGetMinY(self.evaluate.view.frame) - 80 - (IsiPhoneX ? 44 : 20));
    
    if (offset1) {
        self.nav.monitorIndex = 0;
    } else if (offset2) {
        self.nav.monitorIndex = 1;
    } else if (offset3) {
        self.nav.monitorIndex = 2;
    }
    
     CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        self.nav.alpha = 0;
    }
    if (offsetY > 0 && offsetY < scrollView.contentSize.height - scrollView.height) {
        if (offsetY - self.recordOffsetY >= 0) {
//            NSLog(@"向上滑动");
//            NSLog(@"%f", offsetY / 50.0);
            self.nav.alpha = offsetY / 50.0;
        } else {
//            NSLog(@"向下滑动");
        }
        self.recordOffsetY = offsetY;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
