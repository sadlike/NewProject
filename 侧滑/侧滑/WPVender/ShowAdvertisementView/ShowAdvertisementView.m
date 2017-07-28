//
//  ShowAdvertisementView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "ShowAdvertisementView.h"

#import "UIImageView+WebCache.h"

@interface ShowAdvertisementView ()<UIScrollViewDelegate>
@property (nonatomic,assign) BOOL isShowLabel;

@end

@implementation ShowAdvertisementView
@synthesize showPageHeight,isShowLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withShowPageHeight:(float)showpageHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showPageHeight = showpageHeight;
        [self awakeFromNib];

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withShowPageHeight:(float)showpageHeight withShowLabel:(BOOL)isShow
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.showPageHeight = showpageHeight;
        self.isShowLabel = isShow;
        [self awakeFromNib];
    }
    return self;
}
- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    [self initSubViews];
    [self startTimer];
    [super awakeFromNib];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    for (int i = 0; i < _showPictureImageArray.count; i++) {
//        UIImageView *imageView = _showPictureImageArray[i];
//        imageView.frame = CGRectMake(i * self.width, 0, self.width, self.height - self.showPageHeight);
//    }
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentScrollView.frame) * 3, CGRectGetHeight(self.contentScrollView.frame));
    CGFloat subView_W = CGRectGetWidth(self.contentScrollView.frame);
    
    for (int i = 0; i < _showPictureImageArray.count; i++) {
        UIImageView *imageView = _showPictureImageArray[i];
          CGRect subViewFrame = imageView.frame;
        subViewFrame.origin.x = subView_W * i;
        imageView.frame = subViewFrame;
    }
}

- (void)initSubViews{
    CGRect frame = self.bounds;

    if (self.showPageHeight > 0) {
       frame.size.height = frame.size.height - showPageHeight;
    }
    _contentScrollView = [[UIScrollView alloc]initWithFrame:frame];
    _contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    [self addSubview:_contentScrollView];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake(self.width * 3, 0);
    [self scrollViewAddContentView];
    
    _pageControl = [[SShowPageShapeView alloc]initWithFrame:CGRectMake(0, self.height - 3, self.bounds.size.width, 3)];
    _pageControl.userInteractionEnabled = NO;

    
    [self addSubview:_pageControl];
}

- (void)scrollViewAddContentView{
    self.showPictureImageArray = [NSMutableArray array];
    CGRect rect = self.contentScrollView.bounds;
    for (int i = 0; i < 3; i++) {
        rect.origin.x = i * self.width;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = self.placeholderImage;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageViewAction:)];
        [imageView addGestureRecognizer:tap];
        
        // 背景虚化 线条
        UIView *titleBackView = [[UIView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+AUTO_SIZE(44),(imageView.height-AUTO_SIZE(100))/2 ,rect.size.width-AUTO_SIZE(88), AUTO_SIZE(100))];
 
        titleBackView.layer.borderColor=COLOR_WHITE.CGColor;
        titleBackView.layer.borderWidth=ISRetina_Min_Line;
        
//        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+AUTO_SIZE(50),imageView.height-AUTO_SIZE(76/2)-AUTO_SIZE(90) ,rect.size.width-AUTO_SIZE(50)-AUTO_SIZE(98/2), AUTO_SIZE(90))];
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(AUTO_SIZE(5),AUTO_SIZE(5) ,titleBackView.width-AUTO_SIZE(10), AUTO_SIZE(90))];
        titleView.userInteractionEnabled=YES;
        //控件透明 子控件不透明
        titleView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        [titleBackView addSubview:titleView];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, AUTO_SIZE(15), titleView.width, AUTO_SIZE(30))];
        titleLabel.text=@"广告的主标题";
        titleLabel.font=FONT_T18;
        titleLabel.textColor=COLOR_C3;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [titleView addSubview:titleLabel];
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.height+titleLabel.frame.origin.y, titleView.width, AUTO_SIZE(20))];
        detailLabel.text=@"广告的副标题";
        detailLabel.font=FONT_t15;
        detailLabel.textColor=COLOR_CBD;
        detailLabel.textAlignment=NSTextAlignmentCenter;
        [titleView addSubview:detailLabel];
        
        [self.contentScrollView addSubview:imageView];
        if(self.isShowLabel)
        {
            [self.contentScrollView addSubview:titleBackView];
        }
        [self.showPictureImageArray addObject:imageView];
    }
    self.contentScrollView.contentOffset = CGPointMake(self.width, 0);
}

#pragma mark 重置ImageView位置
- (void)resetScrollViewContentLocation{
    _pageControl.currentPage = _index;
    if ([self.delegate respondsToSelector:@selector(advertisementViewSelectedIndex:)]) {
        [self.delegate advertisementViewSelectedIndex:_index];
    }
    for (int i = 0; i < self.showPictureImageArray.count; i++) {
        NSInteger index = _index - 1 + i;
        if (index < 0) {
            index = self.contentModelArray.count + index;
        }else if(index >= self.contentModelArray.count){
            index = index - self.contentModelArray.count;
        }
        UIImageView *imageView = self.showPictureImageArray[i];
        imageView.tag = index + 90;
        NSString *imgUrlStr = [self.contentModelArray objectAtIndex:index];
        if([imgUrlStr hasPrefix:@"http"])
        {
            ////        SDiscoveryBannerModel *currentModel = [self.contentModelArray objectAtIndexCheck:index];
            //        NSURL *currentURL = [NSURL URLWithString:currentModel.img];
            NSURL *currentURL = [NSURL URLWithString:imgUrlStr];
            NSLog(@"currentURL--%@",currentURL);
            
            [imageView sd_setImageWithURL:currentURL placeholderImage:self.placeholderImage];
        }
        else
        {
            [imageView setImage:[UIImage imageNamed:imgUrlStr]];
        }

            }
    self.contentScrollView.contentOffset = CGPointMake(self.width, 0);
}

#pragma mark - 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / self.width;
    CGFloat c = fmodf(scrollView.contentOffset.x, self.width);
    if (index == 1 || c != 0 || !self.contentModelArray) return;
    if (index == 0) {
        _index = _index - 1 < 0? (int)self.contentModelArray.count - 1: _index - 1;
    }else if(index == 2){
        _index = _index + 1 > self.contentModelArray.count - 1? 0: _index + 1;;
    }
    [self resetScrollViewContentLocation];
}

#pragma mark 启动计时器
- (void)startTimer{
    _timer = [NSTimer timerWithTimeInterval:5.0 target:self
                                   selector:@selector(nextImageViewForScrollView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)nextImageViewForScrollView{
    [self.contentScrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
}

#pragma mark  用户拖动scrollview时使计时器失效
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark  拖动scrollview结束时计时器开始
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSDate *date = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];
    [self.timer setFireDate:date];
}

#pragma mark - touch action 点击跳转
- (void)touchImageViewAction:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 90;
    //图片的 model
//    SDiscoveryBannerModel *currentModel = self.contentModelArray[index];
//    NSDictionary *params;
//    if ([currentModel respondsToSelector:@selector(dict)]) {
//        params = currentModel.dict;
//    }else{
//        params = [currentModel valueForKey:@"jump"];
//    }
//    if (!params) return;
//    [[SUtilityTool shared]jumpControllerWithContent:params target:_target];
    if ([self.delegate respondsToSelector:@selector(advertisementViewTouchIndex:)]) {
        [self.delegate advertisementViewTouchIndex:index];
    }
}

#pragma mark - get   set
-(void)setTitleArray:(NSMutableArray *)titleArray
{
    _titleArray = titleArray;
}
-(void) setContentArray:(NSMutableArray *)contentArray
{
    _contentArray = contentArray;
}
- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    if (contentModelArray == nil || contentModelArray.count == 0) {
        self.contentScrollView.userInteractionEnabled = NO;
        return;
    }else if(contentModelArray.count == 1){
        _pageControl.hidden = YES;
        if (_timer) {
            [_timer invalidate];
        }
    }else{
        if (!_timer) {
            [self startTimer];
        }
        _pageControl.hidden = NO;
    }
    self.contentScrollView.userInteractionEnabled = YES;
    _index = 0;
    _pageControl.pageSize = contentModelArray.count;
    [self resetScrollViewContentLocation];
    if (contentModelArray.count <= 1) {
        self.contentScrollView.scrollEnabled = NO;
    }else{
        self.contentScrollView.scrollEnabled = YES;
    }
    NSDate *date = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];
    [self.timer setFireDate:date];
}

- (void)setShowPageFrameHeight:(float)showPageFrameHeight{
    _showPageFrameHeight = showPageFrameHeight;
    _pageControl.height = showPageFrameHeight;
}

- (void)setShowPageBottomSpace:(float)showPageBottomSpace{
    _showPageBottomSpace = showPageBottomSpace;
    _pageControl.bottom = self.height - showPageBottomSpace;
}

- (void)setNormalItemColor:(UIColor *)normalItemColor{
    _normalItemColor = normalItemColor;
    _pageControl.normalItemColor = normalItemColor;
}

- (void)setSelectedItemColor:(UIColor *)selectedItemColor{
    _selectedItemColor = selectedItemColor;
    _pageControl.selectedItemColor = selectedItemColor;
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
//    self.contentModelArray = contentModel.config;
}

- (UIImage *)placeholderImage{
    if (!_placeholderImage) {
        _placeholderImage = [UIImage imageNamed:@"icon"];
        
    }
    return _placeholderImage;
}

@end
