//
//  GXSaveImageToPhone.h
//  GXLCodeRepository
//
//  Created by JasonBourne on 2020/3/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSaveImageToPhone : NSObject

/**
 * 保存图片到手机
 * @param object 必须是图片, 或者图片的数组
 */
+ (void)saveBatchImage:(id)object;
@end

NS_ASSUME_NONNULL_END
