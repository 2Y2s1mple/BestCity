//
//  CZMHSDQuestModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDQuestModel : NSObject
/** 问题 */
@property (nonatomic, strong) NSString *title;
/** 提问人信息 */
@property (nonatomic, strong) NSDictionary *user;
/** 提问时间 */
@property (nonatomic, strong) NSString *createTime;
/** 回答个数 */
@property (nonatomic, strong) NSString *answerCount;
/** 问题ID */
@property (nonatomic, strong) NSString *ID;
/** 回答 */
@property (nonatomic, strong) NSDictionary *answer;
/** 被拒原因 */
@property (nonatomic, strong) NSString *remark;

// 辅助
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
