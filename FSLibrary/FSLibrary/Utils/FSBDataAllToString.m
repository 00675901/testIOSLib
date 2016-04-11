//
//  FSBDataAllToString.m
//  FangStarBroker
//
//  Created by zh on 15/11/24.
//  Copyright © 2015年 fangstar. All rights reserved.
//

#import "FSBDataAllToString.h"
#import "LFCGzipUtillity.h"

@implementation FSBDataAllToString

+ (NSString *)AllToString:(id)parameter
{
    NSString *retString;
    if ([parameter isKindOfClass:[NSNull class]]) {
        retString = @"";
    } else if (parameter == [NSNull null]) {
        retString = @"";
    } else if ([parameter isKindOfClass:[NSString class]]) {
        retString = parameter;
    } else if ([parameter isKindOfClass:[NSNumber class]]) {
        retString = [NSString stringWithFormat:@"%ld", (long)[parameter integerValue]];
    }  else {
        retString = [NSString stringWithFormat:@"%@", [parameter stringValue]];
    }
    
//    if ([retString isEqualToString:@"(null)"]) {
//        retString = @"";
//    }
//    
//    if (!retString) {
//        retString = @"";
//    }
    
    return retString;
}

+ (NSInteger)AllToInteger:(id)parameter
{
    NSInteger retNumber;
    if ([parameter isKindOfClass:[NSNull class]]) {
        retNumber = 0;
    }
    
    if (parameter == [NSNull null]) {
        retNumber = 0;
    }
    
    if ([parameter isKindOfClass:[NSString class]]) {
        retNumber = [parameter integerValue];
    } else if ([parameter isKindOfClass:[NSNumber class]]) {
        retNumber = [parameter integerValue];
    } else if ([parameter isKindOfClass:[NSNull class]]) {
        retNumber = 0;
    } else {
        retNumber = 0;
    }
    
    return retNumber;
}

+ (NSString *)unGzip:(NSString *)gzipString
{
    NSData *gzipData = [gzipString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *retData = [LFCGzipUtillity uncompressZippedData:gzipData];
    NSString *retStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    
    return retStr;
}

+ (NSString *)unGzipData:(NSData *)gzipData
{
    NSData *retData = [LFCGzipUtillity uncompressZippedData:gzipData];
    NSString *retStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    
    return retStr;
}

@end
