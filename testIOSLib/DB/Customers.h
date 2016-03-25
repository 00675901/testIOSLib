/**
 *  数据库表[customs]映射类,用于绑定model和操作数据库表
 *
 *  Created by admin on 16/3/23.
 *  Copyright © 2016年 admin. All rights reserved.
 */

#import "BaseDBModel.h"

@interface Customers : BaseDBModel

- (id)init;
+ (Customers *)getInstance;

- (NSMutableArray *)excuseQueryWithName:(NSString *)name;

@end
