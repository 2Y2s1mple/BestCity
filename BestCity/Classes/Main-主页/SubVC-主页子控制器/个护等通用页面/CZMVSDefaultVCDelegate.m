//
//  CZMVSDefaultVCDelegate.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMVSDefaultVCDelegate.h"
#import "CZguessLineCell.h" // 一行
#import "CZguessWhatYouLikeCell.h" // 横排

#import "CZScollerImageTool.h"
#import "CZSubButton.h"
#import "CZTitlesViewTypeLayout.h"
#import "UIButton+WebCache.h"

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

        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessLineCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessLineCell"]; // 一行
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
            CZguessLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessLineCell" forIndexPath:indexPath];
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
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CZMVSDefaultVCDelegate" forIndexPath:indexPath];
        if (self.categoryList.count > 0) {
            if (self.headerView == nil) {
                self.headerView = [self createHeaderTableView];
            }
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
        return CGSizeMake(SCR_WIDTH, 150);
    } else { // 块
        return CGSizeMake((SCR_WIDTH - 40) / 2.0, 312);
    }
}


// 头视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, self.headerView.height);
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



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
}


- (UIView *)createHeaderTableView
{
    UIView *headerView = [[UIView alloc] init];
    // 添加轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 160)];
    [headerView addSubview:imageView];
    [imageView setSelectedIndexBlock:^(NSInteger index) {

    }];

    NSMutableArray *imgs = [NSMutableArray array];
    for (NSDictionary *imgDic in self.adList) {
        [imgs addObject:imgDic[@"img"]];
    }
    imageView.imgList = imgs;
    [headerView addSubview:imageView];

    // 分类的按钮
    UIView *categoryView = [[UIView alloc] init];
    categoryView.frame = CGRectMake(0, CZGetY(imageView), SCR_WIDTH, 0);
    [headerView addSubview:categoryView];

    CGFloat width = 50;
    CGFloat height = width + 30;
    CGFloat leftSpace = 24;
    NSInteger cols = 5;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    NSInteger count = self.categoryList.count;
    for (int i = 0; i < count; i++) {
        NSInteger col = i % cols;
        NSInteger row = i / cols;

        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = width;
        btn.height = height;
        btn.categoryId = self.categoryList[i][@"categoryId"];
        btn.x = leftSpace + col * (width + space) + (i / 10) * SCR_WIDTH;
        btn.y = 12 + row * (height + 25);
        [btn sd_setImageWithURL:[NSURL URLWithString:self.categoryList[i][@"img"]] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [btn setTitle:self.categoryList[i][@"categoryName"] forState:UIControlStateNormal];
        [categoryView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        categoryView.height = CZGetY(btn);
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.y = CZGetY(categoryView) + 15;
    lineView.width = SCR_WIDTH;
    lineView.height = 10;
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [headerView addSubview:lineView];


    CZTitlesViewTypeLayout *titleView = [[CZTitlesViewTypeLayout alloc] init];
    titleView.y = CZGetY(lineView);
    titleView.width = SCR_WIDTH;
    titleView.height = 38;
    [titleView setBlcok:^(BOOL isLine, BOOL isAsc, NSInteger index) {
        // orderByType : 0综合，1价格，2补贴，3销量

    }];

    [headerView addSubview:titleView];

    headerView.height = CZGetY(titleView);
    return headerView;
}

@end
