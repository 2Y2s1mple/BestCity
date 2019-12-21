//
//  CZUILayoutTool.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZUILayoutTool : NSObject
+ (instancetype)defaultLayoutTool;
/** 状态栏最大尺寸 */
@property (nonatomic, assign) CGFloat STATUSBAR_MAX_ORIGIN_Y;
@end

NS_ASSUME_NONNULL_END
