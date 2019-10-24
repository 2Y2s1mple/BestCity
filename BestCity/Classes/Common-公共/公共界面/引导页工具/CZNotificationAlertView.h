//
//  CZNotificationAlertView.h
//  BestCity
//
//  Created by JasonBourne on 2019/10/23.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZNotificationAlertView : UIView
+ (instancetype)notificationAlertView;
-(void) checkCurrentNotificationStatus;
@end

NS_ASSUME_NONNULL_END
