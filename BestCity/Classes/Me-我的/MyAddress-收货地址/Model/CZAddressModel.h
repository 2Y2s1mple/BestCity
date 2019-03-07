//
//  CZAddressModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZAddressModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSNumber *status;
@end

NS_ASSUME_NONNULL_END
