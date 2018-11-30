//
//  CZEvaluationChoicenessModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/16.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEvaluationChoicenessModel : NSObject
/** 用户信息 */
@property (nonatomic, strong)NSDictionary *userShopmember;
/** 关注 */
@property (nonatomic, strong) NSNumber *concernNum; // 0 围观者 1 关注
/** 测评的id */
@property (nonatomic, strong) NSString *evalWayId;
/** 大图片 */
@property (nonatomic, strong) NSString *imgId;
/** 大图片文字 */
@property (nonatomic, strong) NSString *evalWayName;
/** 时间 */
@property (nonatomic, strong) NSString *showTime;
/** 访问量 */
@property (nonatomic, strong) NSString *visitCount;
/** 评论 */
@property (nonatomic, strong) NSString *commentNum;
@end

NS_ASSUME_NONNULL_END
