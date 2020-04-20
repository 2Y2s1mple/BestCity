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
    for (int i = 0; i  <= count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.x = SCR_WIDTH * i;
        imageView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT);
        [scrollerView addSubview:imageView];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i]];
    }
    
    // 加载视频
    [scrollerView addSubview:[self createVideo]];
    
    scrollerView.contentSize = CGSizeMake(SCR_WIDTH * (count + 1), 0);
    
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"guide0-3"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.x = SCR_WIDTH + 30;
    btn.y = SCR_HEIGHT - 44 - 40;
    [scrollerView addSubview:btn];
    [btn addTarget:self action:@selector(videoPlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"guide0-4"] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    btn1.x = SCR_WIDTH * 2 - 30 - btn1.width;
    btn1.y = SCR_HEIGHT - 44 - 40;
    [scrollerView addSubview:btn1];
    [btn1 addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    
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
    videoView.size = CGSizeMake(245, 490);
    videoView.centerX = SCR_WIDTH / 2.0;
    videoView.y = 65;
//    videoView.backgroundColor = RANDOMCOLOR;
    [backView addSubview:videoView];
    
    UIImage *image = [UIImage imageNamed:@"guide0-2"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [videoView addSubview:imageView];
    
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
