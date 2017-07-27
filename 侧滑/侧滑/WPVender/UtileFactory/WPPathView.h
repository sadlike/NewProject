//
//  WPPathView.h
//  侧滑
//
//  Created by wwp on 2017/7/27.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPathView : UIView

@property (nonatomic, strong) UIImage *itemBtnBackgroundImg;
@property (nonatomic, strong) UIImage *itemBtnHeightlightImg;

@property (nonatomic, strong) NSMutableArray *itemBtnImgs;//图片
@property (nonatomic, strong) NSMutableArray *itemBtnHightlightImgs;//高亮图片

@property (nonatomic, assign) CGFloat bloomRadius;//展开的角度

- (instancetype)initWithCenterImg:(UIImage *)centerImg hilightedImg:(UIImage *)centerHighlightedImg;
- (void)addPathItems:(NSArray *)pathItemButtons;
@end
