//
//  CZTabbaoSearchMainDetailController.h
//  BestCity
//
//  Created by JsonBourne on 2020/4/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZTabbaoSearchMainDetailController : WMPageController
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *type; // 商品来源(1京东,2淘宝，4拼多多)
@end

NS_ASSUME_NONNULL_END
