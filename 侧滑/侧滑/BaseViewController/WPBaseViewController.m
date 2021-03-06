//
//  WPBaseViewController.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "WPBaseViewController.h"


@interface WPBaseViewController ()<SWRevealViewControllerDelegate>

@end

@implementation WPBaseViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //设置手势滑动
    SWRevealViewController *revealVC = self.revealViewController;
    revealVC.delegate = self;
    if (revealVC != nil) {
        revealVC.rearViewRevealWidth =AUTO_SIZE(100);
        [revealVC panGestureRecognizer];
        [revealVC tapGestureRecognizer];
    }
}
#pragma mark - SWRevealViewController delegate
//如果是带有返回按钮则不响应PanGesture
- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController
{
    if (self.tapActionType == TapActionTypeBack) {
        return NO;
    }else{
        return YES;
    }
}

-(void)setNavigationBar:(SWRevealViewController *)reveal btnImageNameStr:(NSString *)imageStr Type:(TapActionType)type{
    self.tapActionType = type;
    switch (self.tapActionType) {
        case 0://返回
        {
            UIBarButtonItem *leftBarBtn= [WPFactory CreateImgButtonName:imageStr target:self action:@selector(backHome)];
            self.navigationItem.leftBarButtonItem = leftBarBtn;
        }break;
        case 1:
        {
            UIBarButtonItem *leftBarBtn= [WPFactory CreateImgButtonName:imageStr target:self action:@selector(showLeftView)];
            self.navigationItem.leftBarButtonItem = leftBarBtn;
        }break;
            
        default:
            break;
    }
}
-(void)showLeftView
{
    [self.view endEditing:YES];
    SWRevealViewController *revealVC = self.revealViewController;
    [revealVC revealToggleAnimated:YES];
}
-(void)backHome
{
    if (self.parentViewController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
