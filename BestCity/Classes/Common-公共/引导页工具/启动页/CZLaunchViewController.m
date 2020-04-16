//
//  CZLaunchViewController.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/29.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZLaunchViewController.h"
#import "CZTabBarController.h"
#import "GXNetTool.h"
#import "CZGuideController.h"
#import "UIImageView+WebCache.h"
#import "CZFreePushTool.h"

@interface CZLaunchViewController ()
/** <#注释#> */
@property (nonatomic, strong) UIWindow *window;
/** NSTimer *timer */
@property (nonatomic, strong) NSTimer *timer;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *btn;
/** <#注释#> */
@property (nonatomic, assign) NSInteger timeCount;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *backImageView;
/** <#注释#> */
@property (nonatomic, assign) NSInteger clickedCount;
/** <#注释#> */
@property (nonatomic, strong) UITabBarController *tabbarVc;

@end

@implementation CZLaunchViewController

- (instancetype)initWithWindow:(UIWindow *)window
{
    self = [super init];
    if (self) {
        self.window = window;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getDataAdlist];
    self.tabbarVc = [[CZTabBarController alloc] init];
}

- (void)pushRootVc
{
    if (self.timeCount == 0) {
        [self.timer invalidate];
        self.window.rootViewController = self.tabbarVc;
    }
    self.timeCount--;
    [self.btn setTitle:[NSString stringWithFormat:@"跳过%lds", self.timeCount] forState:UIControlStateNormal];
}

/** <#注释#> */
- (IBAction)jump
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.window.rootViewController = self.tabbarVc;
    });
}

- (void)jumpAction
{
    aDImage = @[self.adDic];
    self.window.rootViewController = self.tabbarVc;
}

- (void)getDataAdlist
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"location"] = @"15";
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/adList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            NSArray *images = result[@"data"];
            self.adDic = [images firstObject];
            if (images.count == 0) {
                self.window.rootViewController = self.tabbarVc;
                return;
            }

            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.adDic[@"img"]] placeholderImage:[UIImage imageNamed:@"启动页"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self setupTimer];
            }];

        } else {
            self.window.rootViewController = self.tabbarVc;
        }
    } failure:^(NSError *error) {
        self.window.rootViewController = self.tabbarVc;
    }];
}

- (void)setupTimer
{
    self.timeCount = 3;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pushRootVc) userInfo:nil repeats:YES];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAction)];
    [self.backImageView addGestureRecognizer:tap];
}















#pragma mark - 废弃
- (void)isOpenDouble11
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/open11"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {

        } else {

        }
    } failure:^(NSError *error) {
    }];
}
@end
