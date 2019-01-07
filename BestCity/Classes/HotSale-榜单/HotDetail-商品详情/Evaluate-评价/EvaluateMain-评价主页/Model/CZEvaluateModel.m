//
//  CZEvaluateModel.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/12.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZEvaluateModel.h"

@implementation CZEvaluateModel
- (NSInteger)realCommentArrCount
{
    return self.children.count;
}

- (NSInteger)contrlCommentArrCount
{
    if (!_contrlCommentArrCount) {
        _contrlCommentArrCount = 2;
    }
    return _contrlCommentArrCount;
}


- (BOOL)isMoreBtn
{
    if (self.realCommentArrCount <= 2) {
        return NO;
    } else {
        return YES;
    }
}

@end
