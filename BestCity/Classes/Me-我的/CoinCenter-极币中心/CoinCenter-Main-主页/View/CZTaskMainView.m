//
//  CZTaskMainView.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTaskMainView.h"
#import "CZTaskView.h"

@interface CZTaskMainView () <CZTaskViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray <CZTaskView *> *taskViewSet;
@end

@implementation CZTaskMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (NSMutableArray<CZTaskView *> *)taskViewSet
{
    if (_taskViewSet == nil) {
        _taskViewSet = [NSMutableArray array];
    }
    return _taskViewSet;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 添加标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"每日任务";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    [titleLabel sizeToFit];
    titleLabel.y = 30;
    titleLabel.centerX = self.width / 2.0;
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    
    for (int i = 0; i < self.dataSource.count; i++) {
        CZTaskView *itemView = [[CZTaskView alloc] initWithFrame:CGRectMake(0, CZGetY([self.subviews lastObject]), self.width, 62)];
        itemView.taskData = self.dataSource[i];
        itemView.delegate = self;
        [self addSubview:itemView];
        [self.taskViewSet addObject:itemView];
    }
    
    // 计算高度
    UIView *subView = [self.subviews lastObject];
    self.height = CZGetY(subView);
}

#pragma mark - <CZTaskViewDelegate>
- (void)updataTaskView:(CZTaskView *)taskView
{
    for (int i = 0; i < self.taskViewSet.count; i++) {
        CZTaskView *itemView = self.taskViewSet[i];
        if (i == 0) continue;
        itemView.y = CZGetY(self.taskViewSet[i - 1]);
    }
    // 初始化单个的视图
    UIView *subView = [self.subviews lastObject];
    self.height = CZGetY(subView);
    !self.delegate ? : [self.delegate reloadContentView]; 
}
@end
