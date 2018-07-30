//
//  ContactModel.h
//  Epipe
//
//  Created by Tb on 2018/6/21.
//  Copyright © 2018年 Epipe-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Offices;
@class Staffs;

@interface ContactModel : NSObject
/**企业/集团id*/
@property (nonatomic, copy)NSString *ID;
/**企业/集团名称*/
@property (nonatomic, copy)NSString *name;
/**企业类型（0：集团；1：企业，3：部门）(V3.0新增)*/
@property (nonatomic, copy)NSString *type;

@property (nonatomic , strong) NSArray<Offices *>              * offices;

@property (nonatomic, assign)BOOL isOpen;

@property (nonatomic, assign)BOOL isLeft;
@end

@interface Offices: NSObject
/**部门id*/
@property (nonatomic, copy)NSString *departID;
/**部门名称*/
@property (nonatomic, copy)NSString *name;
/**部门人数*/
@property (nonatomic, assign)NSUInteger personNO;

@property (nonatomic , strong) NSArray<Staffs *>              * staff;
@end

@interface Staffs: NSObject
/**姓名*/
@property (nonatomic, copy)NSString *name;
/**0、未知1、男2、女*/
@property (nonatomic, assign)NSUInteger sex;
/**手机*/
@property (nonatomic, copy)NSString *mobile;
/**固定电话*/
@property (nonatomic, copy)NSString *phone;
/**地址*/
@property (nonatomic, copy)NSString *address;
/**个人图像*/
@property (nonatomic, copy)NSString *profileImg;
/**环信im的id*/
@property (nonatomic, copy)NSString *imUserName;
/**环信im的密码*/
@property (nonatomic, copy)NSString *imPassword;
/**手机短号*/
@property (nonatomic, copy)NSString *shortMobile;
/**固话短号*/
@property (nonatomic, copy)NSString *shortPhone;

@end
