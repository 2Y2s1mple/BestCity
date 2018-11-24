//
//  CZDiscoverTitleModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/17.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZDiscoverTitleModel : NSObject
/** 标题ID */
@property (nonatomic, strong) NSString *categoryId;
/** 标题名 */
@property (nonatomic, strong) NSString *categoryName;
@end

NS_ASSUME_NONNULL_END
