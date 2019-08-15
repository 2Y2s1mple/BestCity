//
//  CZEInventoryAddGoodsController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEInventoryAddGoodsController.h"
#import "GXNetTool.h"
#import "CZEInventoryAddGoodsCell.h"
#import "CZEInventoryAddGoodsCellViewMdoel.h"

@interface CZEInventoryAddGoodsController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UITextField *tetField;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** <#注释#> */
@property (nonatomic, strong) UIView *line;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *goodsArr;
@end

int addGoodsNumber = 0;
@implementation CZEInventoryAddGoodsController

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)goodsArr
{
    if (_goodsArr == nil) {

    }
    return _goodsArr;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1 + CZGetY(self.line), SCR_WIDTH, SCR_HEIGHT - CZGetY(self.line) - 1) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSeachView];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

- (void)createSeachView
{
    UITextField *tetField = [[UITextField alloc] init];
    self.tetField = tetField;
    tetField.placeholder = @"请输入商品名称";
    tetField.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tetField.x = 14;
    tetField.y = (IsiPhoneX ? 54 : 30);
    tetField.size = CGSizeMake(SCR_WIDTH - 14 - 78, 40);
    [self.view addSubview:tetField];
    [tetField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];

    UIImageView *sImage = [[UIImageView alloc] init];
    sImage.image = [UIImage imageNamed:@"search"];
    [sImage sizeToFit];
    sImage.centerY = tetField.height / 2.0;
    sImage.x = tetField.width - 20 - sImage.size.width;
    [tetField addSubview:sImage];


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor: UIColorFromRGB(0x2B2B2B) forState:UIControlStateNormal];
    btn.x = SCR_WIDTH - 15 - 40;
    btn.width = 45;
    btn.height = 17;
    btn.centerY = tetField.centerY;
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIView *line = [[UIView alloc] init];
    line.x = 0;
    line.y = CZGetY(tetField) + 10;
    line.width = SCR_WIDTH;
    line.height = 1;
    line.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [self.view addSubview:line];
    self.line = line;
}

- (void)textFieldAction:(UITextField *)textField
{
    NSLog(@"-%@-----", textField.text);
    [self searchGoods:textField.text];
}

// 搜索
- (void)searchGoods:(NSString *)text
{

    if (text.length == 0) {
        return;
    }
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.articleId;
    param[@"keyword"] = text;
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/searchGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = result[@"data"];
            [self.dataSource removeAllObjects];
            for (NSDictionary *dic in list) {
                CZEInventoryAddGoodsCellViewMdoel *viewModel = [[CZEInventoryAddGoodsCellViewMdoel alloc] initWithviewModel:dic];
                viewModel.isSelected = [dic[@"related"] boolValue];
                viewModel.articleId = self.articleId;
                
                [self.dataSource addObject:viewModel];
            }
            [self.tableView reloadData];
        } else {

        }
    } failure:^(NSError *error) {

    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

#pragma mark - 获取数据

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.articleId;
    param[@"keyword"] = self.tetField.text;
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
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZEInventoryAddGoodsCellViewMdoel *viewModel = self.dataSource[indexPath.row];
    CZEInventoryAddGoodsCell *cell = [CZEInventoryAddGoodsCell cellwithTableView:tableView];
    cell.viewModel = viewModel;
    return cell;
}


@end
