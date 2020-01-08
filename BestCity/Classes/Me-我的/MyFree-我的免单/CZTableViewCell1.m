//
//  CZTableViewCell1.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTableViewCell1.h"
#import "UIImageView+WebCache.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import "GXNetTool.h"
#import "TSLWebViewController.h"
#import "CZUserInfoTool.h"
#import "CZOpenAlibcTrade.h"

@interface CZTableViewCell1 ()
@property (nonatomic, weak) IBOutlet UIImageView *shopImg;
@property (nonatomic, weak) IBOutlet UILabel *shopName;
@property (nonatomic, weak) IBOutlet UIImageView *itemImgView;
@property (nonatomic, weak) IBOutlet UILabel *itemTitle;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *userCountLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *btn;

@end

@implementation CZTableViewCell1
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZTableViewCell1";
    CZTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(NSDictionary *)model {
    _model = [model changeAllNnmberValue];

    [self.shopImg sd_setImageWithURL:[NSURL URLWithString:_model[@"shopImg"]]];
    self.shopName.text = [NSString stringWithFormat:@"%@赞助", _model[@"shopName"]];
    [self.itemImgView sd_setImageWithURL:[NSURL URLWithString:_model[@"img"]]];
    self.itemTitle.text = _model[@"name"];
    self.userCountLabel.text = [NSString stringWithFormat:@"剩余%ld件", [_model[@"count"] integerValue] - [_model[@"userCount"] integerValue]];
    [self.btn setTitle:[NSString stringWithFormat:@"立即购买（额外补贴%@元）", _model[@"freePrice"]] forState:UIControlStateNormal];
}

// 购买
- (IBAction)buyBtnAction
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *naVc = tabbar.selectedViewController;
    UIViewController *toVC = naVc.topViewController;
    NSString *specialId = JPUSERINFO[@"relationId"];
    if (specialId.length == 0) {
        [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
        [[ALBBSDK sharedInstance] auth:toVC successCallback:^(ALBBSession *session) {
            NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
            NSLog(@"%@", tip);
            TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@""] actionblock:^{
                [CZProgressHUD showProgressHUDWithText:@"授权成功"];
                [CZProgressHUD hideAfterDelay:1.5];
                [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];
            }];
            [tabbar presentViewController:webVc animated:YES completion:nil];

            //拉起淘宝
            AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
            showParam.openType = AlibcOpenTypeAuto;
            showParam.backUrl = @"tbopen25267281://xx.xx.xx";
            showParam.isNeedPush = YES;
            showParam.nativeFailMode = AlibcNativeFailModeJumpH5;

            [CZProgressHUD hideAfterDelay:1.5];

            [[AlibcTradeSDK sharedInstance].tradeService
             openByUrl:[NSString stringWithFormat:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=25612235&redirect_uri=https://www.jipincheng.cn/qualityshop-api/api/taobao/returnUrl&state=%@&view=wap", JPTOKEN]
             identity:@"trade"
             webView:webVc.webView
             parentController:tabbar
             showParams:showParam
             taoKeParams:nil
             trackParam:nil
             tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                 NSLog(@"-----AlibcTradeSDK------");
                 if(result.result == AlibcTradeResultTypeAddCard){
                     NSLog(@"交易成功");
                 } else if(result.result == AlibcTradeResultTypeAddCard){
                     NSLog(@"加入购物车");
                 }
             } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                 NSLog(@"----------退出交易流程----------");
             }];
        } failureCallback:^(ALBBSession *session, NSError *error) {
            NSString *tip=[NSString stringWithFormat:@"登录失败:%@",@""];
            NSLog(@"%@", tip);
        }];
    } else {
        // 打开淘宝
        [self openAlibcTradeWithId:self.model[@"goodsId"]];
    }

//    NSString *text = @"试用--商品--优惠购买";
//    NSDictionary *context = @{@"goods" : text};
//    [MobClick event:@"ID4" attributes:context];
//    NSLog(@"----%@", text);
}

- (void)openAlibcTradeWithId:(NSString *)ID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = ID;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsBuyLink"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
            UINavigationController *naVc = tabbar.selectedViewController;
            UIViewController *toVC = naVc.topViewController;
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:toVC];
        } else {
        }
    } failure:^(NSError *error) {

    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userCountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
