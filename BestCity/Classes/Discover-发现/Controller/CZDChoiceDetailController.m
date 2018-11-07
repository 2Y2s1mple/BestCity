//
//  CZDChoiceDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDChoiceDetailController.h"
#import "JCTopic.h"
#import "UIButton+CZExtension.h"

@interface CZDChoiceDetailController ()
/** 轮播图 */
@property(nonatomic,strong)JCTopic *Topic_JC;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 记录高度 */
@property (nonatomic, assign) CGFloat recordY;
@end

@implementation CZDChoiceDetailController
-(JCTopic *)Topic_JC
{
    if(!_Topic_JC)
    {
        // 轮播图
        _Topic_JC = [[JCTopic alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 260)];
        _Topic_JC.rect = CGRectMake(0, 0, SCR_WIDTH, 260);
        _Topic_JC.backgroundColor = [UIColor whiteColor];
        _Topic_JC.totalNum = 3;
        _Topic_JC.type = JCTopicMiddle;
        _Topic_JC.scrollView = self.scrollerView;
        
    }
    return _Topic_JC;
}

- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCR_WIDTH,  SCR_HEIGHT + 20)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //设置scrollerView
    [self.view addSubview:self.scrollerView];

    //加载上部分内容
    [self setupTopView];
    
    self.scrollerView.contentSize = CGSizeMake(0, _recordY);
}


//顶部标题和附标题
- (void)setupTopView
{
    //记载轮播图
    [self.scrollerView addSubview:self.Topic_JC];
    self.Topic_JC.pics = @[
                           @{@"pic":IMAGE_NAMED(@"testImage1.png"), @"isLoc":@YES},
                           @{@"pic":IMAGE_NAMED(@"testImage2.png"), @"isLoc":@YES},
                           @{@"pic":IMAGE_NAMED(@"testImage3.png"), @"isLoc":@YES}];
    [self.Topic_JC upDate];
    
    
    UIButton *leftBtn = [UIButton buttonWithFrame:CGRectMake(20, 40, 9, 17) backImage:@"nav-back" target:self action:@selector(popAction)];
    [self.scrollerView addSubview:leftBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, SCR_WIDTH - 20, 20)];
    titleLabel.text = @"有了这些变美神器，做永远的元气美少女";
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [self.scrollerView addSubview:titleLabel];
    
    UILabel *subtitlte = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.x, CZGetY(titleLabel) + 10, titleLabel.width, 20)];
    subtitlte.text = @"逆龄生长的秘方，好东西值得拥有";
    subtitlte.textColor = CZGlobalGray;
    subtitlte.font = [UIFont systemFontOfSize:14];
    subtitlte.numberOfLines = 0;
    [self.scrollerView addSubview:subtitlte];
    
    _recordY = CZGetY(subtitlte);
    _recordY += 20;
    
    [self setupTitleAndImage];
}

- (void)setupTitleAndImage
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, _recordY, SCR_WIDTH - 20, 300)];
    
    [self.scrollerView addSubview:backView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backView.width, 20)];
    [backView addSubview:title];
    NSString *text = @"1  进口硅胶充电式洁面仪";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
//    NSDictionary *UnderlineAS = @{
//        NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
//        NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:16],
//        NSForegroundColorAttributeName : [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.87]
//
//                                  };
    NSDictionary *attDic = @{
                             NSFontAttributeName : [UIFont systemFontOfSize:20],
                             NSForegroundColorAttributeName : [UIColor redColor]
                             };
    [attributeStr addAttributes:attDic range:NSMakeRange(0, 1)];
    title.attributedText = attributeStr;
    
    
    UIView *imageLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(title) + 20, backView.width, 0)];
    [backView addSubview:imageLabelView];
    
    CGFloat imageLabelViewHeight = 0;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, imageLabelViewHeight, imageLabelView.width, 260);
        imageView.image = [UIImage imageNamed:@"testImage6"];
        [imageLabelView addSubview:imageView];
        
        NSString *subtext = @"00后都准备上大学了，80后90后的姐妹们也准备跨入与衰老斗争的大门了，毕竟不再能拥有熬夜后还焕发光彩的肌肤。其实当女生过了二十岁的门槛，肌肤里的胶原蛋白就会急剧流逝导致暗沉、细纹横生，肌肤松弛、斑点等初老症状。";
        
        //行间距的属性
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        
        //初始化可变字符串
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:subtext];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [subtext length])];
        
        //属性字典
        NSDictionary *subTitleAttributDic = @{
                                              NSParagraphStyleAttributeName : paragraphStyle,
                                              NSFontAttributeName : [UIFont systemFontOfSize:16] };
        //设置富文本属性
        [attributedString addAttributes:subTitleAttributDic range:NSMakeRange(0, [subtext length])];
        
        
        //计算高度
        CGFloat height = [subtext boundingRectWithSize:CGSizeMake(imageView.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:subTitleAttributDic context:nil].size.height;
        
        UILabel *subTitle = [[UILabel alloc] init];
        subTitle.frame = CGRectMake(0, CZGetY(imageView) + 20, imageLabelView.width, height);
        subTitle.attributedText = attributedString;
        subTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
        subTitle.textColor = CZRGBColor(21, 21, 21);
        subTitle.numberOfLines = 0;
        [imageLabelView addSubview:subTitle];
        imageLabelView.height = CZGetY(subTitle) + 10;
        imageLabelViewHeight += (imageView.height + subTitle.height + 20 + 20);
    }
    
    backView.height = CZGetY(imageLabelView);
    _recordY += backView.height;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}










@end
