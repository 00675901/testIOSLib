//
//  Utils.m
//  fangstarnet
//
//  Created by XuLei on 15/8/30.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}

// 判断日期是今天、昨天、明天。
+ (NSInteger)compareDate:(NSDate *)date;
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return 2;
    }
    else if ([dateString isEqualToString:yesterdayString])
    {
        return 1;
    }
    else if ([dateString isEqualToString:tomorrowString])
    {
        return 3;
    }
    else
    {
        return 4;
    }
}

+ (NSString *)getFormatDuration:(NSString *)duration
{
    NSInteger durationInt = [duration integerValue];
    
//    NSInteger day = durationInt / (60*60*24);
//    NSString *dayString = [NSString stringWithFormat:@"%ld",(long)day];
    
    int hour = (durationInt / (60*60))%24;
    NSString *hourString = [NSString stringWithFormat:@"%d",hour];
    
    int minutes = (durationInt / 60)%60;
    NSString *minutesString = [NSString stringWithFormat:@"%d",minutes];
    
    int seconds = durationInt % 60;
    NSString *secondsString = [NSString stringWithFormat:@"%d",seconds];
    
    // 超过一小时
    if (durationInt >= 3600) {
        return [NSString stringWithFormat:@"%@时%@分%@秒", hourString,  minutesString, secondsString];
    }
    else {
        if (durationInt >= 60) {
            return [NSString stringWithFormat:@"%@分%@秒",  minutesString, secondsString];
        }
        else
        {
            return [NSString stringWithFormat:@"%@秒", secondsString];
        }
    }

}
@end
