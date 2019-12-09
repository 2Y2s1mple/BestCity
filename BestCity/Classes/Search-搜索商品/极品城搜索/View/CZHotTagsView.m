//
//  CZHotTagsView.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/6.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZHotTagsView.h"
#import "GXNetTool.h"


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
        _maxNumber = 5;
    }
    return _maxNumber;
}

// 设置标题
- (void)setTitle:(NSString *)title
{
    _title = title;
    UILabel *hisLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 23)];
    hisLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    hisLabel.textColor = UIColorFromRGB(0x202020);
    hisLabel.text = _title;
    [self addSubview:hisLabel];

    if (![title isEqualToString:@"今日热搜"]) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.size = CGSizeMake(26, 25);
        deleteBtn.centerY = hisLabel.centerY;
        deleteBtn.x = self.width -  deleteBtn.width - 15;
        [deleteBtn setImage:[UIImage imageNamed:@"delete-2"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
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
    label.text = title;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : label.font}];
    if (size.width > SCR_WIDTH - 20) {
        label.size = CGSizeMake(SCR_WIDTH - 20, 30);
    } else {
        label.size = CGSizeMake((int)((size.width + 28) + 0.5), 30);
    }
    label.type = type;
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
    self.tagsView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.width, 100)];
    self.tagsView.clipsToBounds = YES;
    [self addSubview:_tagsView];
    // 内容
    for (int i = 0; i < self.hisArray.count; i++) {
        CZHotTagLabel *label = [[CZHotTagLabel alloc] init];
        label.delegate = self;
        label.text = self.hisArray[i];
        label.type = self.type;
        [label sizeToFit];

        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = RANDOMCOLOR;
        backView.height = 30;
        [backView addSubview:label];
        backView.layer.cornerRadius = 15;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = CZGlobalLightGray;


        [self.tagsView addSubview:backView];
//        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}];
//        NSLog(@"%lf", size.width);
        
        if ((label.size.width + 28) > SCR_WIDTH - 20) {
            backView.width = SCR_WIDTH - 20;
            label.width = backView.width - 28;
        } else {
            backView.width = label.size.width + 28;

        }
        label.center = CGPointMake(backView.size.width / 2.0, backView.size.height / 2.0);
    }
}

- (void)tagLabelLayout
{
    // 布局
    for (int i = 0; i < self.hisArray.count; i++) {
        // 先布局第一个
        CZHotTagLabel *label = self.tagsView.subviews[i];
        label.x = 10;
        label.y = 10;
        
        if (i > 0) {
            // 获取前一个
            CZHotTagLabel *prevlabel = self.tagsView.subviews[i - 1];
            if (SCR_WIDTH - CGRectGetMaxX(prevlabel.frame) > (label.width + 20)) {
                label.x = CGRectGetMaxX(prevlabel.frame) + 10;
                label.y = prevlabel.y;
            } else {
                label.y = CGRectGetMaxY(prevlabel.frame) + 10;
                label.x = 10;
            }
        }
    }
    self.tagsView.height = CZGetY([self.tagsView.subviews lastObject]);

    if (self.tagsView.height > 120) {
        self.tagsView.height = 120;
        self.isShow = YES; // 显示外面的按钮
    } else {
        self.isShow = NO; // 不显示外面的按钮
    }
    self.height = CZGetY(self.tagsView);
}

- (void)showAll
{
    // 布局
    for (int i = 0; i < self.hisArray.count; i++) {
        // 先布局第一个
        CZHotTagLabel *label = self.tagsView.subviews[i];
        label.x = 10;
        label.y = 10;

        if (i > 0) {
            // 获取前一个
            CZHotTagLabel *prevlabel = self.tagsView.subviews[i - 1];
            if (SCR_WIDTH - CGRectGetMaxX(prevlabel.frame) > label.width + 20) {
                label.x = CGRectGetMaxX(prevlabel.frame) + 10;
                label.y = prevlabel.y;
            } else {
                label.y = CGRectGetMaxY(prevlabel.frame) + 10;
                label.x = 10;
            }
        }
    }
    self.tagsView.height = CZGetY([self.tagsView.subviews lastObject]);

    CGFloat height = 40 * 5;
    if (self.tagsView.height > height) {
        self.tagsView.height = height;
    }
    self.height = CZGetY(self.tagsView);
}

- (void)hide
{
    // 布局
    for (int i = 0; i < self.hisArray.count; i++) {
        // 先布局第一个
        CZHotTagLabel *label = self.tagsView.subviews[i];
        label.x = 10;
        label.y = 10;

        if (i > 0) {
            // 获取前一个
            CZHotTagLabel *prevlabel = self.tagsView.subviews[i - 1];
            if (SCR_WIDTH - CGRectGetMaxX(prevlabel.frame) > label.width + 20) {
                label.x = CGRectGetMaxX(prevlabel.frame) + 10;
                label.y = prevlabel.y;
            } else {
                label.y = CGRectGetMaxY(prevlabel.frame) + 10;
                label.x = 10;
            }
        }
    }
    self.tagsView.height = CZGetY([self.tagsView.subviews lastObject]);

    CGFloat height = 40 * 3;
    if (self.tagsView.height > height) {
        self.tagsView.height = height;
    }
    self.height = CZGetY(self.tagsView);
}


// 全部删除
- (void)deleteAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除全部历史记录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
//        [CZProgressHUD showProgressHUDWithText:nil];
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/deleteAll"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                // 获取数据
//                [self getSourceData];
                [self.delegate deleteTags];
            }
//            [CZProgressHUD hideAfterDelay:1.5];
        } failure:^(NSError *error) {}];
    }]];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
}
@end
