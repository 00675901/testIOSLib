/**
 *  数据库表[customs]映射类,用于绑定model和操作数据库表
 *
 *  Created by admin on 16/3/23.
 *  Copyright © 2016年 admin. All rights reserved.
 */

#import "Customers.h"

@implementation Customers

+ (Customers *)getInstance {
    static Customers *sharedInstance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        sharedInstance = [[Customers alloc] init];
    });
    return sharedInstance;
}

/**
 *  绑定model customer
 *
 *  @return self
 */
- (id)init {
    if (self = [super initWithModelClass:[Customer class]]) {
    }
    return self;
}

/**
 *  从[customs]表中根据名字查询数据,并解析为Array
 *
 *  @return 结果数组
 */
- (NSMutableArray *)excuseQueryWithName:(NSString *)name {
    if ([self.baseDB openDB]) {
        FMResultSet *result = [[self.baseDB getDB] executeQuery:[NSString stringWithFormat:@"select * from %@ where customer_name=%@", self.tabelName, name]];
        NSMutableArray *resultList = [self parseQueryResult:result];
        [self.baseDB closeDB];
        return resultList;
    }
    return NULL;
}

@end
