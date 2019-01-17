//
//  CZSearchSubDetailTwoController.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CZDChoicenessControllerType) {
    CZDChoicenessControllerTypeDiscover,
    CZDChoicenessControllerTypeEvaluation,
    CZDChoicenessControllerTypeTry,
};
NS_ASSUME_NONNULL_BEGIN

@interface CZSearchSubDetailTwoController : UIViewController
/** 搜索文字 */
@property (nonatomic, strong) NSString *textSearch;
/** 类型 */
@property (nonatomic, assign) CZDChoicenessControllerType type;
@end

NS_ASSUME_NONNULL_END
