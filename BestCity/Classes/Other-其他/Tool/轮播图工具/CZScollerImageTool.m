//
//  CZScollerImageTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZScollerImageTool.h"
#import "PlanADScrollView.h"

@interface CZScollerImageTool () <PlanADScrollViewDelegate>

@end

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
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(0, 0, self.width, self.height);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imgList firstObject]] placeholderImage:nil];
            [self addSubview:imageView];
        } else {
            // 初始化控件
            PlanADScrollView *ad = [[PlanADScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) imageUrls:self.imgList placeholderimage:nil];
            ad.delegate = self;
            [self addSubview:ad];
        }
    } else {
        // 初始化控件
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, self.width, self.height);
        imageView.image = [UIImage imageNamed:@"headDefault"];
        [self addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked)];
        [imageView addGestureRecognizer:tap];
    }
}

- (void)imageViewClicked
{
    [self PlanADScrollViewdidSelectAtIndex:0];
}

- (void)PlanADScrollViewdidSelectAtIndex:(NSInteger )index
{
    NSLog(@"%------ld", index);
    !self.selectedIndexBlock ? : self.selectedIndexBlock(index);
}

- (void)PlanADScrollViewCurrentAtIndex:(NSInteger)index
{
    NSLog(@"%------ld", index);
    !self.scrollViewCurrentBlock ? : self.scrollViewCurrentBlock(index);
}
@end
