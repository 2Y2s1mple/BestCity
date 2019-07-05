//
//  CZTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTwoController.h"
#import "CZHotSaleCell.h"
#import "CZHotTitleModel.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CZSubButton.h"


@interface CZTwoController ()

/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 记录点击的主菜单Btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 记录点击的Btn */
@property (nonatomic, strong) UIButton *recordMainBtn;
/** 当前的类目ID */
@property (nonatomic, strong) NSString *categoryId;
/** 记录当前的榜单类型 */
@property (nonatomic, assign) NSInteger orderbyType;
/** 记录从哪里悬浮标题栏 */
@property (nonatomic, strong) UIView *contentTitlesView;
/** 记录原来的contentTitlesViewY值 */
@property (nonatomic, assign) CGFloat  contentTitlesViewY;
/** 记录请求参数 */
@property (nonatomic, strong) NSDictionary *param;
/** 三级标题数组 */
@property (nonatomic, strong) NSArray *thirdTitles;

/** 辅助: 打点 */
/** 记录当前的二级菜单名字 */
@property (nonatomic, strong) NSString *twoTitle;
@end

@implementation CZTwoController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = self.tableView.tableHeaderView.height;
    }
    return _noDataView;
}

- (NSArray *)thirdTitles
{
    return @[
             @{
                 @"title" : @"热卖榜",
                 @"orderbyType" : @(1)
                 },
             @{
                 @"title" : @"轻奢榜",
                 @"orderbyType" : @(2)
                 },
             @{
                 @"title" : @"性能榜",
                 @"orderbyType" : @(5)
                 },
             @{  
                 @"title" : @"新品榜",
                 @"orderbyType" : @(3)
                 },
             @{
                 @"title" : @"性价比榜",
                 @"orderbyType" : @(4)
                 },
             ];
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderbyType = 1; //榜单代表的类型, 默认是热卖榜
    //line
    CZTOPLINE;
    // 设置tableView
    self.tableView.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94));
    // 设置头部标题
    self.tableView.tableHeaderView = [self setupHeaderView]; 
    // 记录当前的类目ID
    self.categoryId = self.subTitles.children[0].categoryId;
    // 加载刷新控件
    [self setupRefresh];
}

#pragma mark - 网络请求
- (void)getDataSourceWithId:(NSString *)categoryId type:(NSNumber *)orderbyType
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @"0";
    param[@"category2Id"] = categoryId;
    param[@"orderbyType"] =  orderbyType;
    param[@"client"] = @"2";
    self.param = param;
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (self.param != param) return;
        
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
                self.tableView.tableFooterView = nil;
            }
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 初始化二级标题视图
- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 90)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 60)];
    [backView addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    NSArray *children = self.subTitles.children;
    
    CGFloat w = 33;
    CGFloat leftSpace = 10;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - 5 * w) / 4;
    CGFloat h = w + 20;
    NSInteger cols = 5;
    for (int i = 0; i < children.count; i++) {
        CZHotSubTilteModel *model = children[i];
        NSInteger row = i / cols % 2;
        NSInteger col = i % cols; 
        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = w;
        btn.height = h;
        btn.x = leftSpace + col * (w + space) + (i / 10) * SCR_WIDTH;
        btn.y = 12 + row * (h + 10);
        [btn sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal];
        [btn setTitle:model.categoryName forState:UIControlStateNormal];
        [scrollView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        scrollView.height = scrollView.height < CZGetY(btn) ? CZGetY(btn) : scrollView.height;
        if (i == 0) {
            self.recordMainBtn = btn;
            self.twoTitle = model.categoryName;
            [btn setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
        }
    }
    
    NSInteger page = (children.count + 9) / 10;
    NSInteger row =  (children.count + (cols - 1)) / cols;
    NSLog(@"一共%ld行", row);
    scrollView.contentSize = CGSizeMake(page * SCR_WIDTH, 0);
    CGFloat lineY = row <= 2 ? scrollView.height + 12 : scrollView.height + 40;
    scrollView.height = lineY;
    
    if (page >= 2) {
        CGFloat circleX = 0.0;
        for (int i = 0; i < page; i++) {
            UIView *pointView = [[UIView alloc] init];
            for (int j = 0; j < page; j++) {
                UIView *circle = [[UIView alloc] init];
                circle.backgroundColor = CZGlobalGray;
                if (j == i) {
                    circle.width = 19;
                } else {                
                    circle.width = 8;
                }
                circle.height = 8;
                circle.x = CGRectGetMaxX([[pointView.subviews lastObject] frame]) + 8; 
                circle.layer.cornerRadius = 4;
                [pointView addSubview:circle];
                circleX = CGRectGetMaxX(circle.frame);
            }
            pointView.width = circleX;
            pointView.height = 8;
            pointView.centerX = scrollView.width / 2.0 + i * scrollView.width;
            pointView.y = lineY - 20;
            [scrollView addSubview:pointView];
        }
        
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, SCR_WIDTH, 6)];
    line.backgroundColor = CZGlobalLightGray; 
    [backView addSubview:line];
    
    // 初始化三级标题
    UIView *titles = [self contentViewTitles];
    self.contentTitlesView = titles;
    self.contentTitlesViewY = CZGetY(line);
    titles.y = self.contentTitlesViewY;
    [backView addSubview:titles];
        
    backView.height = CZGetY(titles);
    return backView;
}

#pragma mark - 二级菜单点击事件
- (void)headerViewDidClickedBtn:(UIButton *)sender
{
    if (self.recordMainBtn == sender) return;
    self.twoTitle = sender.titleLabel.text;
    NSString *text = [NSString stringWithFormat:@"%@--%@",self.subTitles.categoryName, self.twoTitle];
    NSDictionary *context = @{@"twoTab" : text};
    [MobClick event:@"ID1" attributes:context];
    NSLog(@"%@", text);
    [sender setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
    NSInteger index = sender.tag - 100;
    self.categoryId = self.subTitles.children[index].categoryId;
    self.orderbyType = 1; // 默认第一个
    [self contentViewDidClickedBtn:[[self.recordBtn superview] viewWithTag:100]];
    
    [self.recordMainBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    self.recordMainBtn = sender;
}

#pragma mark - 三级菜单视图
- (UIView *)contentViewTitles
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.height = 60;
    backView.width = SCR_WIDTH;
    
    NSArray *titles = self.thirdTitles;
    CGFloat space = (SCR_WIDTH - 30 - titles.count * 55) / (titles.count - 1);
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:titles[i][@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.centerY = backView.height / 2.0;
        btn.x = 15 + i * (space + 55);
        [backView addSubview:btn];
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
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(view), SCR_WIDTH, 1)];
        line.backgroundColor = CZGlobalLightGray; 
        [backView addSubview:line];
        
        if (i == 0) {
            view.hidden = NO;
            [btn setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
            self.recordBtn = btn;
        }
    }
    return backView;
}

#pragma mark - 三级菜单点击事件
- (void)contentViewDidClickedBtn:(UIButton *)sender
{
    if (self.recordBtn != sender) {

        NSString *text = [NSString stringWithFormat:@"%@--%@--%@",self.subTitles.categoryName, self.twoTitle, sender.titleLabel.text];
        NSDictionary *context = @{@"threeTab" : text};
        [MobClick event:@"ID1" attributes:context];
        NSLog(@"%@", text);

        // 现在的btn
        [sender setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        NSInteger lineViewTag = sender.tag + 100;
        UIView *lineView =  [sender.superview viewWithTag:lineViewTag];
        lineView.hidden = NO;
        
        NSLog(@"%s", __func__);
        // 前一个Btn
        [self.recordBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        self.recordBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        UIView *recordLineView =  [sender.superview viewWithTag:self.recordBtn.tag + 100];
        recordLineView.hidden = YES;
        self.recordBtn = sender;
        //获取数据
        self.orderbyType = [self.thirdTitles[sender.tag - 100][@"orderbyType"] integerValue];
    }
    [self getDataSourceWithId:self.categoryId type:@(self.orderbyType)];
}

/**
 * 头部的大图片
 */
- (UIView *)headerView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 180)];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, backView.height - 10);
    [backView addSubview:imageView];
    return backView;
}

/**
 * 加载刷新视图
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData
{    
    //获取数据
    [self getDataSourceWithId:self.categoryId type:@(self.orderbyType)];
}


#pragma mark - 代理方法
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= self.contentTitlesViewY) {
        NSLog(@"走位˚");
        self.contentTitlesView.y = -5;
        self.contentTitlesView.backgroundColor = CZGlobalLightGray;
        self.contentTitlesView.height = 55;
        self.contentTitlesView.clipsToBounds = YES;
        [self.view addSubview:self.contentTitlesView];
    } else if (scrollView.contentOffset.y <= (self.contentTitlesViewY + 60)) {
        self.contentTitlesView.y = self.contentTitlesViewY;
        self.contentTitlesView.height = 60;
        self.contentTitlesView.backgroundColor = [UIColor whiteColor];
        [self.tableView.tableHeaderView addSubview:self.contentTitlesView];
    }
}
@end
