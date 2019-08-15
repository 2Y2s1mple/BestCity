//
//  CZCommentBtn.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/23.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCommentBtn : UIButton
+ (instancetype)commentButton;
/** 评论总数 */
@property (nonatomic, strong) NSNumber *totalCommentCount;
/** 商品ID */
@property (nonatomic, strong) NSString *goodsId;
@end

NS_ASSUME_NONNULL_END
