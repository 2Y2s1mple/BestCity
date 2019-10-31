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
        btn.x = SCR_WIDTH - 15 - 59;
        btn.y = SCR_HEIGHT - (IsiPhoneX ? 183 : 139);
        btn.width = 59;
        btn.height = 59;
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
    shareDic[@"shareTitle"] = @"这里全是钱啊，双十一我得了现金大额补贴";
    shareDic[@"shareContent"] = @"比官方还低价，同商品，同店铺，这里竟然有这样的价格！";
    shareDic[@"shareUrl"] = @"https://www.jipincheng.cn/share/index11.html";
    shareDic[@"shareImg"] = [UIImage imageNamed:@"headDefault"];
    CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
    share.cententText = shareDic[@"content"];
    share.param = shareDic;
    [self.view addSubview:share];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49)) style:UITableViewStylePlain];
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
    [self.view addSubview:self.tableView];
    // 获取数据创建视图
    [self setupRefresh];

    [self.view addSubview:self.editorBtn];
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
    } failure:^(NSError *error) {}];
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

    // 添加轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 200)];
    [self.view addSubview:imageView];
    [imageView setSelectedIndexBlock:^(NSInteger index) {
        //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
        NSDictionary *model = self.dataSource[@"adList"][index];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = [CZJIPINSynthesisTool getModuleType:[model[@"type"] integerValue]];
        vc.findgoodsId = model[@"objectId"];
        if ([model[@"type"] integerValue] != 0) {
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
    UIView *officialLine = [[UIView alloc] init];
    officialLine.frame = CGRectMake(10, CZGetY(imageView) + 10, SCR_WIDTH - 20, 28);
    officialLine.backgroundColor = UIColorFromRGB(0xF9E0CD);
    officialLine.layer.cornerRadius = 5;
    [headerView addSubview:officialLine];

    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"• 精选好物";
    label2.textColor = UIColorFromRGB(0xE74434);
    label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    [label2 sizeToFit];
    [officialLine addSubview:label2];
    label2.centerY = officialLine.height / 2.0;
    label2.x = officialLine.width - 10 - label2.width;

    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"• 双11极品补贴重量升级";
    label1.textColor = UIColorFromRGB(0xE74434);
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    [label1 sizeToFit];
    [officialLine addSubview:label1];
    label1.centerY = officialLine.height / 2.0;
    label1.x = 10;

    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"• 精选好物";
    label3.textColor = UIColorFromRGB(0xE74434);
    label3.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    [label3 sizeToFit];
    [officialLine addSubview:label3];
    label3.centerY = officialLine.height / 2.0;
    label3.x = CZGetX(label1);
    label3.width = officialLine.width - (CZGetX(label1) + label2.width);
    label3.textAlignment = NSTextAlignmentCenter;

    // 分类的按钮
    UIView *categoryView = [[UIView alloc] init];
    categoryView.frame = CGRectMake(0, CZGetY(officialLine) + 15, SCR_WIDTH, 0);
//    categoryView.backgroundColor = RANDOMCOLOR;
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
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:self.dataSource[@"categoryList"][i][@"categoryName"] forState:UIControlStateNormal];
        [categoryView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        categoryView.height = CZGetY(btn);
    }
    headerView.height = CZGetY(categoryView) + 15;
    return headerView;
}

#pragma mark - 事件
// 分类的点击
- (void)headerViewDidClickedBtn:(CZSubButton *)sender
{
    CZFestivalTwoController *vc = [[CZFestivalTwoController alloc] init];
    vc.categoryId = sender.categoryId;
    vc.titleName = sender.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

// tableView点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.listData[indexPath.row];
    if ([model[@"type"] isEqual:@(1)]) {
        //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = [CZJIPINSynthesisTool getModuleType:2];
        vc.findgoodsId = model[@"goods"][@"articleId"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CZFestivalTwoController *vc = [[CZFestivalTwoController alloc] init];
        vc.categoryId = model[@"ad"][@"objectId"];
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
            cell.backgroundColor = UIColorFromRGB(0xE74434);
            UIImageView *image = [[UIImageView alloc] init];
            image.x = 10;
            image.y = 10;
            image.width = SCR_WIDTH - 20;
            image.height = 95;
            [cell addSubview:image];
            [image sd_setImageWithURL:[NSURL URLWithString:model[@"ad"][@"img"]]];
        }
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


@end
