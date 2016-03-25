/**
 *  数据库表映射基类,用于绑定model与数据库,将数据库数据映射到model
 *
 *  Created by admin on 16/3/23.
 *  Copyright © 2016年 admin. All rights reserved.
 */

#import "BaseDBModel.h"
#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseDBModel

@synthesize tabelName = _tabelName;

/**
 *  初始化
 *
 *  @param modelClass 要绑定的model class
 *
 *  @return self
 */
- (id)initWithModelClass:(Class)modelClass {
    if (self = [super init]) {
        _tabelName = [[NSString stringWithUTF8String:class_getName([self class])] lowercaseString];
        _baseDB = [GTDBManager getInstance];
        _baseModelClass = modelClass;
    }
    return self;
}

/**
 *  解析查询结果
 *
 *  @param result 查询结果
 *
 *  @return 结果数组
 */
- (NSMutableArray *)parseQueryResult:(FMResultSet *)result {
    unsigned int outCount = 0;
    objc_property_t *pros = class_copyPropertyList(_baseModelClass, &outCount);
    Ivar *ivars = class_copyIvarList(_baseModelClass, &outCount);

    NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:0];
    while ([result next]) {
        BaseModel *tempc = [_baseModelClass alloc];
        for (int i = 0; i < outCount; i++) {
            objc_property_t pro = pros[i];
            Ivar ivar = class_getInstanceVariable(_baseModelClass, ivar_getName(ivars[i]));
            object_setIvar(tempc, ivar, [result stringForColumn:[NSString stringWithUTF8String:property_getName(pro)]]);
        }
        [resultList addObject:tempc];
    }
    return resultList;
}

/**
 *  从绑定的数据库表中查询所有数据,并解析为Array
 *
 *  @return 结果数组
 */
- (NSMutableArray *)excuseQueryAll {
    if ([_baseDB openDB]) {
        FMResultSet *result = [[self.baseDB getDB] executeQuery:[NSString stringWithFormat:@"select * from %@", self.tabelName]];
        NSMutableArray *resultList = [self parseQueryResult:result];
        [_baseDB closeDB];
        return resultList;
    }
    return NULL;
}

@end
