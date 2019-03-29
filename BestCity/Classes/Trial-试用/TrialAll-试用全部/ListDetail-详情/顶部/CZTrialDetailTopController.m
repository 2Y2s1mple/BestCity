//
//  CZTrialDetailTopController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialDetailTopController.h"
#import "CZScollerImageTool.h"

@interface CZTrialDetailTopController ()
@property (nonatomic, weak) IBOutlet UIView *imageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *contentTitle;
/** 试用数量 */
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
/** 市场价 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/** 申请人数 */
@property (nonatomic, weak) IBOutlet UILabel *applyUserCountLabel;
/** 申请条件 */
@property (nonatomic, weak) IBOutlet UILabel *applyPointLabel;
/** 试用 */
@property (nonatomic, weak) IBOutlet UILabel *testLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *timerView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *day1;
@property (nonatomic, weak) IBOutlet UILabel *day2;

@property (nonatomic, weak) IBOutlet UILabel *hours1;
@property (nonatomic, weak) IBOutlet UILabel *hours2;

@property (nonatomic, weak) IBOutlet UILabel *minutes1;
@property (nonatomic, weak) IBOutlet UILabel *minutes2;

@property (nonatomic, weak) IBOutlet UILabel *seconds1;
@property (nonatomic, weak) IBOutlet UILabel *seconds2;

/** 一共多少秒 */
@property (nonatomic, assign) NSInteger secondsCount;


/** <#注释#> */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CZTrialDetailTopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, self.imageView.height)];
    [self.imageView addSubview:imageView];
    imageView.imgList = self.detailData[@"imgList"];
    
    // 标题
    self.contentTitle.text = self.detailData[@"name"];
    /** 试用数量 */
    self.countLabel.text = [NSString stringWithFormat:@"%@", self.detailData[@"count"]];
    /** 市场价 */
    self.actualPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.detailData[@"actualPrice"]];
    /** 申请人数 */
    self.applyUserCountLabel.text = [NSString stringWithFormat:@"%@", self.detailData[@"applyUserCount"]];
    /** 申请条件 */
    self.applyPointLabel.text = [NSString stringWithFormat:@"%@", self.detailData[@"applyPoint"]];
    
    
    //试用label
    self.testLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    
    
    //2进行中 3试用中，4结束
    NSString *status = self.detailData[@"status"];
    switch ([status integerValue]) {
        case 2:
        {
            self.timerView.hidden = NO;
            self.testLabel.hidden = YES;
            break;
        }
        case 3: //3试用中
        {
            self.timerView.hidden = YES;
            self.testLabel.hidden = NO;
            self.testLabel.text = @"试用中";
            break;
        }
        case 4:
        {
            self.timerView.hidden = YES;
            self.testLabel.hidden = NO;
            self.testLabel.text = @"已结束 ";
            break;
        }   
        default:
            break;
    }
    
    NSInteger secondsNumber = [self.detailData[@"endtimeObj"][@"seconds"] integerValue];
    
    NSInteger minutesNumber = [self.detailData[@"endtimeObj"][@"minutes"] integerValue] * 60;
    NSInteger hoursNumber = [self.detailData[@"endtimeObj"][@"hours"] integerValue] * 60 * 60;
    NSInteger dayNumber = [self.detailData[@"endtimeObj"][@"day"] integerValue] * 60 * 60 * 24;
    
    self.secondsCount = secondsNumber + minutesNumber + hoursNumber + dayNumber;
    
    [self setupTimer]; 

    if (self.secondsCount > 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupTimer) userInfo:nil repeats:YES];
    }
    
    [self.view layoutIfNeeded];
    self.view.x = 0;
    self.view.y = 0;
    self.view.width = SCR_WIDTH;
    self.view.height = CZGetY(self.lineView);
}

- (void)setupTimer
{
    
    // 秒
    NSString *seconds1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount % 60)];
    self.seconds1.text = [seconds1 substringToIndex:1];
    self.seconds2.text = [seconds1 substringFromIndex:1];
    
    // 分
    NSString *minutes1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount / 60 % 60)];
    self.minutes1.text = [minutes1 substringToIndex:1];
    self.minutes2.text = [minutes1 substringFromIndex:1];
    
    // 时
    NSString *hours1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount / 60 / 60 % 24)];
    self.hours1.text = [hours1 substringToIndex:1];
    self.hours2.text = [hours1 substringFromIndex:1];
    
    // 天 
     NSString *day1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount / 60 / 60 / 24)];
    self.day1.text = [day1 substringToIndex:1];
    self.day2.text = [day1 substringFromIndex:1];
    
    self.secondsCount--;
}

- (void)dealloc
{
    [self.timer invalidate];
}
@end
