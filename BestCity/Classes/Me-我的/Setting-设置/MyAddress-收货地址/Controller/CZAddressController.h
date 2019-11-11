//
//  CZAddressController.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZAddressControllerDelegate <NSObject>
- (void)addressUpdata:(id)addressContext;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CZAddressController : UIViewController
/** <#注释#> */
@property (nonatomic, strong) UIViewController *vc;
- (void)getDataSource;
@property (nonatomic, strong) id <CZAddressControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
