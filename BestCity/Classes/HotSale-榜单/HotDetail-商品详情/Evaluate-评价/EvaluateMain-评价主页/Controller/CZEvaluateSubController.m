//
//  CZEvaluateSubController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluateSubController.h"
#import "CZAllCriticalController.h"
#import "CZGiveLikeView.h"
#import "GXNetTool.h"
#import "CZEvaluateModel.h"
#import "MJExtension.h"

#import "CZEvaluateToolBar.h"
#import "CZReplyButton.h"
#import "UIImageView+WebCache.h"

@interface CZEvaluateSubController ()
/** 评论数据 */
@property (nonatomic, strong) NSArray *evaluateArr;
/** 文本框View */
@property (nonatomic, strong) CZEvaluateToolBar *tool;
/** 总高度 */
@property (nonatomic, assign) CGFloat totalHeight;
/** 评论总数 */
@property (nonatomic, strong) NSNumber *totalCommentCount;
@end

@implementation CZEvaluateSubController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 创建文本框
    [self setupTextField];
    // 设置scrollerView
    [self.view addSubview:self.scrollerView];
}
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (void)setModel:(CZRecommendDetailModel *)model
{
    _model = model;
    [self getDataSource];
}

// 获取评价数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articId"] = self.model.goodsId;
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/comment"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.evaluateArr = [CZEvaluateModel objectArrayWithKeyValuesArray:result[@"list"]];
            self.totalCommentCount = result[@"count"];
            
            // 创建用户评价
            [self setupSubViews];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


// 记录高度
- (void)addHeight:(CGFloat)height
{
    self.totalHeight += height;
}


#pragma mark - 创建用户评价
- (void)setupSubViews
{
    CGFloat space = 10.0f;
    // 用户评价
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 2 * space, 100, 20)];
    titleLabel.text = @"用户评价";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [self.scrollerView addSubview:titleLabel];
    // 记录高度
    [self addHeight:CZGetY(titleLabel) + 10];
    
    // 最多加载三个
    NSInteger maxCommentCount = self.evaluateArr.count > 3 ? 3 : self.evaluateArr.count;
    for (NSInteger i = 0; i < maxCommentCount; i++) {
        CZEvaluateModel *model = self.evaluateArr[i];
        // 创建评论单块视图
        UIView *backview = [self setupBackView];
        // 创建头像一行
        UIView *header = [self headerViewAddView:backview model:model];
         backview.height += header.height + 5;
        // 创建评论内容
        UIView *comment = [self commentViewAddView:backview model:model];
        backview.height += comment.height + 10;
        // 创建回复按钮一行
        UIView *reply = [self replyViewAddView:backview model:model];
        backview.height += reply.height + 10;
        
        // 创建回复内容
        UIView *detail = [self commentDetailAddView:backview model:model];
        backview.height += detail.height;
        
        // 记录高度
        [self addHeight:backview.height];
    }

    // 记录高度
    [self addHeight:10];
    
    // 加载更多评论
    UIButton *moreReplyBtn = [self createMoreCommentBtn];
    
    // 记录高度
    [self addHeight:moreReplyBtn.height + 10];
    
    /**点赞*/
    //加个分隔线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.totalHeight, SCR_WIDTH, 7)];
    lineView2.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView2];
    // 记录高度
    [self addHeight:lineView2.height];
    
    //加载点赞小手
    CZGiveLikeView *likeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, self.totalHeight, SCR_WIDTH, 200)];
    [self.scrollerView addSubview:likeView];
    // 记录高度
    [self addHeight:likeView.height];
    
    
    // 计算父视图高度
    self.scrollerView.contentSize = CGSizeMake(0, self.totalHeight);
    self.scrollerView.height = self.totalHeight;
    self.view.height = self.scrollerView.height;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenBoxInspectWebHeightKey object:nil userInfo:@{@"height" : @(self.scrollerView.height)}];
}

#pragma mark - 跳转到详情
- (void)pushCommentDetail:(UIButton *)sendre
{
    CZAllCriticalController *vc = [[CZAllCriticalController alloc] init];
//    vc.evaluateArr = self.evaluateArr;
    vc.model = self.model;
    vc.totalCommentCount = self.totalCommentCount;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 创建文本框
- (void)setupTextField
{
    // 文本框
    CZEvaluateToolBar *tool = [CZEvaluateToolBar evaluateToolBar];
    self.tool = tool;
    tool.autoresizingMask = UIViewAutoresizingNone;
    tool.frame = CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, 49);
    [[UIApplication sharedApplication].keyWindow addSubview:tool];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tool.transform = CGAffineTransformMakeTranslation(0, rect.origin.y - SCR_HEIGHT - self.tool.height);
}

- (void)keyboardHide:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tool.transform = CGAffineTransformMakeTranslation(0, rect.origin.y - SCR_HEIGHT);
}

- (void)reply:(CZReplyButton *)sender
{
    [self.tool.textView becomeFirstResponder];
    //    self.tool.textView. = [NSString stringWithFormat:@"回复%@:", sender.model.fromNickname];
}


- (CGFloat)getTextHeight:(NSString *)text widthRectSize:(CGSize)size
{
    CGFloat contentlabelHeight = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    return contentlabelHeight;
}

#pragma mark - 创建评论单块视图
- (UIView *)setupBackView
{
    UIView *backview = [[UIView alloc] init];
    backview.x = 0;
    backview.y = self.totalHeight ;
    backview.width = SCR_WIDTH;
    backview.height = 0;
    [self.scrollerView addSubview:backview];
    return backview;
}

#pragma mark - 创建头像一行
- (UIView *)headerViewAddView:(UIView *)view model:(CZEvaluateModel *)model
{
    UIView *backview = [[UIView alloc] init];
    [view addSubview:backview];
    backview.x = 0;
    backview.y = view.height;
    backview.width = SCR_WIDTH;
    backview.height = 0;
    
    //图片
    UIImageView *icon = [[UIImageView alloc] init];
    icon.frame = CGRectMake(10, 0, 38, 38);
    icon.layer.cornerRadius = 19;
    icon.layer.masksToBounds = YES;
    [icon sd_setImageWithURL:[NSURL URLWithString:model.fromImg] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    [backview addSubview:icon];
    
    //名字
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(icon) + 10, icon.center.y - 15, 100, 30)];
    name.text = model.userShopmember[@"userNickName"];
    name.font = [UIFont systemFontOfSize:16];
    name.textColor = CZGlobalGray;
    [backview addSubview:name];
    
    //点赞小手
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    likeBtn.frame = CGRectMake(backview.width - 10 - 80, icon.center.y - 15, 80, 30);
    likeBtn.x = backview.width - 40;
    likeBtn.y = name.y;
    [likeBtn sizeToFit];
    [likeBtn setTitle:model.snapNum forState:UIControlStateNormal];
    [likeBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"appreciate-nor"]
             forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"appreciate-sel"]
             forState:UIControlStateHighlighted];
    [backview addSubview:likeBtn];
    
    
    backview.height = icon.height;
    return backview;
    
}

#pragma mark - 创建评论内容
- (UIView *)commentViewAddView:(UIView *)view model:(CZEvaluateModel *)model
{
    UIView *backview = [[UIView alloc] init];
    [view addSubview:backview];
    backview.x = 0;
    backview.y = view.height;
    backview.width = SCR_WIDTH;
    backview.height = 0;
    
    // 内容
    NSString *text = model.content;
    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 0, backview.width - 58 - 10, 0)];
    CGFloat contentlabelHeight = [text boundingRectWithSize:CGSizeMake(contentlabel.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    contentlabel.height = contentlabelHeight;
    contentlabel.text = text;
    contentlabel.font = [UIFont systemFontOfSize:15];
    contentlabel.textColor = CZRGBColor(21, 21, 21);
    contentlabel.numberOfLines = 0;
    [backview addSubview:contentlabel];
   
    
    backview.height = contentlabelHeight;
    return backview;
}

#pragma mark - 创建回复按钮一行
- (UIView *)replyViewAddView:(UIView *)view model:(CZEvaluateModel *)model
{
    UIView *backview = [[UIView alloc] init];
    [view addSubview:backview];
    backview.x = 0;
    backview.y = view.height;
    backview.width = SCR_WIDTH;
    backview.height = 0;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 0, 80, 20)];
    timeLabel.text = [model.createTime substringToIndex:10];
    timeLabel.textColor = CZGlobalGray;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [backview addSubview:timeLabel];
    
    // 回复按钮
    CZReplyButton *replyBtn = [CZReplyButton buttonWithType:UIButtonTypeCustom];
    replyBtn.frame = CGRectMake(CZGetX(timeLabel), timeLabel.center.y - 10, 80, 20);
    [replyBtn setTitle:@"·   回复"forState:UIControlStateNormal];
    replyBtn.model = model;
    replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [replyBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:replyBtn];
    
    
    backview.height = replyBtn.height;
    return backview;
}

#pragma mark - 创建回复内容
- (UIView *)commentDetailAddView:(UIView *)view model:(CZEvaluateModel *)model
{
    UIView *backview = [[UIView alloc] init];
    [view addSubview:backview];
    backview.x = 0;
    backview.y = view.height;
    backview.width = SCR_WIDTH;
    backview.height = 0;
    
    // 创建内容
    UIView *replyView = [[UIView alloc] init];
    replyView.backgroundColor = CZGlobalLightGray;
    replyView.layer.cornerRadius = 5;
    replyView.layer.masksToBounds = YES;
    replyView.x = 58;
    replyView.width = backview.width - replyView.x - 10;
    replyView.height = 0;
    [backview addSubview:replyView];
    
    NSInteger maxCommentCount = model.userCommentList.count > 2 ? 2 : model.userCommentList.count;
    
    // 在内容View中加载
     CGFloat replyHeight = 0.0;
    for (NSInteger i = 0; i < maxCommentCount; i++) {
        NSDictionary *dataDic = model.userCommentList[i];
        UILabel *contentLabel = [[UILabel alloc] init];
        [replyView addSubview:contentLabel];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 0;
        contentLabel.x = 10;
        contentLabel.y = 10 + replyHeight;
        contentLabel.width = replyView.width - 20;
        
        
        NSString *nickName = dataDic[@"fromNickname"] != nil &&  dataDic[@"fromNickname"] != [NSNull null] ? dataDic[@"fromNickname"] : @"***";
        
        NSString *textStr = [NSString stringWithFormat:@"%@ 回复:  %@", nickName, dataDic[@"content"]];
        contentLabel.height = [self getTextHeight:textStr widthRectSize:CGSizeMake(contentLabel.width, 10000)];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:textStr];
        [attriString addAttributes:@{NSForegroundColorAttributeName : CZREDCOLOR} range:[textStr rangeOfString:nickName]];
        contentLabel.attributedText = attriString;
        
        replyHeight += contentLabel.height + 5;
        replyView.height = CZGetY(contentLabel) + 10;
    }
    
    if (model.userCommentList.count > 2) {
        // 显示更多按钮
        UIButton *moreBtn = [[UIButton alloc] init];
        [replyView addSubview:moreBtn];
        moreBtn.x = 10;
        moreBtn.y = replyView.height;
        moreBtn.height = 20;
        moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [moreBtn setTitle:[NSString stringWithFormat:@"共%@条回复", model.secondNum] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
        [moreBtn sizeToFit];
        [moreBtn setNeedsLayout];
        [moreBtn layoutIfNeeded];
        NSLog(@"moreBtn.titleLabel.width - - %f -- %f", moreBtn.titleLabel.width, moreBtn.imageView.width);
        moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, moreBtn.titleLabel.width - moreBtn.imageView.width, 0, 0);
        moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -moreBtn.imageView.width, 0, 0);
        [moreBtn setTitleColor:CZRGBColor(74, 144, 226) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        replyView.height = CZGetY(moreBtn) + 10;
    }
    
    
    backview.height = replyView.height;
    return backview;
}

#pragma mark - 创建更多评论按钮
- (UIButton *)createMoreCommentBtn
{
    // 加载更多评论
    UIButton *moreReplyBtn = [[UIButton alloc] init];
    moreReplyBtn.titleLabel.font = [UIFont systemFontOfSize:14.5];
    NSString *count = [NSString stringWithFormat:@"查看全部%@条评论", self.totalCommentCount];
    [moreReplyBtn setTitle:count forState:UIControlStateNormal];
    [moreReplyBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    moreReplyBtn.height = 20;
    [moreReplyBtn sizeToFit];
    moreReplyBtn.center = CGPointMake(SCR_WIDTH * 0.5, 0);
    moreReplyBtn.y = self.totalHeight;
    [moreReplyBtn addTarget:self action:@selector(pushCommentDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollerView addSubview:moreReplyBtn];
    return moreReplyBtn;
}
@end
