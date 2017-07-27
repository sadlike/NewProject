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

@interface WPShowHomeViewController ()<DCPathButtonDelegate>
//@property (nonatomic,strong) WPPathView * pathAnimationView;
//@property (nonatomic , strong) DCPathButton *pathAnimationView;

@end

@implementation WPShowHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title=@"首页";
    [self setNavigationBar:self.revealViewController btnImageNameStr:@"icon_collect_normal" Type:1];
    [self initPathButton];
    
//    UILabel *label = [WPFactory createLabelWithFrame:CGRectMake(0, 0, 300, 50) text:@"label" textColor:COLOR_CC font:15];
//    [self.view addSubview:label];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(50, 200, 50, 40)];
//    [btn setTitle:@"点击" forState:UIControlStateNormal];
//    [btn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(jumptoNext) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];

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
    ///
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
