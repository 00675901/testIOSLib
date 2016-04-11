//
//  FSNetworkManager.m
//  fangStar
//
//  Created by XuLei on 15/5/19.
//  Copyright (c) 2015年 HomelandStar. All rights reserved.
//

#import "FSNetworkManager.h"
#import "NSString+md5plus.h"

@implementation FSNetworkManager

#pragma mark -
#pragma mark === 继承Get、Post方法 ===
#pragma mark -
//添加get请求
- (FMNetworkRequest *)addGetMethod:(NSString *)requestName baseUrl:(NSString *)baseUrl params:(NSDictionary *)params delegate:(id<FMNetworkProtocol>)networkDelegate {
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    if (baseUrl) {
        [ms setString:baseUrl];
    } else {
        [ms setString:kApiBaseUrl];
    }
    NSLog(@"[GET][%@]:%@", requestName, ms);
    return [super addGetUrl:ms requestName:requestName delegate:networkDelegate];
}

//添加post请求
- (FMNetworkRequest *)addPostMethod:(NSString *)requestName
                            baseUrl:(NSString *)baseUrl
                             params:(NSDictionary *)params
                          formDatas:(NSDictionary *)formDatas
                           delegate:(id<FMNetworkProtocol>)networkDelegate {
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    if (baseUrl) {
        [ms setString:baseUrl];
    } else {
        [ms setString:kApiBaseUrl];
    }

    //    [ms appendString:[self combineCommonGetParams:params]];

    //    NSDictionary *datas = [self combineCommonPostDatas:formDatas];
    NSDictionary *datas = [NSDictionary dictionary];

    //    DDLogInfo(@"[POST][%@]:%@", requestName, [NSString stringWithFormat:@"%@%@", ms, [self combineCommonGetParams:datas]]);
    //    DDLogInfo(@"[POSTDATA][%@]:%@", requestName, datas);

    return [super addPostUrl:ms requestName:requestName formDatas:datas delegate:networkDelegate];
}

- (BOOL)filter:(FMNetworkRequest *)networkRequest {
    BOOL ret = NO;

    if (networkRequest.isSkipFilterRequest) {
        return YES;
    }

    NSString *responseString = networkRequest.responseData;
    //    if([networkRequest.requestName isEqualToString:kReq_fangstarBroker_getClientList]) {
    //        responseString = [FSBDataAllToString unGzip:responseString];
    //    }

    NSLog(@"\n\n%@ 返回数据:\n%@\n\n", networkRequest.requestName, responseString);

    if (!responseString || responseString.length == 0) {
        networkRequest.responseData = @"内容不存在";
        return NO;
    }

    id retObj = [responseString objectFromJSONString];
    if (!retObj) {
        networkRequest.responseData = @"亲，服务器君开了个小差，请稍后再试";
        return NO;
    }

    /*黑名单截获*/
    if ([retObj isKindOfClass:[NSDictionary class]]) {
        NSInteger errorcode = [[(NSDictionary *)retObj objectForKey:@"errorcode"] integerValue];
        if (errorcode == 1 || errorcode == 2) {
            /*设备或用户被设置为黑名单，执行退出登录操作*/
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLACKLIST object:[(NSDictionary *)retObj objectForKey:@"msg"]];
        } else if (errorcode == 3) {
            NSDictionary *notifiDic = [(NSDictionary *)retObj objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPGRADE object:notifiDic];
        }
    }

#pragma mark - 获取二手房房源列表
    if ([networkRequest.requestName isEqualToString:kReq_Probe_GetMySecondHouseList]) {
        if ([retObj isKindOfClass:[NSDictionary class]]) {
            NSInteger result = [[(NSDictionary *)retObj objectForKey:@"result"] integerValue];
            if (result == 1) {
                //                NSMutableArray *ma = [FMBean objectsWithArray:[(NSDictionary*)retObj objectForKey:@"data"] classType:[FSBSecondHouse class]];
                //                if (ma)
                //                {
                //                    networkRequest.responseData = ma;
                networkRequest.responseData = [(NSDictionary *)retObj objectForKey:@"data"];
                ret = YES;
                //                }
                //                else
                //                {
                //                    networkRequest.responseData = [(NSDictionary *)retObj objectForKey:@"msg"];
                //                }
            } else {
                networkRequest.responseData = [(NSDictionary *)retObj objectForKey:@"msg"];
            }
        }
    }
#pragma mark - 获取二手房源筛选参数
    else if ([networkRequest.requestName isEqualToString:kReq_Probe_GetMySecondHouseParams]) {
        if ([retObj isKindOfClass:[NSDictionary class]]) {
            NSInteger result = [[(NSDictionary *)retObj objectForKey:@"result"] integerValue];
            if (result == 1) {
                ret = YES;
                networkRequest.responseData = [(NSDictionary *)retObj objectForKey:@"data"];
            } else {
                ret = NO;
                networkRequest.responseData = [(NSDictionary *)retObj objectForKey:@"msg"];
            }
        }
    }
#pragma mark - 登录
    else if ([networkRequest.requestName isEqualToString:@"loginSession"])
    {
        if ([retObj isKindOfClass:[NSDictionary class]])
        {
            NSInteger result = [[(NSDictionary*)retObj objectForKey:@"result"] integerValue];
            if (result == 1)
            {
                NSLog(@"login");
            }
            else
            {
                networkRequest.responseData = retObj;
                
            }
        }
    }

    return ret;
}

#pragma mark-----------------------------------------
#pragma mark---------------接口实现------------------
#pragma mark-----------------------------------------
#pragma mark - 获取二手房房源列表
/**
 *  Api Name: 获取二手房房源列表
 *
 *  @param u_id            用户id
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
                                networkDelegate:(id<FMNetworkProtocol>)networkDelegate {
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@?", kApiBaseUrl, kApiMethod_GetMySecondHouseList];
    NSMutableDictionary *getParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [getParams setObject:kApiName_user forKey:@"name"];
    if (![FMUString isEmptyString:u_id]) {
        [getParams setObject:u_id forKey:@"u_id"];
    }
    [getParams setObject:FMUSTRING_WRAP_D((long)page) forKey:@"page"];
    [getParams setObject:FMUSTRING_WRAP_D((long)pagesize) forKey:@"pagesize"];

    return [self addGetMethod:kReq_Probe_GetMySecondHouseList baseUrl:baseUrl params:getParams delegate:networkDelegate];
}

/**
 *  获取二手房房源筛选配置参数
 *
 *  @param u_id            用户id
 *  @param networkDelegate 网络代理
 *
 *  @return 二手房房源筛选配置参数
 */
- (FMNetworkRequest *)getMySecondHouseParamsByUID:(NSString *)u_id
                                  networkDelegate:(id<FMNetworkProtocol>)networkDelegate {
    //    NSString *baseUrl = [NSString stringWithFormat:@"%@%@?", kApiBaseUrl, kApiMethod_GetMySecondHouseParams];
    NSString *baseUrl = @"http://192.168.10.20:8991/app/probe/erphouse/index/index-erphouse?osversion=5.0.2&carrieroperator=46001&version=1.1.4&phone=15987184253&tokenkey=866646022806213&hashcheckcode=7164f545a61860674a39469dd8595463&api_key=android&supportlog=&devicetype=X800&deviceid=866646022806213";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    if (![FMUString isEmptyString:u_id]) {
    //        [params setObject:u_id forKey:@"u_id"];
    //    }
    return [self addPostMethod:kReq_Probe_GetMySecondHouseParams baseUrl:baseUrl params:nil formDatas:params delegate:networkDelegate];
}

- (FMNetworkRequest *)loginSession:(id<FMNetworkProtocol>)networkDelegate {
    NSString *loginurl = @"http://192.168.10.20:8991/app/probe/user/show/check-version?deviceid=26BC5656-8406-4FDB-BD21-B659A6D5B993&devicetype=iPhone%204%20(GSM)&name=MobileUser&osversion=7.060000&phone=15987184253&hashcheckcode=ca5311b47a012efe185582bf710cd620&api_key=iPhone&version=1.1.3&tokenkey=";
    return [self addGetMethod:loginSession baseUrl:loginurl params:nil delegate:networkDelegate];
}

@end
