//
//  CZMainHotSaleCategoryView.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainHotSaleCategoryView.h"
#import "CZSubButton.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

// 跳转
#import "CZMainHotSaleDetailController.h"



@interface CZMainHotSaleCategoryView ()
/** 记录btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 点击标题响应 */
@property (nonatomic, strong) BtnActionBlock btnBlock;
@end

@implementation CZMainHotSaleCategoryView

- (instancetype)initWithFrame:(CGRect)frame action:(BtnActionBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBtnBlock:block];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self mainHotSaleCategoryWithData:dataSource];
}

- (void)mainHotSaleCategoryWithData:(NSArray <CZHotTitleModel *> *)modelList
{
    [self setupCategoryView:^UIView *{
        return [self createTitlesViewWithData:modelList];
    } andContentView:^UIView *{
        return [self createContentViewWithData:[modelList firstObject].children];
    }];
}

- (void)setupCategoryView:(UIView * (^)(void))titlesView andContentView:(UIView * (^)(void))contentView
{
    UIView *view1 = titlesView();
    UIView *view2 = contentView();
    view2.y = view1.height;
    [self addSubview:view1];
    [self addSubview:view2];
    self.height = view1.height + view2.height;
}

// 创建标题菜单
- (UIView *)createTitlesViewWithData:(NSArray <CZHotTitleModel *> *)titles
{
    UIScrollView *backView = [[UIScrollView alloc] init];
    backView.showsHorizontalScrollIndicator = NO;
    backView.backgroundColor = [UIColor whiteColor];
    backView.height = 45;
    backView.width = SCR_WIDTH;

    CGFloat space = 20;
    CGFloat btnX = 15;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:titles[i].categoryName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        [btn setTitleColor:UIColorFromRGB(0x2B2B2B) forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.centerY = backView.height / 2.0;
        btn.x = btnX;
        [backView addSubview:btn];
        btnX += (space + btn.width);
        [btn addTarget:self action:@selector(contentViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIView *view = [[UIView alloc] init];
        view.tag = i + 200;
        view.x = btn.x;
        view.y = backView.height - 4;
        view.width = btn.width;
        view.height = 3;
        view.backgroundColor = CZREDCOLOR;
        view.layer.cornerRadius = 2;
        [backView addSubview:view];
        view.hidden = YES;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(view), SCR_WIDTH, 1)];
        line.backgroundColor = CZGlobalLightGray;
        [backView addSubview:line];

        backView.contentSize = CGSizeMake(btnX, 0);

        if (i == 0) {
            view.hidden = NO;
            self.recordBtn = btn;
        }
    }
    return backView;
}

- (void)contentViewDidClickedBtn:(UIButton *)sender
{
    if (self.recordBtn != sender) {
        // 现在的btn
        NSInteger lineViewTag = sender.tag + 100;
        UIView *lineView =  [sender.superview viewWithTag:lineViewTag];
        lineView.hidden = NO;

        NSLog(@"%s", __func__);
        // 前一个Btn
        UIView *recordLineView =  [sender.superview viewWithTag:self.recordBtn.tag + 100];
        recordLineView.hidden = YES;
        self.recordBtn = sender;
        //获取数据
        NSArray *subTitle = self.dataSource[sender.tag - 100].children;
        [[self.subviews lastObject] removeFromSuperview];
        UIView *contentView = [self createContentViewWithData:subTitle];
        contentView.y = CZGetY([self.subviews firstObject]);
        [self addSubview:contentView];
        self.height = CZGetY(contentView);
        NSLog(@"%lf", self.height);
        self.btnBlock(self.height);
    }
}

- (UIView *)createContentViewWithData:(NSArray <CZHotSubTilteModel *> *)datas
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 60)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    NSArray *children = datas;

    CGFloat width = 39;
    CGFloat leftSpace = 18;
    CGFloat space = (SCR_WIDTH - leftSpace * 2 - 5 * width) / 4;
    CGFloat height = width + 20;
    NSInteger cols = 5;
    for (int i = 0; i < children.count; i++) {
        CZHotSubTilteModel *model = children[i];
        NSInteger col = i % cols;
        NSInteger row = i / cols % 2;

        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.model = model;
        btn.tag = i + 100;
        btn.width = width;
        btn.height = height;

        btn.x = leftSpace + col * (width + space) + (i / 10) * SCR_WIDTH;
        btn.y = 12 + row * (height + 25);
        [btn sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal];
        [btn setTitle:model.categoryName forState:UIControlStateNormal];
        [scrollView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(headerViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        scrollView.height = scrollView.height < CZGetY(btn) ? CZGetY(btn) : scrollView.height;
    }

    NSInteger page = (children.count + 9) / 10;
    NSInteger row =  (children.count + (cols - 1)) / cols;
    NSLog(@"一共%ld行", row);
    scrollView.contentSize = CGSizeMake(page * SCR_WIDTH, 0);
    CGFloat lineY = row <= 2 ? scrollView.height + 12 : scrollView.height + 40;
    scrollView.height = lineY;

    if (page >= 2) {
        CGFloat circleX = 0.0;
        for (int i = 0; i < page; i++) {
            UIView *pointView = [[UIView alloc] init];
            for (int j = 0; j < page; j++) {
                UIView *circle = [[UIView alloc] init];
                circle.backgroundColor = CZGlobalGray;
                if (j == i) {
                    circle.width = 19;
                } else {
                    circle.width = 8;
                }
                circle.height = 8;
                circle.x = CGRectGetMaxX([[pointView.subviews lastObject] frame]) + 8;
                circle.layer.cornerRadius = 4;
                [pointView addSubview:circle];
                circleX = CGRectGetMaxX(circle.frame);
            }
            pointView.width = circleX;
            pointView.height = 8;
            pointView.centerX = scrollView.width / 2.0 + i * scrollView.width;
            pointView.y = lineY - 20;
            [scrollView addSubview:pointView];
        }

    }
    return scrollView;
}

#pragma mark - 二级菜单点击事件
- (void)headerViewDidClickedBtn:(CZSubButton *)sender
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    // 更多
    CZMainHotSaleDetailController *toVc = [[CZMainHotSaleDetailController alloc] init];
    toVc.ID = sender.model.categoryId;
    toVc.titleText = [NSString stringWithFormat:@"%@榜单", sender.model.categoryName];
    [vc.navigationController pushViewController:toVc animated:YES];
}

@end
