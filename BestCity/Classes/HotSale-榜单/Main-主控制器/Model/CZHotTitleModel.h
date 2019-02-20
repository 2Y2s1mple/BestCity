//
//  CZHotTitleModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/26.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZHotSubTilteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZHotTitleModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *categoryName;
/** 分类的ID */
@property (nonatomic, strong) NSString *categoryId;
/** 副标题 */
@property (nonatomic, strong) NSArray *children;
/** 大图片 */
@property (nonatomic, strong) NSArray *adList;
@end

NS_ASSUME_NONNULL_END
