//
//  CZEditorView.m
//  BestCity
//
//  Created by JasonBourne on 2019/5/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEditorView.h"
#import "CZEditorTextView.h"

@implementation CZEditorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CZEditorTextView *textView = [[CZEditorTextView alloc] init];
        //    textView.inputAccessoryView = [self setupTool];
        textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        textView.x = 10;
        textView.y = 10;
        textView.width = SCR_WIDTH - 20;
        textView.height = 67;
        [self addSubview:textView];
    }
    return self;
}

@end
