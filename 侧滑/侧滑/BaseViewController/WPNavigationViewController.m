//
//  WPNavigationViewController.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "WPNavigationViewController.h"
#import "UIImage+WP.h"
#import "WPCommon.h"

@interface WPNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WPNavigationViewController
+(void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    //设置背景图片
    UIImage *backImg=[UIImage imageWithColor:COLOR_CB];
    [navigationBar setBackgroundImage:backImg forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    // 设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = FONT_T18;
    [navigationBar setTitleTextAttributes:attrs];
    
    // 2.设置BarButtonItem的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置文字颜色
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = COLOR_WHITE;
    itemAttrs[NSFontAttributeName] = FONT_T18;
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    //右滑返回
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate=self;
    }
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
