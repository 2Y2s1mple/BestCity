//
//  CZHotTagsView.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/6.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZHotTagsView.h"


@interface CZHotTagsView () <CZHotTagLabelDelegate>
{
    NSMutableArray *_myhisArray;
}
/** 存储 */
//@property (nonatomic, strong) NSMutableArray<CZHotTagLabel *> *tagsArray;
/** 标签的view */
@property (nonatomic, strong) UIView *tagsView;

@end

@implementation CZHotTagsView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self reloadSubViews];
    }
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray *)hisArray
{
    if (_myhisArray == nil) {
        _myhisArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"hisSearchKey"]];
    }
    return _myhisArray;
}

#pragma mark - 属性
// 存储标题数组
-(void)setHisArray:(NSMutableArray *)hisArray
{
    _myhisArray = hisArray;
    [self reloadSubViews];
}

// 存储标题数组最大数
- (NSInteger)maxNumber
{
    if (!_maxNumber) {
        _maxNumber = 10;
    }
    return _maxNumber;
}

// 设置标题
- (void)setTitle:(NSString *)title
{
    _title = title;
    UILabel *hisLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, FSS(20))];
    hisLabel.text = _title;
    hisLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:hisLabel];
}

// 设置类型
- (void)setType:(CZHotTagLabelType)type
{
    _type = type;
    [self reloadSubViews];
}

#pragma mark - 方法
// 添加数据
- (void)createTagLabelWithTitle:(NSString *)title withEventType:(CZHotTagLabelType)type
{
    CZHotTagLabel *label = [[CZHotTagLabel alloc] init];
    label.delegate = self;
    label.type = type;
    label.text = title;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : label.font}];
    label.size = CGSizeMake(size.width + 15, 30);
    
    // 添加到数组
    [self.tagsView insertSubview:label atIndex:0];
    [self.hisArray insertObject:title atIndex:0];
    
    if (self.hisArray.count >= self.maxNumber) { // 最大值是10
        [[self.tagsView.subviews lastObject] removeFromSuperview];
        [self.hisArray removeLastObject];
    }
    
    // 重新布局
    [self tagLabelLayout];
    [[NSUserDefaults standardUserDefaults] setObject:self.hisArray forKey:@"hisSearchKey"];
}

#pragma mark - <CZHotTagLabelDelegate>
- (void)hotTagLabel:(CZHotTagLabel *)label longPressAccessoryEvent:(UIButton *)sender
{
   
    [self.hisArray removeObjectAtIndex:[self.tagsView.subviews indexOfObject:label]];
    [[NSUserDefaults standardUserDefaults] setObject:self.hisArray forKey:@"hisSearchKey"];
    [self reloadSubViews];
    !self.delegate ? : [self.delegate hotTagsViewLongPressAccessoryEvent];
}

- (void)hotTagLabelWithTapEvent:(CZHotTagLabel *)label
{
    !self.delegate ? : [self.delegate hotTagsView:self didSelectedTag:label];
}

#pragma mark - 更新控件
- (void)reloadSubViews
{
    [self.tagsView removeFromSuperview];
    [self setup];
    [self tagLabelLayout];
}

- (void)setup
{
    self.tagsView = [[UIView alloc] initWithFrame:CGRectMake(0, FSS(20), self.width, 100)];
    [self addSubview:_tagsView];
    // 内容
    for (int i = 0; i < self.hisArray.count; i++) {
        CZHotTagLabel *label = [[CZHotTagLabel alloc] init];
        label.delegate = self;
        label.type = self.type;
        label.text = self.hisArray[i];
        [self.tagsView addSubview:label];
        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}];
        label.size = CGSizeMake(size.width + 15, 30);
    }
}

- (void)tagLabelLayout
{
    // 布局
    for (int i = 0; i < self.tagsView.subviews.count; i++) {
        // 先布局第一个
        CZHotTagLabel *label = self.tagsView.subviews[i];
        label.x = 10;
        label.y = 10;
        
        if (i > 0) {
            // 获取前一个
            CZHotTagLabel *prevlabel = self.tagsView.subviews[i - 1];
            if (SCR_WIDTH - CGRectGetMaxX(prevlabel.frame) > label.width + 10) {
                label.x = CGRectGetMaxX(prevlabel.frame) + 10;
                label.y = prevlabel.y;
            } else {
                label.y = CGRectGetMaxY(prevlabel.frame) + 10;
                label.x = 10;
            }
        }
    }
    
    UILabel *lab = (UILabel *)[self.tagsView.subviews lastObject];
    self.tagsView.height = CZGetY(lab);
    self.height = CZGetY(self.tagsView);
}
@end
