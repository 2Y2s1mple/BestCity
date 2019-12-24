//
//  CZScrollAD.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZScrollAD.h"
#import "CZScrollADCell.h"
#import "CZScrollADCell1.h"

@interface CZScrollAD () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CZScrollAD

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        NSLog(@"%@", self);
        [self creatrUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"%@", self);

}



- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF5F5F5);
        self.type = type;
        self.dataSource = dataSource;
        [self creatrUI];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (NSTimer *)timer
{
    if (_timer == nil ) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)nextpage
{
    if (self.dataSource.count > 0) {
        // 获取当前的indexPath.item
        NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];

        NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:100/2];

        [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionTop animated:NO];

        NSInteger nextItem = currentIndexPathReset.item + 1;
        NSInteger nextSection = currentIndexPathReset.section;
        if (nextItem == self.dataSource.count) {
            nextItem = 0;
            nextSection++;
        }
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];

        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

- (void)creatrUI
{
    [self addSubview:self.collectionView];
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:100 / 2] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

    [self.timer fire];
}

-(UICollectionView *)collectionView{

    if (!_collectionView ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
        flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;

        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZScrollADCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZScrollADCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZScrollADCell1 class]) bundle:nil] forCellWithReuseIdentifier:@"CZScrollADCell1"];
    }
    return  _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *model = self.dataSource[indexPath.item];
    if (self.type == 0) {
        CZScrollADCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZScrollADCell" forIndexPath:indexPath];
        cell.paramDic = model;
        return cell;
    } else {
        CZScrollADCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZScrollADCell1" forIndexPath:indexPath];
        cell.paramDic = model;
        return cell;
    }
}
@end
