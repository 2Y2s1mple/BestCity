//
//  CZMyPointsController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMyPointsController.h"
#import "CZNavigationView.h"
#import "CZMyPointsCell.h"
#import "GXNetTool.h"
#import "CZMyPointsDetailController.h"
#import "CZOrderController.h"
#import "CZOrderListHeaderView.h"

@interface CZMyPointsController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *lineView;
/** 积分数 */
@property (nonatomic, weak) IBOutlet UILabel *pointNum;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 表单 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZMyPointsController
static NSString * const ID = @"myPointCollectionCell";

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"极币商城" rightBtnTitle:@"兑换记录" rightBtnAction:^{
        CZOrderController *vc = [[CZOrderController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } ];
    [self.view addSubview:navigationView];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCR_WIDTH - 48) / 2, 180);
    layout.minimumInteritemSpacing = 20;
    //    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(18, 14, 10, 14);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 24 : 0) - 67.7) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;

    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZMyPointsCell class]) bundle:nil] forCellWithReuseIdentifier:ID];

    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CZMVSDefaultVCDelegate"];

    // 获取数据
    [self setupRefresh];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CZMyPointsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.dicData = self.dataSource[indexPath.row];
    return cell;
}

// 头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CZMVSDefaultVCDelegate" forIndexPath:indexPath];
        [headerView addSubview:[CZOrderListHeaderView orderListHeaderView]];
        return headerView;
    } else {
        return nil;
    }
}

// 头视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 167);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CZMyPointsDetailController *vc = [[CZMyPointsDetailController alloc] init];
    vc.pointId = self.dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCR_WIDTH - 48) / 2, (SCR_WIDTH - 48) / 2 + 62);
}

#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    self.page = 1;
    [self.collectionView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/point/getGoodslist"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = [NSMutableArray arrayWithArray:result[@"data"]];
            [self.collectionView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.collectionView.mj_header endRefreshing];
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/point/getGoodslist"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *data = result[@"data"];
            [self.dataSource addObjectsFromArray:data];
            [self.collectionView reloadData];
        }
        
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}


#pragma mark - 获取数据
- (void)setupRefresh
{
    self.collectionView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.collectionView.mj_header beginRefreshing];
    self.collectionView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}




@end

