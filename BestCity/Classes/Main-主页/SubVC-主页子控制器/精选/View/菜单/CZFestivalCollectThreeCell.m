//
//  CZFestivalCollectThreeCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectThreeCell.h"
#import "CZTitlesViewTypeLayout.h"

@interface CZFestivalCollectThreeCell ()

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleName;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *backView;

@property (nonatomic, strong) NSString *asc; // (1正序，0倒序);
@property (nonatomic, strong) NSString *orderByType;  // 0综合，1价格，2补贴，3销量
/** 是否是条形布局 */
@property (nonatomic, assign) BOOL layoutType;
/** <#注释#> */
@property (nonatomic, strong) UIButton *recordBtn;
/** <#注释#> */
@property (nonatomic, assign) NSInteger recoredBtnClick;
@end

@implementation CZFestivalCollectThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleName.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
//    [self createTitles];

    CZTitlesViewTypeLayout *view = [[CZTitlesViewTypeLayout alloc] init];
    view.width = SCR_WIDTH;
    view.height = 38;
    [view setBlcok:^(BOOL isLine, BOOL isAsc, NSInteger index) {
        // orderByType : 0综合，1价格，2补贴，3销量
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mainSameTitleAction" object:nil userInfo:@{@"orderByType" : @(index), @"asc" : @(isAsc), @"layoutType" : @(isLine)}];
    }];

    [self.backView addSubview:view];
}

@end
