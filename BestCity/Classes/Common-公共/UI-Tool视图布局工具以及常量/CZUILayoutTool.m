//
//  CZUILayoutTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUILayoutTool.h"

static id instancet_;
@implementation CZUILayoutTool

+ (instancetype)defaultLayoutTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancet_ = [[CZUILayoutTool alloc] init];
    });
    return instancet_;
}

- (CGFloat)STATUSBAR_MAX_ORIGIN_Y
{
    return (IsiPhoneX ? 44 : 20);
}
@end
