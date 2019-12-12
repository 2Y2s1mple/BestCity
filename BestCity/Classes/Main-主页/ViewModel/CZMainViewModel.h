//
//  CZMainViewModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMainViewModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSArray *mainTitles;

- (void)getMainTitles:(void (^)(void))callback;
@end

NS_ASSUME_NONNULL_END
