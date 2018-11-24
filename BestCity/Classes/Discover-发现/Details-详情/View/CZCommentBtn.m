//
//  CZCommentBtn.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/23.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCommentBtn.h"
#import "CZAllCriticalController.h"

@implementation CZCommentBtn

#pragma mark - 类方法创建
+ (instancetype)commentButton
{
    CZCommentBtn *btn = [[self alloc] init];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [btn setImage:IMAGE_NAMED(@"tab-community") forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setTotalCommentCount:(NSNumber *)totalCommentCount
{
    _totalCommentCount = totalCommentCount;
    [self setTitle:[NSString stringWithFormat:@"%@", totalCommentCount] forState:UIControlStateNormal];
}

- (void)commentAction
{
    CZAllCriticalController *vc = [[CZAllCriticalController alloc] init];
    //    vc.evaluateArr = self.evaluateArr;
    vc.goodsId = self.goodsId;
    vc.totalCommentCount = self.totalCommentCount;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)viewController {
    
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
