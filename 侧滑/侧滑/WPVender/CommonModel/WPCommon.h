//
//  WPCommon.h
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.

typedef NS_ENUM(NSInteger, SBaseHandlerReturnType) {
    SBaseHandlerReturnTypeVerify,      //数据验证
    SBaseHandlerReturnTypeSuccess,      //数据操作成功
    SBaseHandlerReturnTypeAbnormal,     //数据操作异常
    SBaseHandlerReturnTypeFailed,       //网络获取失败(无网络)
    SBaseHandlerReturnTypeTimeout,      //网络获取失败(网络超时)
    SBaseHandlerReturnTypeNoData,       //获取数据为空
    SBaseHandlerReturnTypeNoMoreData,   //没有获取到更多数据
};



//按照1536iPad屏幕宽度比例换算
#define IPAD_SCALE_UI_SCREEN (UI_SCREEN_WIDTH/1536.0)
#define IPHONE_IPAD_SCALE_UI_SCREEN(iPhone_Size, iPad_Size) IS_IPAD?IPAD_SCALE_UI_SCREEN*iPad_Size: 1*iPhone_Size
#define IPHONE_IPAD_COLOR_FOUNT(iPhone_CF, iPad_CF) IS_IPAD? iPad_CF: iPhone_CF
//根据iphone数值算出ipad的大小 ((X*2)/750)*1536*IPAD_SCALE_UI_SCREEN
#define IPHONE_IPAD_X(iPhone_Size) IS_IPAD?((iPhone_Size*2)/750)*1536*IPAD_SCALE_UI_SCREEN:iPhone_Size*1

//iPad需要比例换算
#define IPAD_Need_SCALE_UI_SCREEN (IS_IPAD? SCALE_UI_SCREEN: 1)

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#define IS_Retina ([[UIScreen mainScreen] scale] > 1)

#define ISRetina_Min_Line (IS_Retina? 0.5: 1)



/////

#define  UI_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define  UI_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define  WIDTH_RATIO  UI_SCREEN_WIDTH/375.0;

#define  AUTO_SIZE(A) ([[UIScreen mainScreen] bounds].size.width/375*A)

#define  FONT_SIZE(A) ([UIFont systemFontOfSize:(AUTO_SIZE(A))])

#define  FONT_Bold_SIZE(A) ([UIFont boldSystemFontOfSize:(AUTO_SIZE(A))])

#define  STATUS_BAR_HEIGHT_U ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define  NAVIGATION_STATUSBAR (self.navigationController.navigationBar.height +STATUS_BAR_HEIGHT_U)

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]


//颜色
#define COLOR_WHITE ([UIColor whiteColor])
#define COLOR_CLEAR ([UIColor clearColor])
#define COLOR_BLACK ([UIColor blackColor])

#define COLOR_C0 (UIColorFromRGB(0x000000))
#define COLOR_C3 (UIColorFromRGB(0x333333))
#define COLOR_CF (UIColorFromRGB(0xffffff))//白色
#define COLOR_C5 (UIColorFromRGB(0x555555))
#define COLOR_CD (UIColorFromRGB(0xDDDDDD))
#define COLOR_CC (UIColorFromRGB(0xCCCCCC))
#define COLOR_CB (UIColorFromRGB(0x3CDFFC))//浅蓝
#define COLOR_CBD (UIColorFromRGB(0x3CB6FC))//深蓝

#define COLOR_BAR (UIColorFromRGB(0x3E2C1A))//顶部navigationbar颜色

#define FONT_T18 FONT_Bold_SIZE(18)



#define FONT_t24 FONT_SIZE(24)
#define FONT_t23 FONT_SIZE(23)
#define FONT_t18 FONT_SIZE(18)
#define FONT_t19 FONT_SIZE(19)
#define FONT_t20 FONT_SIZE(20)
#define FONT_t17 FONT_SIZE(17)
#define FONT_t15 FONT_SIZE(15)







