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

@interface CZMyPointsController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *lineView;
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
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZMyPointsCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CZMyPointsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = RANDOMCOLOR;
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CZOneDetailController *vc = [[CZOneDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}







@end
