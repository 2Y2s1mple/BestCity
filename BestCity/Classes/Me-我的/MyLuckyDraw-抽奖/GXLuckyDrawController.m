//
//  GXLuckyDrawController.m
//  抽奖
//
//  Created by JasonBourne on 2018/8/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "GXLuckyDrawController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "CZUserInfoTool.h"


@interface GXLuckyDrawController ()
@property (weak, nonatomic) IBOutlet UIView *luckyView;
@property (weak, nonatomic) IBOutlet UIImageView *luckyBackImage;

/** 所有奖品 */
@property (nonatomic, strong) NSArray *allPrizes;

/** 记录 */
@property (nonatomic, strong) UIView *recordMaskView;

/** 快速定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 记录选中的ID */
@property (nonatomic, assign) NSInteger selectedID;

/** 弹出的中奖界面 */
@property (nonatomic, strong) UIView *congratulation;

/** 中奖界面图片 */
@property (nonatomic, strong) UIImageView *congratulationImage;

/**
 * 星期一到星期天全部按钮
 */
@property (weak, nonatomic) IBOutlet UIImageView *monLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friLabel;
@property (weak, nonatomic) IBOutlet UIImageView *satLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sunLabel;

/** 星期字典 */
@property (nonatomic, strong) NSDictionary *weekDic;

/** 获取签到的数组 */
@property (nonatomic, strong) NSMutableArray *signArr;

/** 得到补签后的积分 */
@property (nonatomic, assign) NSInteger signedPoint;

/** 弹出奖励的序号 */
@property (nonatomic, assign) NSInteger luckIndex;

/** 判断能不能抽奖 */
@property (nonatomic, assign) BOOL isLuckyDraw;

/** 抽奖图片 */
@property (nonatomic, strong) NSMutableArray *imagesArr;

@end

@implementation GXLuckyDrawController

/** 抽奖图片的数组 */
- (NSMutableArray *)imagesArr
{
    if (_imagesArr == nil) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

#pragma mark - 签到
- (IBAction)signInAction
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/signInsert"];
    
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        
//        NSLog(@"result ----- %@", result);
        if ([result[@"msg"] isEqualToString:@"success"]) {
           
            // 获取签到数据
            [self setupSignIn:GXLuckyShowCongratulationSignIn];
            
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        [CZProgressHUD hideAfterDelay:2];
        
    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
    }];
}

#pragma mark - 一键补签
- (IBAction)compensationSignIn
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //USERINFO[@"userId"]
    param[@"userId"] = USERINFO[@"userId"];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/Supplement"];
    
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        
//        NSLog(@"result ----- %@", result);
        if ([result[@"msg"] isEqualToString:@"补签成功"]) {
            self.signedPoint = [result[@"point"] integerValue];
            // 获取签到数据
            [self setupSignIn:GXLuckyShowCongratulationSignedIn];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        [CZProgressHUD hideAfterDelay:2];
        
    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"签到" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    
    // 设置签到
    [self signIn];
    
    // 设置抽奖界面
    [self setupluckyView];
    
    
    // 获取抽奖信息
    [self getLucklyImage];
    
 
}

#pragma mark - 获取抽奖的图片
- (void)getLucklyImage
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/luckselects"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
//        NSLog(@"result ----- %@", result);
        if ([result[@"msg"] isEqualToString:@"success"]) {
            for (NSDictionary *dic in result[@"list"]) {
                [self.imagesArr addObject:dic[@"code_img"]];
//                NSLog(@"%@", self.imagesArr);
            }
            for (int i = 0; i < self.imagesArr.count; i++) {
                NSInteger index = [self.allPrizes[i] integerValue];
                UIButton *btn = (UIButton *)[self.luckyBackImage viewWithTag:index];
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.imagesArr[i]] forState:UIControlStateNormal];
            }
            
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
    }];
}



#pragma mark - 设置抽奖界面
- (void)setupluckyView
{
    CGFloat bkW = self.luckyBackImage.width;
    CGFloat W = (self.luckyBackImage.width - (4 * 4) - 20) / 3;
    CGFloat H = (self.luckyBackImage.height - (4 * 4) - 24) / 3;
    
    //创建中间按钮
    UIButton *centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"bj-yewllo"] forState:UIControlStateNormal];
    centerBtn.center = CGPointMake(bkW / 2, (bkW - 4) / 2);
    [self.luckyBackImage addSubview:centerBtn];
    [centerBtn addTarget:self action:@selector(loadRequestLucy:) forControlEvents:UIControlEventTouchUpInside];
//     [centerBtn addTarget:self action:@selector(luckyAction:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *btnWord = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word-lucky"]];
    btnWord.center = CGPointMake(centerBtn.width / 2, centerBtn.height / 2);
    [centerBtn addSubview:btnWord];
    
    //创建周边的按钮
    CGFloat roundX = 14;
    CGFloat roundY = 14;
    
    //当前的行数
    NSInteger line = 0;
    //当前的列数
    NSInteger list = 0;
    for (int i = 0; i < 8; i++) {
        line = (i > 3 ? i + 1 : i) / 3;
        list = (i > 3 ? i + 1 : i) % 3;
        
        UIButton *roundBtn = [[UIButton alloc] initWithFrame:CGRectMake(roundX + (list * (4 + W)), line * (4 + H) + roundY, W, H)];
        [roundBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"prize-%d", i]] forState:UIControlStateNormal];
        UIView *selectedView = [[UIView alloc] initWithFrame:roundBtn.bounds];
        selectedView.backgroundColor = [UIColor grayColor];
        selectedView.alpha = 0.7;
        selectedView.hidden = YES;
        selectedView.tag = 10;
        [roundBtn addSubview:selectedView];
        roundBtn.tag = i + 100;
        [self.luckyBackImage addSubview:roundBtn];
    }
}


#pragma mark - 初始化签到
- (void)signIn{
    // 获取当前的星期
    NSArray *weekdays = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期天"];
    // 查询当前日期在上面的数组中位置index
    NSInteger weeksdayIndex = [weekdays indexOfObject:[self weekdayStringFromDate:[NSDate date]]];
    // 当前位置之前的为补签图片
    for (int i = 0; i < weeksdayIndex; i++) {
        UIImageView *imageView = [self.weekDic objectForKey:weekdays[i]];
        imageView.image = [UIImage imageNamed:@"sign in-supplement"];
    }

    // 查询签到数据
    [self setupSignIn:GXLuckyShowCongratulationsDefault];
}


- (NSArray *)allPrizes
{
    if (_allPrizes == nil) {
        _allPrizes = @[@"100", @"101", @"102", @"104", @"107", @"106", @"105", @"103"];
    }
    return _allPrizes;
}

#pragma mark - 网络请求数据抽奖数据
- (void)loadRequestLucy:(UIButton *)sender
{
    // 判断能不能抽奖
    if (!self.isLuckyDraw) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"userId"] = USERINFO[@"userId"];
        NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/luckselect"];
        
        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            
//            NSLog(@"result ----- %@", result);
            if ([result[@"msg"] isEqualToString:@"success"]) {
                // 减 1
                self.luckIndex = [result[@"list"][0][@"code"] integerValue] - 1;
                // 抽奖
                [self luckyAction:sender];
            } else {
                [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
                [CZProgressHUD hideAfterDelay:2];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [CZProgressHUD showProgressHUDWithText:@"请签满7天再抽奖"];
        [CZProgressHUD hideAfterDelay:2];
    }
    
}

#pragma mark - 抽奖按钮
- (void)luckyAction:(UIButton *)sender
{
    // 添加蒙版
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    // 按钮点击禁止
    sender.enabled = NO;
    // 上一次点停留的
    __block NSInteger index = self.selectedID;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (index > self.allPrizes.count - 1) {
            index = 0;
        };
        
        // 设置选中项
        [self setupSelectedIndex:index++];
    }];
    
    // 控制的角标
    NSInteger test = arc4random() % 8;// self.luckIndex;
    
//    NSLog(@"---%ld", (long)test);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self. timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
            if (index > self.allPrizes.count - 1) {
                index = 0;
            };
            
            // 暂停定时器
            if (index == test) {
                self.selectedID = test;
                [self.timer invalidate];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 激活按钮
                    sender.enabled = YES;
                    //开启奖励界面
                    [self setupCongratulationsWithImage:[UIImage imageNamed:@"kettle"] param:@{@"image" : self.imagesArr[test]}];
                    
                    // 关闭蒙版
                    [backView removeFromSuperview];
                });
            }
            
            //设置选中项
            [self setupSelectedIndex:index++];
 
        }];
    });
}

/**
 * 设置选中的项目
 */
- (void)setupSelectedIndex:(NSInteger)index
{
    //前一个选中项隐藏
    self.recordMaskView.hidden = !self.recordMaskView.hidden;
    
    //拿到选中项
    UIButton *btn = (UIButton *)[self.luckyBackImage viewWithTag:[self.allPrizes[index] integerValue]];
    UIView *maskView = (UIView *)[btn viewWithTag:10];
    maskView.hidden = !maskView.hidden;
    
    //记录选中项
    self.recordMaskView = maskView;
}

#pragma mark - 弹出或关闭奖励
- (void)setupCongratulationsWithImage:(UIImage *)image param:(NSDictionary *)param
{
    //透明的背景
    self.congratulation = [[UIView alloc] initWithFrame:self.view.bounds];
    self.congratulation.backgroundColor = [UIColor blackColor];
    self.congratulation.alpha = 0.7;
    
    //背景上面图片
    _congratulationImage = [[UIImageView alloc] initWithImage:image];
    _congratulationImage.center = CGPointMake(self.congratulation.width / 2, self.congratulation.height / 2);
    
    // 图片上的文字
    if (param[@"title"]) {
        UILabel *imageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
        imageLabel1.center = CGPointMake(_congratulationImage.width / 2, _congratulationImage.height / 2 + 30);
        imageLabel1.text = param[@"title"];
        imageLabel1.textAlignment = NSTextAlignmentCenter;
        imageLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        imageLabel1.textColor = [UIColor colorWithRed:104/255.0 green:95/255.0 blue:161/255.0 alpha:1];
        
        UILabel *imageLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        imageLabel2.center = CGPointMake(imageLabel1.center.x, imageLabel1.center.y + 30);
        imageLabel2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        imageLabel2.textAlignment = NSTextAlignmentCenter;
        imageLabel2.textColor = imageLabel1.textColor;
        imageLabel2.text = param[@"subTitle"];
        
        [_congratulationImage addSubview:imageLabel1];
        [_congratulationImage addSubview:imageLabel2];
    }
    
    if (param[@"image"]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 86, 74)];
        imageView.center = CGPointMake(_congratulationImage.width / 2, _congratulationImage.height / 2 - 10);
        [imageView sd_setImageWithURL:[NSURL URLWithString:param[@"image"]]];
        [_congratulationImage addSubview:imageView];
    }
    
    //取消按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(CGRectGetMaxX(_congratulationImage.frame) - 40, CGRectGetMinY(_congratulationImage.frame) - 50, 50, 50);
    [btn addTarget:self action:@selector(closeCongratulationView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.congratulation];
    [[UIApplication sharedApplication].keyWindow addSubview:_congratulationImage];
    [[UIApplication sharedApplication].keyWindow addSubview:btn];
   
}

- (void)closeCongratulationView:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self.congratulation removeFromSuperview];
    [_congratulationImage removeFromSuperview];
}

/** 获取签到的数组 */
- (NSMutableArray *)signArr
{
    if (_signArr == nil) {
        _signArr = [NSMutableArray array];
    }
    return _signArr;
}

/** 星期字典 */
- (NSDictionary *)weekDic
{
    if (_weekDic == nil) {
        _weekDic = @{
                     @"星期一" : self.monLabel,
                     @"星期二" : self.tueLabel,
                     @"星期三" : self.wedLabel,
                     @"星期四" : self.thuLabel,
                     @"星期五" : self.friLabel,
                     @"星期六" : self.satLabel,
                     @"星期天" : self.sunLabel,
                     };
    }
    return _weekDic;
}

#pragma mark - 查询签到数据
- (void)setupSignIn:(GXLuckyShowCongratulationsType)type
{
    self.signArr = nil;
    
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/sign"];
    // 请求
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
//            NSLog(@"%@", result);
            NSArray *data =  result[@"list"];
            for (NSDictionary *dic in data) {
                [self.signArr addObject:dic[@"arrays_time"]];
            }
            
            switch (type) {
                case GXLuckyShowCongratulationSignIn:// 签到
                    // 弹出奖励
                    [self setupCongratulationsWithImage:[UIImage imageNamed:@"sign in"] param:@{@"title" : @"恭喜您签到成功", @"subTitle" : @"+3积分"}];
                    break;
                    
                case GXLuckyShowCongratulationSignedIn:
                    // 弹出奖励
                    [self setupCongratulationsWithImage:[UIImage imageNamed:@"sign in"] param:@{@"title" : @"恭喜您补签成功！", @"subTitle" : [NSString stringWithFormat:@"-%ld积分", self.signedPoint]}];
                    break;
                default:
                    break;
            }
            
            // 判断能不能抽奖
            self.isLuckyDraw = self.signArr.count == 7;
            
            
            for (NSString *week in self.signArr) {
                UIImageView *imageView = [self.weekDic objectForKey:week];
                imageView.image = [UIImage imageNamed:@"sign in-complete"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


@end
