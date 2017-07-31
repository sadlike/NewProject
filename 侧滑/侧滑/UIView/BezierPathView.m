//
//  BezierPathView.m
//  侧滑
//
//  Created by wwp on 2017/7/31.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //1.获取跟view相关联的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.描述路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //3’画曲线 设置起点还有一个控制点 来控制曲线的方向和弯曲程度
    //设置起点
    [path moveToPoint:CGPointMake(10, 150)];
    //添加一曲线到某个点
    [path addQuadCurveToPoint:CGPointMake(200, 150) controlPoint:CGPointMake(30, 10)];
    //3.把路径添加到上下文中
    CGContextAddPath(ctx, path.CGPath);
    //渲染到view上
    CGContextStrokePath(ctx);
}


@end
