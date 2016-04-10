//
//  BaseAlert.h
//  fangstarnet
//
//  Created by XuLei on 15/8/30.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//


@interface BaseAlert : NSObject

+ (id)sharedInstance;
- (void)showMessage:(NSString *)msg;
- (void)showIndex:(NSString *)msg;//客户列表显示索引，增加此方法,0.5s消失  --by zh
- (void)showLodingWithMessage:(NSString *)msg;
- (void)dismiss;
@end
