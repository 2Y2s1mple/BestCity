//
//  CZScrollAD.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "GXScrollAD.h"
#import "GXScrollADImageCell.h" // 单独图片
#import "GXScrollADPageControl.h" // 小原点
#import "UIImageView+WebCache.h"

@interface GXScrollAD () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSTimer *timer;
/** <#注释#> */
@property (nonatomic, strong) UICollectionViewCell * (^scrollADCellBlock)(UICollectionView *, NSIndexPath *);
/** <#注释#> */
@property (nonatomic, strong) Class cellClass;



/** <#注释#> */
@property (nonatomic, strong) GXScrollADPageControl *pageContrl;

/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation GXScrollAD
#pragma mark -- xib创建时候使用的
- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - 正常便利构造创建
- (instancetype)initWithFrame:(CGRect)frame dataSourceList:(NSArray *)dataSourceList scrollerConfig:(void (^)(GXScrollAD *maker))configBlock registerCell:(void (^)(UICollectionView *))registerCellBlock scrollADCell:(UICollectionViewCell * (^)(UICollectionView *collectionView, NSIndexPath *indexPath))scrollADCellBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // 记录数据
        self.dataSourceList = dataSourceList;
        if (dataSourceList.count > 1) {
            // 初始化属性
            [self setupProperty];
            // 外面设置属性
            !configBlock ? : configBlock(self);
            // 注册cell
            !registerCellBlock ? : registerCellBlock(self. collectionView);
            self.scrollADCellBlock = scrollADCellBlock;
            [self createUI];
        } else {
            [self singletonImageView];
        }

    }
    return self;
}

#pragma mark - 创建UI
// 创建UI
- (void)createUI
{
    [self addSubview:self.collectionView];
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:100 / 2] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    if (!self.scrollADCellBlock && self.isShowPageView) {
        [self addSubview:self.pageContrl];
    }
    if (self.isAutoScroll == YES) {
        [self timer];
    }
}

- (void)singletonImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataSourceList firstObject]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    [self addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singletonImageViewClicked)];
    [imageView addGestureRecognizer:tap];
}

// 创建页面的小点点
- (GXScrollADPageControl *)pageContrl
{
    if (_pageContrl == nil) {
        CGRect frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
        _pageContrl = [[GXScrollADPageControl alloc] initWithFrame:frame];
//        _pageContrl.backgroundColor = [UIColor redColor];
        _pageContrl.numberOfPages = self.dataSourceList.count;
        // 选中的颜色
        _pageContrl.currentPageIndicatorTintColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
        // 未选中颜色
        _pageContrl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageContrl;
}

// 添加定时器
- (NSTimer *)timer
{
    if (_timer == nil ) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

// 创建collectionView
-(UICollectionView *)collectionView{

    if (!_collectionView ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
        flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = self.scrollDirection;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
//        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.backgroundColor = [UIColor clearColor];
        // 手否可以手滑
        _collectionView.scrollEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        // 滚一个屏
        _collectionView.pagingEnabled = YES;

        // 默认是存图片轮播
        if (!self.scrollADCellBlock) {
            [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXScrollADImageCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZScrollADImageCell"];
        }
    }
    return  _collectionView;
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.scrollADCellBlock) {
        UICollectionViewCell *cell = self.scrollADCellBlock(collectionView, indexPath);
        return cell;
    } else {
        NSString *url = self.dataSourceList[indexPath.item];
        GXScrollADImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZScrollADImageCell" forIndexPath:indexPath];
        cell.imageUrlString = url;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cz_scrollAD:didSelectItemAtIndex:)]) {
        [self.delegate cz_scrollAD:self didSelectItemAtIndex:indexPath.item];
    }
    !self.selectedIndexBlock ? : self.selectedIndexBlock(indexPath.item);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currentPage = (int) (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % self.dataSourceList.count;
}

// 彻底没速度了, 调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(cz_scrollAD:currentItemAtIndex:)]) {
        [self.delegate cz_scrollAD:self currentItemAtIndex:_currentPage];
    }
    !self.currentIndexBlock ? : self.currentIndexBlock(_currentPage);
    [UIView animateWithDuration:0.25 animations:^{
        self.pageContrl.currentPage = self->_currentPage;
    }];
}

// 调用setContentOffset方法才调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(cz_scrollAD:currentItemAtIndex:)]) {
        [self.delegate cz_scrollAD:self currentItemAtIndex:_currentPage];
    }
    !self.currentIndexBlock ? : self.currentIndexBlock(_currentPage);
    [UIView animateWithDuration:0.25 animations:^{
        self.pageContrl.currentPage = self->_currentPage;
    }];
}

// 手碰上就调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

// 手移开就调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoScroll == YES) {
        [self timer];
    }
}



#pragma mark - 事件
// 下一张
- (void)nextPage
{
    if (self.dataSourceList.count > 0) {
        //(1) 获取当前的显示的indexPath.item
        NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
        // 创建当前位置 设置section为50
        NSIndexPath *resetCurrentIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:100 / 2];
        // 无动画形式跑到section为50位置
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            [self.collectionView scrollToItemAtIndexPath:resetCurrentIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        } else {
            [self.collectionView scrollToItemAtIndexPath:resetCurrentIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        }

        //(2) 为播放下一张做准备, item + 1
        NSInteger nextItem = resetCurrentIndexPath.item + 1;
        NSInteger nextSection = resetCurrentIndexPath.section;

        // 判断一下, item如果在当前section的最后一个
        if (nextItem == self.dataSourceList.count) {
            nextItem = 0; // 归零
            nextSection++; // 下一个组
        }

        // 根据参数创建下一张的位置
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];

        // 动画形式就位到section为item + 1位置
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        } else {
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        }
    }
}

// 删除定时器
-(void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

// 单个图片的点击方法
- (void)singletonImageViewClicked
{
    if ([self.delegate respondsToSelector:@selector(cz_scrollAD:didSelectItemAtIndex:)]) {
        [self.delegate cz_scrollAD:self didSelectItemAtIndex:0];
    }
    !self.selectedIndexBlock ? : self.selectedIndexBlock(0);
}

#pragma mark - 初始化属性
- (void)setupProperty
{
    self.isAutoScroll = YES;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.timeInterval = 3.0;
}

#pragma mark - 刷新
- (void)reloadDataSource
{
    [self.collectionView reloadData];
}

#pragma mark -  内存处理
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
