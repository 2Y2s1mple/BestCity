//
//  CZScollerImageTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZScollerImageTool.h"
#import "PlanADScrollView.h"

@implementation CZScollerImageTool

- (void)setImgList:(NSArray *)imgList
{
    _imgList = imgList;
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 创建轮播图
    if ([self.imgList count] > 0) {
        if (self.imgList.count == 1) {
            // 初始化控件
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imgList firstObject]] placeholderImage:IMAGE_NAMED(@"headDefault")];
            imageView.frame = CGRectMake(0, 0, self.width, self.height);
            [self addSubview:imageView];
        } else {
            // 初始化控件
            PlanADScrollView *ad =[[PlanADScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) imageUrls:self.imgList placeholderimage:IMAGE_NAMED(@"headDefault")];
            [self addSubview:ad];
        }
    } else {
        // 初始化控件
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headDefault"]];
        imageView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:imageView];
    }
}
@end
