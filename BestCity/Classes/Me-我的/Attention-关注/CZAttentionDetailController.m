//
//  CZAttentionDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionDetailController.h"
#import "UIButton+CZExtension.h"
#import "CZAttentionDetailCell.h"
#import "Masonry.h"
#import "CZAttentionBtn.h"

@interface CZAttentionDetailController ()<UITableViewDataSource, UITableViewDelegate>
/** 存放所有cell的高度 */
@property (strong, nonatomic) NSMutableDictionary *heights;
@end

@implementation CZAttentionDetailController

- (NSMutableDictionary *)heights
{
    if (_heights == nil) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self setupHeaderView];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:tableView];
    

    
}

- (UIView *)setupHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 250)];
    UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testImage8"]];
    topImage.frame = CGRectMake(0, 0, SCR_HEIGHT, 180);
    [headerView addSubview:topImage];
    
    //返回按钮
    UIButton *leftBtn = [UIButton buttonWithFrame:CGRectMake(20, 40, 9, 17) backImage:@"nav-back" target:self action:@selector(popAction)];
    [headerView addSubview:leftBtn];
    
    //白色视图
    UIView *titleView = [[UIView alloc] init];
    [headerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftBtn.mas_bottom).offset(70);
        make.left.equalTo(headerView).offset(10);
        make.right.equalTo(headerView).offset(-10);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
    }];
    
    UIImage *image = [UIImage imageNamed:@"backshadow.png"];
    UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    UIImageView *backImage = [[UIImageView alloc] initWithImage:stretchImage];
    [titleView addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(titleView);
    }];
    
    //头像
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    [titleView addSubview:iconImage];
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"F买遍全球无敌手";
    nameLabel.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:nameLabel];
    //粉丝数
    UILabel *funsNumber = [[UILabel alloc] init];
    funsNumber.text = @"粉丝数:3762";
    funsNumber.font = [UIFont systemFontOfSize:14];
    funsNumber.textColor = CZGlobalGray;
    [titleView addSubview:funsNumber];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(20);
        make.centerY.equalTo(titleView);
        make.width.height.equalTo(@55);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_top);
        make.left.equalTo(iconImage.mas_right).offset(20);
    }];
    
    [funsNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconImage.mas_bottom);
        make.left.equalTo(iconImage.mas_right).offset(20);
    }];
    
    [titleView layoutIfNeeded];
    CZAttentionBtn *btn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(titleView.width - 20 - 60, iconImage.y, 60, 24) CommentType:CZAttentionBtnTypeFollowed didClickedAction:^{
        NSLog(@"点击了按钮");
    }];
    [titleView addSubview:btn];
    return headerView;
}



#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZAttentionDetailCell *cell = [CZAttentionDetailCell cellWithTabelView:tableView];
    self.heights[@(indexPath.row)] = @(cell.cellHeight);
//    NSLog(@"%f", cell.cellHeight);
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heights[@(indexPath.row)] doubleValue];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
