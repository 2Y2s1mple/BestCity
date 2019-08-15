//
//  CZMHSDCommodityCell2.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDCommodityCell2.h"
#import "CZMHSDCell2CollectionCell.h"
// 跳转
#import "CZRecommendDetailController.h"

@interface CZMHSDCommodityCell2 () <UICollectionViewDelegate, UICollectionViewDataSource>
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionArr;
@end

@implementation CZMHSDCommodityCell2
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZMHSDCommodityCell2";
    CZMHSDCommodityCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.titleLabel.text = dataDic[@"name"];
    self.collectionArr = dataDic[@"goodsList"];
    [self.collectionView reloadData];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 19];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZMHSDCell2CollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZMHSDCell2CollectionCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CZMHSDCell2CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZMHSDCell2CollectionCell" forIndexPath:indexPath];
    cell.dataDic = self.collectionArr[indexPath.item];
    cell.indexNumber = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.collectionArr[indexPath.item];;
    CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
    vc.goodsId = model[@"goodsId"];

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *navVc = nav.topViewController;
    [navVc.navigationController pushViewController:vc animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
