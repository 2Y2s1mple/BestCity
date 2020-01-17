//
//  CZFestivalTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalTwoController.h"
#import "CZNavigationView.h"
// 工具
#import "GXNetTool.h"
#import "UIButton+WebCache.h"
#import "CZShareView.h"

// 视图
#import "CZFestivalCell.h"
#import "CZScollerImageTool.h" // 轮播图

// 跳转
#import "CZDChoiceDetailController.h"
#import "CZTaobaoDetailController.h"

@interface CZFestivalTwoController () <UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation CZFestivalTwoController
- (NSMutableArray *)listData
{
    if (_listData == nil) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? (24 + 67) : 67), SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0) - (IsiPhoneX ? (24 + 67) : 67)) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xE74434);
//        self.tableView.scrollEnabled = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.titleName rightBtnTitle:[UIImage imageNamed:@"Forward-1"] rightBtnAction:^{
        if ([JPTOKEN length] <= 0) {
            CZLoginController *vc = [CZLoginController shareLoginController];
            [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
            return;
        }
        NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
        shareDic[@"shareTitle"] = [NSString stringWithFormat:@"【%@】像我这样买才最低价！", self.titleName];
        shareDic[@"shareContent"] = @"官方正品抄底价，加券！加现金！额外返现现金转支付宝~";
        shareDic[@"shareUrl"] = [NSString stringWithFormat:@"https://www.jipincheng.cn/share/category11.html?id=%@", self.categoryId];
        shareDic[@"shareImg"] = [UIImage imageNamed:@"launchLogo.png"];
        CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
        share.param = shareDic;
        [self.view addSubview:share];
    } ];
    [self.view addSubview:navigationView];
    [self.view addSubview:self.tableView];

    // 获取数据创建视图
    [self setupRefresh];
}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleCategoryId"] =  self.categoryId;
    param[@"page"] = @(self.page);
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/activity11/category/goodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result;
            self.listData = [NSMutableArray arrayWithArray:result[@"data"]];
            self.tableView.tableHeaderView = [self createHeaderTableView];
            [self.tableView reloadData];
        } else {

        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleCategoryId"] = self.categoryId;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/activity11/category/goodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = result[@"data"];
            if (list.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.listData addObjectsFromArray:list];
                [self.tableView reloadData];
                // 结束刷新
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UIView *)createHeaderTableView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.width = SCR_WIDTH;
    // 添加轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 187.5)];
    [self.view addSubview:imageView];
    [imageView setSelectedIndexBlock:^(NSInteger index) {
        //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = [CZJIPINSynthesisTool getModuleType:[self.dataSource[@"ad"][@"type"] integerValue]];
        vc.findgoodsId = self.dataSource[@"ad"][@"objectId"];
        if ([self.dataSource[@"ad"][@"type"] integerValue] != 0) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    imageView.imgList = @[self.dataSource[@"ad"][@"img"]];
    [headerView addSubview:imageView];
    headerView.height = CZGetY(imageView);
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.listData[indexPath.row];
    CZFestivalCell *cell = [CZFestivalCell cellwithTableView:tableView];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.dataDic1 = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.listData[indexPath.row];
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
    CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
    vc.otherGoodsId = model[@"otherGoodsId"];

//    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
//    vc.detailType = [CZJIPINSynthesisTool getModuleType:2];
//    vc.findgoodsId = model[@"articleId"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
