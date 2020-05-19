//
//  CZMainViewSubOneVC.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainViewSubOneVC.h"
// 工具
#import "GXNetTool.h"
#import "CZFreePushTool.h"

// 视图
#import <AdSupport/AdSupport.h>
#import "KCUtilMd5.h"

//------------------
// viewModel
#import "CZFestivalCollectDelegate.h"

// 数据
#import "CZMainViewSubOneVCModel.h"

// 弹框
#import "CZAlertMainViewController.h"



@interface CZMainViewSubOneVC ()
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectView;
/** <#注释#> */
@property (nonatomic, strong) CZFestivalCollectDelegate *collectDataSurce;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *orderByType;  // 0综合，1价格，2返现，3销量
/** <#注释#> */
@property (nonatomic, strong) UIImageView *icon;

/** 总数据 */
@property (nonatomic, strong) CZMainViewSubOneVCModel *totalDataModel;

/** 精选推荐 */
@property (nonatomic, strong) NSMutableArray *qualityGoods;
@end

@implementation CZMainViewSubOneVC
#pragma mark - 系统生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    // 数据初始化
    self.orderByType = @"2";
    
    // 创建UI
    self.icon = [[UIImageView alloc] init];
    self.icon.image = [UIImage imageNamed:@"Main-矩形"];
    [self.icon setTintColor:UIColorFromRGB(0x143030)];
    self.icon.width = SCR_WIDTH;
    self.icon.height = 58;
    [self.view addSubview:self.icon];

    [self.view addSubview:self.collectView];

    // 改变上部环形图片的颜色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageColorChange:) name:@"mainImageColorChange" object:nil];
    
    // 监听按钮的点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsRecommendedBtnsAction:) name:@"mainSameTitleAction" object:nil];
    
    // 接收登录时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewTrailDataSorce) name:loginChangeUserInfo object:nil];

    // 接收极光的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jiGuangPushNotifi) name:@"JiGuangPushNotifi" object:nil];

    // 数据
    [self setupRefresh];

    // 极光推送的信息
    [self jiGuangPushNotifi];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectView.height = self.view.height;
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_xinren"];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
    [CZJIPINSynthesisTool jipin_privacyPolicyAlertView:^(BOOL isAgree) {
        if (isAgree) {
            if (aDImage.count > 0) {
                NSDictionary *dic = [[aDImage firstObject] deleteAllNullValue];
                NSDictionary *param = @{
                    @"targetType" : dic[@"type"] == nil ? @"" : dic[@"type"],
                    @"targetId" : dic[@"objectId"] == nil ? @"" : dic[@"objectId"],
                    @"targetTitle" : dic[@"name"] == nil ? @"" : dic[@"type"],
                };
                [CZFreePushTool bannerPushToVC:param];
                aDImage = nil;
            } else {
                // 如果是新版本
                [CZJIPINSynthesisTool jipin_isFirstIntoWithIdentifier:[self class] info:^(BOOL isFirstInto, NSInteger count) {
                    if (count == 2) { // 新版本
                        CZAlertMainViewController *alertView = [[CZAlertMainViewController alloc] initWithBlock:^{
                            // 开启弹框
//                            [CZJIPINSynthesisTool jipin_globalAlertWithNewVersion:YES];
                        }];
                        [self presentViewController:alertView animated:NO completion:nil];
                    } else { // 旧版本
                        static dispatch_once_t onceToken;
                        dispatch_once(&onceToken, ^{
                            // 开启弹框
                            [CZJIPINSynthesisTool jipin_globalAlertWithNewVersion:NO];
                        });
                    }
                }];
            }

            // 全局弹框在全局, 显示一个删除一个
            if (alertList_.count > 0) {
                [[UIApplication sharedApplication].keyWindow addSubview:alertList_[0]];
            }
        }
    }];
}

#pragma mark - UI创建
- (UICollectionView *)collectView
{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        CGRect frame = CGRectMake(0, 0, SCR_WIDTH, 0);
        _collectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.backgroundColor = [UIColor clearColor];
        self.collectDataSurce = [[CZFestivalCollectDelegate alloc] initWithCollectView:_collectView];
        self.collectDataSurce.iconImageView = self.icon;
        self.collectDataSurce.superView = self.view;
    }
    return _collectView;
}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.collectView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.collectView.mj_header beginRefreshing];
//    self.collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
    
    self.collectView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

#pragma mark - 数据
// 精品推荐数据
- (NSMutableArray *)qualityGoods
{
    if (_qualityGoods == nil) {
        _qualityGoods = [NSMutableArray array];
    }
    return _qualityGoods;
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.collectView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/index"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.totalDataModel = [CZMainViewSubOneVCModel objectWithKeyValues:result[@"data"]];
            self.collectDataSurce.totalDataModel = self.totalDataModel;
            [self.collectView reloadData];
            // 获取精品推荐
            [self getProductsRecommendedData:@{@"orderByType" : self.orderByType}];
        } else {
            // 结束刷新
            [self.collectView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {// 结束刷新
        [self.collectView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTrailDataSorce
{
    [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_loding"];
    [self.collectView.mj_header endRefreshing];
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"source"] = self.orderByType; // 1:京东 2:淘宝 4拼多多
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/commendGoodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] != 0) {
                [self.qualityGoods addObjectsFromArray:result[@"data"]];
                self.collectDataSurce.qualityGoods = self.qualityGoods;
                [self.collectView reloadData];
                // 结束刷新
                [self.collectView.mj_footer endRefreshing];
            } else {
                [self.collectView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            // 结束刷新
            [self.collectView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {// 结束刷新
        [self.collectView.mj_footer endRefreshing];

    }];
}

// 获取今日推荐
- (void)getProductsRecommendedData:(NSDictionary *)dataParam
{
    [self.collectView.mj_header endRefreshing];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"source"] = dataParam[@"orderByType"]; // 1:京东 2:淘宝 4拼多多
    param[@"page"] = @(self.page);
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/commendGoodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.qualityGoods = [NSMutableArray arrayWithArray:result[@"data"]];
            self.collectDataSurce.qualityGoods = self.qualityGoods;
            
            NSIndexSet *index = [NSIndexSet indexSetWithIndex:4];
            [self.collectView reloadSections:index];
        }
        // 结束刷新
        [self.collectView.mj_footer endRefreshing];
    } failure:^(NSError *error) { // 结束刷新
        [self.collectView.mj_footer endRefreshing];
    }];
}

#pragma mark - 事件
// 改变颜色
- (void)imageColorChange:(NSNotification *)sender
{
    UIColor *color = sender.userInfo[@"color"];
    [UIView animateWithDuration:0.25 animations:^{
        [self.icon setTintColor:color];
    }];
}

// 精品推荐的按钮
- (void)productsRecommendedBtnsAction:(NSNotification *)sender
{
    NSDictionary *param = sender.userInfo;
    [self.collectView.mj_footer endRefreshing];
    self.orderByType = param[@"orderByType"];
    [self getProductsRecommendedData:param];
}

- (void)jiGuangPushNotifi
{
    if (PushData_) {
        NSDictionary *dic = PushData_;
        NSDictionary *param1 = @{
            @"targetType" : dic[@"targetType"] == nil ? @"" : dic[@"targetType"],
            @"targetId" : dic[@"targetId"] == nil ? @"" : dic[@"targetId"],
            @"targetTitle" : dic[@"targetTitle"] == nil ? @"" : dic[@"targetTitle"],
        };
        [CZFreePushTool bannerPushToVC:param1];
        PushData_ = nil;
    }
}



@end
