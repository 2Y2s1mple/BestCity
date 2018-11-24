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
#import "CZOneDetailController.h"//榜单的详情页面
#import "CZMyPointDetailController.h"
#import "TSLWebViewController.h"
#import "GXNetTool.h"
#import "CZUserInfoTool.h"

@interface CZMyPointsController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *lineView;
/** 积分数 */
@property (nonatomic, weak) IBOutlet UILabel *pointNum;
/** 数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 表单 */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CZMyPointsController
#pragma mark - 跳转到积分明细
- (IBAction)pushPointDetail:(id)sender {
    NSLog(@"%s", __func__);
    CZMyPointDetailController *vc = [[CZMyPointDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

static NSString * const ID = @"myPointCollectionCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {
        NSString *point = [[NSUserDefaults standardUserDefaults] objectForKey:@"point"];
        self.pointNum.text = [NSString stringWithFormat:@"%@", point];
    }];
    // 积分
    
    
    // 获取数据
    [self getDataSource];
    
    self.view.backgroundColor = CZGlobalLightGray;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"我的积分" rightBtnTitle:@"积分规则" rightBtnAction:^{
        TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:POINTSRULE_URL]];
        webVc.titleName = @"积分规则";
        [self.navigationController pushViewController:webVc animated:YES];
    } navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCR_WIDTH - 30) / 2, 260);
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CZGetY(self.lineView), SCR_WIDTH, SCR_HEIGHT - CZGetY(self.lineView)) collectionViewLayout:layout];
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
    CZOneDetailController *vc = [[CZOneDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(0);
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/goodsPoint/selectList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"list"];
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
