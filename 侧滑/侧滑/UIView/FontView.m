//
//  FontView.m
//  侧滑
//
//  Created by wwp on 2017/7/31.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "FontView.h"

@implementation FontView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  NSString *str = @"DNS映射实际是模拟了DNS请求的解析行为。如果客户端将自己的位置信息诸如ip地址，国家码等加入映射文件的请求参数当中，服务器就可以根据客户端所处的位置不同，下发距离其物理位置最近的server ip地址，从而减小整体网络请求的延迟，实现一定程度的服务器动态部署。";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //设置字体
    dic[NSFontAttributeName] = FONT_t15;
    dic[NSForegroundColorAttributeName] = [UIColor redColor];
    //设置🐱边
    dic[NSStrokeColorAttributeName] = [UIColor blueColor];
    dic[NSStrokeWidthAttributeName] = @3;
    //设置阴影
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor orangeColor];
    shadow.shadowOffset = CGSizeMake(-2, -2);
    shadow.shadowBlurRadius =3;
    dic[NSShadowAttributeName] = shadow;
    //drawinrect 会自动换行
//    drawatpoint //不会自动换行
    [str drawInRect:self.bounds withAttributes:dic];
    
}

@end
