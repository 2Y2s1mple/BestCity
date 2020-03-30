//
//  CZSubSubIssueMomentsListController.h
//  BestCity
//
//  Created by JasonBourne on 2020/3/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZSubSubIssueMomentsListController : UIViewController
/** 模块 */
@property (nonatomic, strong) NSNumber *paramType; // 1精选 2.素材
/** 一级 */
@property (nonatomic, strong) NSString *paramCategoryId1;
/** 2级数据 */
@property (nonatomic, strong) NSArray *categoryView2Data;
@end

NS_ASSUME_NONNULL_END
