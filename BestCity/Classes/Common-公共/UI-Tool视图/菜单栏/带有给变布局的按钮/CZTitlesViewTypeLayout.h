//
//  CZTitlesViewTypeLayout.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/17.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CZTVTLayoutBtn : UIButton

@end

@interface CZTitlesViewTypeLayout : UIView
/** <#注释#> */
@property (nonatomic, strong) void (^blcok) (BOOL isLine, BOOL isAsc, NSInteger index);
@end


NS_ASSUME_NONNULL_END
