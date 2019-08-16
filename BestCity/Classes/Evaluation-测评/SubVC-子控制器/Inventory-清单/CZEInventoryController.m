//
//  CZEInventoryController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEInventoryController.h"
#import "GXNetTool.h"
#import "CZETestModel.h"
// 跳转
#import "CZDChoiceDetailController.h"
#import "CZEInventoryEditorController.h"
// 视图
#import "CZEInventoryCell.h"

@interface CZEInventoryController () <UITableViewDelegate, UITableViewDataSource>
/** tabelview */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 记录btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** 类目 */
@property (nonatomic, strong) NSArray *categoryList;
/** 第一个类目ID */
@property (nonatomic, strong) NSString *categoryId;
/** 记录类目 */
@property (nonatomic, strong) NSDictionary *categoryParam;
/** <#注释#> */
@property (nonatomic, strong) UIButton *editorBtn;
@end

@implementation CZEInventoryController
- (UIButton *)editorBtn
{
    if (_editorBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"编组 4"] forState:UIControlStateNormal];
        btn.x = SCR_WIDTH - 15 - 59;
        btn.y = self.view.height - 30 - 59;
        btn.width = 59;
        btn.height = 59;
        [btn addTarget:self action:@selector(pushEditorController) forControlEvents:UIControlEventTouchUpInside];
        self.editorBtn = btn;
    }
    return _editorBtn;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 视图
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1 + 45, SCR_WIDTH, ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49))) style:UITableViewStylePlain];
        self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    // 获取类目
    [self getCategoryList];
}

- (void)pushEditorController
{
    CZEInventoryEditorController *vc = [[CZEInventoryEditorController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.height = self.view.height - 1 - 45;
    [self.view addSubview:self.editorBtn];
}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

- (void)reloadNewTrailDataSorce
{
    [self reloadNewDataSorce:self.categoryId];
}

- (void)loadMoreTrailDataSorce
{
    [self loadMoreTrailDataSorce:self.categoryId];
}

#pragma mark - 获取数据
// 获取类目
- (void)getCategoryList
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/listing/categoryList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.categoryList = result[@"data"];
            [self createTitlesViewWithData:result[@"data"]];
            [self setupRefresh];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}


// 获取整体数据
- (void)reloadNewDataSorce:(NSString *)categoryId
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    [CZProgressHUD showProgressHUDWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = categoryId;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/listingList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {

            self.dataSource = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];

            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce:(NSString *)categoryId
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = categoryId;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/listingList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.dataSource addObjectsFromArray:list];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

#pragma mark -- UITableViewDataSource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.dataSource[indexPath.row];
    CZEInventoryCell *cell = [CZEInventoryCell cellwithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.dataSource[indexPath.row];
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = [CZJIPINSynthesisTool getModuleType:[model.type integerValue]];
    vc.findgoodsId = model.articleId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 创建标题菜单
- (void)createTitlesViewWithData:(NSArray *)titles
{
    UIScrollView *backView = [[UIScrollView alloc] init];
    backView.showsHorizontalScrollIndicator = NO;
    backView.backgroundColor = [UIColor whiteColor];
    backView.y = 1;
    backView.height = 45;
    backView.width = SCR_WIDTH;
    [self.view addSubview:backView];


    CGFloat space = 20;
    CGFloat btnX = 15;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:titles[i][@"categoryName"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.centerY = backView.height / 2.0;
        btn.x = btnX;
        btn.height = 24;
        btn.width = btn.width + 10;
        btn.layer.cornerRadius = 12;
        [backView addSubview:btn];
        btnX += (space + btn.width);
        [btn addTarget:self action:@selector(contentViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIView *view = [[UIView alloc] init];
        view.tag = i + 200;
        view.x = btn.x;
        view.y = backView.height - 4;
        view.width = btn.width;
        view.height = 3;
        view.backgroundColor = CZREDCOLOR;
        view.layer.cornerRadius = 2;
        [backView addSubview:view];
        view.hidden = YES;

        backView.contentSize = CGSizeMake(btnX, 0);

        if (i == 0) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = UIColorFromRGB(0xE25838);
            self.recordBtn = btn;
            NSDictionary *param = self.categoryList[0];
            self.categoryId = param[@"categoryId"];
        }
    }
}

- (void)contentViewDidClickedBtn:(UIButton *)sender
{
    if (self.recordBtn != sender) {
        // 现在的btn
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = UIColorFromRGB(0xE25838);
        NSLog(@"%s", __func__);

        // 前一个Btn
        [self.recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.recordBtn.backgroundColor = [UIColor whiteColor];
        self.recordBtn = sender;
        //获取数据
        self.categoryParam = self.categoryList[sender.tag - 100];
        self.categoryId = self.categoryParam[@"categoryId"];
        [self reloadNewDataSorce:self.categoryId];
    }
}



@end
