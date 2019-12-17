//
//  PlanADScrollView.m
//  PlanADScrollView
//
//  Created by anan on 2017/10/18.
//  Copyright © 2017年 Plan. All rights reserved.
//

#import "PlanADScrollView.h"
#import "PlanADCollectionViewCell.h"

#import "PlanPageControl.h"
#define PlanSections 100

@interface PlanADScrollView()<UICollectionViewDataSource, UICollectionViewDelegate>
/**
 图片地址数组
 */
@property (nonatomic,copy) NSArray *imageUrls;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) PlanPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIImage *placeholderimage;
@end

@implementation PlanADScrollView

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

/**
 imageUrls         网络请求的图片url
 placeholderimage  占位图片
 
 */
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls placeholderimage:(UIImage*)placeholderimage
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatrUIImageUrls:imageUrls placeholderimage:placeholderimage];
    }
    return self;
}

- (void)creatrUIImageUrls:(NSArray *)imageUrls placeholderimage:(UIImage*)placeholderimage
{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self addTimer];
    
    self.imageUrls = imageUrls;
    self.pageControl.numberOfPages = imageUrls.count;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:PlanSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    self.placeholderimage = placeholderimage;
}

#pragma mark 添加定时器
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


#pragma mark 删除定时器
-(void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)nextpage {

    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:100/2];
    
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.imageUrls.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return PlanSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlanADCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlanADCell" forIndexPath:indexPath];
    
    [cell  imageStr:self.imageUrls[indexPath.row] placeholderimage:self.placeholderimage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.delegate respondsToSelector:@selector(PlanADScrollViewdidSelectAtIndex:)]){
        
        [self.delegate PlanADScrollViewdidSelectAtIndex:indexPath.row];
    }
}

// 手碰上就调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

// 手移开就调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

#pragma mark 设置页码
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.imageUrls.count;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.delegate PlanADScrollViewCurrentAtIndex:self.pageControl.currentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.pageControl.currentPage) {
        [self.delegate PlanADScrollViewCurrentAtIndex:self.pageControl.currentPage];
        NSLog(@"%s", __func__);
    }
}

-(NSString *)controllerTitle{
    return @"无限轮播";
}

#pragma mark - 懒加载
-(UICollectionView *)collectionView{
    
    if (!_collectionView ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
        flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[PlanADCollectionViewCell class] forCellWithReuseIdentifier:@"PlanADCell"];
        
    }
    return  _collectionView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[PlanPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5, self.frame.size.height-30, self.frame.size.width*0.5, 20)];
        _pageControl.pageIndicatorTintColor = CZGlobalLightGray;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.enabled = NO;
        _pageControl.pointSize = CGSizeMake(8, 8);
        
    }
    return _pageControl;
}



@end
