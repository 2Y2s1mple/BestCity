//
//  CZSub2FreeChargeSubDetailView.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub2FreeChargeSubDetailView.h"
#import "GXNetTool.h"

@interface CZSub2FreeChargeSubDetailView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *ruleBtn;
/**  */
@property (nonatomic, weak) IBOutlet UILabel *buyPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *volume;
@property (nonatomic, weak) IBOutlet UILabel *titleName;
@property (nonatomic, weak) IBOutlet UILabel *feeMoney;
/** 返现数 */
@property (nonatomic, weak) IBOutlet UILabel *downFeeLabel;
/** 优惠券View */
@property (nonatomic, weak) IBOutlet UIView *couponView;
@end

@implementation CZSub2FreeChargeSubDetailView

+ (instancetype)sub2FreeChargeSubDetailView
{
    CZSub2FreeChargeSubDetailView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getGoodsURl)];
    [self.couponView addGestureRecognizer:tap];
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    self.buyPriceLabel.text = [NSString stringWithFormat:@"%@", param[@"buyPrice"]];
    
    NSString *therPrice = [NSString stringWithFormat:@"¥%.2f", [param[@"otherPrice"] floatValue]];
    self.otherPriceLabel.attributedText = [therPrice addStrikethroughWithRange:[therPrice rangeOfString:therPrice]];
    
    self.volume.text = [NSString stringWithFormat:@"已售%@", param[@"volume"]];
    
    self.titleName.text = param[@"otherName"];
    
    self.feeMoney.text = [NSString stringWithFormat:@"付￥%.2f，返¥%.2f", [param[@"actualPrice"] floatValue], [param[@"fee"] floatValue]];
    
    self.downFeeLabel.text = [NSString stringWithFormat:@"您当前需要支付￥%.2f，返现￥%.2f将在确认收货后进行结算", [param[@"actualPrice"] floatValue], [param[@"fee"] floatValue]];
    
    [self layoutIfNeeded];
    self.height = CZGetY(self.ruleBtn) + 10;
}


// 获取购买的URL
- (void)getGoodsURl
{
    NSString *ID = self.param[@"otherGoodsId"];
    
    // 淘宝授权
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
        if (isAuthTaobao) {
           NSMutableDictionary *param = [NSMutableDictionary dictionary];
           param[@"otherGoodsId"] = ID;
           [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/free/apply?"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
               if ([result[@"msg"] isEqualToString:@"success"]) {
                   [CZJIPINSynthesisTool jipin_jumpTaobaoWithUrlString:result[@"data"]];
               } else {
                   [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
                   [CZProgressHUD hideAfterDelay:1.5];
               }
           } failure:^(NSError *error) {

           }];
        }
    }];
}

/** 规则 */
- (IBAction)rule
{
    [CZFreePushTool generalH5WithUrl:@"https://www.jipincheng.cn/new-free/mdRule" title:@"新人免单活动规则" containView:nil];
    NSLog(@"《隐私政策》---------------");
}

@end
