//
//  CZChangeSignController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZChangeSignController.h"
#import "CZNavigationView.h"
#import "DLIDEKeyboardView.h"
#import "GXNetTool.h"
#import "CZUserInfoTool.h"
#import "CZEditorTextView.h"

@interface CZChangeSignController ()
/** <#注释#> */
@property (nonatomic, strong) CZEditorTextView *textView;
/** <#注释#> */
@property (nonatomic, strong) NSString *recordText;
@end

@implementation CZChangeSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;

    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"个性签名" rightBtnTitle:@"保存" rightBtnAction:^{
        // 保存用户信息
        [self saveUserInfo];
    } ];
    [self.view addSubview:navigationView];

    [self setupTitle:CZGetY(navigationView)];

}

// 最上面的标题文本框
- (void)setupTitle:(CGFloat)Y
{
    CZEditorTextView *textView = [[CZEditorTextView alloc] init];
    self.textView = textView;
    [textView setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 16]];
    textView.placeHolder = @"一个好的签名，让朋友一眼记住你……";
    textView.x = 15;
    textView.y = Y + 10;
    textView.width = SCR_WIDTH - 30;
    textView.height = 70;
    [self.view addSubview:textView];


    textView.defaultText = self.name;


    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CZGetY(textView) + 30, SCR_WIDTH - 30, 0.7)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];

    UILabel *label = [[UILabel alloc] init];
    label.x = SCR_WIDTH - 20 - 35;
    label.y = CZGetY(line) - 25;
    [self.view addSubview:label];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    label.textColor = CZGlobalGray;

    NSString *number = [NSString stringWithFormat:@"%ld/36", self.name.length];
    label.text = number;
    label.numberOfLines = 1;
    [label sizeToFit];
    __block CZEditorTextView *blockTextView = textView;
    textView.titleTextBlock = ^(NSString *text) {
        if (blockTextView.text.length <= 36) {
            label.text = [NSString stringWithFormat:@"%ld/36", text.length];
            [label sizeToFit];
            self.recordText = text;
        } else {
            blockTextView.text = self.recordText;
        }
    };

}


- (void)saveUserInfo
{
    NSDictionary *param = @{@"detail" : self.textView.text};
    [CZUserInfoTool changeUserInfo:param callbackAction:^(NSDictionary *param) {
        // 代理方法更新上一页的用户信息
//        [self.delegate updateUserInfo];

        // 返回上一页
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
