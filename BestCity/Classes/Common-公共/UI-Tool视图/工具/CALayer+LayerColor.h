//
//  CALayer+LayerColor.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LayerColor)
- (void)setBorderColorFromUIColor:(UIColor *)color;
@end
