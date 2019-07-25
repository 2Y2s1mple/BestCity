//
//  CZMHSDetailBkController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDetailBkController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZCommonRecommendCell.h"
#import "CZDChoiceDetailController.h"

@interface CZMHSDetailBkController () <UIScrollViewDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
/** 表 */
@property (nonatomic, strong) UITableView *tableView;
/** webView */
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UIView *line;
@end

@implementation CZMHSDetailBkController
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;

// 导航条
- (CZNavigationView *)navigationView
{
    if (_navigationView == nil) {
        _navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.titleText rightBtnTitle:nil rightBtnAction:nil navigationViewType  :CZNavigationViewTypeBlack];
        _navigationView.backgroundColor = CZGlobalWhiteBg;
        //导航条
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationView.height - 0.7, _navigationView.width, 0.7)];
        line.backgroundColor = CZGlobalLightGray;
        [_navigationView addSubview:line];
    }
    return _navigationView;
}

- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        CGFloat originY = (IsiPhoneX ? 44 : 20) + 40;
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, SCR_HEIGHT - originY)];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;

    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalGray;

    [self.view addSubview:self.navigationView];

    [self.view addSubview:self.scrollerView];

    [self obtainDetailData];
}

- (void)createWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(14, 0, SCR_WIDTH - 28, SCR_HEIGHT)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:self.webView];
    self.webView.delegate = self;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView loadHTMLString:self.dataSource[@"content"] baseURL:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size =  [change[@"new"] CGSizeValue];
    self.webView.height = size.height;
    self.line.y = self.webView.height;
    self.titleLabel.y = CZGetY(self.line) + 25;
    self.tableView.y =  CZGetY(self.titleLabel);
    // 更新滚动视图
    if ([self.dataSource[@"relatedArticleList"] count] > 0) {
        self.scrollerView.contentSize = CGSizeMake(0, CZGetY(self.tableView));
    } else {
        self.scrollerView.contentSize = CGSizeMake(0, self.webView.height);
    }
}

- (void)setup
{
    if ([self.dataSource[@"relatedArticleList"] count] > 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, 1)];
        line.backgroundColor = CZGlobalLightGray;
        self.line = line;
        [self.scrollerView addSubview:line];
        CGFloat space = 14.0f;
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, SCR_HEIGHT, 150, 20)];
        titleLabel.text = @"相关推荐";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        self.titleLabel = titleLabel;
        [self.scrollerView addSubview:titleLabel];
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(titleLabel.x, SCR_HEIGHT, SCR_WIDTH - 2 * titleLabel.x, 200) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.scrollerView addSubview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView = tableView;
        self.tableView.height = 146 * [self.dataSource[@"relatedArticleList"] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[@"relatedArticleList"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZCommonRecommendCell *cell = [CZCommonRecommendCell cellWithTableView:tableView];
    cell.articleDic = self.dataSource[@"relatedArticleList"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSDictionary *model = self.dataSource[@"relatedArticleList"][indexPath.row];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = CZJIPINModuleRelationBK;
        vc.findgoodsId = model[@"articleId"];
        vc.TitleText = self.titleText;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 网络请求
- (void)obtainDetailData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.dataDic[@"articleId"];
    param[@"type"] = @"5";
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/article/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];
            [self createWebView];
            [self setup];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {}];
}



@end
