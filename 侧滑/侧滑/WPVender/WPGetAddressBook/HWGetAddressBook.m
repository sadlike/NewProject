//
//  HWGetAddressBook.m
//  HyWin
//
//  Created by wwp on 2017/4/24.
//  Copyright © 2017年 wwp. All rights reserved.
//

#import "HWGetAddressBook.h"
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
HWGetAddressBook *hwGetAddressBook=nil;

@interface HWGetAddressBook () <CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>
{
   __block NSMutableArray *contactPeopleArray;//通讯录选取的人
   __block NSMutableArray *allContactArray;//通讯录所有联系人的信息
}
@end

@implementation HWGetAddressBook
@synthesize target;

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (hwGetAddressBook==nil) {
            hwGetAddressBook = [[HWGetAddressBook alloc]init];
        }
    });
    return hwGetAddressBook;
}
-(void)gainAddressBookInfoCompleteBlock:(GainAddressBookInfoCompleteBlock)block
{
    _gainAddressBookInfoCompleteBlock = block;
}
-(void)getUserAddressBookMessage
{
    //9.0以后才可以用CNContactStore  8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
    {
        [self getRequestAuthorizationAddressBook];
    }
    else
    {
        [self getUserAuthority];
    }
}
#pragma mark -ios 8 获取通讯录权限
-(void)getRequestAuthorizationAddressBook
{
    __weak typeof(self) weakSelf = self;
    // 判断是否授权
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        // 请求授权
        //保存信息
        ABAddressBookRef addressBookRef =  ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {  // 授权成功
                [weakSelf getContactMessage];
                //判断是否已经上传 如果不是 则上传
//                if (hwSaveCache.informationModel.isContactExist ==YES) {
              
                    [weakSelf getAllContentArray];
//                }
            } else {
                // 授权失败
                [weakSelf gainAddressBookFailureCallBack:nil withSuccessType:addressBookInfoAllPeopleType];
            }
        });
    }
    else if(authorizationStatus == kABAuthorizationStatusAuthorized)
    {
        //        kABAuthorizationStatusNotDetermined = 0,    // 未进行授权选择
        //        kABAuthorizationStatusRestricted,           // 未授权，且用户无法更新，如家长控制情况下
        //        kABAuthorizationStatusDenied,               // 用户拒绝App使用
        //        kABAuthorizationStatusAuthorized            // 已授权，可使用
        // 成功
        [weakSelf getContactMessage];
        //判断是否已经上传 如果不是 则上传
//        if (hwSaveCache.informationModel.isContactExist ==YES) {
      
            [weakSelf getAllContentArray];
//        }
    }
    else
    {
        [self gainAddressBookFailureCallBack:nil withSuccessType:addressBookInfoAllPeopleType];
    }
}
#pragma mark -9上获取通讯录权限
-(void)getUserAuthority
{
    //传所有信息要在用户点后 体验不好 因为修改用户权限后 app会重启
    __weak typeof(self) weakSelf = self;
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
            [weakSelf getContactMessage];
            //判断是否已经上传 如果不是 则上传
//            if (hwSaveCache.informationModel.isContactExist ==YES) {
          
                [weakSelf getAllContentArray];
//            }
          
        } else {
            
            [weakSelf gainAddressBookFailureCallBack:nil withSuccessType:addressBookInfoAllPeopleType];
        }
    }];
}
#pragma mark - contact授权完了后跳转选择联系人页面
-(void) getContactMessage
{
    [contactPeopleArray removeAllObjects];
    contactPeopleArray = [[NSMutableArray alloc]init];
    allContactArray = [[NSMutableArray alloc]init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        //弹出控制器
        ABPeoplePickerNavigationController *picker  = [[ABPeoplePickerNavigationController alloc]init];
        //设置代理
        picker.peoplePickerDelegate = self;
        //展示界面
        [self.target presentViewController:picker animated:YES completion:nil];
    }else
    {
        CNContactPickerViewController *contactPickerVc=[[CNContactPickerViewController alloc]init];
        contactPickerVc.delegate=self;
        [self.target presentViewController:contactPickerVc animated:YES completion:nil];
    }
}
#pragma mark -addressbook delegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    //目标: 获取联系人信息
    //coreFountion
    //指针  Record 记录  数据库   字段   列   记录  行
    //需求 : name  电话号码
    //C语言API特征    实现任何功能都是  调用一个函数  参数  返回值  输入和输出
    // name
    NSMutableDictionary *contactInfoDic=[[NSMutableDictionary alloc]init];
    NSMutableArray *phoneArray=[[NSMutableArray alloc]init];
    CFStringRef strfirst =   ABRecordCopyValue(person, kABPersonFirstNameProperty);
    CFStringRef strlast =   ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *strF = (__bridge_transfer NSString *)(strfirst);
    NSString *strL = (__bridge_transfer NSString *)(strlast);
    NSString *nameAll =[NSString stringWithFormat:@"%@%@",[self getSNSString:strL],[self getSNSString:strF]];
    
    [contactInfoDic setObject:[self getSNSString:nameAll] forKey:@"name"];
    
    NSLog(@"ios 8  %@  %@",strF,strL);
    //电话号码  ABMultiValueRef 封装一个保存了很多电话的一个类型
    ABMultiValueRef  multiValues =   ABRecordCopyValue(person, kABPersonPhoneProperty);
    //函数 来做
    CFIndex index = ABMultiValueGetCount(multiValues);
    
    for (CFIndex i = 0; i < index; i++) {
        CFStringRef strPhone  =    ABMultiValueCopyValueAtIndex(multiValues, i);
        NSString *phoneStr = (__bridge_transfer  NSString *)(strPhone);
        NSString *allPhone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [phoneArray addObject:[self getSNSString:allPhone]];
    }
    
    NSString *phoneStr = [NSString stringWithFormat:@"%@",[phoneArray firstObject]];
    [contactInfoDic setObject:phoneStr forKey:@"mobile"];
    
    [contactPeopleArray addObject:contactInfoDic];
    
    [self gainAddressBookSuccessCallBack:nil withSuccessType:addressBookInfochoosePeopleType];

    if (multiValues != NULL) {
        CFRelease(multiValues);
    }
}
//点击取消了 就会调用
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    NSLog(@"peoplePickerNavigationControllerDidCancel");
}

#pragma mark - contact选择联系人
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
}
// 如果实现该方法当选中联系人时就不会再出现联系人详情界面， 如果需要看到联系人详情界面只能不实现这个方法，
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    [self printContactInfo:contact WithAll:NO];
}
- (void)printContactInfo:(CNContact *)contact WithAll:(BOOL)isAll {
    NSMutableDictionary *contactInfoDic=[[NSMutableDictionary alloc]init];
    
    NSString *givenName = contact.givenName;//备注名称
    NSString *familyName = contact.familyName;//家庭名称
    NSString *nameAll =[NSString stringWithFormat:@"%@%@",[self getSNSString:familyName],[self getSNSString:givenName]];
    
    [contactInfoDic setObject:[self getSNSString:nameAll] forKey:@"name"];
    NSArray * phoneNumbers = contact.phoneNumbers;
    NSMutableArray *phoneArray=[[NSMutableArray alloc]init];
    if (isAll) {
        for (CNLabeledValue<CNPhoneNumber*>*phone in phoneNumbers) {
            //            NSString *label = phone.label;
            CNPhoneNumber *phonNumber = (CNPhoneNumber *)phone.value;
            NSString *phoneStr = [NSString stringWithFormat:@"%@",phonNumber.stringValue];
            NSString *allPhone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [phoneArray addObject:[self getSNSString:allPhone]];
        }
        NSString *phoneStr = [NSString stringWithFormat:@"%@",[phoneArray componentsJoinedByString:@","]];
        [contactInfoDic setObject:phoneStr forKey:@"mobile"];
        
        [allContactArray addObject:contactInfoDic];
  
    }
    else
    {
        for (CNLabeledValue<CNPhoneNumber*>*phone in phoneNumbers) {
            //            NSString *label = phone.label;
            CNPhoneNumber *phonNumber = (CNPhoneNumber *)phone.value;
            NSString *phoneStr = [NSString stringWithFormat:@"%@",phonNumber.stringValue];
            NSString *allPhone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [phoneArray addObject:[self getSNSString:allPhone]];
        }
        //实名认证 只取一个手机号码
        //    NSString *phoneStr = [NSString stringWithFormat:@"%@",[phoneArray componentsJoinedByString:@","]];
        NSString *phoneStr = [NSString stringWithFormat:@"%@",[phoneArray firstObject]];
        [contactInfoDic setObject:phoneStr forKey:@"mobile"];
        [contactPeopleArray addObject:contactInfoDic];
        
        [self gainAddressBookSuccessCallBack:nil withSuccessType:addressBookInfochoosePeopleType];
    }
}
#pragma mark - 9上获取所有通讯录联系人信息
-(void)getAllContentArray
{
    allContactArray = [[NSMutableArray alloc]init];
    //9.0以后才可以用CNContactStore  8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
    {
        [self getAllPeopleByAddressBook];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        //创建通讯录对象
        CNContactStore *contactStore=[[CNContactStore alloc]init];
        //获取对应的属性key
        NSArray *keys=@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContainerNameKey];
        //创建cncontactfetchreuest对象
        CNContactFetchRequest *request=[[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
        //遍历所有联系人
        [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            [weakSelf printContactInfo:contact WithAll:YES];
        }];
        
        [self gainAddressBookSuccessCallBack:nil withSuccessType:addressBookInfoAllPeopleType];
    }
    
}
#pragma mark - 9下 addressbook获取所有通讯录联系人信息
-(void)getAllPeopleByAddressBook;
{
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        [self gainAddressBookFailureCallBack:nil withSuccessType:addressBookInfoAllPeopleType];
        return;
    }
    // 2. 获取所有联系人
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    long count = CFArrayGetCount(arrayRef);
    for (int i = 0; i < count; i++) {
        //获取联系人对象的引用
        ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);
        //获取当前联系人名字
        NSString *firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        //获取当前联系人姓氏
        NSString *lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        NSLog(@"firstName=%@, lastName=%@", firstName, lastName);
        
        NSMutableDictionary *contactInfoDic=[[NSMutableDictionary alloc]init];
        NSString *nameAll =[NSString stringWithFormat:@"%@%@",[self getSNSString:lastName],[self getSNSString:firstName]];
        [contactInfoDic setObject:[self getSNSString:nameAll] forKey:@"name"];
        //获取当前联系人的电话 数组
        NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        //函数 来做
        CFIndex index = ABMultiValueGetCount(phones);
        
        for (CFIndex i = 0; i < index; i++) {
            CFStringRef strPhone  =    ABMultiValueCopyValueAtIndex(phones, i);
            NSString *phoneStr = (__bridge_transfer  NSString *)(strPhone);
            NSLog(@"ios8 -----%@",phoneStr);
            NSString *allPhone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [phoneArray addObject:[self getSNSString:allPhone]];
        }
        
        NSString *phoneStr = [NSString stringWithFormat:@"%@",[phoneArray componentsJoinedByString:@","]];
        [contactInfoDic setObject:phoneStr forKey:@"mobile"];
        [allContactArray addObject:contactInfoDic];
    }
    
    [self gainAddressBookSuccessCallBack:nil withSuccessType:addressBookInfoAllPeopleType];
    
}
#pragma mark - 成功失败的代理回调
-(void)gainAddressBookSuccessCallBack:(id)sender withSuccessType:(AddressBookInfoSuccessType)successType
{
    if (_gainAddressBookInfoCompleteBlock) {
        _gainAddressBookInfoCompleteBlock(allContactArray,contactPeopleArray,successType,SBaseHandlerReturnTypeSuccess);
    }
}
-(void)gainAddressBookFailureCallBack:(id)sender withSuccessType:(AddressBookInfoSuccessType)successType
{
    if(_gainAddressBookInfoCompleteBlock)
    {
       _gainAddressBookInfoCompleteBlock(nil,nil,successType,SBaseHandlerReturnTypeFailed);
    }
}
-(NSString *)getSNSString:(NSString *)str
{
    if (!str) {
        return @"";
    }
    NSString *rst;
    
    if (str && (NSNull *)str!=[NSNull null])
    {
        if ([str isEqualToString:@"<null>"]||str==nil||[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]||[str isEqualToString:@"(null)"] || [str isEqualToString:@"null"])
            str=@"";
        rst=[NSString stringWithFormat:@"%@", str];
    }
    else
    {
        rst=[NSString stringWithFormat:@""];
    }
    return rst;
}
@end
