//
//  CZERecommendHeaderView.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZERecommendHeaderView.h"
#import "CZERecommendViewModel.h"
#import "UIImageView+WebCache.h"
// 跳转
#import "CZDChoiceDetailController.h"

@interface CZERecommendHeaderView() <UICollectionViewDataSource, UICollectionViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) CZERecommendViewModel *viewModel;
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collection;
@end

@implementation CZERecommendHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setupProperty];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    [self.collection reloadData];
}

- (void)setupProperty
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(290, 152);
    layout.minimumLineSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, SCR_WIDTH, self.height - 40) collectionViewLayout:layout];
    collection.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self addSubview:collection];
    collection.showsVerticalScrollIndicator = NO;
    collection.showsHorizontalScrollIndicator = NO;
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CZERecommendHeaderView"];
    self.collection = collection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZERecommendHeaderView" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 6;
    cell.contentView.layer.masksToBounds = YES;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.size = CGSizeMake(290, 152);
    [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    [cell.contentView addSubview:imageView];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //类型：0不跳转，1商品详情，2发现详情 3评测详情, 4试用 5评测类目，7清单详情
    NSDictionary *dic = self.dataList[indexPath.row];
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = [CZJIPINSynthesisTool getModuleType:[dic[@"type"] integerValue]];
    vc.findgoodsId = dic[@"objectId"];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
