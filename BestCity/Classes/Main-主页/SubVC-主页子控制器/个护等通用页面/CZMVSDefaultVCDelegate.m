//
//  CZMVSDefaultVCDelegate.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMVSDefaultVCDelegate.h"
#import "CZCollectionTypeOneCell.h" // 一行
#import "CZguessWhatYouLikeCell.h" // 横排

#import "CZScollerImageTool.h"
#import "CZSubButton.h"
#import "CZTitlesViewTypeLayout.h"
#import "UIButton+WebCache.h"
#import "CZTaobaoDetailController.h"

// UI
#import "CZCategoryLineLayoutView.h"

#import "CZMainProjectGeneralView.h" // 专题通用界面
#import "CZFreePushTool.h""

@interface CZMVSDefaultVCDelegate ()
/** <#注释#> */
@property (nonatomic, strong) UIView *headerView;
@end

@implementation CZMVSDefaultVCDelegate
- (instancetype)initWithCollectView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        self.layoutType = YES;
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CZMVSDefaultVCDelegate"];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        NSDictionary *dic = self.dataSource[indexPath.item];
        if (self.layoutType == YES) { // 一条
            CZCollectionTypeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZCollectionTypeOneCell" forIndexPath:indexPath];
            cell.dataDic = dic;
            return cell;
        } else { // 块
            CZguessWhatYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessWhatYouLikeCell" forIndexPath:indexPath];
            cell.dataDic = dic;
            return cell;
        }
}

// <UICollectionViewDelegateFlowLayout>
// 头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CZMVSDefaultVCDelegate" forIndexPath:indexPath];
        if (self.categoryList.count > 0) {
            [headerView addSubview:self.headerView];
        }
        return headerView;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.layoutType == YES) { // 一条
        return CGSizeMake(SCR_WIDTH, 140);
    } else { // 块
        return CGSizeMake((SCR_WIDTH - 40) / 2.0, 312);
    }
}


// 头视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.categoryList.count > 0) {
            return CGSizeMake(0, self.headerView.height);
        } else {
            return CGSizeZero;
        }
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   if (self.layoutType == YES) { // 一条
        return UIEdgeInsetsZero;
    } else { // 块
        if (self.dataSource.count == 0) {
            return UIEdgeInsetsZero;
        } else {
            return UIEdgeInsetsMake(10, 15, 10, 15);
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.layoutType == YES) { // 一条
        return 0;
    } else { // 块
        return 10;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
    NSDictionary *param = self.dataSource[indexPath.row];
    CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
    vc.otherGoodsId = param[@"otherGoodsId"];
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];
}


- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.width = SCR_WIDTH;

        CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0)];
        if (self.adList.count > 0) {
            imageView.height = 160;
            // 添加轮播图
            [_headerView addSubview:imageView];
            [imageView setSelectedIndexBlock:^(NSInteger index) {
                NSLog(@"-----%ld", index);

                [CZJIPINStatisticsTool statisticsToolWithID:[NSString stringWithFormat:@"%@.banner.%ld", self.statistics, (index + 1)]];
                NSDictionary *dic = self.adList[index];
                NSDictionary *param = @{
                    @"targetType" : dic[@"type"],
                    @"targetId" : dic[@"objectId"],
                    @"targetTitle" : dic[@"name"],
                };
                [CZFreePushTool bannerPushToVC:param];
            }];

            NSMutableArray *imgs = [NSMutableArray array];
            for (NSDictionary *imgDic in self.adList) {
                [imgs addObject:imgDic[@"img"]];
            }
            imageView.imgList = imgs;
        }

        // 分类的按钮
        NSArray *list = [CZCategoryLineLayoutView categoryItems:self.categoryList setupNameKey:@"categoryName" imageKey:@"img" IdKey:@"categoryId" objectKey:@""];
        CGRect frame = CGRectMake(24, CZGetY(imageView) + 12, SCR_WIDTH - 48, 0);
        CZCategoryLineLayoutView *categoryView = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:list type:0 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
            [CZJIPINStatisticsTool statisticsToolWithID:[NSString stringWithFormat:@"%@.gongge.%ld", self.statistics, (item.index + 1)]];
            CZMainProjectGeneralView *vc = [[CZMainProjectGeneralView alloc] init];
            vc.titleText = item.categoryName;
            vc.category2Id = item.categoryId;
            CURRENTVC(currentVc)
            [currentVc.navigationController pushViewController:vc animated:YES];
        }];
        [_headerView addSubview:categoryView];

        UIView *lineView = [[UIView alloc] init];
        lineView.y = CZGetY(categoryView) + 15;
        lineView.width = SCR_WIDTH;
        lineView.height = 10;
        lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [_headerView addSubview:lineView];

        CZTitlesViewTypeLayout *titleView = [[CZTitlesViewTypeLayout alloc] init];
        titleView.y = CZGetY(lineView);
        titleView.width = SCR_WIDTH;
        titleView.height = 38;
        [titleView setBlcok:^(BOOL isLine, BOOL isAsc, NSInteger index) {
            // orderByType : 0综合，1价格，2返现，3销量
            [self.delegate defaultVCDelegateReload:@{@"orderByType" : @(index), @"asc" : @(isAsc), @"layoutType" : @(isLine)}];
            NSString *str;
            switch (index) {
                case 0:
                {
                    str = @"zh";
                    break;
                }
                case 1:
                {
                    str = @"jg";
                    break;
                }
                case 2:
                {
                    str = @"bt";
                    break;
                }
                case 3:
                {
                    str = @"xl";
                    break;
                }
                default:
                    break;
            }
            [CZJIPINStatisticsTool statisticsToolWithID:[NSString stringWithFormat:@"%@.liebiao.%@", self.statistics, str]];
        }];
        [_headerView addSubview:titleView];

        UIView *line = [[UIView alloc] init];
        line.width = SCR_WIDTH;
        line.height = 1;
        line.y = CZGetY(titleView);
        line.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [_headerView addSubview:line];
        _headerView.height = CZGetY(line);
    }
    return _headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        NSLog(@"------");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CZMainViewControllerHidden" object:nil];
    } else {
        NSLog(@"++++++");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CZMainViewControllerShow" object:nil];
    }
}

@end
