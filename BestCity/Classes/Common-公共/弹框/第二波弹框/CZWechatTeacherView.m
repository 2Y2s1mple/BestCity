//
//  CZWechatTeacherView.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/24.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZWechatTeacherView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"

@interface CZWechatTeacherView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *wechatLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;

/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;
@end

@implementation CZWechatTeacherView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadNewTrailDataSorce];
}

- (IBAction)cancle:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/** 复制到剪切板 */
- (IBAction)generalPaste:(UIButton *)sender
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.dataSource[@"wechat"];
    [CZProgressHUD showProgressHUDWithText:@"复制微信成功"];
    [CZProgressHUD hideAfterDelay:1.5];
    [recordSearchTextArray addObject:posteboard.string];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/user/getParentInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];
            self.wechatLabel.text =[NSString stringWithFormat:@"微信：%@", self.dataSource[@"wechat"]];
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.dataSource[@"avatar"]]];
        } else {
            
        }
    } failure:^(NSError *error) {
    }];
}

@end
