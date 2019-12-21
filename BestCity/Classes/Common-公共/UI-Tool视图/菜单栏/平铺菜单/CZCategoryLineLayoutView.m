//
//  CZCategoryLineLayoutView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCategoryLineLayoutView.h"
#import "UIButton+WebCache.h"
#import "GXNetTool.h"

@implementation CZCategoryItem
@end

@implementation CZCategoryButton
- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;

    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + 10;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width / 2.0;
}

@end

@interface CZCategoryLineLayoutView () <UIScrollViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) void (^block)(CZCategoryItem *);
/** 指示器 */
@property (nonatomic, strong) UIView *minline;
@end

@implementation CZCategoryLineLayoutView

+ (NSArray *)categoryItems:(NSArray *)items setupNameKey:(NSString *)NameKey imageKey:(NSString *)imageKey IdKey:(NSString *)IdKey objectKey:(NSString *)objectKey
{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in items) {
        if (![dic isKindOfClass:[NSDictionary class]]) return @[];
        CZCategoryItem *item = [[CZCategoryItem alloc] init];
        item.categoryName = dic[NameKey];
        item.categoryId = dic[IdKey];
        item.categoryImage = dic[imageKey];
        item.objectInfo = dic[objectKey];
        [list addObject:item];
    }
    return list;
}


+ (instancetype)categoryLineLayoutViewWithFrame:(CGRect)frame Items:(NSArray <CZCategoryItem *> *)items type:(NSInteger)type didClickedIndex:(void (^)(CZCategoryItem *item))block
{
    CZCategoryLineLayoutView *view = [[CZCategoryLineLayoutView alloc] initWithFrame:frame];
    view.block = block;
    view.categoryItems = items;
    if (type == 0) {
        [view createView];
    } else {
        [view createLineTitle];
    }
    return view;
}


- (void)createView
{
    CGFloat width = 50;
    CGFloat height = width + 30;
    NSInteger cols = 5;
    CGFloat space = (self.width - cols * width) / (cols - 1);
    NSInteger count = self.categoryItems.count;

    for (int i = 0; i < count; i++) {
        NSInteger colIndex = i % cols;
        NSInteger rowIndex = i / cols;
        CZCategoryItem *item = self.categoryItems[i];
        // 创建按钮
        CZCategoryButton *btn = [CZCategoryButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.width = width;
        btn.height = height;
        btn.x = colIndex * (width + space);
        btn.y = rowIndex * (height + 25);
        [btn sd_setImageWithURL:[NSURL URLWithString:item.categoryImage] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [btn setTitle:item.categoryName forState:UIControlStateNormal];
        [self addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(categoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.height = CZGetY(btn);
        if (i == 0) {
            self.categoryItem = item;
        }
    }
}

- (void)categoryButtonAction:(CZCategoryButton *)sender
{
    self.categoryItem = self.categoryItems[sender.tag];
    !self.block ? : self.block(self.categoryItem);
}


#pragma mark - 创建所有按钮在一条线上
- (void)createLineTitle
{
    UIScrollView *categoryView = [[UIScrollView alloc] init];
    categoryView.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:categoryView];
    categoryView.pagingEnabled = YES;
    categoryView.showsHorizontalScrollIndicator = NO;
    categoryView.delegate = self;

    CGFloat width = 45;
    CGFloat height = width + 25;
    CGFloat leftSpace = 24;
    NSInteger cols = 4;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    NSInteger count = self.categoryItems.count;
    for (int i = 0; i < count; i++) {
        CZCategoryItem *item = self.categoryItems[i];
        // 创建按钮
        CZCategoryButton *btn = [CZCategoryButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.width = width;
        btn.height = height;
        btn.x = leftSpace + i * (width + space);
        [btn sd_setImageWithURL:[NSURL URLWithString:item.categoryImage] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [btn setTitle:item.categoryName forState:UIControlStateNormal];
        [categoryView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(categoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        categoryView.height = CZGetY(btn);

        CGFloat contentWith = self.width * (count + (cols - 1) / cols);
        categoryView.contentSize = (CGSizeMake(contentWith, 0));
    }


    // 指示器
    UIView *redLine = [[UIView alloc] init];
    [self addSubview:redLine];
    redLine.tag = 100;
    redLine.width = 50;
    redLine.height = 3;
    redLine.layer.cornerRadius = 1.5;
    redLine.layer.masksToBounds = YES;
    redLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
    redLine.centerX = self.width / 2.0;
    redLine.y = self.height - redLine.height;

    UIView *minline = [[UIView alloc] init];
    self.minline = minline;
    minline.width = redLine.width / 2.0;
    minline.height = redLine.height;
    minline.layer.cornerRadius = 1.5;
    minline.layer.masksToBounds = YES;
    [redLine addSubview:minline];
    minline.backgroundColor = UIColorFromRGB(0xE25838);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index =  scrollView.contentOffset.x / SCR_WIDTH;
    NSLog(@"%ld", index);
    [UIView animateWithDuration:0.25 animations:^{
        if (index == 0) {
            self.minline.transform = CGAffineTransformIdentity;
        } else {
            self.minline.transform = CGAffineTransformMakeTranslation(self.minline.width, 0);
        }
    }];
}




@end
