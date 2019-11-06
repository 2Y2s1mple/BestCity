//
//  CZEvaluateToolBar.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/12.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZEvaluateToolBar.h"

@interface CZEvaluateToolBar ()<UITextViewDelegate>

@end

@implementation CZEvaluateToolBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textView.layer.cornerRadius = 4;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = CZRGBColor(224, 224, 224).CGColor;
    
    
    self.textView.delegate = self;
}

+ (instancetype)evaluateToolBar
{
    CZEvaluateToolBar *toolBar = [[CZEvaluateToolBar alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 49)];
    toolBar.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return toolBar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[UITextView alloc] init];
        self.textView.x = 15;
        self.textView.y = 10;
        self.textView.width = SCR_WIDTH - 55 - 15;
        self.textView.height = 29;
        self.textView.layer.cornerRadius = 4;
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.borderColor = CZRGBColor(224, 224, 224).CGColor;
        [self addSubview:self.textView];
        self.textView.delegate = self;

        self.senderBtn = [[UIButton alloc] init];
        [self.senderBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self.senderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.senderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.senderBtn.x = CZGetX(self.textView);
        self.senderBtn.width = 55;
        self.senderBtn.height = self.height;
        [self.senderBtn addTarget:self action:@selector(sandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.senderBtn];

        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.text = @"点击输入评论";
        self.placeholderLabel.font = [UIFont systemFontOfSize:13];
        self.placeholderLabel.textColor = UIColorFromRGB(0xACACAC);
        [self.placeholderLabel sizeToFit];
        self.placeholderLabel.x = 20;
        self.placeholderLabel.centerY = self.height / 2.0;
        [self addSubview:self.placeholderLabel];
    }
    return self;
}


- (void)sandBtnAction:(UIButton *)sender {
    self.block();
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)setPlaceHolderText:(NSString *)placeHolderText
{
    _placeHolderText = placeHolderText;
    self.placeholderLabel.text = placeHolderText;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual: @"\n"]) {
        self.block();
        return NO;
    }
    return YES;
}
@end
