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
#import "CZRedPacketsAlertView.h"


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
    self.view.backgroundColor = [UIColor whiteColor];

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
    if ([JPTOKEN length] <= 0) {
        self.redView.isNoLogin = YES;
    } else {
        self.redView.isNoLogin = NO;
        // 获取弹框
        [self popAlert];
    }
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

// 获取弹框
- (void)popAlert
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/getPopInfo"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"][@"popId"] length] > 0) {
                // 显示获得新人红包
                CURRENTVC(currentVc);
                CZRedPacketsAlertView *alert1 = [[CZRedPacketsAlertView alloc] init];
                alert1.model = result[@"data"];
                alert1.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [currentVc presentViewController:alert1 animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {

    }];
}


- (void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    self.redView.model = dataSource;



    for (UIView *subView in self.redView.hongbaoView.subviews) {
        [subView removeFromSuperview];
    }

    if ([dataSource[@"hongbaoList"] isKindOfClass:[NSNull class]]) {
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
                hongbaoView = [self createCaiHongBaoViewWithImageName:@"redPackets-7" model:dic];
                break;
            }
            case 1: // 待领取
            {
                hongbaoView = [self createCaiHongBaoViewWithImageName:@"redPackets-8" model:dic];
                break;
            }
            case 2: // 已领取
            {
                hongbaoView = [self createCaiHongBaoViewWithImageName:@"redPackets-8" model:dic];
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


    UIView *topView = [self.scrollView.subviews lastObject];
    topView.height = CZGetY(self.redView);
    CGFloat maxHeight = CZGetY([self.scrollView.subviews lastObject]);
    self.scrollView.contentSize = CGSizeMake(0, maxHeight);


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
- (UIView *)createCaiHongBaoViewWithImageName:(NSString *)imageName model:(NSDictionary *)model
{
    // 最外第一层
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openHongbao:)];
    UIView *backView = [[UIView alloc] init];
    backView.tag = [model[@"orderNum"] integerValue];
    backView.width = 83;
    backView.height = 104;
    [backView addGestureRecognizer:tap];


    // 第二层
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:imageName];
    image.frame = backView.bounds;
    [backView addSubview:image];

    // 第三层
    NSString *text;

    switch ([model[@"status"] integerValue]) {
        case 0: // 待邀请
        {
            text = [NSString stringWithFormat:@"%@元/位",model[@"addHongbao"]];
            break;
        }
        case 1: // 待领取
        {
            text = [NSString stringWithFormat:@"%@元",model[@"addHongbao"]];
            break;
        }
        case 2: // 已领取
        {
            text = [NSString stringWithFormat:@"%@元",model[@"addHongbao"]];
            break;
        }
        default:
            break;
    }

    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0xFDE9D0);
    label.font = [UIFont fontWithName:@"PingFangSC-Bold" size: 15];
    label.attributedText = [text addAttributeFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 23]  Range:[text rangeOfString:[NSString stringWithFormat:@"%@",model[@"addHongbao"]]]];
    [label sizeToFit];
    label.y = 17;
    label.centerX = 83 / 2.0;

    [backView addSubview:label];


    UILabel *label2 = [[UILabel alloc] init];
    label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    label2.text = [NSString stringWithFormat:@"邀请第%@位", model[@"orderNum"]];
    label2.textColor = [UIColor whiteColor];
    [label2 sizeToFit];
    label2.y = 78;
    label2.centerX = 83 / 2.0;
    [backView addSubview:label2];


    switch ([model[@"status"] integerValue]) {
        case 2: // 已领取
        {
            UIView *maskView = [[UIView alloc] init];
            maskView.frame = backView.bounds;
            maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            maskView.layer.cornerRadius = 5;
            [backView addSubview:maskView];

            UILabel *label = [[UILabel alloc] init];
            label.text = @"已拆";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:18];
            [label sizeToFit];
            label.center = image.center;
            [maskView addSubview:label];
            break;
        }
        default:
            break;
    }

    return backView;
}

#pragma mark - 事件
- (void)openHongbao:(UIGestureRecognizer *)tap
{
    NSLog(@"%ld", tap.view.tag);
    NSString *ID = self.dataSource[@"hongbaoList"][tap.view.tag - 1][@"id"];


    [self openHongbaoWithId:ID];

}

- (void)openHongbaoWithId:(NSString *)ID
{
    if ([ID isKindOfClass:[NSNull class]]) return;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/open"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = ID;
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [self getDataSource];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:nil];
}
@end
