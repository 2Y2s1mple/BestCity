//
//  CZHotSubTilteModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/26.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZHotSubTilteModel : NSObject
/** 具体标题 */
@property (nonatomic, strong) NSString *categoryname;
/** ID */
@property (nonatomic, strong) NSString *categoryid;
/** 按钮的序号 */
@property (nonatomic, assign) NSInteger indexBtn;
@end

NS_ASSUME_NONNULL_END
