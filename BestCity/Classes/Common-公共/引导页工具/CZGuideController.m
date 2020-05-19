//
//  CZGuideController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/26.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZGuideController.h"
#import "CZTabBarController.h"
#import "GXAVPlayerTool.h"
#import "GXButtons.h"
#import "CZAlertView5Controller.h"
#import "GXNetTool.h"

@interface CZGuideController () <UIScrollViewDelegate>
/** 播放器 */
@property (nonatomic, strong) GXAVPlayerTool *playerView;
@end

@implementation CZGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
    scrollerView.pagingEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollerView];
    
    
    NSInteger count = 1;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [scrollerView addSubview:imageView];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i]];
        imageView.width = SCR_WIDTH;
        imageView.height = imageView.width * imageView.image.size.height / imageView.image.size.width;
        imageView.center = CGPointMake(SCR_WIDTH / 2.0, SCR_HEIGHT / 2.0);
    }
    
    // 加载视频
    [scrollerView addSubview:[self createVideo]];
    scrollerView.contentSize = CGSizeMake(SCR_WIDTH * (count + 1), 0);
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"guide0-3"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.x = SCR_WIDTH + 30;
    btn.y = SCR_HEIGHT - 44 - 40 - (IsiPhoneX ? 34 : 0);
    [scrollerView addSubview:btn];
    [btn addTarget:self action:@selector(videoPlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"guide0-4"] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    btn1.x = SCR_WIDTH * 2 - 30 - btn1.width;
    btn1.y = SCR_HEIGHT - 44 - 40 - (IsiPhoneX ? 34 : 0);
    [scrollerView addSubview:btn1];
    [btn1 addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![[CZSaveTool objectForKey:@"CZGuideControllerGetPrivateVersion"] isEqual:@"1"]) {
        CZAlertView5Controller *alert = [[CZAlertView5Controller alloc] initWithAgreementBlock:^{
            [CZSaveTool setObject:@"1" forKey:@"CZGuideControllerGetPrivateVersion"];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/getPrivateVersion"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
                if ([result[@"msg"] isEqualToString:@"success"]) {
                    //获取隐私政策版本号
                    NSString *curVersion = result[@"data"];
                     [CZSaveTool setObject:curVersion forKey:@"getPrivateVersion"];
                }
            } failure:^(NSError *error) {}];
            
        }];
        [self presentViewController:alert animated:NO completion:nil];
    }
}

- (void)clicked
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[CZTabBarController alloc] init];
}

- (void)videoPlay
{
    [self.playerView stop];
    [self.playerView start];
}

- (UIView *)createVideo
{
    UIView *backView = [[UIView alloc] init];
    backView.width = SCR_WIDTH;
    backView.height = SCR_HEIGHT;
    backView.x = SCR_WIDTH;
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *videoView = [[UIView alloc] init];
    videoView.x = 65;
    videoView.y = (IsiPhoneX ? (24 + 65) : 65);
    videoView.size = CGSizeMake(SCR_WIDTH - 130, SCR_HEIGHT - videoView.y - 120);
//    videoView.backgroundColor = RANDOMCOLOR;
    [backView addSubview:videoView];
    
    UIImage *image = [UIImage imageNamed:@"guide0-2"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.width = videoView.width;  // image.size.width
    imageView.height = videoView.width * image.size.height / image.size.width; // image.size.height
    [videoView addSubview:imageView];
    
    videoView.height = imageView.height;
    
    NSString *localFilePath1 = [[NSBundle mainBundle] pathForResource:@"12秒nn" ofType:@"mp4"];
    GXAVPlayerTool *playerView = [GXAVPlayerTool aVPlayerFrame:CGRectMake(17, 10, videoView.width - 34, videoView.height) andURLStr:localFilePath1];
    self.playerView = playerView;
    [videoView addSubview:playerView];
    
    // 读秒
    CGRect secendFrame = CGRectMake(CZGetX(videoView), videoView.y - 20, 53, 20);
    UIButton *secendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secendBtn.frame = secendFrame;
    secendBtn.backgroundColor = UIColorFromRGB(0x202020);
    secendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    [secendBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    secendBtn.layer.cornerRadius = 10;
    [backView addSubview:secendBtn];
    
    // 获取播放进度
    __weak __typeof(self) weakSelf = self;
    [playerView aVPlayerProgress:^(CGFloat scale, NSTimeInterval currentTime, NSTimeInterval totalTime) {
        // 设置显示的时间：以00:00:00的格式
        int secend = (int)(totalTime - currentTime) % 60;
        NSString *currentTimeStr = [NSString stringWithFormat:@"%ds",secend];
        
        [secendBtn setTitle:currentTimeStr forState:UIControlStateNormal];
        
        NSLog(@"当前的播放时间: %@", currentTimeStr);
    }];
    return backView;
    
}

// 策底没速度了调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == SCR_WIDTH) {
        [self.playerView start];
    }
    if (scrollView.contentOffset.x == 0) {
        [self.playerView pause];
    }
}

@end
