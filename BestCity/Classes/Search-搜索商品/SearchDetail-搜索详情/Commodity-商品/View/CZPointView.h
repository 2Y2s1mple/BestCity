//
//  CZPointView.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/26.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZPointView : UIView
+ (CGFloat)pointViewWithFrame:(CGRect)frame tilte:(NSString *)mainTitle titleImage:(NSString *)imageName pointTitles:(NSArray *)pointTitles superView:(UIView *)superView;

+ (CGFloat)pointFormViewWithFrame:(CGRect)frame tilte:(NSString *)mainTitle titleImage:(NSString *)imageName formTitles:(NSArray *)formTitles subformTitles:(NSArray *)subformTitles superView:(UIView *)superView;
@end
