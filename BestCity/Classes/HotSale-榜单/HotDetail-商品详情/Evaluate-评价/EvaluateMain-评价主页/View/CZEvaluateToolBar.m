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
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)sandBtnAction:(UIButton *)sender {
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
