//
//  CZFestivalCollectHeaderView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectHeaderView.h"

#import "CZScollerImageTool.h"
#import "CZSubButton.h"
#import "UIButton+WebCache.h"
#import "CZFreePushTool.h"
#import "CZCategoryLineLayoutView.h"

@interface CZFestivalCollectHeaderView () <UIScrollViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIView *minline;

/** <#注释#> */
@property (nonatomic, strong) UIView *headerView;
/** 轮播图 */
@property (nonatomic, strong) CZScollerImageTool *imageView;
/** 宫格 */
@property (nonatomic, strong) CZCategoryLineLayoutView *categoryView;
/** 最下面条 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CZFestivalCollectHeaderView

- (void)prepareForReuse
{
    [super prepareForReuse];
    NSLog(@"%s", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headerView];

    }
    return self;
}

- (void)setAd1List:(NSArray *)ad1List
{
    _ad1List = ad1List;
    if (ad1List.count > 0) {
        [self createHeaderTableView];
    }
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.width = SCR_WIDTH;
        _headerView.height = 260 + 10;
    }
    return _headerView;
}

#pragma mark - UI创建
- (void)createHeaderTableView
{
    // 添加轮播图
    if (self.imageView == nil) {
        CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(15, 0, SCR_WIDTH - 30, 150)];
        self.imageView = imageView;
        [self.headerView addSubview:imageView];
        imageView.layer.cornerRadius = 15;
        imageView.layer.masksToBounds = YES;

        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *imgs = [NSMutableArray array];
        
        for (NSDictionary *imgDic in self.ad1List) {
            [imgs addObject:imgDic[@"img"]];
            [colors addObject:[@"0x" stringByAppendingString:imgDic[@"color"]]];
        }
        [imageView setScrollViewCurrentBlock:^(NSInteger index) {
            NSLog(@"setScrollViewCurrentBlock %ld", index);
            UIColor *currentColor = [UIColor gx_colorWithHexString:colors[index]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mainImageColorChange" object:nil userInfo:@{@"color" : currentColor}];
        }];
        [imageView setSelectedIndexBlock:^(NSInteger index) {
            NSDictionary *dic = self.ad1List[index];
            NSDictionary *param = @{
                @"targetType" : dic[@"type"],
                @"targetId" : dic[@"objectId"],
                @"targetTitle" : dic[@"name"],
            };
            NSLog(@"%@", param);
            [CZFreePushTool bannerPushToVC:param];
        }];
        imageView.imgList = imgs;
    }

    // 分类的按钮
    if (self.categoryView == nil) {
        // 分类的按钮
       NSArray *list = [CZCategoryLineLayoutView categoryItems:self.boxList setupNameKey:@"title" imageKey:@"iconUrl" IdKey:@"targetId" objectKey:@"type"];
        CGRect frame = CGRectMake(0, 170, SCR_WIDTH, 80);;
        CZCategoryLineLayoutView *categoryView = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:list type:2 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
            NSDictionary *param = @{
                @"targetType" : item.objectInfo,
                @"targetId" : item.categoryId,
                @"targetTitle" : item.categoryName,
            };
            NSLog(@"%@", param);
            [CZFreePushTool categoryPushToVC:param];
        }];
        [self.headerView addSubview:categoryView];
        self.categoryView = categoryView;
    }

    if (self.lineView == nil) {
        UIView *lineView = [[UIView alloc] init];
        self.lineView = lineView;
        lineView.y = 250 + 10;
        lineView.width = SCR_WIDTH;
        lineView.height = 10;
        lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.headerView addSubview:lineView];
    }
}

@end
