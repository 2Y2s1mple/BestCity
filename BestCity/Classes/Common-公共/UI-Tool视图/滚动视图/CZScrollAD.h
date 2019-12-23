//
//  CZScrollAD.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZScrollAD : UIView
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource type:(NSInteger)type;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataSource;
/** <#注释#> */
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
