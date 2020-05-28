//
//  CZFestivalCollectDataSource.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectDelegate.h"

#import "CZFestivalCollectHeaderView.h"

#import "CZFestivalCollectOneCell.h" // 新人0元购
#import "CZFestivalCollectTwoCell.h" // 热销
#import "CZFestivalCollectThreeCell.h" // 按钮
#import "CZCollectionTypeOneCell.h" // 一行
#import "CZguessWhatYouLikeCell.h" // 横排
#import "CZTaobaoDetailController.h"
#import "CZFestivalCollectOneSubCell.h"

@implementation CZFestivalCollectDelegate
static NSString *ID = @"CZFestivalCollectCell";
static NSString *HeaderId = @"CZFestivalCollectheader";
static NSString *oneId = @"CZFestivalCollectOneCell";
static NSString *twoId = @"CZFestivalCollectTwoCell";
static NSString *threeId = @"CZFestivalCollectThreeCell";

- (instancetype)initWithCollectView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];

        [collectionView registerClass:[CZFestivalCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderId];

        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZFestivalCollectOneCell class]) bundle:nil] forCellWithReuseIdentifier:oneId];
        
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZFestivalCollectOneSubCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZFestivalCollectOneSubCell"];
        
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZFestivalCollectTwoCell class]) bundle:nil] forCellWithReuseIdentifier:twoId];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZFestivalCollectThreeCell class]) bundle:nil] forCellWithReuseIdentifier:threeId];

        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZCollectionTypeOneCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZCollectionTypeOneCell"]; // 一行
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessWhatYouLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessWhatYouLikeCell"]; // 两行
        

        collectionView.dataSource = self;
        collectionView.delegate = self;
    }
    return self;
}

// <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 4) {
        return self.qualityGoods.count;
    } else {
        return 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 新人0元购
        CZFestivalCollectOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneId forIndexPath:indexPath];
        cell.model = self.totalDataModel;
        cell.messageList = self.totalDataModel.messageList;
        cell.newUser = self.totalDataModel.newUser;
        cell.allowanceGoodsList = self.totalDataModel.allowanceGoodsList;

        return cell;
    } else if (indexPath.section == 1) { // 半圆广告
        CZFestivalCollectOneSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZFestivalCollectOneSubCell" forIndexPath:indexPath];
        cell.model = self.totalDataModel;
        return cell;
    } else if (indexPath.section == 2) { // 热销榜单
        CZFestivalCollectTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:twoId forIndexPath:indexPath];
        cell.hotGoodsList = self.totalDataModel.hotGoodsList;
        return cell;
    } else if (indexPath.section == 3) { // 按钮
           CZFestivalCollectThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:threeId forIndexPath:indexPath];
           return cell;
    } else if (indexPath.section == 4) { // 做过了 横排
        NSDictionary *dic = self.qualityGoods[indexPath.item];
        CZCollectionTypeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZCollectionTypeOneCell" forIndexPath:indexPath];
        cell.dataDic = dic;
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.backgroundColor = RANDOMCOLOR;
        return cell;
    }
}

// <UICollectionViewDelegateFlowLayout>
// 头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CZFestivalCollectHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderId forIndexPath:indexPath];
        headerView.boxList = self.totalDataModel.boxList;
        headerView.ad1List = self.totalDataModel.ad1List;
        return headerView;
    } else {
        return nil;
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        
    } else {

    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 新人0元购
        if (self.totalDataModel.newUser == NO) {
            return CGSizeMake(SCR_WIDTH,  327 - 24 + 10);
        } else {
            return CGSizeMake(SCR_WIDTH,  327 + 10);
        }
    } else if (indexPath.section == 1) { // 图片
        NSInteger count = self.totalDataModel.activityList.count;
        count = (count + 1) / 2;
        CGFloat height = 10 + count * (10 + 80) + 10;
        return CGSizeMake(SCR_WIDTH, height);
    } else if (indexPath.section == 2) {
        return CGSizeMake(SCR_WIDTH, 270);
    } else if (indexPath.section == 3) {
        return CGSizeMake(SCR_WIDTH, 100);
    } else if (indexPath.section == 4) {
        return CGSizeMake(SCR_WIDTH, 140);
    } else {
        return CGSizeZero;
    }
}

// 头视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, 270 + 80);
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        NSDictionary *param = self.qualityGoods[indexPath.item];
        // 商品来源(1京东,2淘宝，4拼多多)
        [CZFreePushTool push_tabbaokeDetailWithId:param[@"otherGoodsId"] title:@"" source:[NSString stringWithFormat:@"%@", param[@"source"]]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        NSLog(@"------");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CZMainViewControllerHidden" object:nil];
        self.iconImageView.hidden = YES;
    } else {
        NSLog(@"++++++");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CZMainViewControllerShow" object:nil];
        self.iconImageView.hidden = NO;
    }
}


@end
