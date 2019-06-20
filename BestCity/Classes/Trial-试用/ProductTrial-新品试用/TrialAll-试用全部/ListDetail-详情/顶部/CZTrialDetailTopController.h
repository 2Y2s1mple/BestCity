//
//  CZTrialDetailTopController.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialDetailTopController : UIViewController
/** 数据 */
@property (nonatomic, strong) NSDictionary *detailData;
/** 最下面的横线 */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@end

NS_ASSUME_NONNULL_END
