//
//  CZFreeChargeModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeModel : NSObject

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *actualPrice;
@property (nonatomic, strong) NSString *trialId;
@property (nonatomic, strong) NSString *status;

// 辅助
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
