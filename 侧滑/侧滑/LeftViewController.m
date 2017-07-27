//
//  LeftViewController.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "LeftViewController.h"
#import "WPShowHomeViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //增加点击收拾切换
    UITapGestureRecognizer *pushFrontVC = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushFrontVC)];
    [self.view addGestureRecognizer:pushFrontVC];
}

//页面跳转
- (void)pushFrontVC
{
    WPShowHomeViewController *navc = [[WPShowHomeViewController alloc]init];
    ;
    SWRevealViewController *revealVC = self.revealViewController;
    [revealVC pushFrontViewController:navc animated:YES];
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
