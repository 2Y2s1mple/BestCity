//
//  CZMyWalletModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMyWalletModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *year;
/** <#注释#> */
@property (nonatomic, strong) NSString *month;
/** <#注释#> */
@property (nonatomic, strong) NSString *totalPreFee;
/** <#注释#> */
@property (nonatomic, strong) NSArray *commissionDetailList;

/** 辅助 */
@property (nonatomic, assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
