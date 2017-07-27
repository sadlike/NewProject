//
//  WPPathView.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "WPPathView.h"
#import <QuartzCore/QuartzCore.h>

@interface WPPathView ()
{
    
}
@property (strong, nonatomic) UIImage *centerImage;
@property (strong, nonatomic) UIImage *centerHighlightedImage;

@property (assign, nonatomic) CGSize foldedSize;
@property (assign, nonatomic) CGSize bloomSize;

@property (assign, nonatomic) CGPoint foldCenter;
@property (assign, nonatomic) CGPoint bloomCenter;

@property (assign, nonatomic) CGPoint pathCenterButtonBloomCenter;

@property (assign, nonatomic) CGPoint expandCenter;


@property (strong, nonatomic) NSMutableArray *itemButtons;//图片

@property (strong, nonatomic) UIImageView *pathCenterButtonView;
@property (strong, nonatomic) UIView *bottomView;//阴影遮罩
@property (assign, nonatomic)BOOL bloom;


@end
@implementation WPPathView

- (instancetype)initWithCenterImg:(UIImage *)centerImg hilightedImg:(UIImage *)centerHighlightedImg
{
    self = [super init];
    if (self) {
        self.centerImage =centerImg;
        self.centerHighlightedImage=centerHighlightedImg;
        self.itemBtnImgs = [[NSMutableArray alloc]init];
        self.itemBtnHightlightImgs = [[NSMutableArray alloc]init];
        [self configureViewLayout];
    }
    return self;
    
}
-(void)configureViewLayout
{
    self.foldedSize = self.centerImage.size;
    self.bloomSize = [UIScreen mainScreen].bounds.size;
    self.bloomRadius = 100.0f;
    self.foldCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height -100);
    self.bloomCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height /2);
    
    self.frame = CGRectMake(0, 0,self.foldedSize.width , self.foldedSize.height);
    self.center = self.foldCenter;
    
    _pathCenterButtonView = [[UIImageView alloc]initWithImage:self.centerImage highlightedImage:self.centerHighlightedImage];
    _pathCenterButtonView.userInteractionEnabled=YES;
    _pathCenterButtonView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:_pathCenterButtonView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPathView)];
    [_pathCenterButtonView addGestureRecognizer:tap];
   
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height)];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.0f;
}
- (void)addPathItems:(NSArray *)pathItemButtons
{
    [self.itemButtons addObjectsFromArray:pathItemButtons];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Tap the bottom area, excute the fold animation
    [self pathCenterButtonFold];
}

-(void)clickPathView
{
      self.bloom? [self pathCenterButtonFold] : [self pathCenterButtonBloom];
}
-(void)pathCenterButtonFold
{
    for (int i =1 ; i<=self.itemButtons.count; i++) {
        UIImageView *imgView = self.itemButtons[i-1];
        CGFloat currentAngel = i / ((CGFloat)self.itemButtons.count + 1);
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 5.0f andAngel:currentAngel];
        
        CAAnimationGroup *foldAnimation = [self foldAnimationFromPoint:imgView.center withFarPoint:farPoint];
        
        [imgView.layer addAnimation:foldAnimation forKey:@"foldAnimation"];
        imgView.center = self.pathCenterButtonBloomCenter;
    }
    [self bringSubviewToFront:self.pathCenterButtonView];

    [self resizeToFoldedFrame];
    
}
-(void)resizeToFoldedFrame
{
    [UIView animateWithDuration:0.0618f * 3
                          delay:0.0618f * 2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.pathCenterButtonView.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.1f
                          delay:0.35f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _bottomView.alpha = 0.0f;
                     }
                     completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIImageView *imgView in self.itemButtons) {
            [imgView performSelector:@selector(removeFromSuperview)];
        }
        
        self.frame = CGRectMake(0, 0, self.foldedSize.width, self.foldedSize.height);
        self.center = self.foldCenter;
        self.pathCenterButtonView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self.bottomView removeFromSuperview];
    });
    
    _bloom = NO;
}
- (CGPoint)createEndPointWithRadius:(CGFloat)itemExpandRadius andAngel:(CGFloat)angel
{
    return CGPointMake(self.pathCenterButtonBloomCenter.x - cosf(angel * M_PI) * itemExpandRadius,
                       self.pathCenterButtonBloomCenter.y - sinf(angel * M_PI) * itemExpandRadius);
}
- (CAAnimationGroup *)foldAnimationFromPoint:(CGPoint)endPoint withFarPoint:(CGPoint)farPoint
{
    // 1.Configure rotation animation
    //
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0), @(M_PI), @(M_PI * 2)];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.35f;
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, self.pathCenterButtonBloomCenter.x, self.pathCenterButtonBloomCenter.y);
    
    movingAnimation.keyTimes = @[@(0.0f), @(0.75), @(1.0)];
    
    movingAnimation.path = path;
    movingAnimation.duration = 0.35f;
    CGPathRelease(path);
    
    // 3.Merge animation together
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[rotationAnimation, movingAnimation];
    animations.duration = 0.35f;
    
    return animations;
}
-(void)pathCenterButtonBloom
{
    self.pathCenterButtonBloomCenter = self.center;
    
    // 2. Resize the DCPathButton's frame
    //
    self.frame = CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height);
    self.center = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height / 2);
    
    [self insertSubview:self.bottomView belowSubview:self.pathCenterButtonView];
    
    // 3. Excute the bottom view alpha animation
    //
    [UIView animateWithDuration:0.0618f * 3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bottomView.alpha = 0.618f;
                     }
                     completion:nil];
    
    // 4. Excute the center button rotation animation
    //
    [UIView animateWithDuration:0.1575f
                     animations:^{
                         _pathCenterButtonView.transform = CGAffineTransformMakeRotation(-0.75f * M_PI);
                     }];
    
    self.pathCenterButtonView.center = self.pathCenterButtonBloomCenter;
    
    // 5. Excute the bloom animation
    //
    CGFloat basicAngel = 180 / (self.itemButtons.count + 1) ;
    
    for (int i = 1; i <= self.itemButtons.count; i++) {
        
        UIImageView *imgView = self.itemButtons[i - 1];
        
        imgView.tag = i - 1;
        imgView.transform = CGAffineTransformMakeTranslation(1, 1);
        imgView.alpha = 1.0f;
        
        // 1. Add pathItem button to the view
        //
        CGFloat currentAngel = (basicAngel * i)/180;
        
        imgView.center = self.pathCenterButtonBloomCenter;
        
        [self insertSubview:imgView belowSubview:self.pathCenterButtonView];
        
        // 2.Excute expand animation
        //
        CGPoint endPoint = [self createEndPointWithRadius:self.bloomRadius andAngel:currentAngel];
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 10.0f andAngel:currentAngel];
        CGPoint nearPoint = [self createEndPointWithRadius:self.bloomRadius - 5.0f andAngel:currentAngel];
        
        CAAnimationGroup *bloomAnimation = [self bloomAnimationWithEndPoint:endPoint
                                                                andFarPoint:farPoint
                                                               andNearPoint:nearPoint];
        
        [imgView.layer addAnimation:bloomAnimation forKey:@"bloomAnimation"];
        imgView.center = endPoint;
        
    }
    
    _bloom = YES;
    

}

- (CAAnimationGroup *)bloomAnimationWithEndPoint:(CGPoint)endPoint andFarPoint:(CGPoint)farPoint andNearPoint:(CGPoint)nearPoint
{
    // 1.Configure rotation animation
    //
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0.0), @(- M_PI), @(- M_PI * 1.5), @(- M_PI * 2)];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.keyTimes = @[@(0.0), @(0.3), @(0.6), @(1.0)];
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.pathCenterButtonBloomCenter.x, self.pathCenterButtonBloomCenter.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, nearPoint.x, nearPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    movingAnimation.path = path;
    movingAnimation.keyTimes = @[@(0.0), @(0.5), @(0.7), @(1.0)];
    movingAnimation.duration = 0.3f;
    CGPathRelease(path);
    
    // 3.Merge two animation together
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[movingAnimation, rotationAnimation];
    animations.duration = 0.3f;
    animations.delegate = self;
    
    return animations;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
