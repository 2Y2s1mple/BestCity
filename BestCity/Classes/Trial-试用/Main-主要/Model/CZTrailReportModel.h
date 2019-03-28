//
//  CZTrailReportModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTrailReportModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *pv;
@property (nonatomic, strong) NSString *title;
/** id */
@property (nonatomic, strong) NSString *articleId;

@end

NS_ASSUME_NONNULL_END
