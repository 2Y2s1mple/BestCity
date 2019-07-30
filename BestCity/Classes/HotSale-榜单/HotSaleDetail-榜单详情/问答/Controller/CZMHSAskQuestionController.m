//
//  CZMHSAskQuestionController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSAskQuestionController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZUpdataView.h"

@interface CZMHSAskQuestionController () <UITextViewDelegate>
/** 提示文字 */
@property (nonatomic, strong) UILabel *placeHoldlabel;
/** 导航条 */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 发布按钮 */
@property (nonatomic, strong) UIButton *issueBtn;
/** 文字输入框 */
@property (nonatomic, strong) UITextView *textView;
/** 剩余文字个数 */
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation CZMHSAskQuestionController
- (UILabel *)placeHoldlabel
{
    if (_placeHoldlabel == nil) {
        _placeHoldlabel = [[UILabel alloc] init];
        _placeHoldlabel.x = 5;
        _placeHoldlabel.y = 5;
        _placeHoldlabel.width = self.textView.width - 10;
        _placeHoldlabel.height = 50;
        _placeHoldlabel.text = @"提出问题，让大家给你推荐什么值得买吧，并使用问号结尾";
        _placeHoldlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _placeHoldlabel.textColor = CZGlobalGray;
        _placeHoldlabel.numberOfLines = 0;
    }
    return _placeHoldlabel;
}
// 导航条qwew
- (CZNavigationView *)navigationView
{
    if (_navigationView == nil) {
        _navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"发起问题" rightBtnTitle:nil rightBtnAction:nil navigationViewType  :CZNavigationViewTypeBlack];
        _navigationView.backgroundColor = CZGlobalWhiteBg;
        [self.view addSubview:_navigationView];
        //导航条
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationView.height - 0.7, _navigationView.width, 0.7)];
        line.backgroundColor = CZGlobalLightGray;
        [_navigationView addSubview:line];

        [_navigationView addSubview:self.issueBtn];
        self.issueBtn.centerY = _navigationView.height / 2.0 + 10;
        self.issueBtn.x = SCR_WIDTH - 65;
    }
    return _navigationView;
}

- (UIButton *)issueBtn
{
    if (_issueBtn == nil) {
        _issueBtn = [[UIButton alloc] init];
        _issueBtn.size = CGSizeMake(50, 25);
        _issueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_issueBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_issueBtn setTitleColor:UIColorFromRGB(0xD8D8D8) forState:UIControlStateNormal];
        _issueBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        [_issueBtn addTarget:self action:@selector(issueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _issueBtn;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(14, CZGetY(self.navigationView) + 10, SCR_WIDTH - 28, 120)];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.x = SCR_WIDTH - 20 - 35;
        _numberLabel.y = CZGetY(self.textView) + 5;
        _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        _numberLabel.textColor = CZGlobalGray;
        _numberLabel.text = @"0/36";
        _numberLabel.numberOfLines = 1;
        [_numberLabel sizeToFit];
    }
    return _numberLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.textView];
    [self.textView addSubview:self.placeHoldlabel];
    [self.view addSubview:self.numberLabel];
}

#pragma mark - 代理
// UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeHoldlabel.hidden = YES;
        [self.issueBtn setTitleColor:UIColorFromRGB(0xE84643) forState:UIControlStateNormal];
        self.issueBtn.enabled = YES;
    } else {
        self.issueBtn.enabled = NO;
        self.placeHoldlabel.hidden = NO;
        [self.issueBtn setTitleColor:UIColorFromRGB(0xD8D8D8) forState:UIControlStateNormal];
    }

    if (textView.text.length <= 36) {
        NSString *therPrice = [NSString stringWithFormat:@"%ld/36", textView.text.length];
        self.numberLabel.attributedText = [therPrice addAttributeColor:UIColorFromRGB(0x202020) Range:[therPrice rangeOfString:[NSString stringWithFormat:@"%ld", textView.text.length]]];
        [self.numberLabel sizeToFit];
    } else {
        NSString *therPrice = [NSString stringWithFormat:@"%d/36", 36];
        self.numberLabel.attributedText = [therPrice addAttributeColor:UIColorFromRGB(0x202020) Range:[therPrice rangeOfString:[NSString stringWithFormat:@"%d", 36]]];
        [self.numberLabel sizeToFit];
        NSString *text = [textView.text substringToIndex:36 ];
        self.textView.text = text;
    }
}

#pragma mark - 事件
- (void)issueBtnAction:(UIButton *)sender
{
    NSLog(@"--------------");
    self.issueBtn.enabled = NO;
    [self obtainDetailData];
}

#pragma mark - 网络请求
- (void)obtainDetailData
{
    [self.view endEditing:YES];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"title"] = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    param[@"goodsCategoryId"] = self.goodsCategoryId;
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/question/addQuestion"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            // 判断是否更新
            CZUpdataView *backView = [CZUpdataView reviewView];
            backView.frame = [UIScreen mainScreen].bounds;
            backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [[UIApplication sharedApplication].keyWindow addSubview: backView];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"提交失败"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
        self.issueBtn.enabled = YES;
    } failure:^(NSError *error) {}];
}
@end
