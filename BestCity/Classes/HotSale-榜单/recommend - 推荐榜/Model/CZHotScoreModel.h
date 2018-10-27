//
//  CZHotScoreModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZHotScoreModel : NSObject
/** 内容 */
@property (nonatomic, strong) NSString *name;
/** 分数 */
@property (nonatomic, strong) NSString *score;
@end

NS_ASSUME_NONNULL_END
