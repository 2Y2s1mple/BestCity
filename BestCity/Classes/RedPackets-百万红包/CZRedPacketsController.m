//
//  CZRedPacketsController.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/18.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsController.h"
#import "CZRedPacketsView.h"
#import "GXNetTool.h"


@interface CZRedPacketsController ()
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;

/** <#注释#> */
@property (nonatomic, weak) CZRedPacketsView *redView;
@end

@implementation CZRedPacketsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RANDOMCOLOR;

    // 创建滚动视图
    [self.view addSubview:self.scrollView];

    // 创建上部view
    [self topView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取数据
    [self getDataSource];
}

#pragma mark - 数据
- (void)getDataSource
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/index"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];
        }
    } failure:^(NSError *error) {

    }];
}


- (void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    self.redView.model = dataSource;

    if ([self.redView.hongbaoView.subviews count] > 0) {
        return;
    }

    CGFloat width =  83;
    CGFloat height = 103;
    CGFloat spaceW = (self.redView.hongbaoView.width - 3 * width) / 2.0;
    CGFloat spaceH = (self.redView.hongbaoView.height - 3 * height) / 2.0;

    for (int i = 0; i < 9; i++) {
        NSDictionary *dic = dataSource[@"hongbaoList"][i];
        UIView *hongbaoView;
        switch ([dic[@"status"] integerValue]) {
            case 0: // 待邀请
            {
                hongbaoView = [self createCaiHongBaoViewWithImageName:@"redPackets-7" status:0];
                break;
            }
            case 1: // 待领取
            {
                hongbaoView = [self createCaiHongBaoViewWithImageName:@"redPackets-8" status:1];
                break;
            }
            case 2: // 已领取
            {
                hongbaoView = [self createCaiHongBaoViewWithImageName:@"redPackets-8" status:2];
                break;
            }
            default:
                break;
        }
        hongbaoView.x = (width + spaceW) * (i % 3);
        hongbaoView.y = (height + spaceH) * (i / 3);
        hongbaoView.width = width;
        hongbaoView.height = height;

        [self.redView.hongbaoView addSubview:hongbaoView];
    }


}

#pragma mark - 创建UI
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49));
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}


- (void)topView
{
    // 第一部分
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = UIColorFromRGB(0xE04625);
    topView.size = CGSizeMake(SCR_WIDTH, 0);
    [self.scrollView addSubview:topView];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.size = CGSizeMake(SCR_WIDTH, 463);
    imageView.image = [UIImage imageNamed:@"redPackets-1"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [topView addSubview:imageView];

    CZRedPacketsView *redView = [CZRedPacketsView redPacketsView];
    redView.y = (IsiPhoneX ? 44 : 20) + 25;
    [topView addSubview:redView];
    self.redView = redView;

    topView.height = CZGetY(redView);


    CGFloat maxHeight = CZGetY([self.scrollView.subviews lastObject]);
    self.scrollView.contentSize = CGSizeMake(0, maxHeight);

}

// 创建拆红包视图
- (UIView *)createCaiHongBaoViewWithImageName:(NSString *)imageName status:(NSInteger)status
{
    // 最外第一层
    UIView *backView = [[UIView alloc] init];
    backView.width = 83;
    backView.height = 104;

    // 第二层
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:imageName];
    image.frame = backView.bounds;
    [backView addSubview:image];

    // 第三层
    switch (status) {
        case 0: // 待邀请
        {

            break;
        }
        case 1: // 待领取
        {

            break;
        }
        case 2: // 已领取
        {

            break;
        }
        default:
            break;
    }
    NSString *text = [NSString stringWithFormat:@"%@元/位", @"7"];

    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0xFDE9D0);
    label.font = [UIFont fontWithName:@"PingFangSC-Bold" size: 15];
    label.attributedText = [text addAttributeFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 23]  Range:[text rangeOfString:@"7"]];
    [label sizeToFit];
    label.y = 17;
    label.centerX = 83 / 2.0;

    [backView addSubview:label];

    return backView;
}
@end
