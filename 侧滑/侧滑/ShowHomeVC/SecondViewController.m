//
//  SecondViewController.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomView.h"
#import "BezierPathView.h"
#import "FontView.h"

@interface SecondViewController ()<UIGestureRecognizerDelegate>
{
    CustomView *customView;
    BezierPathView *bezierView;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self addCustomView];
}

-(void)addCustomView
{
    customView=[[CustomView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2)];
    customView.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:customView];
    bezierView =[[BezierPathView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2, 0, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2)];
    bezierView.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:bezierView];
    FontView *fontView=[[FontView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/2)];
    fontView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:fontView];
}
//-(void)autoLayOutSubView
//{
//    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(self.view.mas_bottom).offset(0);
//        make.size.mas_equalTo(CGSizeMake(UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2));
//    }];
//    [bezierView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(customView.mas_right);
//        make.top.equalTo(customView.mas_top);
//        make.size.mas_equalTo(CGSizeMake(UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2));
//    }];
//}
-(void)setupNavigationBar
{
    NSString *titleStr= NSLocalizedString(@"Second", nil);
    self.title=titleStr;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationBar:self.revealViewController btnImageNameStr:@"icon_back@2x" Type:0];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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
