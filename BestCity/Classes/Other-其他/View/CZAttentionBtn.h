//
//  CZAttentionBtn.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AttentionAction)(void);
typedef NS_ENUM(NSUInteger, CZAttentionBtnType) {
    CZAttentionBtnTypeFollowed,
    CZAttentionBtnTypeAttention,
};

@interface CZAttentionBtn : UIView
+ (instancetype)attentionBtnWithframe:(CGRect)frame CommentType:(CZAttentionBtnType)type didClickedAction:(AttentionAction)action;
/** x类型 */
@property (nonatomic, assign) CZAttentionBtnType type;
@end
