//
//  CZFestivalController.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/29.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalController.h"

#import "CZSubButton.h"
#import "UIButton+WebCache.h"
// 工具
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZShareView.h"

// 视图
#import "CZFestivalCell.h"
#import "CZScollerImageTool.h" // 轮播图


// 跳转
#import "CZDChoiceDetailController.h"
#import "CZFestivalTwoController.h"
#import "CZTaobaoDetailController.h" // 淘宝详情页
#import "CZTaobaoSearchController.h"
#import "CZGuideTool.h"



@interface CZFestivalController () <UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
//@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *listData;
/** <#注释#> */
@property (nonatomic, strong) UIButton *editorBtn;


@end

@implementation CZFestivalController

- (UIButton *)editorBtn
{
    if (_editorBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"Festival-share"] forState:UIControlStateNormal];
        btn.width = 68;
        btn.height = 45;
        btn.x = SCR_WIDTH - 10 - btn.width;
        btn.y = SCR_HEIGHT - (IsiPhoneX ? 83 + 150 : 49 + 150);
        [btn addTarget:self action:@selector(pushEditorController) forControlEvents:UIControlEventTouchUpInside];
        self.editorBtn = btn;
    }
    return _editorBtn;
}

- (void)pushEditorController
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
    shareDic[@"shareTitle"] = @"这里全是钱啊，我得个现金大额返现~";
    shareDic[@"shareContent"] = @"比官方还低，同商品，同店铺，这里竟然有这样的价格！";
    shareDic[@"shareUrl"] = @"https://www.jipincheng.cn/share/index11.html";
    shareDic[@"shareImg"] = [UIImage imageNamed:@"launchLogo.png"];
    CZShareView *share = [[CZShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    share.param = shareDic;
    [[UIApplication sharedApplication].keyWindow addSubview:share];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49)) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    // 获取数据创建视图
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 新用户指导
        [CZGuideTool newpPeopleGuide];
    });
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
    self.page = 1;
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/activity11/index"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            self.listData = [NSMutableArray arrayWithArray:result[@"data"][@"goodsDataList"]];
            // 创建头部视图
            self.tableView.tableHeaderView = [self createHeaderTableView];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTrailDataSorce
{
    // 结束尾部刷新
    self.page++;
    [self.tableView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/activity11/goodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UIView *)createHeaderTableView
{
    UIView *headerView = [[UIView alloc] init];

    UIView *searchView = [[UIView alloc] init];
    searchView.x = 10;
    searchView.y = (IsiPhoneX ? 54 : 30);
    searchView.width = SCR_WIDTH - 20;
    searchView.height = 36;
    searchView.layer.cornerRadius =  18;
    searchView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [headerView addSubview:searchView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchView)];
    [searchView addGestureRecognizer:tap];

    UIImageView *imageS = [[UIImageView alloc] init];
    imageS.image = [UIImage imageNamed:@"taobaoDetai_搜索"];
    [searchView addSubview:imageS];
    [imageS sizeToFit];
    imageS.x = 14;
    imageS.centerY = searchView.height / 2.0;

    UILabel *title = [[UILabel alloc] init];
    title.text = @"搜商品名称或粘贴标题";
    title.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    title.textColor = UIColorFromRGB(0x9D9D9D);
    [searchView addSubview:title];
    [title sizeToFit];
    title.x = CZGetX(imageS) + 5;
    title.centerY = searchView.height / 2.0;


    // 添加轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, CZGetY(searchView) + 5, SCR_WIDTH, 200)];
    [self.view addSubview:imageView];
    [imageView setSelectedIndexBlock:^(NSInteger index) {
        //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
        NSDictionary *model = self.dataSource[@"adList"][index];
        if ([model[@"type"] integerValue] == 2) {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = [CZJIPINSynthesisTool getModuleType:[model[@"type"] integerValue]];
            vc.findgoodsId = model[@"objectId"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model[@"type"] integerValue] == 10) {
            CZFestivalTwoController *vc = [[CZFestivalTwoController alloc] init];
            vc.categoryId = model[@"objectId"];
            vc.titleName = [model[@"name"] stringByAppendingString:@"双11专区"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];

    NSMutableArray *imgs = [NSMutableArray array];
    for (NSDictionary *imgDic in self.dataSource[@"adList"]) {
        [imgs addObject:imgDic[@"img"]];
    }
    imageView.imgList = imgs;
    [headerView addSubview:imageView];

    // 添加官网声明的条
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"Main-icon5"];
    [headerView addSubview:icon];
    [icon sizeToFit];
    icon.centerX = SCR_WIDTH / 2.0;
    icon.y = CZGetY(imageView) + 10;

    // 分类的按钮
    UIView *categoryView = [[UIView alloc] init];
    categoryView.frame = CGRectMake(0, CZGetY(icon) + 10, SCR_WIDTH, 0);
    [headerView addSubview:categoryView];

    CGFloat width = 50;
    CGFloat height = width + 30;
    CGFloat leftSpace = 24;
    NSInteger cols = 4;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    NSInteger count = [self.dataSource[@"categoryList"] count];
    for (int i = 0; i < count; i++) {
        NSInteger col = i % cols;
        NSInteger row = i / cols % 2;

        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = width;
        btn.height = height;
        btn.categoryId = self.dataSource[@"categoryList"][i][@"categoryId"];
        btn.x = leftSpace + col * (width + space) + (i / 10) * SCR_WIDTH;
        btn.y = 12 + row * (height + 25);
        [btn sd_setImageWithURL:[NSURL URLWithString:self.dataSource[@"categoryList"][i][@"iconImg"]] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [btn setTitle:self.dataSource[@"categoryList"][i][@"categoryName"] forState:UIControlStateNormal];
        [categoryView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        categoryView.height = CZGetY(btn);
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.y = CZGetY(categoryView) + 15;
    lineView.width = SCR_WIDTH;
    lineView.height = 10;
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [headerView addSubview:lineView];

    headerView.height = CZGetY(lineView);
    return headerView;
}

#pragma mark - 事件
// 分类的点击
- (void)headerViewDidClickedBtn:(CZSubButton *)sender
{
    CZFestivalTwoController *vc = [[CZFestivalTwoController alloc] init];
    vc.categoryId = sender.categoryId;
    vc.titleName = [sender.titleLabel.text stringByAppendingString:@"专区"];
    [self.navigationController pushViewController:vc animated:YES];
}

// tableView点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.listData[indexPath.row];
    if ([model[@"type"] isEqual:@(1)]) {
        CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
        vc.otherGoodsId = model[@"goods"][@"otherGoodsId"];
        //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
//        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
//        vc.detailType = [CZJIPINSynthesisTool getModuleType:2];
//        vc.findgoodsId = model[@"goods"][@"articleId"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CZFestivalTwoController *vc = [[CZFestivalTwoController alloc] init];
        vc.categoryId = model[@"ad"][@"objectId"];
        vc.titleName = [model[@"ad"][@"name"] stringByAppendingString:@"专区"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.listData[indexPath.row];
    if ([model[@"type"] isEqual:@(1)]) {
        CZFestivalCell *cell = [CZFestivalCell cellwithTableView:tableView];
        cell.dataDic = model;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CZFestivalCell2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CZFestivalCell2"];
//            cell.backgroundColor = UIColorFromRGB(0xE74434);
        }

        UIImageView *image = [cell viewWithTag:20];
        if (image == nil) {
            image = [[UIImageView alloc] init];
            image.tag = 20;
            image.x = 10;
            image.y = 10;
            image.width = SCR_WIDTH - 20;
            image.height = 95;
            [cell addSubview:image];
        }
        [image sd_setImageWithURL:[NSURL URLWithString:model[@"ad"][@"img"]]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.listData[indexPath.row];
    if ([model[@"type"] isEqual:@(1)]) {
        return 140;
    } else {
        return 115;
    }
}

- (void)pushSearchView
{
    CZTaobaoSearchController *vc = [[CZTaobaoSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
