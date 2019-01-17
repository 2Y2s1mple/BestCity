//
//  CZSubCollectTwoController.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CZSubCollectTwoControllerType) {
    CZTypeDiscover,
    CZTypeEvaluation,
    CZTypeTryout,
};

NS_ASSUME_NONNULL_BEGIN

@interface CZSubCollectTwoController : UIViewController
/** 类型 */
@property (nonatomic, assign) CZSubCollectTwoControllerType type; // 
@end

NS_ASSUME_NONNULL_END
