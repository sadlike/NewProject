//
//  HWGetAddressBook.h
//  HyWin
//
//  Created by wwp on 2017/4/24.
//  Copyright © 2017年 wwp. All rights reserved.
//  获取通讯录

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AddressBookInfoSuccessType) {
    
    /**
     *  所有
     */
    addressBookInfoAllPeopleType = 0,
    
    /**
     *  选则的
     */
    addressBookInfochoosePeopleType,
};

/**
 选择联系人回调  回调里的处理 ui页面的 最好在主线程中处理
 @param allInfoArray 所有通讯录的信息
 @param chooseInfoArray 选择的个人信息
 @param successType 是全选还是单选
 @param returnType 成功还是失败
 */
typedef void (^GainAddressBookInfoCompleteBlock) (NSArray *allInfoArray,NSArray *chooseInfoArray,AddressBookInfoSuccessType successType,SBaseHandlerReturnType returnType);
@interface HWGetAddressBook : NSObject

@property (nonatomic,strong) UIViewController *target;
@property (nonatomic,copy) GainAddressBookInfoCompleteBlock gainAddressBookInfoCompleteBlock;

+(instancetype)shareInstance;
-(void)gainAddressBookInfoCompleteBlock:(GainAddressBookInfoCompleteBlock)block;
-(void)getUserAddressBookMessage;
-(NSString *)getSNSString:(NSString *)str;

@end
extern HWGetAddressBook *hwGetAddressBook;
