//
//  CZAttentionsModel.m
//  BestCity
//
//  Created by JasonBourne on 2018/10/10.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionsModel.h"

@implementation CZAttentionsModel

- (void)setStatus:(NSNumber *)status
{
    _status = status;
    if ([status isEqualToNumber:@(1)]) { // 互关
        self.attentionType = CZAttentionBtnTypeTogether;
    }
}
@end
