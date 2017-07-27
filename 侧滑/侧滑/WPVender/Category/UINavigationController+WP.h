//
//  UINavigationController+WP.h
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (WP)

- (void)pushViewController:(UIViewController *)desViewController fromViewController:(UIViewController *)sourceViewController animated:(BOOL)animated;

@end
