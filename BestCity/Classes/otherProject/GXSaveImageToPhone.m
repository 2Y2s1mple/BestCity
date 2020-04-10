//
//  GXSaveImageToPhone.m
//  GXLCodeRepository
//
//  Created by JasonBourne on 2020/3/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "GXSaveImageToPhone.h"
#import "SDWebImageManager.h"

@implementation GXSaveImageToPhone
#pragma mark - /** 保存图片到本地 */
+ (void)saveBatchImage:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *images = object;
        for (int i = 0; i < images.count; i++) {
            id obj = images[i];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveImage:obj];
            });
        }
    } else {
        [self saveImage:object];
    }

}

+ (void)saveImage:(id)image
{
    // 注意: The app's Info.plist must contain an NSPhotoLibraryAddUsageDescription

    if ([image isKindOfClass:[NSString class]]) {
        // 保存图片
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:image] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    } else if ([image isKindOfClass:[UIImage class]]) {

        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

// <保存到相册> -对象和+类方法都行
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [CZProgressHUD showProgressHUDWithText:msg];
        [CZProgressHUD hideAfterDelay:1.5];
    }else{
        msg = @"保存图片成功" ;
        [CZProgressHUD showProgressHUDWithText:msg];
        [CZProgressHUD hideAfterDelay:1.5];
    }
}
@end
