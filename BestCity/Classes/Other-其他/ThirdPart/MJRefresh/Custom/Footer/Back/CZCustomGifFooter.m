//
//  CZCustomGifFooter.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/8.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZCustomGifFooter.h"

@implementation CZCustomGifFooter
- (void)prepare {
    [super prepare];
    //GIF数据
    NSArray * idleImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:5];
    NSArray * refreshingImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:5];
    //普通状态
    [self setImages:@[[UIImage imageNamed:@"Loading_1.png"]] forState:MJRefreshStateIdle];
    //即将刷新状态
    [self setImages:@[[UIImage imageNamed:@"Loading_1.png"]] forState:MJRefreshStatePulling];
    //正在刷新状态
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];

    // 设置文字
    [self setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];

    // 设置字体
    self.stateLabel.font = [UIFont systemFontOfSize:12];

    self.labelLeftInset = 5;
    

}

#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {

    NSMutableArray * imageArray = [NSMutableArray array];

    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Loading_%zd.png",i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    return imageArray;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
