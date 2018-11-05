//
//  CZHotSearchView.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/3.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZHotSearchView.h"
#import "CZTextField.h"
#import "UIButton+CZExtension.h"

@implementation CZHotSearchView

- (instancetype)initWithFrame:(CGRect)frame msgAction:(void (^)(void))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.msgBlock = block;
    }
    return self;
}

- (void)setTextFieldActive:(BOOL)textFieldActive
{
    _textFieldActive = textFieldActive;
    [self setup];
}

- (void)setup
{
    UIImage *msgImage = [UIImage imageNamed:@"nav-message"];
    
    self.backgroundColor = [UIColor clearColor];
    CZTextField *textF = [[CZTextField alloc] init];
    textF.width = self.width - msgImage.size.width - 10;
    textF.height = self.height;
    textF.enabled = self.isTextFieldActive;
    [self addSubview:textF];
    
    UIButton *msgBtn = [[UIButton alloc] init];
    [msgBtn setImage:msgImage forState:UIControlStateNormal];
    msgBtn.x = CGRectGetMaxX(textF.frame) + 10;
    msgBtn.size = msgBtn.currentImage.size;
    msgBtn.centerY = self.height * 0.5;
    [msgBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:msgBtn];
}

- (void)msgAction
{
    !self.msgBlock ? : self.msgBlock();
}



@end
