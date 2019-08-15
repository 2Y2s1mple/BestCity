//
//  CZETestController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZETestController.h"
#import "GXNetTool.h"
#import "CZETestModel.h"

// 跳转
#import "CZDChoiceDetailController.h"
#import "CZETestAllContrastController.h"
#import "CZETestAllOpenBoxController.h"

// 视图
#import "CZETestOpenBoxCell.h"
#import "CZETestContrastCell.h"

@interface CZETestController ()<UITableViewDelegate, UITableViewDataSource>
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

@end

@implementation CZETestController
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1 + 45, SCR_WIDTH, ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49))) style:UITableViewStyleGrouped];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.height = self.view.height - 1 - 45;
}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDataSorce)];
}

- (void)reloadNewDataSorce
{
    [self reloadNewDataSorce:self.categoryId];
}

#pragma mark - 获取数据
// 获取类目
- (void)getCategoryList
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/evaluation/categoryList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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
    [self.dataSource removeAllObjects];
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = categoryId;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/indexEvaluationList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list1 = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];
            NSArray *list2 = [CZETestModel objectArrayWithKeyValuesArray:result[@"list2"]];
            [self.dataSource addObject:list1];
            [self.dataSource addObject:list2];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

#pragma mark -- 方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.height = 45;
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x565252);
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    if (section == 0) {
        label.text = @"开箱评测";
    } else {
        label.text = @"对比评测";
    }
    [label sizeToFit];
    label.x = 15;
    label.centerY = view.height / 2.0 + 10;
    [view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = section;
    [btn setTitle:@"全部" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setImage:[UIImage imageNamed:@"编组 2"] forState:UIControlStateNormal];
    [btn setTitleColor: UIColorFromRGB(0x565252) forState:UIControlStateNormal];
    btn.x = SCR_WIDTH - 15 - 40;
    btn.width = 45;
    btn.height = 17;
    btn.centerY = view.height / 2.0 + 10;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [view addSubview:btn];
    [btn addTarget:self action:@selector(pushAllGoogsVC:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

#pragma mark - 跳转全部
- (void)pushAllGoogsVC:(UIButton *)sender
{
    if (sender.tag == 0) {
        CZETestAllOpenBoxController *vc = [[CZETestAllOpenBoxController alloc] init];
        vc.titleText = [self.recordBtn.titleLabel.text stringByAppendingString:@"开箱评测"];
        vc.categoryId = self.categoryParam[@"categoryId"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CZETestAllContrastController *vc = [[CZETestAllContrastController alloc] init];
        vc.titleText = [self.recordBtn.titleLabel.text stringByAppendingString:@"对比评测"];
        vc.categoryId = self.categoryParam[@"categoryId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

// UITableViewDataSource代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        CZETestOpenBoxCell *cell = [CZETestOpenBoxCell cellwithTableView:tableView];
        cell.model = model;
        return cell;
    } else {
        CZETestContrastCell *cell = [CZETestContrastCell cellwithTableView:tableView];
        cell.model = model;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        return 190;
    } else {
        return model.cellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.dataSource[indexPath.section][indexPath.row];
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
            [self reloadNewDataSorce:self.categoryId];
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
