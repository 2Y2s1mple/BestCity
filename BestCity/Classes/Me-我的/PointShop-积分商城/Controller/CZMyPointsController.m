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

@interface CZMyPointsController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *lineView;
/** 积分数 */
@property (nonatomic, weak) IBOutlet UILabel *pointNum;
/** 数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 表单 */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CZMyPointsController
static NSString * const ID = @"myPointCollectionCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取数据
    [self getDataSource];
    
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"极币商城" rightBtnTitle:nil rightBtnAction:nil navigationViewType:nil];
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    
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
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(0);
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/point/getGoodslist"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];
            [self.collectionView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}






@end
