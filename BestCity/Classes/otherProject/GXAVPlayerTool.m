//
//  GXAVPlayerTool.m
//  GXLCodeRepository
//
//  Created by JsonBourne on 2020/4/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "GXAVPlayerTool.h"

@interface GXAVPlayerTool ()
/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;

/** 监听当前播放时间 */
@property (nonatomic, assign) id timerObserver;

/** 返回播放器的状态 */
@property (nonatomic, strong) void (^avplayerStatusBlock)(AVPlayerStatus, AVPlayerItem *);

// 内存管理
/** 是否添加了status观察者 */
@property (nonatomic, assign) BOOL isAddObserveStatus;
@end


@implementation GXAVPlayerTool

#pragma mark - 创建AVPlayer
+ (instancetype)aVPlayerFrame:(CGRect)frame andURLStr:(NSString *)url
{
    GXAVPlayerTool *toolView = [[GXAVPlayerTool alloc] initWithFrame:frame];
    
    // 第1步: 获取播放地址URL, 创建item
    NSString *localFilePath = url;
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:localVideoUrl];
    
    // 第2步: 创建播放器
    toolView.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    // 第3步: 创建显示视频的AVPlayerLayer,设置视频显示属性，并添加视频图层
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:toolView.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect; // 等比例  默认
//    avLayer.backgroundColor = [UIColor cyanColor].CGColor;
    avLayer.frame = CGRectMake(0, 0, toolView.width, toolView.height);
    [toolView.layer addSublayer:avLayer];
    
    return toolView;
}

#pragma mark - 监听Status属性
- (void)aVAddObserverStatus:(void (^)(AVPlayerStatus status, AVPlayerItem *playerItem))avplayerStatusBlock
{
    // 是否添加了观察者
    self.isAddObserveStatus = YES;
    
    // 添加属性观察, 观察Status属性，可以在加载成功之后得到视频的长度
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.avplayerStatusBlock = ^(AVPlayerStatus status, AVPlayerItem *playerItem) {
        avplayerStatusBlock(status, playerItem);
        NSLog(@"%ld", status);
    };
}

#pragma mark - 监听取缓存进度, loadedTimeRanges实现缓冲进度条
- (void)aVAddObserverBuffer
{
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark - 监听播放进度与状态的刷新
- (void)aVPlayerProgress:(void (^)(CGFloat scale, NSTimeInterval currentTime, NSTimeInterval totalTime))block
{
    __weak __typeof(self) weakSelf = self;
    self.timerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        // 当前播放的时间
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        
        // 视频的总时间
        NSTimeInterval totalTime = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        
        // 设置滑块的当前进度
        CGFloat scale = currentTime / totalTime;

        block(scale, currentTime, totalTime);
    }];
}

// 添加属性观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        // 观察Status属性，可以在加载成功之后得到视频的长度
        switch (status) {
               case AVPlayerStatusReadyToPlay:
               {
                   NSLog(@"资源加载成功");
                   self.avplayerStatusBlock(AVPlayerStatusReadyToPlay, (AVPlayerItem *)object);
                   break;
               }
               case AVPlayerStatusFailed:
               {
                   NSLog(@"资源加载失败，点击继续尝试加载");
                   self.avplayerStatusBlock(AVPlayerStatusReadyToPlay, (AVPlayerItem *)object);
                   break;
               }
               case AVPlayerStatusUnknown:{
                   NSLog(@"加载遇到未知问题:AVPlayerStatusUnknown");
                   self.avplayerStatusBlock(AVPlayerStatusReadyToPlay, (AVPlayerItem *)object);
                   break;
               }
               default:
                   break;
           }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 观察loadedTimeRanges，可以获取缓存进度，实现缓冲进度条
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        
        //获取视频缓冲进度数组，这些缓冲的数组可能不是连续的
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        
        //获取最新的缓冲区间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        
        //缓冲区间的开始的时间
        NSTimeInterval loadStartSeconds = CMTimeGetSeconds(timeRange.start);
        
        //缓冲区间的时长
        NSTimeInterval loadDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        
        //当前视频缓冲时间总长度
        NSTimeInterval currentLoadTotalTime = loadStartSeconds + loadDurationSeconds;
        NSLog(@"开始缓冲:%f, 缓冲时长:%f, 总时间:%f", loadStartSeconds, loadDurationSeconds, currentLoadTotalTime);
        
        //更新显示：当前缓冲总时长
        NSString *allBufferTime = [self formatTimeWithTimeInterVal:currentLoadTotalTime];
        NSLog(@"当前缓冲总时长: %@", allBufferTime);
        
        //更新显示：视频的总时长
        NSString *allTime = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(self.player.currentItem.duration)];
        NSLog(@"视频的总时长: %@", allTime);
        
        //更新显示：缓冲进度条的值
        CGFloat scale = currentLoadTotalTime / CMTimeGetSeconds(self.player.currentItem.duration);
        NSLog(@"缓冲进度条的值: %lf", scale);
    }
}

#pragma mark - /** 播放 */
- (void)start
{
    [self.player play];
}

#pragma mark - /** 暂停 */
- (void)pause
{
    [self.player pause];
}

#pragma mark - /** 停止 */
- (void)stop
{
    [self.player.currentItem seekToTime:kCMTimeZero];
    [self.player pause];
}

#pragma mark - 监听播放完毕, 视频循环播放
- (void)moviePlayDidEndThenLoopIt
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

// 视频循环播放
- (void)moviePlayDidEnd:(NSNotification*)notification
{
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - 设置视频播放位置
- (void)aVplayerToTime:(NSTimeInterval)time
{
    if(self.player.status == AVPlayerStatusReadyToPlay){
        NSTimeInterval playTime = time;
        CMTime seekTime = CMTimeMake(playTime, 1);
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
        }];
    }
}


#pragma mark - 转换时间格式的方法
- (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0;
    int hour = 0;
    int secend = timeInterVal;
    hour = secend / 3600;
    minute = (secend % 3600) / 60;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

#pragma mark - 内存管理
- (void)dealloc
{
    // 移除时，调用removeTimeObserver
    [self.player removeTimeObserver:self.timerObserver];
    
    if (self.isAddObserveStatus) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
}

/**
     注意：使用addPeriodicTimeObserverForInterval必须持有返回对象，且在不需要播放器的时候移除此对象；
     否则将会导致undefined behavior，这一点可以从文档是这样说明的：
     You must retain this returned value as long as you want the time observer to be invoked by the player.
     Pass this object to -removeTimeObserver: to cancel time observation.
     Releasing the observer object without a call to -removeTimeObserver: will result in undefined behavior
 */

@end
