//
//  CZGuessTypeOneView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGuessTypeOneView.h"
#import "CZTabbaoSearchDetailController.h"
@interface CZGuessTypeOneView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *contentText;
@end

@implementation CZGuessTypeOneView

+ (instancetype)createView
{
    CZGuessTypeOneView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.width = SCR_WIDTH;
    view.height = SCR_HEIGHT;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.title.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.contentText.text = text;
}

- (IBAction)closeAction:(UIButton *)sender {

    NSLog(@"--------");
    [self removeFromSuperview];

}

- (IBAction)searchAction:(UIButton *)sender {
    CZTabbaoSearchDetailController *vc = [[CZTabbaoSearchDetailController alloc] init];
    vc.searchText = self.contentText.text;
    vc.type = @"1";
    CURRENTVC(currentVc);
    [currentVc.navigationController pushViewController:vc animated:YES];
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
