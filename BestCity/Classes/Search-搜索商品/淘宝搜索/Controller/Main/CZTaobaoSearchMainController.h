//
//  CZTaobaoSearchMainController.h
//  BestCity
//
//  Created by JsonBourne on 2020/4/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZTaobaoSearchMainController : WMPageController
/** <#注释#> */
@property (nonatomic, strong) NSString *searchText;
/** <#注释#> */
@property (nonatomic, assign) NSInteger source;
@end

NS_ASSUME_NONNULL_END
