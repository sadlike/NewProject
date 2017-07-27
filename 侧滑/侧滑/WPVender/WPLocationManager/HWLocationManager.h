//
//  HWLocationManager.h
//  HyWin
//
//  Created by wwp on 2017/4/21.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GainLocationCompleteBlock) (id sender,NSString *locationProvince,NSString *locationCity,NSString *locationArea,SBaseHandlerReturnType returnType);
@interface HWLocationManager : NSObject
@property (nonatomic,copy) GainLocationCompleteBlock gainLocationCompletBlock;
@property (nonatomic,strong) NSString *longitude;//经度
@property (nonatomic,strong) NSString *latitude;//纬度
@property (nonatomic,strong) NSString *locationProvince;//省
@property (nonatomic,strong) NSString *locationCity;//城市
@property (nonatomic,strong) NSString *locationSubLocality;//区域
@property (nonatomic,strong) NSString *locationAddress;//具体街道
+(instancetype) shareInstance;
-(void)getStartLocation;

-(void)gainLocationCompleteBlock:(GainLocationCompleteBlock) block;
@end
extern HWLocationManager *hwLocationManger;
