//
//  CZMyWalletController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletController.h"

@interface CZMyWalletController ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *lineView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;
@end

@implementation CZMyWalletController
- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (IBAction)leftActoin:(UITapGestureRecognizer *)sender {
    NSLog(@"----------%@", sender.view);
    CGFloat lineX = sender.view.frame.origin.x;
    self.leftLabel.textColor = [UIColor blackColor];
    self.lineView.x = lineX;
    
    self.rightLabel.textColor = CZGlobalGray;
}

- (IBAction)rightAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"----------%@", sender.view);
    CGFloat lineX = sender.view.frame.origin.x;
    self.rightLabel.textColor = [UIColor blackColor];
    self.lineView.x = lineX;
    
    self.leftLabel.textColor = CZGlobalGray;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
