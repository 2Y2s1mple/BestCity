//
//  CZHotSearchView.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/3.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZTaobaoSearchView.h"
#import "UIButton+CZExtension.h"

@interface CZTaobaoSearchView ()<UITextFieldDelegate>
/** 右侧按钮 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 文本框 */
@property (nonatomic, strong) CZTextField *textField;
/** 未读按钮 */
@property (nonatomic, strong) UILabel *unreadLabel;
@end

@implementation CZTaobaoSearchView

- (instancetype)initWithFrame:(CGRect)frame msgAction:(void (^)(NSString *))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.msgBlock = block;
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    [super setFrame:rect];
}

- (void)setTextFieldActive:(BOOL)textFieldActive
{
    _textFieldActive = textFieldActive;
    self.textField.enabled = textFieldActive;
}

- (void)setup
{
    UIButton *popBtn = [[UIButton alloc] init];
    [popBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    popBtn.size = CGSizeMake(45, self.height);
    popBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:popBtn];

    UIView *backView = [[UIView alloc] init];
    backView.x = 45;
    backView.width = self.width - 45 - 15;
    backView.height = self.height;
    backView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    backView.layer.cornerRadius = 19;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];

    CZTextField *textF = [[CZTextField alloc] init];
    textF.width = backView.width - 76;
    textF.backgroundColor = UIColorFromRGB(0xF5F5F5);
    textF.height = self.height;
    self.textField = textF;
    self.textField.delegate = self;
    [textF addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [backView addSubview:textF];
    
    UIButton *msgBtn = [[UIButton alloc] init];
    msgBtn.backgroundColor = UIColorFromRGB(0xE25838);
    [msgBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [msgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    msgBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 17];
    msgBtn.x = CGRectGetMaxX(textF.frame);
    msgBtn.size = CGSizeMake(76, self.height);
    msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [msgBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:msgBtn];
    self.rightBtn = msgBtn;
}

- (void)setUnreaderCount:(NSInteger)unreaderCount
{
    _unreaderCount = unreaderCount;
    if (unreaderCount <= 0) {
        self.unreadLabel.hidden = YES;
    } else {
        self.unreadLabel.hidden = NO;
        self.unreadLabel.text = [NSString stringWithFormat:@"%ld", unreaderCount];
    }
}

- (void)setMsgTitle:(NSString *)msgTitle
{
    _msgTitle = msgTitle;
    
    [self.rightBtn setTitle:msgTitle forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
}

- (void)msgAction
{
    if (self.textField.text.length > 0) {
        !self.msgBlock ? : self.msgBlock(self.msgTitle);
    }
}

- (void)textFieldAction:(CZTextField *)textField
{
    !self.delegate ? : [self.delegate hotView:self didTextFieldChange:textField];
    _searchText = textField.text;
}

- (void)setTextFieldBorderColor:(UIColor *)textFieldBorderColor
{
    _textFieldBorderColor = textFieldBorderColor;
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    self.textField.text = searchText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField.text.length > 0) {
        !self.msgBlock ? : self.msgBlock(self.msgTitle);
        return YES;
    } else {
        return NO;
    }
}

- (void)popAction
{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
