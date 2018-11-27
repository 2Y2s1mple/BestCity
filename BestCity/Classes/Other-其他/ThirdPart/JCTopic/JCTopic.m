//
//  JCTopic.m
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import "JCTopic.h"
#import "UIImageView+WebCache.h"
#define SPACE 5
#define HEI 26
#define WID 156
#define HX 200
#define HY 380
#define FSIZE 16

@interface JCTopic ()
/** <#注释#> */
@property (nonatomic, assign) CGFloat originY;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageArr;
@end

@implementation JCTopic
@synthesize rect;
@synthesize scrollView;

- (NSMutableArray *)imageArr
{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.originY = frame.size.height - 30;
        [self setup];
       
    }
    return self;
}

-(void)setup{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setPics:(NSArray *)pics
{
    _pics = pics;
    
    NSDictionary *dic = [pics lastObject];
    
    
    UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCR_WIDTH, rect.size.height)];
    if ([dic[@"isLoc"] boolValue]) {
        [tempImage setImage:dic[@"pic"]];
    }else{
        [tempImage sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    }
    [self.imageArr addObject:tempImage];
    [self addSubview:tempImage];
    
    
    for (int i = 1; i < self.pics.count + 1; i++) {
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(i * SCR_WIDTH, 0, SCR_WIDTH, rect.size.height)];
        if ([self.pics[i - 1][@"isLoc"] boolValue]) {
            [tempImage setImage:self.pics[i - 1][@"pic"]];
        }else{
            [tempImage sd_setImageWithURL:[NSURL URLWithString:self.pics[i - 1][@"pic"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
        }
        [self.imageArr addObject:tempImage];
        [self addSubview:tempImage];
    }
    [self setContentSize:CGSizeMake(self.frame.size.width * ([self.pics count] + 1), 0)];
    [self setContentOffset:CGPointMake(SCR_WIDTH, 0)];
    
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    scrollTopicFlag = 1;
}

-(void)upDate{

//    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}

-(void)scrollTopic{
    
    [self setContentOffset:CGPointMake(SCR_WIDTH * scrollTopicFlag, 0) animated:YES];
    
    if (scrollTopicFlag > self.pics.count + 1) {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
        scrollTopicFlag = 0;
    }else if (self.contentOffset.x < 0) {
        [self setContentOffset:CGPointMake((self.pics.count) * SCR_WIDTH, 0) animated:NO];
    }
    scrollTopicFlag++;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)ScrollView
{
    NSInteger index = self.contentOffset.x / SCR_WIDTH;
    NSLog(@"%ld", (long)index);
    if (self.contentOffset.x > (self.pics.count) * SCR_WIDTH) {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }else if (self.contentOffset.x < 0) {
        [self setContentOffset:CGPointMake((self.pics.count) * SCR_WIDTH, 0) animated:NO];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

-(void)releaseTimer{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

@end
