//
//  CZTitlesViewTypeLayout.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/17.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTitlesViewTypeLayout.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

@interface CZTVTLayoutBtn ()
/** <#注释#> */
@property (nonatomic, assign) NSInteger type;
@end

@implementation CZTVTLayoutBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    }
    return self;
}

- (void)setType:(NSInteger)type
{
    _type = type;
    switch (type) {
        case 4: // 纯图片按钮
        {
            [self setImage:[UIImage imageNamed:@"search_line"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"search_cols"] forState:UIControlStateSelected];
            break;
        }
        case 1: // 文字加图片
        {
            [self setImage:[UIImage imageNamed:@"search_asc_non"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"search_asc"] forState:UIControlStateSelected];
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            break;
        }
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    } else {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    }
}
@end


@interface CZTitlesViewTypeLayout ()
/** 记录点击的btn */
@property (nonatomic, strong) CZTVTLayoutBtn *recordBtn;
/** 记录正序按钮点击了几次 */
@property (nonatomic, assign) NSInteger recoredBtnClick;
/** YES 正序 */
@property (nonatomic, assign) BOOL isASC;

/** 是否是条形布局 */
@property (nonatomic, assign) BOOL islayoutLine;
@end

@implementation CZTitlesViewTypeLayout

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isASC = YES;
        self.islayoutLine = YES;
        [self createTitles];

    }
    return self;
}

- (void)createTitles
{
    CGFloat leftRightSpace = 20;
    CGFloat itemWidth = 42;
    CGFloat space = (SCR_WIDTH - 2 *leftRightSpace - itemWidth * 5) / 4;

    NSArray *list = @[@"综合", @"价格", @"返现", @"销量", @""];
    for (int i = 0; i < list.count; i++) {
        CZTVTLayoutBtn *btn = [[CZTVTLayoutBtn alloc] init];
        btn.type = i;
        btn.tag = i;
        btn.x = leftRightSpace + i * (itemWidth + space);
        btn.width = itemWidth;
        btn.height = 38;
        [btn setTitle:list[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            self.recordBtn = btn;
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    // 获取数据
}

- (void)titleAction:(CZTVTLayoutBtn *)sender
{

    if (sender.tag == 4) {
        if (sender.isSelected) { // 线性排布
            self.islayoutLine = YES;
            sender.selected = NO;
        } else { // 非线性排布
            self.islayoutLine = NO;
            sender.selected = YES;
        }
        self.blcok(self.islayoutLine, self.isASC, sender.tag);
        return;
    }

    if (sender.tag == 1) {
        if (self.isASC) { // 正序
            self.blcok(self.islayoutLine, self.isASC, sender.tag);
            [sender setImage:[UIImage imageNamed:@"search_asc"] forState:UIControlStateSelected];
            self.isASC = NO;
        } else {
            self.blcok(self.islayoutLine, self.isASC, sender.tag);
            [sender setImage:[UIImage imageNamed:@"search_nasc"] forState:UIControlStateSelected];
            self.isASC = YES;
        }
    } else { // 点了其他的默认改回升序
        self.isASC = YES;
        self.blcok(self.islayoutLine, self.isASC, sender.tag);
    }

    self.recordBtn.selected = NO;
    sender.selected = YES;
    self.recordBtn = sender;

}



- (void)downloadFile {

  NSString *url = @"http://test.service.jdimage.cn/dcm/download/91330482307418997W.file?objectKey=/91330482307418997W/2018/12/04/CT/acdc8243d1724acefe2c6369ed901ce1/film/MR22035.bmp";
  NSURL *URL = [NSURL URLWithString:url];
  //1.创建管理者
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

   // 构建HEAD请求
    NSMutableURLRequest *headRequest = [NSMutableURLRequest requestWithURL:URL];
    [headRequest setHTTPMethod:@"HEAD"];
    // 清空Accept-Encoding请求头字段，不接受Gzip压缩
    [headRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];

    NSURLSessionDataTask *headTask = [manager dataTaskWithRequest:headRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        // 第一步
        // 设置总数已经监听数据下载了多少
        long long totalUnitCount = response.expectedContentLength;
        NSLog(@"%lld", totalUnitCount);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            // 一共下载的数totalBytesWritten
//            NSLog(@"---totalBytesExpectedToWrite : %lli, totalBytesWritten : %lli", totalBytesExpectedToWrite, totalBytesWritten);
            //胖胖提醒: 注意这个地方不是主线程 *****************
            NSString *progress = [NSString stringWithFormat:@"下载:%f%%",100.0 * totalBytesWritten / totalUnitCount];
            NSLog(@"%@", progress);


        }];

        // 第二步, 常规操作, 监听下载完成后, 文件放到哪里
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            //拼接文件全路径
            NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
            NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];

            return filePathUrl;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {

            }
            if(filePath){ // 第三步, 肯定下载完成后, 把图片赋值, 就好了, 希望胖糊能看得明白,
                NSLog(@"filePath : %@", filePath);

                UIImageView *imageView =[[UIImageView alloc] init];
                imageView.width = 200;
                imageView.height = 200;
                imageView.image = [UIImage imageWithContentsOfFile:filePath.path];

                [[UIApplication sharedApplication].keyWindow addSubview:imageView];

            }
        }];
        [downloadTask resume];




    }];
    [headTask resume];

}
@end
