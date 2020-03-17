//
//  CZIssueMomentsController.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/16.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueMomentsController.h"
#import "CZNavigationView.h"
#import "CZCategoryLineLayoutView.h"
#import "GXNetTool.h"

@interface CZIssueMomentsController ()  <UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 三级 */
@property (nonatomic, strong) CZCategoryLineLayoutView *categoryView;

/** 页数 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation CZIssueMomentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
//    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"发圈" rightBtnTitle:nil rightBtnAction:nil];
//    navigationView.backgroundColor = [UIColor whiteColor];
//    self.navigationView = navigationView;
//    [self.view addSubview:navigationView];

    [self createView1];
    [self createView2];
    [self createView3];

}


- (void)createView1
{
    UIView *topview = [[UIView alloc] init];
    topview.width = SCR_WIDTH;
    topview.y = (IsiPhoneX ? 44 : 20);
    topview.height = 44;
    topview.backgroundColor = UIColorFromRGB(0xE25838);
    [self.view addSubview:topview];

    NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:@[@"每日精选", @"宣传素材"] setupNameKey:@"categoryName" imageKey:@"img" IdKey:@"categoryId" objectKey:@""];
    CGRect frame = CGRectMake(0, 9, SCR_WIDTH, 0);
    CZCategoryLineLayoutView *categoryView = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:2 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
        NSLog(@"%@", item.categoryName);
    }];
    categoryView.backgroundColor = [UIColor clearColor];
    [topview addSubview:categoryView];
}

- (void)createView2
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"titlesViewDataSource" ofType:@"json"];
    NSString *jsonStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    CGRect frame = CGRectMake(0, CZGetY([self.view.subviews lastObject]), SCR_WIDTH, 0);
    // 分类的按钮
    NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:list setupNameKey:@"categoryName" imageKey:@"img" IdKey:@"categoryId" objectKey:@""];
    CZCategoryLineLayoutView *categoryView = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:3 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
        NSLog(@"%@", item.categoryName);
    }];
    categoryView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:categoryView];
}

- (void)createView3
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"titlesViewDataSource" ofType:@"json"];
    NSString *jsonStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    CGRect frame = CGRectMake(0, CZGetY([self.view.subviews lastObject]), SCR_WIDTH, 0);
    // 分类的按钮
    NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:list setupNameKey:@"categoryName" imageKey:@"img" IdKey:@"categoryId" objectKey:@""];
    CZCategoryLineLayoutView *categoryView = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:4 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
        NSLog(@"%@", item.categoryName);
    }];
    categoryView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.categoryView = categoryView;
    [self.view addSubview:categoryView];

    UIButton *btn = [[UIButton alloc] init];
    [categoryView addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"moments-1"] forState:UIControlStateNormal];
    btn.x = SCR_WIDTH - 50;
    btn.width = 50;
    btn.height = categoryView.height;
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(alerView) forControlEvents:UIControlEventTouchUpInside];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) - 50 - 1) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(0);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/my/trial/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {



            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(0);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/my/trial/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {


            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 161;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"hotSaleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"-----%ld", indexPath.row];
    return cell;
}


- (void)alerView
{
    UIView *alertView = [[UIView alloc] init];
    alertView.y = self.categoryView.y;
    alertView.width = SCR_WIDTH;
    alertView.height = 200;
    alertView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:alertView];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 15, 53.0, 18.2);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"全部频道"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]}];
    label.attributedText = string;
    [alertView addSubview:label];

    UIButton *recoredBtn;
    NSInteger colIndex = 0;
    NSInteger rowIndex = 0;
    for (int i = 0; i < 10; i++) {

        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"收入素材" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x565252) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
        [btn sizeToFit];
        btn.height = 25;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        btn.width += 10;

        CGFloat maxW = CZGetX(recoredBtn);

        if (i == 0) { // 第一次什么也不做

        } else {
            if (SCR_WIDTH - maxW > (btn.width + 15)) { // 还能放
                colIndex++;
            } else {
                colIndex = 0;
                rowIndex++;
            }
        }

        btn.x = 10 + colIndex * (btn.width + 17);
        btn.y = 54 + rowIndex * (btn.height + 20);
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(alerViewAction:) forControlEvents:UIControlEventTouchUpInside];

        [alertView addSubview:btn];
        recoredBtn = btn;

        alertView.height = CZGetY(btn) + 23;
    }
}

- (void)alerViewAction:(UIButton *)sender
{
    [sender.superview removeFromSuperview];
}



@end
