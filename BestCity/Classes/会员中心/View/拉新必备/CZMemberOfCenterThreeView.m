//
//  CZMemberOfCenterThreeView.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterThreeView.h"

@implementation CZMemberOfCenterThreeView

+ (instancetype)memberOfCenterThreeView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

/** 右边 */
- (IBAction)freeMoney{
    [CZFreePushTool push_freeMoney];
}

/** 新人免单 */
- (IBAction)aaa
{
    [CZFreePushTool push_newPeopleFree];
}

@end
