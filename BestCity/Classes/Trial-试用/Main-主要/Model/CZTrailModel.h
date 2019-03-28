//
//  CZTrailModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTrailModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *actualPrice;
/** <#注释#> */
@property (nonatomic, strong) NSString *trialId;
/** （1即将开始，2进行中，3试用中，4 结束 5结束） */
@property (nonatomic, strong) NSString *status;


@end

NS_ASSUME_NONNULL_END
