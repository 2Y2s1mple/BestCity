//
//  CZMainProjectGeneralView.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMainProjectGeneralView : UIViewController
/** <#注释#> */
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *category2Id;

/** 通用专题页 */
@property (nonatomic, assign) BOOL isGeneralProject;
@end

NS_ASSUME_NONNULL_END
