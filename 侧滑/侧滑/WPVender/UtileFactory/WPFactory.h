//
//  WPFactory.h
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WPFactory : NSObject

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(NSInteger)font;
+ (UIBarButtonItem *)CreateImgButtonName:(NSString *)imgName target:( id)target action:(SEL)action;
@end
