//
//  ShowAdvertisementView.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SShowPageShapeView.h"
@class SDiscoveryFlexibleModel;

@protocol ShowAdvertisementViewDelegate <NSObject>

@optional
- (void)advertisementViewSelectedIndex:(int)index;
- (void)advertisementViewTouchIndex:(NSInteger)index;

@end

@interface ShowAdvertisementView : UIView

@property (nonatomic, weak) id <ShowAdvertisementViewDelegate> delegate;

@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, strong) NSMutableArray *titleArray;//title 标题
@property (nonatomic, strong) NSMutableArray *contentArray;//具体标题

@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;

//------------
@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *showPictureImageArray;

@property (nonatomic, strong) SShowPageShapeView *pageControl;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIColor *selectedItemColor;
@property (nonatomic, strong) UIColor *normalItemColor;
//pagecontroller
@property (nonatomic, assign) float showPageHeight;
@property (nonatomic, assign) float showPageFrameHeight;
@property (nonatomic, assign) float showPageBottomSpace;

- (instancetype)initWithFrame:(CGRect)frame withShowPageHeight:(float)showpageHeight;

- (instancetype)initWithFrame:(CGRect)frame withShowPageHeight:(float)showpageHeight withShowLabel:(BOOL)isShow;

- (void)startTimer;
- (void)initSubViews;
@end
