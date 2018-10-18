//
//  JCTopic.m
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import "JCTopic.h"
#define SPACE 5
#define HEI 26
#define WID 156
#define HX 200
#define HY 380
#define FSIZE 16

@interface JCTopic ()
/** <#注释#> */
@property (nonatomic, assign) CGFloat originY;
@end

@implementation JCTopic
@synthesize JCdelegate;
@synthesize rect;
@synthesize totalNum;
@synthesize scrollView;
@synthesize type;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.originY = frame.size.height - 30;
        [self setSelf];
       
    }
    return self;
}
-(void)setSelf{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    switch (type) {
        case JCTopicLeft:
        {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(HX, self.originY, WID, HEI)];
            pageControl.numberOfPages = totalNum;
            pageControl.currentPage = 0;
            pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            pageControl.pageIndicatorTintColor = [UIColor grayColor];
            [pageControl setBounds:CGRectMake(0, 0, 16 * (3 - 1) + 16, 16)];
            [scrollView==nil?self.window:scrollView addSubview:pageControl];
        }
            break;
            
        case JCTopicMiddle:
        {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(HX, self.originY, WID, HEI)];
            pageControl.numberOfPages = totalNum;
            pageControl.currentPage = 0;
            pageControl.center=CGPointMake(self.center.x, pageControl.center.y);
            [pageControl setBounds:CGRectMake(0, 0, 16 * (3 - 1) + 16, 16)];
            [scrollView==nil?self.window:scrollView addSubview:pageControl];
        }
            break;
        case JCTopicRight:
        {
            
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(HX, self.originY, WID, HEI)];
            pageControl.numberOfPages = totalNum;
            pageControl.currentPage = 0;
            [pageControl setBounds:CGRectMake(0, 0, 16 * (3 - 1) + 16, 16)];
            [scrollView==nil?self.window:scrollView addSubview:pageControl];
        }
            break;
        default:
            break;
    }

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setSelf];
    
    // Drawing code
}
-(void)upDate{
    NSMutableArray * tempImageArray = [[NSMutableArray alloc]init];
    [tempImageArray addObject:[self.pics lastObject]];
    for (id obj in self.pics) {
        [tempImageArray addObject:obj];
    }
    [tempImageArray addObject:[self.pics objectAtIndex:0]];
    self.pics = Nil;
    self.pics = tempImageArray;
    
    int i = 0;
    for (id obj in self.pics) {
 
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width+rect.origin.x,rect.origin.y, rect.size.width, rect.size.height)];
        //tempImage.contentMode = UIViewContentModeScaleAspectFill;
        [tempImage setClipsToBounds:YES];
        if ([[obj objectForKey:@"isLoc"]boolValue]) {
            [tempImage setImage:[obj objectForKey:@"pic"]];
        }else{
            if ([obj objectForKey:@"placeholderImage"]) {
                [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
            }
            [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[obj objectForKey:@"pic"]]]
                                               queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                                   if (!error && responseCode == 200) {
                                                       tempImage.image = Nil;
                                                       UIImage *_img = [[UIImage alloc] initWithData:data];
                                                       [tempImage setImage:_img];
                                                   }else{
                                                       if ([obj objectForKey:@"placeholderImage"]) {
                                                           [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
                                                       }
                                                   }
                                               }];
        }
 
        [self addSubview:tempImage];

        i ++;
    }
    [self setContentSize:CGSizeMake(self.frame.size.width*[self.pics count], 0)];
    [self setContentOffset:CGPointMake(self.frame.size.width, self.contentOffset.y) animated:NO];
    
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
    if ([self.pics count]>3) {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
    [pageControl bringSubviewToFront:self];
}
-(void)click:(id)sender{
    [JCdelegate didClick:[self.pics objectAtIndex:[sender tag]]];
}
- (void)scrollViewDidScroll:(UIScrollView *)ScrollView{
    
    CGFloat Width=self.frame.size.width;
    if (ScrollView.contentOffset.x == self.frame.size.width) {
        flag = YES;
    }
    if (flag) {
        if (ScrollView.contentOffset.x <= 0) {
            [self setContentOffset:CGPointMake(Width*([self.pics count]-2), self.contentOffset.y) animated:NO];
        }else if (ScrollView.contentOffset.x >= Width*([self.pics count]-1)) {
            [self setContentOffset:CGPointMake(self.frame.size.width, self.contentOffset.y) animated:NO];
        }
    }
    currentPage = ScrollView.contentOffset.x/self.frame.size.width-1;
    [JCdelegate currentPage:currentPage total:[self.pics count]-2];
    scrollTopicFlag = currentPage+2==2?2:currentPage+2;
    
    pageControl.currentPage = scrollTopicFlag-2;
}
-(void)scrollTopic{
    [self setContentOffset:CGPointMake(self.frame.size.width*scrollTopicFlag, self.contentOffset.y) animated:YES];

    pageControl.currentPage = scrollTopicFlag-2;
    if (scrollTopicFlag > [self.pics count]) {
        scrollTopicFlag = 1;
    }else {
        scrollTopicFlag++;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
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
