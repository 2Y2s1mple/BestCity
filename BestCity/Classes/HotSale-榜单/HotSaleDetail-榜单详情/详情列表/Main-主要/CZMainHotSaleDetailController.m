//
//  CZMainHotSaleDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainHotSaleDetailController.h"
#import "GXNetTool.h"
#import "CZNavigationView.h"
#import "CZScrollMenuModule.h"
// 视图
#import "CZMHSDetailCommodity.h"
#import "CZNoDataView.h"
// 数据
#import "ZMHSDetailModel.h"


@interface CZMainHotSaleDetailController ()
/** <#注释#> */
@property (nonatomic, strong) CZMHSDetailCommodity *commodity;
/** 计算高度 */
@property (nonatomic, assign) CGFloat calculateHeight;
/** <#注释#> */
@property (nonatomic, strong) NSString *orderbyCategoryId;
/** 没有数据视图 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 记录请求参数 */
@property (nonatomic, strong) NSDictionary *param;
@end

@implementation CZMainHotSaleDetailController
#pragma mark - 创建视图
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

// 导航条
- ( CZNavigationView * (^)(void))createNavView
{
    return ^ {
        CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.titleText rightBtnTitle:nil rightBtnAction:nil ];
        [self.view addSubview:navigationView];
        self.calculateHeight = CZGetY(navigationView);
        return navigationView;
    } ;
}

- (CZScrollMenuModule * (^)(NSArray *titles))createMenuView
{
    return ^(NSArray *titles){
        NSMutableArray *titleaArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in titles) {
            [titleaArr addObject:dic[@"name"]];
        }
        CZScrollMenuModule *menuView = [[CZScrollMenuModule alloc] initWithFrame:CGRectMake(0, self.calculateHeight, SCR_WIDTH, 55)];
        menuView.normalColor = UIColorFromRGB(0x2B2B2B);
        menuView.selectColor = UIColorFromRGB(0xE25838);
        menuView.titles = titleaArr;
        menuView.didSelectedTitle = ^(NSInteger index) {
            NSLog(@"%ld", index);
            NSDictionary *dic = titles[index];
            self.commodity.selectedItemIndex = index;
            self.orderbyCategoryId = dic[@"orderbyCategoryId"];
            [self getTopListData:^(NSDictionary *dic) {
                self.commodity.topDataList = dic[@"data"];
            }];
        };
        self.calculateHeight += menuView.height;
        return menuView;
    };
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航条
    [self.view addSubview:self.createNavView()];

    WS(weakself);
    // 获取数据
    [self getData:^(NSDictionary *data) {
        // 菜单
        ZMHSDetailModel *model = [ZMHSDetailModel objectWithKeyValues:data];
        if (model.relatedItemList.count > 0) {
            [weakself.view addSubview:weakself.createMenuView(model.relatedItemList)];
            // 榜单列表
            CZMHSDetailCommodity *commodity = [[CZMHSDetailCommodity alloc] init];
            [weakself addChildViewController:commodity];
            commodity.model = [ZMHSDetailModel objectWithKeyValues:data];
            commodity.ID = weakself.ID;
            commodity.view.frame = CGRectMake(0, weakself.calculateHeight, SCR_WIDTH, SCR_HEIGHT - weakself.calculateHeight);
            weakself.commodity = commodity;
            // 榜单列表
            [weakself.view addSubview:commodity.view];
        } else {
            [weakself.view addSubview:weakself.noDataView];
        }
    }];
}

#pragma mark - 网络请求
- (instancetype)getData:(void (^)(NSDictionary *))listData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = self.ID;
    param[@"client"] = @(2);
    
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/getTopCategoryDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            listData(result[@"data"]);
        }
    } failure:^(NSError *error) {}];
    return self;
}

- (instancetype)getTopListData:(void (^)(NSDictionary *))listData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"orderbyCategoryId"] = self.orderbyCategoryId;
    param[@"client"] = @(2);
    self.param = param;

    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/goodsListByOrderbyCategoryId"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (self.param != param) return;
        NSLog(@"--------");
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            listData(result);
        }
    } failure:^(NSError *error) {}];
    return self;
}


@end
