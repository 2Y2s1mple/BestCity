//
//  CZMHSDQDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDQDetailController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZAttentionBtn.h"

#import "UIImageView+WebCache.h"
// 模型
#import "CZMHSDQDetailModel.h"
// 视图
#import "CZMHSDQDetailCell.h"
#import "CZShareView.h"
/// 跳转
#import "CZMHSAskQuestionController.h"

@interface CZMHSDQDetailController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 导航条 */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 关注按钮 */
@property (nonatomic, strong) CZAttentionBtn *attentionBtn;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 回答数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;
/** 底部视图右面星星点击事件 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 输入框 */
@property (nonatomic, strong) UITextView *textView;
/** 键盘视图 */
@property (nonatomic, strong) UIView *keyboardAccessoryView;
/** 提示文字 */
@property (nonatomic, strong) UILabel *placeHoldlabel;
/** 剩余文字个数 */
@property (nonatomic, strong) UILabel *numberLabel;
/** 发布按钮 */
@property (nonatomic, strong) UIButton *issueBtn;
@end

@implementation CZMHSDQDetailController

#pragma mark - 视图
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.y = SCR_HEIGHT - (IsiPhoneX ? 83 : 49);
        _bottomView.width = SCR_WIDTH;
        _bottomView.height = 49;
        _bottomView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _bottomView.layer.shadowColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.5].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0,-1.5);
        _bottomView.layer.shadowOpacity = 1;
        _bottomView.layer.shadowRadius = 2;
        _bottomView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomAction:)];
        [_bottomView addGestureRecognizer:tap];

        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(15, 5, 290, 40);
        view.backgroundColor = UIColorFromRGB(0xF5F5F5);
        view.layer.cornerRadius = 4;
        [_bottomView addSubview:view];

        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(0x9E9E9E);
        label.text = @"输入回答";
        [label sizeToFit];
        label.x = 7;
        label.centerY = view.height / 2.0;
        [view addSubview:label];


        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];;
        [rightBtn setImage:[UIImage imageNamed:@"nav-favor"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"nav-favor-sel"] forState:UIControlStateSelected];
        [rightBtn sizeToFit];
        rightBtn.x = SCR_WIDTH - 42;
        rightBtn.centerY = _bottomView.height / 2.0;
        [_bottomView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(clickedRight:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn = rightBtn;
    }
    return _bottomView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 24 : 0) - 67 - (IsiPhoneX ? 83 : 49)) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.tableHeaderView = [self createTopView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

// 导航条
- (CZNavigationView *)navigationView
{
    if (_navigationView == nil) {
        _navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"" rightBtnTitle:[UIImage imageNamed:@"Forward"] rightBtnAction:^{
           // 分享
            CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
            share.cententText = @"";
            share.param = @{
                            @"shareUrl" : [NSString stringWithFormat:@"https://www.jipincheng.cn/share/question.html?id=%@", self.model.ID],
                            @"shareTitle" : self.model.title,
                            @"shareContent" : [[self.dataSource firstObject] content],
                            @"shareImg" : [UIImage imageNamed:@"headDefault"],
                            };
            [self.view addSubview:share];
        } navigationViewType  :CZNavigationViewTypeBlack];
        _navigationView.backgroundColor = CZGlobalWhiteBg;
        [self.view addSubview:_navigationView];
        //导航条
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationView.height - 0.7, _navigationView.width, 0.7)];
        line.backgroundColor = CZGlobalLightGray;
        [_navigationView addSubview:line];
    }
    return _navigationView;
}

// 创建头部视图
- (UIView *)createTopView
{
    UIView *topView = [[UIView alloc] init];
    topView.width = SCR_HEIGHT;

    CGFloat space = 14.0f;
    // 头像
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.layer.cornerRadius = 20;
    iconImage.layer.masksToBounds = YES;
    [iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    iconImage.frame = CGRectMake(space, space, 40, 40);
    [topView addSubview:iconImage];

    // 名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(iconImage) + space, iconImage.y + 8, 100, 20)];
    nameLabel.text = self.model.user[@"nickname"];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [nameLabel sizeToFit];
    nameLabel.textColor = CZRGBColor(21, 21, 21);
    [topView addSubview:nameLabel];

    // 时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, CZGetY(nameLabel), 160, 20)];
    timeLabel.text = self.model.createTime;
    timeLabel.textColor = CZGlobalGray;
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    [topView addSubview:timeLabel];

    // 关注按钮
    CZAttentionBtnType type;
    if ([self.model.user[@"follow"] integerValue] == 0) {
        type = CZAttentionBtnTypeAttention;
    } else {
        type = CZAttentionBtnTypeFollowed;
    }
    self.attentionBtn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(self.view.width - space - 60, iconImage.center.y - 12, 78, 30) CommentType:type didClickedAction:^(BOOL isSelected){
        if (isSelected) {
            [self addAttention];
        } else {
            [self deleteAttention];
        }
    }];
    [topView addSubview:self.attentionBtn];

    UILabel *questLabel = [[UILabel alloc] init];
    questLabel.numberOfLines = 0;
    questLabel.x = space;
    questLabel.y = CZGetY(timeLabel) + 12;
    questLabel.width = SCR_WIDTH - 2 * space;
    questLabel.text = self.model.title;
    questLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 20];
    CGRect rect = [self.model.title boundingRectWithSize:CGSizeMake(questLabel.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : questLabel.font} context:nil];
    questLabel.height = rect.size.height;
    questLabel.textColor = CZRGBColor(21, 21, 21);
    [topView addSubview:questLabel];

    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.x = space;
    moreLabel.y = CZGetY(questLabel) + 12;
    moreLabel.text = [NSString stringWithFormat:@"全部%@条回答", self.model.answerCount];
    moreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    [moreLabel sizeToFit];
    moreLabel.textColor = UIColorFromRGB(0x84B5D3);
    [topView addSubview:moreLabel];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(moreLabel) + 7, SCR_WIDTH, 0.7)];
    line.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [topView addSubview:line];

    UILabel *answerTitle = [[UILabel alloc] init];
    answerTitle.x = space;
    answerTitle.y = CZGetY(line) + 25;
    answerTitle.text = @"全部回答";
    answerTitle.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    [answerTitle sizeToFit];
    answerTitle.textColor = UIColorFromRGB(0x202020);
    [topView addSubview:answerTitle];
    topView.height = CZGetY(answerTitle) + 20;
    return topView;
}

// 添加加载控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

// 创建键盘工具条
- (UIView *)keyboardAccessoryView
{
    if (_keyboardAccessoryView == nil) {
        _keyboardAccessoryView = [[UIView alloc] init];
        _keyboardAccessoryView.width = SCR_WIDTH;
        _keyboardAccessoryView.height = 140;
        _keyboardAccessoryView.y = SCR_HEIGHT;
        _keyboardAccessoryView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _keyboardAccessoryView.layer.shadowColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.5].CGColor;
        _keyboardAccessoryView.layer.shadowOffset = CGSizeMake(0,-1.5);
        _keyboardAccessoryView.layer.shadowOpacity = 1;
        _keyboardAccessoryView.layer.shadowRadius = 2;

        UIView *backView = [[UIView alloc] init];
        [_keyboardAccessoryView addSubview:backView];
        backView.layer.cornerRadius = 4;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        backView.x = 14;
        backView.y = 13;
        backView.size = CGSizeMake(SCR_WIDTH - 28, 90);
        [backView addSubview:self.textView];
        [backView addSubview:self.placeHoldlabel];
        [backView addSubview:self.numberLabel];
        [_keyboardAccessoryView addSubview:self.issueBtn];
    }
    return _keyboardAccessoryView;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.size = CGSizeMake(SCR_WIDTH - 28, 68);
        _textView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeHoldlabel
{
    if (_placeHoldlabel == nil) {
        _placeHoldlabel = [[UILabel alloc] init];
        _placeHoldlabel.text = @"输入评论";
        _placeHoldlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        [_placeHoldlabel sizeToFit];
        _placeHoldlabel.x = 5;
        _placeHoldlabel.y = 5;
        _placeHoldlabel.textColor = CZGlobalGray;
        _placeHoldlabel.numberOfLines = 0;
    }
    return _placeHoldlabel;
}

- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        _numberLabel.textColor = CZGlobalGray;
        _numberLabel.text = @"0/500";
        _numberLabel.numberOfLines = 1;
        [_numberLabel sizeToFit];
        _numberLabel.x = SCR_WIDTH - 28 - _numberLabel.width - 5;
        _numberLabel.y = 70;
    }
    return _numberLabel;
}

- (UIButton *)issueBtn
{
    if (_issueBtn == nil) {
        _issueBtn = [[UIButton alloc] init];
        _issueBtn.y = 110;
        _issueBtn.x = SCR_WIDTH - 20 - 50;
        _issueBtn.size = CGSizeMake(50, 25);
        _issueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_issueBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_issueBtn setTitleColor:UIColorFromRGB(0x9E9E9E) forState:UIControlStateNormal];
        _issueBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        [_issueBtn addTarget:self action:@selector(issueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _issueBtn;
}


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [CZMHSDQDetailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
    self.view.backgroundColor = CZGlobalWhiteBg;
    [self.view addSubview:self.navigationView];
    [self createTopView];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.keyboardAccessoryView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [self isCollectDetail];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // 键盘的动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    if (frame.origin.y == SCR_HEIGHT) {
        [UIView animateWithDuration:duration animations:^{
            self.keyboardAccessoryView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.keyboardAccessoryView.transform = CGAffineTransformMakeTranslation(0, frame.origin.y - SCR_HEIGHT - 140);
        }];
    }
}

#pragma mark - 事件
- (void)clickedRight:(UIButton *)sender
{
    if (sender.selected) {
        // 取消收藏
        [self collectDelete];
    } else {
        // 收藏
        [self collectInsert];
    }
}

#pragma mark - 判断是否收藏了此文章
- (void)isCollectDetail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.model.ID;
    param[@"type"] = @"4";

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/view/status"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"collect"] isEqualToNumber:@(1)]) {
            self.rightBtn.selected = YES;
        } else {
            self.rightBtn.selected = NO;
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 取消收藏
- (void)collectDelete
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.model.ID;
    param[@"type"] = @"4";

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"/api/collect/delete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            [CZProgressHUD showProgressHUDWithText:@"取消收藏"];
            self.rightBtn.selected = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:collectNotification object:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消收藏失败"];
            self.rightBtn.selected = YES;
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 收藏
- (void)collectInsert
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.model.ID;
    param[@"type"] = @"4";

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/collect/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已收藏"]) {
            [CZProgressHUD showProgressHUDWithText:@"收藏成功"];
            self.rightBtn.selected = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:collectNotification object:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"收藏失败"];
            self.rightBtn.selected = NO;
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 取消关注
- (void)deleteAttention
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/delete"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            // 关注
            self.attentionBtn.type = CZAttentionBtnTypeAttention;
            [CZProgressHUD showProgressHUDWithText:@"取关成功"];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 新增关注
- (void)addAttention
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"关注成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"关注成功"];
            self.attentionBtn.type = CZAttentionBtnTypeFollowed;
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)bottomAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"0000000");
    [self.textView becomeFirstResponder];
}

- (void)issueBtnAction:(UIButton *)sender
{
    NSLog(@"--------------");
    [self obtainDetailData];
}

- (void)obtainDetailData
{
    [self.view endEditing:YES];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"content"] = self.textView.text;
    param[@"questionId"] = self.model.ID;
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/question/addAnswer"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [self.tableView.mj_header beginRefreshing];
            [CZProgressHUD showProgressHUDWithText:@"提交成功"];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"提交失败"];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {}];
}


#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"questionId"] = self.model.ID;
    param[@"page"] = @(self.page);

    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/question/answerList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = [CZMHSDQDetailModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   param[@"questionId"] = self.model.ID;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/question/answerList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *arr = [CZMHSDQDetailModel objectArrayWithKeyValuesArray:result[@"data"]] ;
            [self.dataSource addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}


#pragma mark - 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDQDetailModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDQDetailModel *model = self.dataSource[indexPath.row];
    CZMHSDQDetailCell *cell = [CZMHSDQDetailCell cellwithTableView:tableView];
    cell.model = model;
    return cell;
}

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

    if (textView.text.length <= 500) {
        NSString *therPrice = [NSString stringWithFormat:@"%ld/500", textView.text.length];
        self.numberLabel.attributedText = [therPrice addAttributeColor:UIColorFromRGB(0x202020) Range:[therPrice rangeOfString:[NSString stringWithFormat:@"%ld", textView.text.length]]];
        [self.numberLabel sizeToFit];
    } else {
        NSString *therPrice = [NSString stringWithFormat:@"%d/500", 500];
        self.numberLabel.attributedText = [therPrice addAttributeColor:UIColorFromRGB(0x202020) Range:[therPrice rangeOfString:[NSString stringWithFormat:@"%d", 500]]];
        [self.numberLabel sizeToFit];
        NSString *text = [textView.text substringToIndex:500];
        self.textView.text = text;
    }
}



@end
