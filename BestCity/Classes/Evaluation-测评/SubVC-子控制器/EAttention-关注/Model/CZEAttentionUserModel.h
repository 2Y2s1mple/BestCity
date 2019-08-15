//
//  CZEAttentionUserModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEAttentionUserModel : NSObject
/** ID */
@property (nonatomic, strong) NSString *userId;
/** 背景图 */
@property (nonatomic, strong) NSString *bgImg;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 用户名 */
@property (nonatomic, strong) NSString *nickname;
/** 个性签名 */
@property (nonatomic, strong) NSString *detail;
/** 里面的文章图片 */
@property (nonatomic, strong) NSArray *imgs;
/** 关注 */
@property (nonatomic, strong) NSString *follow;
@end

NS_ASSUME_NONNULL_END
