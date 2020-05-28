//
//  CZEditorTextView.m
//  BestCity
//
//  Created by JasonBourne on 2019/5/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEditorTextView.h"
@interface CZEditorTextView () <UITextViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UILabel *label;
@end

@implementation CZEditorTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSLog(@"%s", __func__);
    [self setup];
}

- (void)setup
{
    self.label.x = 7;
    self.label.y = 5;
    self.label.width = self.width - 7;
    [self addSubview:self.label];
    self.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    self.label.textColor = CZGlobalGray;
    self.label.numberOfLines = 0;
    [self.label sizeToFit];
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *string = [NSString stringWithFormat:@"%@", textView.text];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil];
    !self.textBlock ? : self.textBlock(string, rect.size.height);
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSLog(@"%@-----%@", text, textView.text);
//    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
//    return !self.titleTextBlock ? : self.titleTextBlock(textView.text);;
//}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.label.hidden = YES;
    } else {
        self.label.hidden = NO;
    }
    !self.titleTextBlock ? : self.titleTextBlock(textView.text);
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.label.text = placeHolder;
    [self.label sizeToFit];
}

- (void)setDefaultText:(NSString *)defaultText
{
    _defaultText = defaultText;
    if ([defaultText isKindOfClass:[NSNull class]]) {
        return;
    }
    self.text = defaultText;
    [self textViewDidChange:self];
    [self textViewDidEndEditing:self];
//    [self textView:self shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""];
}
@end
