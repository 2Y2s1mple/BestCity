//
//  GXSaveImageToPhone.m
//  GXLCodeRepository
//
//  Created by JasonBourne on 2020/3/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "GXSaveImageToPhone.h"
#import "SDWebImageManager.h"

@interface GXSaveImageToPhone()

@end

@implementation GXSaveImageToPhone
/** 图片数组 */
static NSMutableArray *imagesList_;

#pragma mark - /** 递归保存图片到本地 */
+ (void)saveBatchImage:(id)object
{
    [CZProgressHUD showProgressHUDWithText:nil];
    if ([object isKindOfClass:[NSArray class]]) {
        imagesList_ = [NSMutableArray arrayWithArray:object];
    } else {
        imagesList_ = [NSMutableArray arrayWithObject:object];
    }
    
    id obj = imagesList_[0];
    [self saveImage:obj];

}

+ (void)saveImage:(id)image
{
    // 注意: The app's Info.plist must contain an NSPhotoLibraryAddUsageDescription
    
    if (imagesList_.count == 0) {
        return;
    }
    
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
        [imagesList_ removeObjectAtIndex:0];
        if (imagesList_.count == 0) {
            msg = @"保存图片成功" ;
            [CZProgressHUD hideAfterDelay:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CZProgressHUD showProgressHUDWithText:msg];
                [CZProgressHUD hideAfterDelay:1.5];
            });
            
        } else {
            [self saveImage:[imagesList_ firstObject]];
        }
    }
}
@end
