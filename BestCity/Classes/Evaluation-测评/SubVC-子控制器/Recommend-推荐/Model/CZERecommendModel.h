//
//  CZERecommendModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZEAttentionUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZERecommendModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *pv;
/** <#注释#> */
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) CZEAttentionUserModel *user;
@end

NS_ASSUME_NONNULL_END
