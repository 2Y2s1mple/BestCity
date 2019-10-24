//
//  CZGotoScoreTextView.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGotoScoreTextView.h"
#import "GXNetTool.h"

@interface CZGotoScoreTextView ()
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;
@property (nonatomic, weak) IBOutlet UIImageView *image4;
@property (nonatomic, weak) IBOutlet UIImageView *image5;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UITextView *textView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *placeHolderLabel;
@end

@implementation CZGotoScoreTextView

+ (instancetype)gotoScoreTextView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setScore:(NSString *)score
{
    _score = score;
    for (int i = 1; i <= [self.score integerValue]; i++) {
        UIImageView *image = [self viewWithTag:i];
        image.image = [UIImage imageNamed:@"星形-1"];
    }
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frame.origin.y != SCR_HEIGHT) {
        self.centerY -= 60;
        self.placeHolderLabel.hidden = YES;
    } else {
        self.centerY += 60;
        if (self.textView.text.length == 0) {
            self.placeHolderLabel.hidden = NO;
        }
    }
}


- (IBAction)commitAction {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"content"] = self.textView.text;
    param[@"score"] = self.score;
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/addScore"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"感谢你的反馈!"];
            [CZProgressHUD hideAfterDelay:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.viewController popToRootViewControllerAnimated:YES];
                [[self superview] removeFromSuperview];
            });
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (IBAction)deleteBrtnAction:(id)sender {

    [self.viewController popToRootViewControllerAnimated:YES];
    [[self superview] removeFromSuperview];
}

// 找到父控制器
- (UINavigationController *)viewController {
   UITabBarController *tabbar = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    return nav;
}

@end
