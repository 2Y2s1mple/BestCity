//
//  CZRecommendDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZRecommendDetailController.h"
// 视图控制器
#import "CZCommoditySubController.h" // 商品
#import "CZTestSubController.h" // 测评
#import "CZEvaluateSubController.h" // 评论
#import "CZCommonRecommendController.h" // 推荐文章

#import "CZRecommendNav.h" // 导航
#import "CZCollectButton.h"
#import "CZShareAndlikeView.h" // 分享

#import "GXNetTool.h" // 网络请求
#import "CZUserInfoTool.h"

#import "UIButton+CZExtension.h" // 按钮扩展
#import "CZHotSaleDetailModel.h" // 当前数据模型

#import "TSLWebViewController.h"

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
/** 推荐文章 */
@property (nonatomic, strong) CZCommonRecommendController *recommen;
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

/** 分享里面文字 */
@property (nonatomic, strong) NSDictionary *shareDic;
/** 购买URL */
@property (nonatomic, strong) NSString *bugLinkUrl;
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
            NSString *text = @"榜单--商品详情--分享给好友";
            NSDictionary *context = @{@"mine" : text};
            [MobClick event:@"ID5" attributes:context];
            if ([JPTOKEN length] <= 0) {
                CZLoginController *vc = [CZLoginController shareLoginController];
                [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
                return;
            }
            CZShareView *share = [[CZShareView alloc] initWithFrame:weakSelf.view.frame];
            share.cententDic = weakSelf.shareDic;
            share.param = weakSelf.shareParam;
            [weakSelf.view addSubview:share];
        } rightBtnAction:^{
            NSString *text = @"榜单--商品详情--立即购买";
            NSDictionary *context = @{@"mine" : text};
            [MobClick event:@"ID5" attributes:context];

            NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
            if (specialId.length == 0) {
              __block TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/taobao/login?token=%@", JPSERVER_URL, JPTOKEN]] actionblock:^{
                    [CZProgressHUD showProgressHUDWithText:@"授权成功"];
                    [CZProgressHUD hideAfterDelay:1.5];
                    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];
                }];
                [weakSelf presentViewController:webVc animated:YES completion:nil];
            } else {
                // 打开淘宝
                [weakSelf getGoodsURl];
            }
        }];
    }
    return _likeView;
}

- (CZRecommendNav *)nav
{
    if (_nav == nil) {
        self.nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 40) type:CZJIPINModuleHotSale];
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
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
// 获取购买的URL
- (void)getGoodsURl
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = self.goodsId;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsBuyLink"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.bugLinkUrl = result[@"data"];
            // 打开淘宝
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:self];
        } else {
            self.bugLinkUrl = @"";
            [CZProgressHUD showProgressHUDWithText:@"链接获取失败"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)getSourceData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = self.goodsId;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.shareDic = result;

            self.detailModel = [CZHotSaleDetailModel objectWithKeyValues:result[@"data"]];
            [self createSubViews];
            
            // 创建分享购买视图
            NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
            shareDic[@"shareTitle"] =  self.detailModel.goodsDetailEntity.shareTitle;
            shareDic[@"shareContent"] = self.detailModel.goodsDetailEntity.shareContent;
            shareDic[@"shareUrl"] = self.detailModel.goodsDetailEntity.shareUrl;
            shareDic[@"shareImg"] = self.detailModel.goodsDetailEntity.shareImg;
            self.shareParam = shareDic;
            NSDictionary *versionParam = [CZSaveTool objectForKey:requiredVersionCode];
            if ([self.detailModel.goodsCouponsEntity.dataFlag isEqual:@(-1)]) {
                 if ( [versionParam[@"open"] isEqualToNumber:@(1)]) {
                     self.likeView.titleData = @{@"left" : result[@"btnTxt1"], @"right" : result[@"btnTxt2"]};
                 } else {
                     self.likeView.titleData = @{@"left" : @"分享", @"right" : @"立即购买"};
                 }
            } else {
                if ( [versionParam[@"open"] isEqualToNumber:@(1)]) {
                    self.likeView.titleData = @{@"left" : result[@"btnTxt1"], @"right" : result[@"btnTxt2"]};
                } else {
                    self.likeView.titleData = @{@"left" : @"分享", @"right" : @"立即购买"};
                }
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
    self.commendVC.view.y = 0;
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
    
    // 推荐文章
    self.recommen = [[CZCommonRecommendController alloc] init];
    self.recommen.view.y = self.evaluate.view.y + self.evaluate.scrollerView.height;
    self.recommen.articleArr = self.detailModel.goodsEntity.relatedArticleList;
    [self.scrollerView addSubview:self.recommen.view];
    [self addChildViewController:self.recommen];
    
    
    // 设置滚动高度
    self.scrollerView.contentSize = CGSizeMake(0, self.commendVC.scrollerView.height + self.testVc.scrollerView.height + self.evaluate.scrollerView.height + self.recommen.view.height);
}

#pragma mark - 监听子控件的frame的变化
- (void)openBoxInspectWebViewHeightChange:(NSNotification *)notfi
{
    self.evaluate.view.y = self.commendVC.scrollerView.height + self.testVc.scrollerView.height;
    self.recommen.view.y = self.evaluate.view.y + self.evaluate.scrollerView.height;
    
    self.scrollerView.contentSize = CGSizeMake(0, self.commendVC.scrollerView.height + self.testVc.scrollerView.height + self.evaluate.scrollerView.height + self.recommen.view.height);
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
            point = CGPointMake(0, CGRectGetMinY(self.testVc.view.frame) - 40 - (IsiPhoneX ? 44 : 20));
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
    BOOL offset1 = self.scrollerView.contentOffset.y >= -20 && self.scrollerView.contentOffset.y < (CGRectGetMinY(self.testVc.view.frame) - 40 - (IsiPhoneX ? 44 : 20));
    
    BOOL offset2 = self.scrollerView.contentOffset.y >= (CGRectGetMinY(self.testVc.view.frame) - 40 - (IsiPhoneX ? 44 : 20)) && self.scrollerView.contentOffset.y < (CGRectGetMinY(self.evaluate.view.frame) - 40 - (IsiPhoneX ? 44 : 20));
    
    BOOL offset3 = self.scrollerView.contentOffset.y >= (CGRectGetMinY(self.evaluate.view.frame) - 40 - (IsiPhoneX ? 44 : 20));
    
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
