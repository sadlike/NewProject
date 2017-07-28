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

@interface WPShowHomeViewController ()<DCPathButtonDelegate,ShowAdvertisementViewDelegate>

@end

@implementation WPShowHomeViewController
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
    [self initPathButton];
    [self initAdView];


}
-(void)initAdView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, AUTO_SIZE(150))];
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
#pragma mark - DCPathButton Delegate

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    NSLog(@"You tap at index : %ld", index);
    switch (index) {
        case 0:
        {
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
