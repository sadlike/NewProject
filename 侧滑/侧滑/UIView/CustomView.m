//
//  CustomView.m
//  侧滑
//
//  Created by wwp on 2017/7/31.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "CustomView.h"
@implementation CustomView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// 画四分之一圆
/*
- (void)drawRect:(CGRect)rect {
   //取得当前view 相关联的图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画扇形 拼接路径
    CGContextMoveToPoint(ctx, 100, 100);
    CGContextAddLineToPoint(ctx, 100, 150);
    CGContextAddArc(ctx, 100, 100, 50, -M_PI_2, M_PI, 1);
    CGContextClosePath(ctx);
    [[UIColor redColor] set];
    
    CGContextFillPath(ctx);
    
}
*///矩形
//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //描述路径
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 200, 200)];
//    //3.把路径添加到上下文
//    CGContextAddPath(ctx, path.CGPath);
//    [[UIColor redColor] set];// 路径的颜色
//    
//    //4.把上下文的内容渲染到View的layer.
////    CGContextStrokePath(ctx);// 描边路径
//    CGContextFillPath(ctx);// 填充路径
//}
//oc自带画图画扇形
-(void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.size.width *0.5, rect.size.height*0.5);
    CGFloat radius = rect.size.width *0.5-5;
    CGFloat startA = 0;
    CGFloat endA = -M_PI_2;
    
    //画弧的路径
//    ARCCenter 弧所在的圆心。 radius 圆的半径。satarta 开始的角度。最右侧为0度  end 截止角度 向下为正 向上为负 clockwist。yes 顺时针 no 逆时针
 // cornerRadius:圆角半径。矩形的宽高都为200，如果圆角为100，那么两个角之间弧线上任意一点到矩形中心的距离都为100,所以为圆形
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 50, 200, 200) cornerRadius:100];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    //添加一个线到圆心
    [path addLineToPoint:center];
    //闭合路径
    [path closePath];
    //路径的颜色
    [[self randomColor] set];
    //填充路径
    [path fill];
    
    
      UIBezierPath *pathT = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:NO];
    //添加一个线到圆心
    [pathT addLineToPoint:center];
    //闭合路径
    [pathT closePath];
    //路径的颜色
    [[self randomColor] set];
    //填充路径
    [pathT fill];
}
- (UIColor *)randomColor {
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
//点击变换颜色

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //重绘
    [self setNeedsDisplay];
    
}
@end
