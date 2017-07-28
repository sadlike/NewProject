//
//  WPShowHomeViewController.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "WPShowHomeViewController.h"

#import "SecondViewController.h"
#import "UINavigationController+WP.h"
//#import "WPPathView.h"
#import "DCPathButton.h"
#import "HWLocationManager.h"
#import "HWGetAddressBook.h"
#import "ShowAdvertisementView.h"
#import "NSArray+Sudoku.h"

@implementation UIColor (Extensions)


+ (instancetype)randomColor {
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    return [self colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
@interface WPShowHomeViewController ()<DCPathButtonDelegate,ShowAdvertisementViewDelegate>
{
    UIView *headView;
    
}
@property(nonatomic,strong)UIView *containerView;//九宫格view
@end

@implementation WPShowHomeViewController
-(UIView *)containerView
{
    if (!_containerView) {
        UIView *containerView=[[UIView alloc]init];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.userInteractionEnabled=YES;
        _containerView = containerView;
    }
    return  _containerView;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSString *titleStr= NSLocalizedString(@"Home", nil);
    self.title=titleStr;
    [self setNavigationBar:self.revealViewController btnImageNameStr:@"icon_collect_normal" Type:1];

    [self initAdView];
    [self.view addSubview:self.containerView];
     [self distributeFixedCellWithCount:9 warp:3];
//    [self autoLayOutContainerView];
//    [self initSubViews];
    
    [self initPathButton];
}
-(void)initAdView
{
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, AUTO_SIZE(150))];
    [headView setBackgroundColor:COLOR_WHITE];
    ShowAdvertisementView *_contentPlayerView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, AUTO_SIZE(150)) withShowPageHeight:0 withShowLabel:YES];
    _contentPlayerView.showPageFrameHeight = 2;
    _contentPlayerView.showPageBottomSpace = 1;
    _contentPlayerView.delegate = self;
    _contentPlayerView.selectedItemColor = COLOR_CBD;
    _contentPlayerView.normalItemColor = [COLOR_CB colorWithAlphaComponent:0.5];
    _contentPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    _contentPlayerView.backgroundColor=[UIColor whiteColor];
    //title  content  //数组个数>1 则可滑动
    [_contentPlayerView setContentModelArray:@[@"banner-home@2x",@"banner-home@2x"]];
    [headView addSubview:_contentPlayerView];
    [self.view addSubview:headView];
}
-(void)autoLayOutContainerView
{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(headView.mas_bottom).offset(0);
        make.width.and.height.equalTo(self.view.mas_width).offset(-30);
    }];
    
}
-(void)initPathButton
{
//    WPPathView *dcPathButton = [[WPPathView alloc]initWithCenterImg:[UIImage imageNamed:@"chooser-button-tab"] hilightedImg:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
//    _pathAnimationView = dcPathButton;
    
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab@2x"]
                                                           hilightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted@2x"]];
//    _pathAnimationView = dcPathButton;
    
    dcPathButton.delegate = self;
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5]];
    
    [self.view addSubview:dcPathButton];

}
-(void)initSubViews
{
    //每个Item宽高
    CGFloat W = 80;
    CGFloat H = 100;
    //每行列数
    NSInteger rank = 3;
    //每列间距
    CGFloat rankMargin = (self.view.frame.size.width-30 - rank * W) / (rank - 1);
    //每行间距
    CGFloat rowMargin = 20;
    //Item索引 ->根据需求改变索引
    NSUInteger index = 9;
    
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 10;
        UIView *speedView = [[UIView alloc] init];
        speedView.backgroundColor = [UIColor randomColor];
//        speedView.backgroundColor=[UIColor grayColor];
        speedView.frame = CGRectMake(X, Y+top, W, H);
        [self.containerView  addSubview:speedView];
    }
}
// 固定container大小
// 固定宫格大小
- (void)distributeFixedCellWithCount:(NSUInteger)count warp:(NSUInteger)warp {
    
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self autoLayOutContainerView];
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor randomColor]];
        btn.tag=i;
        [btn setTitleColor:[UIColor randomColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:btn];
    }
    float space = AUTO_SIZE(10.0);
    [self.containerView.subviews mas_distributeSudokuViewsWithFixedItemWidth:AUTO_SIZE(90)
                                                             fixedItemHeight:AUTO_SIZE(90)
                                                                   warpCount:warp
                                                                  topSpacing:space
                                                               bottomSpacing:space
                                                                 leadSpacing:space
                                                                 tailSpacing:space];
}
-(void)btnClick:(UIButton *)sender
{
    NSLog(@"sender--%ld",(long)sender.tag);
    if (![sender.titleLabel.textColor isEqual:sender.backgroundColor]) {
   
        NSString *titleStr= NSLocalizedString(@"Congratulation", nil);
        NSString *descrpition= NSLocalizedString(@"Your Good Luck!", nil);
        NSString *cancel = NSLocalizedString(@"Cancle", nil);
        NSString *next =NSLocalizedString(@"Next", nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:descrpition preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }];
       
        [cancelAction setValue:[UIColor randomColor] forKey:@"_titleTextColor"];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:next style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
         [okAction setValue:[UIColor randomColor] forKey:@"_titleTextColor"];
        //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [hogan addAttribute:NSFontAttributeName value:FONT_T18 range:NSMakeRange(0, [[hogan string] length])];
        [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor randomColor] range:NSMakeRange(0, [[hogan string] length])];
        [alertController setValue:hogan forKey:@"attributedTitle"];

        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
    }
}
#pragma mark - DCPathButton Delegate

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    NSLog(@"You tap at index : %ld", index);
    switch (index) {
        case 0:
        {
               [self distributeFixedCellWithCount:9 warp:3];
        }
            break;
        case 1:
        {
            [self getLocation];
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            [self getAddressBook];
            
        }
            break;
        case 4:
        {
            [self jumptoNext];
        }
            break;
            
        default:
            break;
    }
    ///
}
- (void)advertisementViewSelectedIndex:(int)index
{
    NSLog(@"index---%d",index);
    
}
#pragma mark 拉通讯录
-(void)getAddressBook
{
    if (!hwGetAddressBook) {
        hwGetAddressBook = [[HWGetAddressBook  alloc]init];
    }
    hwGetAddressBook.target=self;
    [hwGetAddressBook gainAddressBookInfoCompleteBlock:^(NSArray *allInfoArray, NSArray *chooseInfoArray, AddressBookInfoSuccessType successType, SBaseHandlerReturnType returnType) {
        switch (returnType) {
            case SBaseHandlerReturnTypeSuccess:
            {
                switch (successType) {
                    case addressBookInfoAllPeopleType:
                    {
                        // 上传所有信息回调 do somethiing
                    } break;
                    case addressBookInfochoosePeopleType:{
                        //选择了单个联系人后 do somethiing
                    }break;
                        
                    default:
                        break;
                }
            } break;
            case SBaseHandlerReturnTypeFailed:{
                //获取通讯录失败,回调 doSomething   .
            }break;
            default:
                break;
        }
    }];
    [hwGetAddressBook getUserAddressBookMessage];
    
}
#pragma mark 获取定位
-(void)getLocation
{
    if (!hwLocationManger) {
        hwLocationManger= [[HWLocationManager alloc]init];
    }
    [hwLocationManger gainLocationCompleteBlock:^(id sender,NSString *locationProvince ,NSString *locationCity,NSString *locationArea, SBaseHandlerReturnType returnType) {
        
        switch (returnType) {
            case SBaseHandlerReturnTypeSuccess:
            {
                //获取地理位置成功后do something
                NSLog(@"--经度-%@--精度-%@---纬度-%@",sender,hwLocationManger.longitude,hwLocationManger.latitude);
            }
                break;
            case SBaseHandlerReturnTypeFailed:
            {
            }
                break;
            default:
                break;
        }
    }];
    [hwLocationManger  getStartLocation];
    
 
}
-(void)jumptoNext
{
    SecondViewController *second = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:second fromViewController:self animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
