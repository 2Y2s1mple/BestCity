//
//  CZEvaluationViewModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZEvaluationProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZEvaluationViewModel : NSObject <CZEvaluationProtocol>
/** 标题 */
@property (nonatomic, strong, readonly) NSArray *titlesText;

@end

NS_ASSUME_NONNULL_END
