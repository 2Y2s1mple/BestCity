//
//  JCTopic.h
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import <UIKit/UIKit.h>
@protocol JCTopicDelegate<NSObject>
-(void)currentPage:(int)page total:(NSUInteger)total;
@end

@interface JCTopic : UIScrollView<UIScrollViewDelegate>{
    bool flag;
    int scrollTopicFlag;
    NSTimer * scrollTimer;
    CGSize imageSize;
    UIImage *image;
    @public
}
@property(nonatomic,strong) NSArray      *pics;
@property(nonatomic,assign) CGRect       rect;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) id<JCTopicDelegate> JCdelegate;
-(void)releaseTimer;
-(void)upDate;
@end
