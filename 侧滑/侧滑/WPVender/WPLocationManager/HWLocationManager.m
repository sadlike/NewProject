//
//  HWLocationManager.m
//  HyWin
//
//  Created by wwp on 2017/4/21.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "HWLocationManager.h"
#import <CoreLocation/CoreLocation.h>

HWLocationManager *hwLocationManger=nil;
@interface HWLocationManager ()<CLLocationManagerDelegate>
{
    __block NSString *address;
    __block NSString *province;//省
    __block NSString *city;//城市
    __block NSString *SubLocality;//区域
    __block int timeNumber; //地理位置代理执行的次数
    CLLocationManager *locationMg;
}
@end
@implementation HWLocationManager
@synthesize latitude,longitude,locationProvince,locationCity,locationSubLocality,locationAddress;
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (hwLocationManger==nil) {
            hwLocationManger = [[HWLocationManager alloc]init];
        }
    });
    return hwLocationManger;
}
-(void)gainLocationCompleteBlock:(GainLocationCompleteBlock)gainLocationCompletBlock
{
    _gainLocationCompletBlock = gainLocationCompletBlock;
}

-(void)getStartLocation
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        if (!locationMg) {
            locationMg=[[CLLocationManager alloc]init];
        }
        locationMg.delegate=self;
        //定位功能可用
        //设置定位的精准度
        [locationMg setDesiredAccuracy:kCLLocationAccuracyBest];
        locationMg.distanceFilter = 10.0f;
    
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationMg requestWhenInUseAuthorization];//使用中
        }
        timeNumber=0;
        //开始实时定位
        [locationMg startUpdatingLocation];
        
    }else {
        timeNumber=0;
        //定位不能用
        [self getlocationFailureCallBack:nil];
    }
}
//代理,定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationMg stopUpdatingLocation];
    __weak typeof(self) weakSelf = self;

    locationMg.delegate=nil;
    CLLocation * newLoaction = locations[0];
    CLLocationCoordinate2D oCoordinate = newLoaction.coordinate;
    NSLog(@"经度：%f，维度：%f",oCoordinate.longitude,oCoordinate.latitude);
    longitude = [NSString stringWithFormat:@"%f",oCoordinate.longitude];
    latitude = [NSString stringWithFormat:@"%f",oCoordinate.latitude];
    
    //创建地理位置解码编码器对象
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLoaction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark * place in placemarks) {
            NSDictionary * location = [place addressDictionary];
            NSLog(@"国家：%@",[location objectForKey:@"Country"]);
            NSLog(@"省：%@",[location objectForKey:@"State"]);
            NSLog(@"市：%@",[location objectForKey:@"City"]);
            NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
            NSLog(@"街道----%@",[location objectForKey:@"FormattedAddressLines"]);
            NSArray *lines = [location objectForKey:@"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@"\n"];
            NSLog(@"Address: %@", addressString);
            province =[NSString stringWithFormat:@"%@",[location objectForKey:@"State"]];
            city =[NSString stringWithFormat:@"%@",[location objectForKey:@"City"]];
            SubLocality = [NSString stringWithFormat:@"%@",[location objectForKey:@"SubLocality"]];
            address=[NSString stringWithFormat:@"%@",addressString];
            weakSelf.locationProvince =[NSString stringWithFormat:@"%@",[location objectForKey:@"State"]];
            weakSelf.locationCity =[NSString stringWithFormat:@"%@",[location objectForKey:@"City"]];
            weakSelf.locationSubLocality=[NSString stringWithFormat:@"%@",[location objectForKey:@"SubLocality"]];
            weakSelf.locationAddress =[NSString stringWithFormat:@"%@",addressString];
        }
        NSLog(@"timenumber--%d",timeNumber);
        if (timeNumber<1) {
            timeNumber++;
            //执行方法
            [weakSelf getLocationCompleteCallBack:nil];
        }
    }];
    
}
// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
    [self getlocationFailureCallBack:error];
}
-(void)getLocationCompleteCallBack:(id)sender
{
    if (_gainLocationCompletBlock) {
        _gainLocationCompletBlock([NSString stringWithFormat:@"%@",address],province,city,SubLocality,SBaseHandlerReturnTypeSuccess);
    }
}
-(void)getlocationFailureCallBack:(id)sender
{
    if (_gainLocationCompletBlock) {

        _gainLocationCompletBlock([NSString stringWithFormat:@"%@",sender],nil,nil,nil,SBaseHandlerReturnTypeFailed);
        
    }
}
@end
