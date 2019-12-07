//
//  CZTBSubOneView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTBSubOneView.h"

@interface CZTBSubOneViewBtn ()
/** <#注释#> */
@property (nonatomic, strong) UIView *subView;
@end

@implementation CZTBSubOneViewBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.subView = [[UIView alloc] init];
        self.subView.backgroundColor = UIColorFromRGB(0xE25838);
        self.subView.hidden = YES;
        [self addSubview:self.subView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.y = 0;
    self.subView.y = self.height - 3;
    self.subView.width = self.titleLabel.width - 5;
    self.subView.height = 3;
    self.subView.centerX = self.titleLabel.centerX;
    self.subView.layer.cornerRadius = 1.5;
    self.subView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.subView.hidden = !selected;
}

@end



@interface CZTBSubOneView ()
/** 记录点击的btn */
@property (nonatomic, strong) CZTBSubOneViewBtn *recordBtn;
@end

@implementation CZTBSubOneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;

    [self btnAction:[self viewWithTag:selectIndex + 100]];
}

- (void)createSubView
{
    NSArray *titles = @[@"搜极品城", @"搜淘宝"];
    for (int i = 0; i < titles.count; i++) {
        CZTBSubOneViewBtn *btn1 = [[CZTBSubOneViewBtn alloc] init];
        btn1.tag = i + 100;
        [btn1 setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateSelected];
        [btn1 setTitle:titles[i] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        btn1.width = SCR_WIDTH / 2.0;
        btn1.height = 33;
        btn1.x = i * btn1.width;
        [self addSubview:btn1];
        if (i == 0) {
            btn1.selected = YES;
            self.recordBtn = btn1;
        } else {
        }
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 33, SCR_WIDTH, 1)];
    line.backgroundColor = CZGlobalLightGray;
    [self addSubview:line];
}

- (void)btnAction:(CZTBSubOneViewBtn *)sender
{
    if (sender == self.recordBtn) return;

    sender.selected = YES;
    self.recordBtn.selected = NO;
    self.recordBtn = sender;
    !self.btnBlock ? : self.btnBlock(sender.tag - 100);
}


@end
