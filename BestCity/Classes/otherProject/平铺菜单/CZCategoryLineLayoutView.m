//
//  CZCategoryLineLayoutView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCategoryLineLayoutView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "GXCategoryPageControl.h"



@implementation CZCategoryItem
@end

@implementation CZCategoryButton

+ (instancetype)buttonWithItem:(CZCategoryItem *)item tag:(NSInteger)tag target:(nullable id)target andAction:(SEL)action
{
    // 创建按钮
    CZCategoryButton *btn = [CZCategoryButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    
    // 设置文字
    [btn setTitle:item.categoryName forState:UIControlStateNormal];
    
    // 设置图片
    [btn sd_setImageWithURL:[NSURL URLWithString:item.categoryImage] forState:UIControlStateNormal];
    
    // 点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

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
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollerConentView;
/** 指示器 */
@property (nonatomic, strong) GXCategoryPageControl *indicatorView;
//@property (nonatomic, strong) UIView *minline;
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
    } else if (type == CZCategoryLineLayoutViewTypeTwoLine) {
        [view createTwoLine];
    } else if (type == CZCategoryLineLayoutViewTypeDefault2) {
        [view createDefault2View];
    }
    return view;
}


#pragma mark - 创建小组件component, module, element
// 创建scrollerView
- (UIScrollView *)scrollerConentView
{
    if (_scrollerConentView == nil) {
        _scrollerConentView = [[UIScrollView alloc] init];
        _scrollerConentView.frame = CGRectMake(0, 0, self.width, self.height);
        _scrollerConentView.pagingEnabled = YES;
        _scrollerConentView.showsHorizontalScrollIndicator = NO;
        _scrollerConentView.delegate = self;
    }
    return _scrollerConentView;;
}
// 指示器
- (GXCategoryPageControl *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[GXCategoryPageControl alloc] init];
        _indicatorView.width = 50;
        _indicatorView.height = 3;
        _indicatorView.centerX = self.width / 2.0;
        _indicatorView.y = self.height - 3;
        
        _indicatorView.numberOfPages = 2;
        _indicatorView.pageIndicatorTintColor = UIColorFromRGB(0xD8D8D8);
        _indicatorView.currentPageIndicatorTintColor = UIColorFromRGB(0xE25838);
        _indicatorView.layer.cornerRadius = 1.5;
        _indicatorView.layer.masksToBounds = YES;
    }
    return _indicatorView;
}

// 创建上下排布的按钮
- (UIView *)createBtnView:(CGSize)size img:(id)img text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    UIView *btnView = [[UIView alloc] init];
        btnView.size = size;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.size = CGSizeMake(btnView.width, btnView.width);
        if ([img isKindOfClass:[UIImage class]]) {
            imageView.image = img;
        } else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:img]];
        }
        [btnView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor;
        label.font = font;
        label.text = text;
        [label sizeToFit];
        label.y = btnView.height - label.height;
        label.centerX = btnView.width / 2.0;
        [btnView addSubview:label];
    
    return btnView;
}

// 单独创建一排按钮
- (UIView *)createBtnViewsWithData:(NSArray <CZCategoryItem *> *)data cols:(NSInteger)cols contentSize:(CGSize)contentSize itemWidth:(CGFloat)itemWidth textColor:(UIColor *)textColor font:(UIFont *)font
{
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    CGFloat space = (contentSize.width - cols * itemWidth) / (cols - 1);
    for (int i = 0; i < cols; i++) {
        CZCategoryItem *item = data[i];
        UIView *btnView = [self createBtnView:CGSizeMake(itemWidth, contentSize.height) img:item.categoryImage text:item.categoryName textColor:textColor font:font];
        btnView.x = i * (itemWidth + space);
        [content addSubview:btnView];
    }
    return content;
}

#pragma mark - 一直往下排布
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
        CZCategoryButton *btn = [CZCategoryButton buttonWithItem:item tag:i target:self andAction:@selector(categoryButtonAction:)];
        btn.width = width;
        btn.height = height;
        btn.x = colIndex * (width + space);
        btn.y = rowIndex * (height + 10);
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [self addSubview:btn];
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

#pragma mark - 横向排布, 带指示器(一排)
- (void)createLineTitle
{
    [self addSubview:self.scrollerConentView];

    CGFloat width = 45;
    CGFloat height = width + 25;
    CGFloat leftSpace = 24;
    NSInteger cols = 4;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    CGFloat itemWidth = SCR_WIDTH / cols;
    NSInteger count = self.categoryItems.count;
    NSInteger page = (count + (cols * 2  - 1)) / (cols * 2);;
    for (int i = 0; i < count; i++) {
        CZCategoryItem *item = self.categoryItems[i];
        // 创建按钮
        CZCategoryButton *btn = [CZCategoryButton buttonWithItem:item tag:i target:self andAction:@selector(categoryButtonAction:)];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        btn.width = width;
        btn.height = height;
        btn.x = leftSpace + i * (width + space);
        [self.scrollerConentView addSubview:btn];
        
        self.scrollerConentView.height = CZGetY(btn);
        // itemWidth 四舍五入
        CGFloat contentWidth = (int)(itemWidth + 0.5) * (i + 1);
        self.scrollerConentView.contentSize = (CGSizeMake(contentWidth, 0));
    }
    self.height = CZGetY(self.scrollerConentView) + 10;

    if (page > 1) {
        // 指示器
        [self addSubview:self.indicatorView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / 40;
    NSLog(@"%ld", (long)index);
    self.indicatorView.currentPage = index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        self.indicatorView.currentPage = 0;
    }
}

#pragma mark - 横向排布, 带指示器(两排)
- (CGRect)createFrameWithindex:(NSInteger)i
{
    CGRect rect;
    
    CGFloat width = 45;
    CGFloat height = width + 25;
    CGFloat leftSpace = 20;
    NSInteger cols = 5;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - cols * width) / (cols - 1);
    
    rect.size.width = width;
    rect.size.height = height;
    
    if (i % 2 == 0) { // 第一排
        NSInteger col = i / 2;
        NSInteger row = i % 2;
        rect.origin.x = leftSpace + col * (width + space);
        rect.origin.y = row * (height + 15);
    } else { // 第二排
        NSInteger col = (i - 1) / 2;
        NSInteger row = i % 2;
        rect.origin.x = leftSpace + col * (width + space);
        rect.origin.y = row * (height + 15);
    }
    return rect;
}

- (void)createTwoLine
{
    [self addSubview:self.scrollerConentView];
    
    for (int i = 0; i < self.categoryItems.count; i++) {
        CZCategoryItem *item = self.categoryItems[i];
        
        // 创建按钮
        CZCategoryButton *btn = [CZCategoryButton buttonWithItem:item tag:i target:self andAction:@selector(categoryButtonAction:)];
        [btn setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        btn.frame = [self createFrameWithindex:i];
        [self.scrollerConentView addSubview:btn];

        // 计算scroller尺寸 itemWidth 四舍五入
        CGFloat contentWidth = (int)(CZGetX(btn) + 0.5);
        self.scrollerConentView.contentSize = (CGSizeMake(contentWidth + 20, 0));

        if (i > 1) {
            self.scrollerConentView.height = btn.height * 2 + 25;
        } else {
            self.scrollerConentView.height = (CZGetY(btn));
        }
    }

    self.height = CZGetY(self.scrollerConentView) + 10;
    NSInteger count = self.categoryItems.count;
    NSInteger cols = 5;
    NSInteger page = (count + (cols * 2  - 1)) / (cols * 2);
    if (page > 1) {
        // 指示器
        [self addSubview:self.indicatorView];
    }
}

#pragma mark - 普通排一排的
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


#pragma mark - 普通排一排, 带指示器
- (void)createDefault2View
{
    [self addSubview:self.scrollerConentView];
    
    NSInteger count = self.categoryItems.count;
    CGFloat space = 20;
    CGFloat btnX = 15;
    
    for (int i = 0; i < count; i++) {
        CZCategoryItem *item = self.categoryItems[i];
        UIButton *btn = [[UIButton alloc] init];
//        btn.backgroundColor = RANDOMCOLOR;
        btn.tag = i + 100;
        [btn setTitle:item.categoryName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        [btn setTitleColor:UIColorFromRGB(0x040404) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateSelected];
        [btn sizeToFit];
        btn.centerY = self.scrollerConentView.height / 2.0;
        btn.x = btnX;
        [self.scrollerConentView addSubview:btn];
        btnX += (space + btn.width);
        [btn addTarget:self action:@selector(createDefault2Action:) forControlEvents:UIControlEventTouchUpInside];

        UIView *view = [[UIView alloc] init];
        view.tag = i + 200;
        view.x = btn.x;
        view.y = CZGetY(btn);
        view.width = btn.width;
        view.height = 3;
        view.backgroundColor = UIColorFromRGB(0xE25838);
        view.layer.cornerRadius = 2;
        [self.scrollerConentView addSubview:view];
        view.hidden = YES;

//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(view), SCR_WIDTH, 1)];
//        line.backgroundColor = UIColorFromRGB(0xDEDEDE);
//        [self.scrollerConentView addSubview:line];

        self.scrollerConentView.contentSize = CGSizeMake(btnX, 0);

        if (i == 0) {
            view.hidden = NO;
            btn.selected = YES;
            self.recordElement = btn;
        }
    }
}

#pragma mark - 普通排一排, 带指示器, 点击事件
- (void)createDefault2Action:(UIButton *)sender
{
    if (self.recordElement != sender) {
        // 现在的btn
        NSInteger lineViewTag = sender.tag + 100;
        UIView *lineView =  [sender.superview viewWithTag:lineViewTag];
        lineView.hidden = NO;
        sender.selected = YES;
        
        // 前一个Btn
        UIButton *recordElement = self.recordElement;
        recordElement.selected = NO;
        UIView *recordLineView =  [sender.superview viewWithTag:recordElement.tag + 100];
        recordLineView.hidden = YES;
        self.recordElement = sender;
    }
    
    self.categoryItem = self.categoryItems[sender.tag - 100];
    !self.block ? : self.block(self.categoryItem);
}


@end
