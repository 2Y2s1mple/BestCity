//
//  CZTrialReportHotController.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CZTrialReportType) {
    CZTrialReportTypeNew = 1,
    CZTrialReportTypeHot,
};

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialReportHotController : UIViewController
@property (nonatomic, assign) CZTrialReportType type;
@end

NS_ASSUME_NONNULL_END
