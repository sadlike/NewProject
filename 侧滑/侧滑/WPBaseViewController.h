//
//  WPBaseViewController.h
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>

typedef NS_ENUM(NSInteger,TapActionType)
{
    TapActionTypeBack = 0,// 返回
    TapActionTypeList ,
};
@interface WPBaseViewController : UIViewController
@property(nonatomic,assign) TapActionType tapActionType;
//导航栏设置
-(void)setNavigationBar:(SWRevealViewController *)reveal btnImageNameStr:(NSString *)imageStr Type:(TapActionType)type;

@end
