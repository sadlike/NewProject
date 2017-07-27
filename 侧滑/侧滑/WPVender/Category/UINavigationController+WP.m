//
//  UINavigationController+WP.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "UINavigationController+WP.h"
#import <SWRevealViewController.h>

@implementation UINavigationController (WP)
- (void)pushViewController:(UIViewController *)desViewController fromViewController:(UIViewController *)sourceViewController animated:(BOOL)animated
{
    SWRevealViewController *revealVc = sourceViewController.revealViewController;
    if (revealVc.frontViewPosition != FrontViewPositionLeft) {
        revealVc.frontViewPosition = FrontViewPositionLeft;
    }else{
        [self pushViewController:desViewController animated:animated];
    }
}
@end
