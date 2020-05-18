//
//  CZJVerificationHandler.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/18.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZJVerificationHandler.h"
//引入JVERIFICATIONService.h头文件
#import "JVERIFICATIONService.h"
#import "CZSubButton.h"

@interface CZJVerificationHandler ()
/** <#注释#> */
@property (nonatomic, strong) void (^block)(void);
@end

@implementation CZJVerificationHandler
static id _instance;
+ (instancetype)shareJVerificationHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init];
    });
    return _instance;
}

/** SDK登录预取号 */
- (void)preLogin:(void (^)(BOOL success))isSuccess {
    [JVERIFICATIONService preLogin:3000 completion:^(NSDictionary *result) {
        NSLog(@"预取号 result:%@", result);
        if ([result[@"code"]  isEqual: @(7000)]) {
            NSLog(@"预取号成功");
            isSuccess(YES);
        } else {
            isSuccess(NO);
        }
    }];
}

- (void)JAuthorizationWithController:(UIViewController *)vc action:(void (^)(NSString *))action
{
    [self customFullScreenUI1];
    [JVERIFICATIONService getAuthorizationWithController:vc hide:YES animated:YES timeout:15*1000 completion:^(NSDictionary *result) {
        NSLog(@"一键登录 result:%@", result);
        if ([result[@"code"] isEqual: @(6000)]) {
            action(result[@"loginToken"]);
        } else if ([result[@"code"] isEqual: @(6400)]) {
            NSLog(@"正在登录中，稍候再试");
            [CZProgressHUD showProgressHUDWithText:@"正在登录中，稍候再试"];
            [CZProgressHUD hideAfterDelay:1.5];
        } else {
            action(@"");
        }
    } actionBlock:^(NSInteger type, NSString *content) {
        NSLog(@"一键登录 actionBlock :%ld %@", (long)type , content);
    }];
}

- (void)JAuthBindingWithController:(UIViewController *)vc action:(void (^)(NSString *))action
{
    [self customFullScreenUI2];
    [JVERIFICATIONService getAuthorizationWithController:vc hide:YES animated:YES timeout:15*1000 completion:^(NSDictionary *result) {
        NSLog(@"一键绑定 result:%@", result);
        if ([result[@"code"] isEqual: @(6000)]) {
            action(result[@"loginToken"]);
        } else if ([result[@"code"] isEqual: @(6400)]) {
            NSLog(@"正在登录中，稍候再试");
            [CZProgressHUD showProgressHUDWithText:@"正在登录中，稍候再试"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } actionBlock:^(NSInteger type, NSString *content) {
        NSLog(@"一键登录 actionBlock :%ld %@", (long)type , content);
    }];
}

/*设置全屏样式UI1*/
- (void)customFullScreenUI1{
    // 导航
    JVUIConfig *config = [[JVUIConfig alloc] init];
    config.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    config.navCustom = NO;
    config.navColor = [UIColor whiteColor];
    config.navText = [[NSAttributedString alloc]initWithString:@"手机号登录" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x0E0402), NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    config.navReturnImg = [UIImage imageNamed:@"nav-back"];
    config.navReturnImageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    
    //logo
    config.logoImg = [UIImage imageNamed:@"headDefault-2"];
    JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-230];
    config.logoConstraints = @[logoConstraintX, logoConstraintY];
    config.logoHorizontalConstraints = config.logoConstraints;
    
    //号码栏
    config.numberSize = 21;
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-100];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
    config.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
    config.numberHorizontalConstraints = config.numberConstraints;
    
    //slogan隐藏
    config.sloganTextColor = [UIColor whiteColor];
    
    //登录按钮
    config.logBtnText = @"一键登录";
    UIImage *login_nor_image = [UIImage imageNamed:@"me-矩形 4"];
    UIImage *login_dis_image = [UIImage imageNamed:@"me-矩形 4"];
    UIImage *login_hig_image = [UIImage imageNamed:@"me-矩形 4"];
    config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    CGFloat loginButtonWidth = 310;
    CGFloat loginButtonHeight = 44;
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20];
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    config.logBtnHorizontalConstraints = config.logBtnConstraints;
    config.customLoadingViewBlock = ^(UIView *View) {
        NSLog(@"-----------");
    };
    
    //隐私
    config.privacyState = YES;
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:70];
    JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-70];
    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
    config.privacyHorizontalConstraints = config.privacyConstraints;
    
    config.appPrivacyOne = @[@"《极品城用户协议》", UserAgreement_url];
    config.appPrivacyTwo = @[@"《 隐私政策》", UserPrivacy_url];
    config.privacyComponents = @[@"登录代表同意", @"及", @"和"];
    
    //勾选框
    UIImage * uncheckedImg = [UIImage imageNamed:@"me-checkBox_unSelected"];
    UIImage * checkedImg = [UIImage imageNamed:@"me-checkBox_selected"];
    CGFloat checkViewWidth = 30;
    CGFloat checkViewHeight = 30;
    config.uncheckedImg = uncheckedImg;
    config.checkedImg = checkedImg;
    JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:45];
    JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
    JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
    config.checkViewConstraints = @[checkViewConstraintX, checkViewConstraintY, checkViewConstraintW, checkViewConstraintH];
    config.checkViewHorizontalConstraints = config.checkViewConstraints;
    
    //loading
    JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
    config.loadingHorizontalConstraints = config.loadingConstraints;
    config.customPrivacyAlertViewBlock = ^(UIViewController *vc) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击同意协议" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:alert animated:true completion:nil];
    };
    
    
    
    /*
     设置一键登录页gif背景
     config.authPageGifImagePath = [[NSBundle mainBundle] pathForResource:@"auth" ofType:@"gif"];
     */
    
    /*
     设置一键登录页视频背景
     NSString *urlStr = @"http://video01.youju.sohu.com/88a61007-d1be-4e82-8d74-2b87ba7797f72_0_0.mp4";
     [config setVideoBackgroudResource:urlStr placeHolder:@"cmBackground.jpeg"];
     **/
    
    /*
     config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
     config.navColor = [UIColor redColor];
     config.preferredStatusBarStyle = 0;
     config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
     config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     button.frame = CGRectMake(0, 0, 44, 44);
     button.backgroundColor = [UIColor greenColor];
     config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
     config.logoHidden = NO;
     config.logBtnText = @"自定义登录按钮文字";
     config.logBtnTextColor = [UIColor redColor];
     config.numberColor = [UIColor blueColor];
     config.appPrivacyOne = @[@"应用自定义服务条款1",@"https:www.jiguang.cn/about"];
     config.appPrivacyTwo = @[@"应用自定义服务条款2",@"https://www.jiguang.cn/about"];
     config.privacyComponents = @[@"文本1",@"文本2",@"文本3",@"文本4"];
     config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
     config.sloganTextColor = [UIColor redColor];
     config.navCustom = NO;
     config.numberSize = 24;
     config.privacyState = YES;
     */
    //隐私协议添加下划线
//    [config addPrivacyTextAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range: NSMakeRange(5, 10)];

    [JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
        
        //添加一个自定义label
        UILabel *label  = [[UILabel alloc] init];
        label.text = @"淘好物，更省钱！";
        label.textColor = UIColorFromRGB(0x9D9D9D);
        label.font = [UIFont systemFontOfSize:15];
        [label sizeToFit];
        CGPoint point = CGPointMake(customAreaView.center.x, customAreaView.center.y - 260);
        label.center = point;
        [customAreaView addSubview:label];
        
        
        // 微信
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [btn setTitle:@"微信登陆" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        btn.size = CGSizeMake(40, 40);
        btn.centerX = customAreaView.width / 2.0 - 88;
        btn.centerY = customAreaView.height - 150;
        [customAreaView addSubview:btn];
        
        // 其他手机登陆
        CZSubButton *btn1 = [CZSubButton buttonWithType:UIButtonTypeCustom];
        [btn1 setImage:[UIImage imageNamed:@"me-otheriPhone"] forState:UIControlStateNormal];
        [btn1 setTitle:@"其他手机号登录" forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        btn1.size = CGSizeMake(40, 40);
        btn1.centerX = customAreaView.width / 2.0 + 88;
        btn1.centerY = customAreaView.height - 150;
        [customAreaView addSubview:btn1];
        
        
        
        // 绑定其他手机号
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, 310, 44);
//        CGPoint point1 = CGPointMake(customAreaView.center.x, customAreaView.center.y - 30);
//        btn.center = point1;
////        [customAreaView addSubview:btn];
//        [btn setTitle:@"绑定其他手机号" forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:18];
//        [btn setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
//        btn.layer.cornerRadius = 22;
//        btn.layer.borderWidth = 0.5;
//        btn.layer.borderColor = UIColorFromRGB(0x989898).CGColor;
//        [btn addTarget:self action:@selector(bindingMobile) forControlEvents:UIControlEventTouchUpInside];
        
        
    }];
}

/*设置全屏样式UI2*/
- (void)customFullScreenUI2{
    // 导航
    JVUIConfig *config = [[JVUIConfig alloc] init];
    config.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    config.navCustom = NO;
    config.navColor = [UIColor whiteColor];
    config.navText = [[NSAttributedString alloc]initWithString:@"绑定手机号" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x0E0402), NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    config.navReturnImg = [UIImage imageNamed:@"nav-back"];
    config.navReturnImageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    
    //logo
    config.logoImg = [UIImage imageNamed:@"headDefault-2"];
    JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-230];
    config.logoConstraints = @[logoConstraintX, logoConstraintY];
    config.logoHorizontalConstraints = config.logoConstraints;
    
    //号码栏
    config.numberSize = 21;
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-100];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
    config.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
    config.numberHorizontalConstraints = config.numberConstraints;
    
    //slogan隐藏
    config.sloganTextColor = [UIColor whiteColor];
    
    //登录按钮
    config.logBtnText = @"一键绑定账号";
    UIImage *login_nor_image = [UIImage imageNamed:@"me-矩形 4"];
    UIImage *login_dis_image = [UIImage imageNamed:@"me-矩形 4"];
    UIImage *login_hig_image = [UIImage imageNamed:@"me-矩形 4"];
    config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    CGFloat loginButtonWidth = 310;
    CGFloat loginButtonHeight = 44;
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20];
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    config.logBtnHorizontalConstraints = config.logBtnConstraints;
    config.customLoadingViewBlock = ^(UIView *View) {
        NSLog(@"-----------");
    };
    
    //隐私
    config.privacyState = YES;
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:70];
    JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-70];
    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
    config.privacyHorizontalConstraints = config.privacyConstraints;
    
    config.appPrivacyOne = @[@"《极品城用户协议》", UserAgreement_url];
    config.appPrivacyTwo = @[@"《 隐私政策》", UserPrivacy_url];
    config.privacyComponents = @[@"登录代表同意", @"及", @"和"];
    
    //勾选框
    UIImage * uncheckedImg = [UIImage imageNamed:@"me-checkBox_unSelected"];
    UIImage * checkedImg = [UIImage imageNamed:@"me-checkBox_selected"];
    CGFloat checkViewWidth = 30;
    CGFloat checkViewHeight = 30;
    config.uncheckedImg = uncheckedImg;
    config.checkedImg = checkedImg;
    JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:45];
    JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
    JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
    config.checkViewConstraints = @[checkViewConstraintX, checkViewConstraintY, checkViewConstraintW, checkViewConstraintH];
    config.checkViewHorizontalConstraints = config.checkViewConstraints;
    
    //loading
    JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
    config.loadingHorizontalConstraints = config.loadingConstraints;
    config.customPrivacyAlertViewBlock = ^(UIViewController *vc) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击同意协议" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:alert animated:true completion:nil];
    };
    
    
    
    /*
     设置一键登录页gif背景
     config.authPageGifImagePath = [[NSBundle mainBundle] pathForResource:@"auth" ofType:@"gif"];
     */
    
    /*
     设置一键登录页视频背景
     NSString *urlStr = @"http://video01.youju.sohu.com/88a61007-d1be-4e82-8d74-2b87ba7797f72_0_0.mp4";
     [config setVideoBackgroudResource:urlStr placeHolder:@"cmBackground.jpeg"];
     **/
    
    /*
     config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
     config.navColor = [UIColor redColor];
     config.preferredStatusBarStyle = 0;
     config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
     config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     button.frame = CGRectMake(0, 0, 44, 44);
     button.backgroundColor = [UIColor greenColor];
     config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
     config.logoHidden = NO;
     config.logBtnText = @"自定义登录按钮文字";
     config.logBtnTextColor = [UIColor redColor];
     config.numberColor = [UIColor blueColor];
     config.appPrivacyOne = @[@"应用自定义服务条款1",@"https:www.jiguang.cn/about"];
     config.appPrivacyTwo = @[@"应用自定义服务条款2",@"https://www.jiguang.cn/about"];
     config.privacyComponents = @[@"文本1",@"文本2",@"文本3",@"文本4"];
     config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
     config.sloganTextColor = [UIColor redColor];
     config.navCustom = NO;
     config.numberSize = 24;
     config.privacyState = YES;
     */
    //隐私协议添加下划线
//    [config addPrivacyTextAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range: NSMakeRange(5, 10)];

    [JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
        
        //添加一个自定义label
        UILabel *label  = [[UILabel alloc] init];
        label.text = @"淘好物，更省钱！";
        label.textColor = UIColorFromRGB(0x9D9D9D);
        label.font = [UIFont systemFontOfSize:15];
        [label sizeToFit];
        CGPoint point = CGPointMake(customAreaView.center.x, customAreaView.center.y - 260);
        label.center = point;
        [customAreaView addSubview:label];
        
        
        // 其他手机登陆
        CZSubButton *btn1 = [CZSubButton buttonWithType:UIButtonTypeCustom];
        [btn1 setImage:[UIImage imageNamed:@"me-otheriPhone"] forState:UIControlStateNormal];
        [btn1 setTitle:@"其他手机号登录" forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        btn1.size = CGSizeMake(40, 40);
        btn1.centerX = customAreaView.width / 2.0;
        btn1.centerY = customAreaView.height - 150;
        [customAreaView addSubview:btn1];
        
        
        
        // 绑定其他手机号
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, 310, 44);
//        CGPoint point1 = CGPointMake(customAreaView.center.x, customAreaView.center.y - 30);
//        btn.center = point1;
////        [customAreaView addSubview:btn];
//        [btn setTitle:@"绑定其他手机号" forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:18];
//        [btn setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
//        btn.layer.cornerRadius = 22;
//        btn.layer.borderWidth = 0.5;
//        btn.layer.borderColor = UIColorFromRGB(0x989898).CGColor;
//        [btn addTarget:self action:@selector(bindingMobile) forControlEvents:UIControlEventTouchUpInside];
        
        
    }];
}
@end
