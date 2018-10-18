//
//  CZAttentionsModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/10.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZAttentionsModel : NSObject
/** 头像 */
@property (nonatomic, strong) NSString *from_thumb_img;
/** 关注用户名字 */
@property (nonatomic, strong) NSString *from_nickname;
@end

NS_ASSUME_NONNULL_END
