//
//  CZAttentionDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionDetailController.h"
#import "UIButton+CZExtension.h"
#import "Masonry.h"
#import "CZAttentionBtn.h"
#import "MJRefresh.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "CZAttentionDetailModel.h"
#import "CZChoicenessCell.h" // 发现cell
#import "CZAttentionDetailCell.h" //没有重用这个测评cell
#import "CZEvaluationChoicenessDetailController.h" // 测评详情
#import "CZDChoiceDetailController.h" // 发现详情


@interface CZAttentionDetailController ()<UITableViewDataSource, UITableViewDelegate>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CZAttentionDetailController
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self setupHeaderView];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:tableView];
    
    // 创建刷新控件
    [self setupRefresh];
}

/** 加载刷新控件*/
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNowAttentions)];
    // 进来先刷一次
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAttentions)];
}

// 刷新
- (void)loadNowAttentions
{
    // 结束footer
    [self.tableView.mj_footer endRefreshing];
    
    // 加载数据
    self.page = 0;
    
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"attentionUserId"] = self.model.userShopmember[@"userId"];
    param[@"page"] = @(self.page);
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/selectConcern"];
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"])
        {
            // 字典转模型
            self.dataSource = [CZAttentionDetailModel objectArrayWithKeyValuesArray:result[@"list"]];
            
            [self.tableView reloadData];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:2];
            
            UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 67, SCR_WIDTH, SCR_HEIGHT - 67)];
            noDataView.backgroundColor = [UIColor redColor];
            [self.view addSubview:noDataView];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [CZProgressHUD showProgressHUDWithText:@"网络错误!"];
        [CZProgressHUD hideAfterDelay:2];
    }];
}

// 加载更多
- (void)loadMoreAttentions
{
    self.page++;
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"attentionUserId"] = self.model.userShopmember[@"userId"];
    param[@"page"] = @(self.page);
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/selectConcern"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"list"] count] != 0)
        {
            // 字典转模型
            NSArray *attentions = [CZAttentionDetailModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.dataSource addObjectsFromArray:attentions];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        } else {
            // 显示没有更多数据
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (UIView *)setupHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 250)];
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.frame = CGRectMake(0, 0, SCR_WIDTH, 180);
    [topImage sd_setImageWithURL:[NSURL URLWithString:self.model.userShopmember[@"userNickImg"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    [headerView addSubview:topImage];
    
    // 毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
    HUDView.alpha = 0.5f;
    HUDView.frame = topImage.frame;
    [headerView addSubview:HUDView];
    
   
    
    //返回按钮
    UIButton *leftBtn = [UIButton buttonWithFrame:CGRectMake(10, 30, 50, 50) backImage:@"nav-back" target:self action:@selector(popAction)];
    [headerView addSubview:leftBtn];
    
    //白色视图
    UIView *titleView = [[UIView alloc] init];
    [headerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftBtn.mas_bottom).offset(70);
        make.left.equalTo(headerView).offset(10);
        make.right.equalTo(headerView).offset(-10);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
    }];
    
    UIImage *backshadow = [UIImage imageNamed:@"backshadow.png"];
    UIImage *stretchImage = [backshadow stretchableImageWithLeftCapWidth:backshadow.size.width * 0.5 topCapHeight:backshadow.size.height * 0.5];
    UIImageView *backImage = [[UIImageView alloc] initWithImage:stretchImage];
    [titleView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(titleView);
    }];
    
    //头像
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    iconImage.layer.cornerRadius = 55 / 2.0;
    iconImage.layer.masksToBounds = YES;
    [iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.userShopmember[@"userNickImg"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    [titleView addSubview:iconImage];
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.model.userShopmember[@"userNickName"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:nameLabel];
    //粉丝数
    UILabel *funsNumber = [[UILabel alloc] init];
    funsNumber.text = [NSString stringWithFormat:@"粉丝数:%@", self.model.userShopmember[@"fansCount"]];
    funsNumber.font = [UIFont systemFontOfSize:14];
    funsNumber.textColor = CZGlobalGray;
    [titleView addSubview:funsNumber];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(20);
        make.centerY.equalTo(titleView);
        make.width.height.equalTo(@55);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_top);
        make.left.equalTo(iconImage.mas_right).offset(20);
    }];
    
    [funsNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconImage.mas_bottom);
        make.left.equalTo(iconImage.mas_right).offset(20);
    }];
    
    [titleView layoutIfNeeded];
//    CZAttentionBtn *btn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(titleView.width - 20 - 60, iconImage.y, 60, 24) CommentType:CZAttentionBtnTypeDisable didClickedAction:^(BOOL isSelected){
//        NSLog(@"点击了按钮");
//    }];
    //关注按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"+关注" forState:UIControlStateNormal];
    [btn setTitle:@"已关注" forState:UIControlStateSelected];
    btn.frame = CGRectMake(titleView.width - 20 - 60, iconImage.y, 60, 24);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitleColor:CZGlobalGray forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 13;
    btn.layer.borderColor = [UIColor redColor].CGColor;
//    switch (type) {
//        case CZAttentionBtnTypeFollowed:
//            btn.backgroundColor = CZGlobalLightGray;
//            btn.layer.borderColor = CZGlobalLightGray.CGColor;
//            btn.selected = YES;
//            break;
//        case CZAttentionBtnTypeAttention:
//            btn.backgroundColor = [UIColor whiteColor];
//            btn.layer.borderColor = [UIColor redColor].CGColor;
//            btn.selected = NO;
//            break;
//        default:
//            break;
//    }
    [titleView addSubview:btn];
    return headerView;
}



#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZAttentionDetailModel *model = self.dataSource[indexPath.row];
    if ([model.smallTitle isEqualToString:@"0"]) { // 测评文章
        CZAttentionDetailCell *cell = [CZAttentionDetailCell cellWithTabelView:tableView];
        cell.model = model;
        return cell;
    } else { // 发现
        CZChoicenessCell *cell = [CZChoicenessCell cellwithTableView:tableView];
        cell.attentionModel = model;
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZAttentionDetailModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     CZAttentionDetailModel *model = self.dataSource[indexPath.row];
    if ([model.smallTitle isEqualToString:@"0"]) { // 测评文章
        CZEvaluationChoicenessDetailController *vc = [[CZEvaluationChoicenessDetailController alloc] init];
        vc.detailID = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
    } else { // 发现
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.findgoodsId = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)filterImage:(UIImage *)img blurLevel:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    NSData *imageData = UIImageJPEGRepresentation(img, 1);
    
    CIImage *image = [CIImage imageWithData:imageData];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *bluerImage = [UIImage imageWithCGImage:outImage];
    return bluerImage;
}



@end
