//
//  CZGotoScoreView.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/23.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGotoScoreView.h"
#import "GXNetTool.h"
#import "CZGotoScoreTextView.h"

@interface CZGotoScoreView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;
@property (nonatomic, weak) IBOutlet UIImageView *image4;
@property (nonatomic, weak) IBOutlet UIImageView *image5;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;
@end

@implementation CZGotoScoreView

+ (instancetype)gotoScoreView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];

    self.image1.tag = 10;
    self.image2.tag = 20;
    self.image3.tag = 30;
    self.image4.tag = 40;
    self.image5.tag = 50;

    [self.image1 addGestureRecognizer:tap1];
    [self.image2 addGestureRecognizer:tap2];
    [self.image3 addGestureRecognizer:tap3];
    [self.image4 addGestureRecognizer:tap4];
    [self.image5 addGestureRecognizer:tap5];
}

- (void)imageAction:(UIGestureRecognizer *)sender
{
    NSLog(@"%ld", sender.view.tag);
    NSInteger tag = sender.view.tag;
    if (tag == 10) {
        self.image1.image = [UIImage imageNamed:@"星形-1"];
        [self commitScore:@"1"];
        [self createTextViewAlert:@"1"];
    } else if (tag == 20) {
        for (int i = 10; i <= 20; i+=10) {
            UIImageView *image = [self viewWithTag:i];
            image.image = [UIImage imageNamed:@"星形-1"];
        }
        [self commitScore:@"2"];
        [self createTextViewAlert:@"2"];
    } else if (tag == 30) {
        for (int i = 10; i <= 30; i+=10) {
            UIImageView *image = [self viewWithTag:i];
            image.image = [UIImage imageNamed:@"星形-1"];
        }
        [self commitScore:@"3"];
        [self createTextViewAlert:@"3"];
    } else if (tag == 40) {
        for (int i = 10; i <= 40; i+=10) {
            UIImageView *image = [self viewWithTag:i];
            image.image = [UIImage imageNamed:@"星形-1"];
        }
        [self commitScore:@"4"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1450707933&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
            [self.viewController popToRootViewControllerAnimated:YES];
            [[self superview] removeFromSuperview];
        });
    } else if (tag == 50) {
        for (int i = 10; i <= 50; i+=10) {
            UIImageView *image = [self viewWithTag:i];
            image.image = [UIImage imageNamed:@"星形-1"];
        }
        [self commitScore:@"5"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1450707933&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
            [self.viewController popToRootViewControllerAnimated:YES];
            [[self superview] removeFromSuperview];
        });

    }
}

- (IBAction)deleteBrtnAction:(id)sender {

    [self.viewController popToRootViewControllerAnimated:YES];
    [[self superview] removeFromSuperview];
}

- (void)commitScore:(NSString *)score
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"content"] = @"";
    param[@"score"] = score;
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/addScore"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {


        } else {
            
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)createTextViewAlert:(NSString *)score
{

    CZGotoScoreTextView *alert = [CZGotoScoreTextView gotoScoreTextView];
    alert.center = CGPointMake(SCR_WIDTH / 2.0, SCR_HEIGHT / 2.0);
    alert.layer.cornerRadius = 10;
    alert.layer.masksToBounds = YES;
    [[self superview] addSubview:alert];
    alert.score = score;

    [self removeFromSuperview];
}

// 找到父控制器
- (UINavigationController *)viewController {
   UITabBarController *tabbar = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    return nav;
}

@end
