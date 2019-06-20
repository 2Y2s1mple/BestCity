//
//  CZTestReportController.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTestReportController : UIViewController
/** 报告数据 */
@property (nonatomic, strong) NSMutableArray *reportDatasArr;
/** 全部报告接口需要 */
@property (nonatomic, strong) NSString *goodId;
@end

NS_ASSUME_NONNULL_END
