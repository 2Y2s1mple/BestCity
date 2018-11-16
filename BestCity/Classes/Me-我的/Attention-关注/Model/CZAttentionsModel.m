//
//  CZAttentionsModel.m
//  BestCity
//
//  Created by JasonBourne on 2018/10/10.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionsModel.h"

@implementation CZAttentionsModel
- (CZAttentionBtnType)attentionType
{
    if (!_attentionType) {
        _attentionType = CZAttentionBtnTypeFollowed;
    }
    return _attentionType;
}
@end
