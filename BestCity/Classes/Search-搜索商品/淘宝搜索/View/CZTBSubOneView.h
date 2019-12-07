//
//  CZTBSubOneView.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTBSubOneViewBtn : UIButton

@end

@interface CZTBSubOneView : UIView
/**  */
@property (nonatomic, copy) void (^btnBlock) (NSInteger index);

/** <#注释#> */
@property (nonatomic, assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
