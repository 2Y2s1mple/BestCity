//
//  CZCategoryLineLayoutView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCategoryLineLayoutView.h"
#import "UIButton+WebCache.h"


@implementation CZCategoryItem
@end

@implementation CZCategoryButton
- (void)setup
{
    [self setAdjustsImageWhenHighlighted:NO];
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
/** <#注释#> */
@property (nonatomic, strong) id recordElement;

@end

@implementation CZCategoryLineLayoutView

+ (NSArray *)categoryItems:(NSArray *)items setupNameKey:(NSString *)NameKey imageKey:(NSString *)imageKey IdKey:(NSString *)IdKey objectKey:(NSString *)objectKey
{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in items) {

        if (![dic isKindOfClass:[NSDictionary class]]) {
            CZCategoryItem *item = [[CZCategoryItem alloc] init];
            item.categoryName = (NSString *)dic;
            [list addObject:item];
        } else {
            CZCategoryItem *item = [[CZCategoryItem alloc] init];
            item.categoryName = dic[NameKey];
            item.categoryId = dic[IdKey];
            item.categoryImage = dic[imageKey];
            item.objectInfo = dic[objectKey];
            [list addObject:item];
        }
    }
    return list;
}


+ (instancetype)categoryLineLayoutViewWithFrame:(CGRect)frame Items:(NSArray <CZCategoryItem *> *)items type:(CZCategoryLineLayoutViewType)type didClickedIndex:(void (^)(CZCategoryItem *item))block
{
    CZCategoryLineLayoutView *view = [[CZCategoryLineLayoutView alloc] initWithFrame:frame];
    view.block = block;
    view.categoryItems = items;
    if (type == CZCategoryLineLayoutViewTypeVertical) {
        [view createVerticalView];
    } else if (type == CZCategoryLineLayoutViewTypeLine) {
        [view createLineTitle];
    } else if (type == CZCategoryLineLayoutViewTypeDefault) {
        [view createDefaultView:1];
    }
    return view;
}

#pragma mark - 样式1
- (void)createVerticalView
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
        btn.y = rowIndex * (height + 10);
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
    self.categoryItem.index = sender.tag;
    !self.block ? : self.block(self.categoryItem);
}


#pragma mark - 样式2 - 创建所有按钮在一条线上
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
    CGFloat itemWidth = SCR_WIDTH / cols;
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

//        CGFloat contentWidth = self.width * ((count + (cols - 1)) / cols);
//        CGFloat contentWidth = self.width * 2;
        // itemWidth 四舍五入
        CGFloat contentWidth = (int)(itemWidth + 0.5) * (i + 1);
        categoryView.contentSize = (CGSizeMake(contentWidth, 0));
    }
    self.height = CZGetY(categoryView) + 10;

    if (count > cols) {
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat itemWidth = SCR_WIDTH / 4;
    NSInteger index = scrollView.contentOffset.x / itemWidth;
    NSLog(@"%ld", (long)index);
    [UIView animateWithDuration:0.25 animations:^{
        if (index == 0) {
            self.minline.transform = CGAffineTransformIdentity;
        } else {
            self.minline.transform = CGAffineTransformMakeTranslation(self.minline.width, 0);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        self.minline.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 正常排一排的
- (void)createDefaultView:(NSInteger)type
{
    if (self.height == 0) {
        [CZProgressHUD showProgressHUDWithText:@" 样式4高度等于0!!!!!"];
        [CZProgressHUD hideAfterDelay:1.5];
    }

    UIScrollView *backView = [[UIScrollView alloc] init];
    backView.showsHorizontalScrollIndicator = NO;
    backView.height = self.height;
    backView.width = SCR_WIDTH;
    [self addSubview:backView];

    NSInteger count = self.categoryItems.count;
    CGFloat space = 20;
    CGFloat btnX = 15;
    for (int i = 0; i < count; i++) {
        CZCategoryItem *item = self.categoryItems[i];
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setTitle:item.categoryName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        [btn setTitleColor:UIColorFromRGB(0x565252) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateSelected];
        [btn sizeToFit];
        btn.height = 25;
        btn.centerY = backView.height / 2.0;
        btn.x = btnX;
        [backView addSubview:btn];
//        [self.saveBtns addObject:btn];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        btn.width += 16;
        btnX += (space + btn.width);
        btn.layer.cornerRadius = 3;
        [btn addTarget:self action:@selector(viewTypeFourAction:) forControlEvents:UIControlEventTouchUpInside];
        if (type == 1) {
            btn.backgroundColor = [UIColor whiteColor];
        }

        backView.contentSize = CGSizeMake(btnX, 0);

        if (i == item.selecedIndex) {
            btn.selected = YES;
            self.recordElement = btn;
        }
    }
}

- (void)viewTypeFourAction:(UIButton *)sender
{
    if (self.recordElement == sender) {
        return;
    }

    // 设置选中
    sender.selected = YES;

    // 还原选中
    UIButton *recordElement = self.recordElement;
    recordElement.selected = NO;

    self.categoryItem = self.categoryItems[sender.tag];
    !self.block ? : self.block(self.categoryItem);

    self.recordElement = sender;
}





@end
