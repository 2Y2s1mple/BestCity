//
//  CZHotsaleSearchController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotsaleSearchController.h"
#import "CZHotsaleSearchDetailController.h"
#import "CZHotSearchView.h"
#import "CZHotTagsView.h"
#import "GXNetTool.h"
#import "CZHisSearchCell.h"

@interface CZHotsaleSearchController ()<hotsaleSearchDetailControllerDelegate, CZHotSearchViewDelegate, CZHotTagsViewDelegate, UITableViewDelegate, UITableViewDataSource>

/** 历史搜索视图 */
@property (nonatomic, strong) CZHotTagsView *hisView;
/** 删除Btn */
@property (nonatomic, strong) UIButton *btnClose;
/** 记录要删除的tag */
@property (nonatomic, assign) NSInteger recordTag;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *searchView;
/** search记录 */
@property (nonatomic, strong) NSMutableArray *searchArr;
/** 历史搜索记录 */
@property (nonatomic, strong) NSMutableArray *hisArr;
/** 历史记录tableView */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZHotsaleSearchController
#pragma mark - 数据
// 搜索框Y值
- (CGFloat)searchViewY
{
    return (IsiPhoneX ? 54 : 30);
}

// 搜索框H值
- (CGFloat)searchHeight
{
    return 34;
}
#pragma mark -- end

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建搜索栏
    [self setupSearchView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取数据
    [self getSourceData];
}

- (void)getSourceData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/log"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"%@", result[@"data"]);
            // 大家都在搜
            self.searchArr = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"][@"hotWordList"]) {
                [self.searchArr addObject:dic[@"word"]];
            }
            // 历史
            self.hisArr = result[@"data"][@"logList"];
            // 创建大家都在搜
            [self createHistorySearchModule];
            // 创建历史搜索
            [self createHotSearchModule];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 创建搜索及代理方法
- (void)setupSearchView
{
    __weak typeof(self) weakSelf = self;
    self.searchView = [[CZHotSearchView alloc] initWithFrame:CGRectMake(10, self.searchViewY, SCR_WIDTH, self.searchHeight) msgAction:^(NSString *rightBtnText){
        if ([rightBtnText isEqualToString:@"搜索"]) {
            [weakSelf pushSearchDetail];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.searchView.textFieldBorderColor = CZGlobalGray;
    self.searchView.textFieldActive = YES;
    self.searchView.msgTitle = @"取消";
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
}

// <CZHotSearchViewDelegate>
- (void)hotView:(CZHotSearchView *)hotView didTextFieldChange:(CZTextField *)textField
{
    if (textField.text.length == 0) {
        hotView.msgTitle = @"取消";
    } else {
        hotView.msgTitle = @"搜索";
    }
}

#pragma mark - 创建大家都在搜, 历史搜索及代理方法
// 大家都在搜
- (void)createHistorySearchModule
{
    self.hisView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, 100, SCR_WIDTH, 300)];
    self.hisView.type = CZHotTagLabelTypeTapGesture;
    self.hisView.delegate = self;
    self.hisView.title = @"大家都在搜";
    self.hisView.hisArray = [NSMutableArray arrayWithArray:self.searchArr];
    [self.view addSubview:_hisView];
}

// 历史搜索
- (void)createHotSearchModule
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(self.hisView) + 40, SCR_WIDTH, SCR_HEIGHT - (CZGetY(self.hisView) + 40))];
    [self.view addSubview:historyView];

    UILabel *hisLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    hisLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    hisLabel.text = @"历史搜索";
    [historyView addSubview:hisLabel];
  
    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.frame = CGRectMake(SCR_WIDTH - 14 - 17, hisLabel.y, 17, 17);
    [deleteBtn setImage:[UIImage imageNamed:@"delete-1"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [historyView addSubview:deleteBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CZGetY(hisLabel) + 20, SCR_WIDTH - 10, 200) style:UITableViewStylePlain];
    tableView.height = SCR_WIDTH - CGRectGetMinY(tableView.frame); 
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [historyView addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
}

#pragma mark - 全部删除
- (void)deleteAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除全部历史记录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [CZProgressHUD showProgressHUDWithText:nil];
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/deleteAll"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                [self reloadData];
            }        
        } failure:^(NSError *error) {}];
    }]];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
}

- (void)reloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/log"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 历史
            self.hisArr =  result[@"data"][@"logList"];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hisArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZHisSearchCell *cell = [CZHisSearchCell cellWithTableView:tableView deleteBtnBlock:^{
        [self reloadData];
    }];
    cell.historyData = self.hisArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *titleData = self.hisArr[indexPath.row];
    self.searchView.searchText = titleData[@"word"];
    [self pushSearchDetail];
}

// 点击事件 <CZHotTagsViewDelegate>
- (void)hotTagsView:(CZHotTagsView *)tagsView didSelectedTag:(CZHotTagLabel *)tagLabel
{
    NSInteger index = arc4random_uniform(100) % 2;
    NSString *text;
    if (index == 0) {
        text = @"首页搜索框--大家都在搜--第一位置";
    } else {
        text = @"首页搜索框--大家都在搜--第二位置";
    }
    NSLog(@"%@", text);
    NSDictionary *context = @{@"message" : text};
    [MobClick event:@"ID1" attributes:context];
    self.searchView.searchText = tagLabel.text;
    [self pushSearchDetail];
}

// 长按事件 <CZHotTagsViewDelegate>
- (void)hotTagsViewLongPressAccessoryEvent
{
//    // 大家都在搜
//    self.hotView.frame = CGRectMake(0, CZGetY(self.hisView) + 20, SCR_WIDTH, 300);
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - <>详情页面的代理方法
- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear
{
    if (clear) {
        //详情页面点击了清除
        self.searchView.searchText = nil;
    } else {
        
    }
    
    if (self.searchView.searchText) {
        self.searchView.msgTitle = @"搜索";
    } else {
        self.searchView.msgTitle = @"取消";
    }
}
#pragma mark - 跳转
- (void)pushSearchDetail
{
    CZHotsaleSearchDetailController *vc = [[CZHotsaleSearchDetailController alloc] init];
    vc.textTitle = self.searchView.searchText;
    vc.type = @"1";
    vc.currentDelegate = self;
    WMPageController *hotVc = (WMPageController *)vc;
    hotVc.selectIndex = 0;
    hotVc.menuViewStyle = WMMenuViewStyleDefault;
    //        hotVc.progressWidth = 30;
    hotVc.itemMargin = 10;
//    hotVc.progressHeight = 3;
    hotVc.automaticallyCalculatesItemWidths = YES;
    hotVc.titleFontName = @"PingFangSC-Medium";
    hotVc.titleColorNormal = CZGlobalGray;
    hotVc.titleColorSelected = CZRGBColor(5, 5, 5);
    hotVc.titleSizeNormal = 16.0f;
    hotVc.titleSizeSelected = 16;
    hotVc.progressColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
