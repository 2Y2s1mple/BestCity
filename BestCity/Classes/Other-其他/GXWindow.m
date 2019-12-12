//
//  GXWindow.m
//  testiOS
//
//  Created by JasonBourne on 2019/11/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "GXWindow.h"

@implementation GXWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
     UIView *hitView = [super hitTest:point withEvent:event];
       NSLog(@"GXWindow - %@", [hitView class]);
       return hitView;
}

@end
