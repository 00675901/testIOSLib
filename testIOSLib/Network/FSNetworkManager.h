//
//  FSNetworkManager.h
//  fangStar
//
//  Created by XuLei on 15/5/19.
//  Copyright (c) 2015年 HomelandStar. All rights reserved.
//

#ifndef fangStar_FSNetworkManager_h
#define fangStar_FSNetworkManager_h

#import "FMNetworkManager.h"

#define kApiKey @"iPhone"

@class FSBSelectCondition;

//方法名称

//v1.2.0
static NSString *const loginSession=@"loginSession";
static NSString *kReq_Probe_GetMySecondHouseList = @"获取二手房列表";
static NSString *kReq_Probe_GetMySecondHouseParams = @"获取二手房房源筛选配置参数";

//apiName
#define kApiName_user @"MobileUser"

//apiMethod

//1.2.0
static NSString *const kApiMethod_GetMySecondHouseList = @"/app/probe/erphouse/index/index-erphouse";
static NSString *const kApiMethod_GetMySecondHouseParams = @"/app/probe/erphouse/create/init-indexparam";

@interface FSNetworkManager : FMNetworkManager

- (FMNetworkRequest *)loginSession:(id<FMNetworkProtocol>)networkDelegate;

#pragma mark - 获取二手房房源列表
/**
 *  Api Name: 获取二手房房源列表
 *
 *  @param u_id            用户id
 *  @param params          获取房源的参数
 *  @param page            页码
 *  @param pagesize        每页数量
 *  @param networkDelegate 网络代理
 *
 *  @return
 */
- (FMNetworkRequest *)getMySecondHouseListByUID:(NSString *)u_id
                                         params:(NSMutableDictionary *)params
                                           page:(NSInteger)page
                                       pagesize:(NSInteger)pagesize
                                networkDelegate:(id<FMNetworkProtocol>)networkDelegate;

#pragma mark - 获取二手房房源筛选配置参数
/**
 *  获取二手房房源筛选配置参数
 *
 *  @param u_id            用户id
 *  @param networkDelegate 网络代理
 *
 *  @return 二手房房源筛选配置参数
 */
- (FMNetworkRequest *)getMySecondHouseParamsByUID:(NSString *)u_id
                                  networkDelegate:(id<FMNetworkProtocol>)networkDelegate;

@end

#endif
