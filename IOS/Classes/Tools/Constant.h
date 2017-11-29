//
//  Constant.h
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


/**
 开发环境
 0 开发环境
 1 生产环境
 */
#define Development_Environment 0


#if Development_Environment

//生产环境
#define Default_URL  @"http://192.168.112.160/api/"
#define Resource_RUL @"http://172.16.100.147/lis"

#else //开发环境

//测试服务器环境
//#define Default_URL @"http://172.16.100.147/lisapi/api"
//#define Resource_URL @"http://172.16.100.147/devlis"
////上传资源服务器域名
//#define UploadResouce_URL @"http://172.16.100.147/devlis/api"

//本地服务器环境
#define Default_URL  @"http://192.168.112.160:80/api"
#define Resource_URL @"http://192.168.112.160:66"
//上传资源服务器域名
#define UploadResouce_URL @"http://192.168.112.160:66/api"

#endif





#endif /* Constant_h */
