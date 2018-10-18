//
//  CZGiveLikeView.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZGiveLikeView.h"

@interface CZGiveLikeView ()
/** 点赞 */
@property (nonatomic, strong) UILabel *likeNumber;
/** 判断是否点击了小手 */
@property (nonatomic, assign) BOOL isClicked;
@end

@implementation CZGiveLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    //背后的圆圈
    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 76, 76)];
    imageBackView.center = CGPointMake(self.width / 2, self.height / 2);
    imageBackView.layer.borderWidth = 1;
    imageBackView.layer.borderColor = [CZRGBColor(227,20,54) CGColor];
    imageBackView.layer.cornerRadius = imageBackView.height / 2;
    imageBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    [imageBackView addGestureRecognizer:tap];
    [self addSubview:imageBackView];
    
    //小手图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appreciate-big"]];
    imageView.frame = CGRectMake(10, 10, 35, 32);
    imageView.center = CGPointMake(imageBackView.width / 2, imageBackView.height / 2 - 10);
    [imageBackView addSubview:imageView];
    
    //点赞的数字
    UILabel *likeNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 38, 20)];
    likeNumber.center = CGPointMake(imageView.center.x, imageView.center.y + 30);
    likeNumber.text = @"123";
    likeNumber.textColor = CZGlobalGray;
    likeNumber.font = [UIFont systemFontOfSize:15];
    likeNumber.textAlignment = NSTextAlignmentCenter;
    [imageBackView addSubview:likeNumber];
    self.likeNumber = likeNumber;
}

- (void)action
{
    //判断是否点击过
    if (!self.isClicked) {
        //初始化小手
        __block UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:label];
        label.text = @"+1";
        label.textColor = CZRGBColor(227,20,54);
        label.font = [UIFont systemFontOfSize:15];
        label.center = CGPointMake(self.width / 2 + 40, self.height / 2 - 40);
        
        //给小手一个过渡
        [UIView animateWithDuration:1 animations:^{
            label.transform = CGAffineTransformMakeTranslation(0, -30);
        }];
        
        //延时删除
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [label removeFromSuperview];
            self.likeNumber.text = [NSString stringWithFormat:@"%ld", ([self.likeNumber.text integerValue] + 1)];
            self.likeNumber.textColor = CZRGBColor(227,20,54);
        });
        
        self.isClicked = !self.isClicked;
    } else {
        NSLog(@"");
    }
    
}

@end
