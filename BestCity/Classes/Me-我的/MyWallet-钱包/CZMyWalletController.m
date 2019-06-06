//
//  CZMyWalletController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletController.h"
#import "CZMyWalletDepositController.h"

@interface CZMyWalletController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *lineView;

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;
@end

@implementation CZMyWalletController
#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CZGetY(self.leftLabel) + 24, SCR_WIDTH, SCR_HEIGHT - CZGetY(self.leftLabel) - 24)];
        _scrollerView.backgroundColor = CZREDCOLOR;
    }
    return _scrollerView;

}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.view addSubview:self.scrollerView];
    self.scrollerView.contentSize = CGSizeMake(SCR_WIDTH * 2, 0);
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.delegate = self;

    // 初始化控件
    [self setupUI];

}

#pragma mark - UI初始化
- (void)setupUI
{
    self.leftLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    self.rightLabel.font = self.leftLabel.font;


    // 收入明细
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(14, 0, SCR_WIDTH - 28, self.scrollerView.height) style:UITableViewStylePlain];
    [self.scrollerView addSubview:leftTableView];
    self.leftTableView = leftTableView;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;

    // 提现明细
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCR_WIDTH + 14, 0, SCR_WIDTH - 28, self.scrollerView.height) style:UITableViewStylePlain];
    [self.scrollerView addSubview:rightTableView];
    self.rightTableView = rightTableView;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
}

#pragma mark - 点击事件
- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftActoin:(UITapGestureRecognizer *)sender {
    NSLog(@"----------%@", sender.view);
    CGFloat lineX = sender.view.frame.origin.x;
    self.leftLabel.textColor = [UIColor blackColor];
    self.lineView.x = lineX;

    self.rightLabel.textColor = CZGlobalGray;
    [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)rightAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"----------%@", sender.view);
    CGFloat lineX = sender.view.frame.origin.x;
    self.rightLabel.textColor = [UIColor blackColor];
    self.lineView.x = lineX;

    self.leftLabel.textColor = CZGlobalGray;
    [self.scrollerView setContentOffset:CGPointMake(SCR_WIDTH, 0) animated:YES];
}

/* 条转提现 */
- (IBAction)pushWithdrawDeposit
{
    CZMyWalletDepositController *vc = [[CZMyWalletDepositController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"---%ld", indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollerView) {
        NSLog(@"------");
        if (scrollView.contentOffset.x == SCR_WIDTH) {
            self.leftLabel.textColor = CZGlobalGray;
            self.rightLabel.textColor = [UIColor blackColor];
            self.lineView.x = self.rightLabel.x;
        } else if (scrollView.contentOffset.x == 0) {
            self.rightLabel.textColor = CZGlobalGray;
            self.leftLabel.textColor = [UIColor blackColor];
            self.lineView.x = self.leftLabel.x;
        }

    }
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
