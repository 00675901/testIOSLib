//
//  Utils.h
//  fangstarnet
//
//  Created by XuLei on 15/8/30.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import <MBProgressHUD.h>

@interface Utils : NSObject

+(MBProgressHUD *)createHUD;

/**
 *  判断日期是今天、昨天、明天。
 *
 *  @param date 待判断的日期
 *
 *  @return 1:昨天 2：今天 3：明天 4：其他
 */
+ (NSInteger)compareDate:(NSDate *)date;

/**
 *  获取格式化的时长
 *
 *  @param duration 时长（s）
 *
 *  @return 几时几分几秒
 */
+ (NSString *)getFormatDuration:(NSString *)duration;

@end
