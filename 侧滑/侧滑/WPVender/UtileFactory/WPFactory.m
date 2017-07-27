//
//  WPFactory.m
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "WPFactory.h"

@implementation WPFactory
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(NSInteger)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment=NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}
+(UIBarButtonItem *)CreateImgButtonName:(NSString *)imgName target:( id)target action:(SEL)action
{
    UIBarButtonItem *barButtonItem = nil;
    UIButton *btn = [self createNavigationImageBarButtonName:imgName target:target action:action];
    barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return barButtonItem;
}
+ (UIButton *)createNavigationImageBarButtonName:(NSString *)imgName target:(id)target action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 22, 22)];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
