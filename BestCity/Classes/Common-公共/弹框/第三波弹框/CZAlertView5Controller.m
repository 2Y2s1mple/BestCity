//
//  CZAlertView5Controller.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/13.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAlertView5Controller.h"

@interface CZAlertView5Controller () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

/** <#注释#> */
@property (nonatomic, strong) void (^agreementBlock)(void);

@end

@implementation CZAlertView5Controller

- (instancetype)initWithAgreementBlock:(void (^)(void))block1
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.agreementBlock = block1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = @"依据最新法律要求，我们更新了《隐私政策》，特向您说明，在使用我们的服务时，我们如何收集、使用、储存和分享这些信息，以及我们为您提供的访问、更新、控制和保护这些信息的方式。请您在使用前仔细阅读《用户服务协议》及《隐私政策》，充分理解后选择”同意并继续“。";
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; // 调整行间距
    NSRange range = NSMakeRange(0, [attribut length]);
    [attribut addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x989898) range:NSMakeRange(0, string.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 12] range:NSMakeRange(0, string.length)];
    
    [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4E89FF) range:NSMakeRange(14, 6)];
    [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4E89FF) range:[string rangeOfString:@"《用户服务协议》"]];
    [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4E89FF) range:NSMakeRange(104, 6)];
    
    [attribut addAttribute:NSLinkAttributeName value:@"yinsi://" range:NSMakeRange(14, 6)];
    [attribut addAttribute:NSLinkAttributeName value:@"yinsi://" range:NSMakeRange(104, 6)];
    [attribut addAttribute:NSLinkAttributeName value:@"yonghu://" range:[string rangeOfString:@"《用户服务协议》"]];
    
    self.textView.editable = NO;
    self.textView.delegate = self;
    self.textView.attributedText = attribut;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"%@", URL.absoluteString);
    if ([[URL scheme] isEqualToString:@"yinsi"]) {
        [CZFreePushTool generalH5WithUrl:UserPrivacy_url title:@"隐私政策" containView:self];
        NSLog(@"《隐私政策》---------------");
        return NO;
    } else if ([[URL scheme] isEqualToString:@"yonghu"]) {
        [CZFreePushTool generalH5WithUrl:UserAgreement_url title:@"用户服务协议" containView:self];
        NSLog(@"《用户服务协议》---------------");
        return NO;
    }
    return YES;
}

/** 同意 */
- (IBAction)Agreement
{
    [self dismissViewControllerAnimated:NO completion:^{
        self.agreementBlock();
    }];
    
}

- (IBAction)cancle
{
    abort();
}



@end
