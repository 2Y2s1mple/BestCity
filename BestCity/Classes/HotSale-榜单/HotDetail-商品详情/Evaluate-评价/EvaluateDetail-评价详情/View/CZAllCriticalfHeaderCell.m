//
//  CZAllCriticalfHeaderCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/14.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZAllCriticalfHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "CZCommentCell.h"
#import "CZCommentModel.h"

@interface CZAllCriticalfHeaderCell ()<UITableViewDelegate, UITableViewDataSource>
/** icon */
@property (nonatomic, strong) UIImageView *icon;
/** 名字 */
@property (nonatomic, strong) UILabel *name;
/** 点赞小手 */
@property (nonatomic, strong) UIButton *likeBtn;
/** 内容 */
@property (nonatomic, strong) UILabel *contentlabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 回复 */
@property (nonatomic, strong) UIButton *replyBtn;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 表单数据 */
@property (nonatomic, strong) NSArray *commentArr;

@end

@implementation CZAllCriticalfHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = RANDOMCOLOR;
        [self setup];
    }
    return self;
}


// 初始化
- (void)setup
{
    //图片
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    self.icon.layer.cornerRadius = 19;
    self.icon.layer.masksToBounds = YES;
    [self.contentView addSubview:_icon];
    
    //名字
    self.name = [[UILabel alloc] init];
    _name.text = @"李丹妮";
    _name.font = [UIFont systemFontOfSize:16];
    _name.textColor = CZGlobalGray;
    [self.contentView addSubview:_name];
    
    //点赞小手
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn setTitle:@"245" forState:UIControlStateNormal];
    [_likeBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"appreciate-nor"]
              forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"appreciate-sel"]
              forState:UIControlStateHighlighted];
    [self.contentView addSubview:_likeBtn];
    
    
    // 内容
    self.contentlabel = [[UILabel alloc] init];
    _contentlabel.text = @"";
    _contentlabel.font = [UIFont systemFontOfSize:15];
    _contentlabel.textColor = CZRGBColor(21, 21, 21);
    _contentlabel.numberOfLines = 0;
    _contentlabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_contentlabel];
    
    
    //时间
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"2018.09.21";
    _timeLabel.textColor = CZGlobalGray;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLabel];
    
    
    //回复
    self.replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyBtn setTitle:@"·   回复"forState:UIControlStateNormal];
    _replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_replyBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [self.contentView addSubview:_replyBtn];
    
    // 回复内容表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 40;
}

- (void)setModel:(CZEvaluateModel *)model
{
    _model = model;
    // 头像
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.fromImg] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    
    // 名子
    self.name.text = model.userShopmember[@"userNickName"];
    
    // 点赞数
    [self.likeBtn setTitle:model.snapNum forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
    // 详情
    self.contentlabel.text = model.content;
    CGFloat contentHeight = [self.model.content getTextHeightWithRectSize:CGSizeMake(SCR_WIDTH - _name.x - 10, 1000) andFont:self.contentlabel.font];
    self.contentlabel.frame = CGRectMake(_name.x, CZGetY(_icon) + 10, SCR_WIDTH - _name.x - 10, contentHeight);
    // 时间
    self.timeLabel.text = [model.createTime substringToIndex:10];
    self.timeLabel.frame = CGRectMake(_contentlabel.x, CZGetY(_contentlabel) + 10, 80, 20);
    // 回复按钮
    self.replyBtn.frame = CGRectMake(CZGetX(_timeLabel), _timeLabel.center.y - 10, 80, 20);
    // 回复内容
    self.commentArr = model.userCommentList;
    if (model.realCommentArrCount > model.contrlCommentArrCount) { // 大于2条
        // 自己计算tableView的高度
        CGFloat tableViewHeight = 0.0;
        for (NSInteger i = 0; i < model.contrlCommentArrCount; i++) {
            tableViewHeight += [self.commentArr[i] cellHeight];
        }
        self.tableView.frame = CGRectMake(self.contentlabel.x, CGRectGetMaxY(self.replyBtn.frame), self.contentlabel.width, tableViewHeight + 40);
    } else {
        model.contrlCommentArrCount = model.realCommentArrCount;;
        // 自己计算tableView的高度
        CGFloat tableViewHeight = 0.0;
        for (CZCommentModel *model in self.commentArr) {
            tableViewHeight += model.cellHeight;
        }
        
        if (model.contrlCommentArrCount > 2) {
            self.tableView.frame = CGRectMake(self.contentlabel.x, CGRectGetMaxY(self.replyBtn.frame), self.contentlabel.width, tableViewHeight + 40);
        } else {
            self.tableView.frame = CGRectMake(self.contentlabel.x, CGRectGetMaxY(self.replyBtn.frame), self.contentlabel.width, tableViewHeight);
        }
        
        
    }
    
    // 判断底部按钮出现
    if (model.isMoreBtn) {
        self.tableView.tableFooterView = [self FooterViewType:model.moreBtnType];
    } else {
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
    self.model.cellHeight = CZGetY(self.tableView);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.contrlCommentArrCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZCommentModel *model = self.commentArr[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"subCommentCell";
    CZCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CZCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    CZCommentModel *model = self.commentArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)showMoreCommtent
{
    if (self.model.moreBtnType == 1) {
        self.model.moreBtnType = 0;
        self.model.contrlCommentArrCount = 2;
        [self.tableView reloadData];
        !self.delegate ? : [self.delegate showMoreCommentCell:self.model.indexPath];
        return;
    }
    
    if (self.model.realCommentArrCount < 10) {
        self.model.contrlCommentArrCount = self.model.realCommentArrCount;
    } else {
        self.model.contrlCommentArrCount += 10;
        if (self.model.contrlCommentArrCount >= self.model.realCommentArrCount) {
            self.model.moreBtnType = 1; // 收起所有
        } else {
            self.model.moreBtnType = 2; // 在展示10条
        }
    }
    
    [self.tableView reloadData];
    !self.delegate ? : [self.delegate showMoreCommentCell:self.model.indexPath];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat space = 10.0;
    self.icon.frame = CGRectMake(space, 2 * space, 38, 38);
    self.name.frame = CGRectMake(CZGetX(_icon) + space, _icon.center.y - 15, 100, 30);
    self.likeBtn.frame = CGRectMake(self.contentView.width - 10 - 80, _icon.center.y - 15, 80, 30);
}


- (UIView *)FooterViewType:(NSInteger)type
{
    switch (type) {
        case 0:
           return [self setupFooterViewBtnFrame:CGRectMake(10, 10, 100, 20) titleColor:CZRGBColor(74, 144, 226) image:[UIImage imageNamed:@"right-blue"] title:[NSString stringWithFormat:@"共%ld条回复", self.model.realCommentArrCount]];
            break;
        case 1:
           return [self setupFooterViewBtnFrame:CGRectMake(self.tableView.width * 0.5 - 50, 10, 100, 20) titleColor:CZGlobalGray image:[UIImage imageNamed:@"more-up"] title:@"收起所有回复"];
            break;
        case 2:
            return [self setupFooterViewBtnFrame:CGRectMake(self.tableView.width * 0.5 - 50, 10, 100, 20) titleColor:CZGlobalGray image:[UIImage imageNamed:@"more-down"] title:@"查看10条回复"];
            break;
        default:
            return nil;
            break;
    }
   
}

#pragma mark - 创建底部button
- (UIView *)setupFooterViewBtnFrame:(CGRect)frame titleColor:(UIColor *)color image:(UIImage *)image title:(NSString *)title
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = CZGlobalLightGray;
    backView.frame = CGRectMake(0, 0, SCR_WIDTH, 40);
    // 显示更多按钮
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:frame];
    [backView addSubview:moreBtn];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [moreBtn setTitle:title forState:UIControlStateNormal];
    [moreBtn setImage:image forState:UIControlStateNormal];
    [moreBtn sizeToFit];
    [moreBtn setNeedsLayout];
    [moreBtn layoutIfNeeded];
    NSLog(@"moreBtn.titleLabel.width - - %f -- %f", moreBtn.titleLabel.width, moreBtn.imageView.width);
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, moreBtn.titleLabel.width - moreBtn.imageView.width, 0, 0);
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -moreBtn.imageView.width, 0, 0);
    [moreBtn setTitleColor:color forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreBtn addTarget:self action:@selector(showMoreCommtent) forControlEvents:UIControlEventTouchUpInside];
    return backView;
}

@end
