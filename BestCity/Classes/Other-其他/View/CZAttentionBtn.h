//
//  CZAttentionBtn.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AttentionAction)(void);

@interface CZAttentionBtn : UIView
+ (instancetype)attentionBtnWithframe:(CGRect)frame didClickedAction:(AttentionAction)action;
@end
