//
//  SFAuthStatusModle.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAuthStatusModle : NSObject

@property (nonatomic,copy)NSString *verify_remark;
@property (nonatomic,copy)NSString *verify_id;
@property (nonatomic,copy)NSString *verify_status;
@property (nonatomic,copy)NSString *driverno;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *driver_by;
@property (nonatomic,copy)NSString *idno;
@property (nonatomic,copy)NSString *driver_mobile;

@property (nonatomic,copy)NSString *carAuthCardId;
@property (nonatomic,copy)NSString *driving_license;
@property (nonatomic,copy)NSString *car_type;
@property (nonatomic,copy)NSString *car_long;
@property (nonatomic,copy)NSString *car_no;
@property (nonatomic,copy)NSString *car_weight;
@property (nonatomic,copy)NSString *car_size;

/**
 门头照
 */
@property (nonatomic,strong,readonly)NSString *shopPhotoUrl;

/**
 生活照
 */
@property (nonatomic,strong,readonly)NSString *lifePhotoUrl;

/**
 营业执照
 */
@property (nonatomic,strong,readonly)NSString *businessLicenseUrl;

/**
 身份证背面
 */
@property (nonatomic,strong,readonly)NSString *idCardBackUrl;

/**
 身份证正面
 */
@property (nonatomic,strong,readonly)NSString *idCardUrl;


/**
 车辆照片
 */
@property (nonatomic,strong,readonly)NSString *carUrl;
@property (nonatomic,strong,readonly)NSString *carHeadUrl;
@property (nonatomic,strong,readonly)NSString *carTailUrl;


/**
 驾驶证正面
 */
@property (nonatomic,strong,readonly)NSString *driverUrl;

/**
 驾驶证背面
 */
@property (nonatomic,strong,readonly)NSString *driverBUrl;

@property (nonatomic,strong)NSArray *verify_pic;

- (SFAuthStatus)status;
- (NSString *)statusDesc;

@end
