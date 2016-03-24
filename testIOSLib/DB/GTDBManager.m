//
//  GTDBManager.m
//  testIOSLib
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTDBManager.h"
#import <objc/runtime.h>
#import <sqlite3.h>

@interface GTDBManager ()

@end

@implementation GTDBManager

+ (GTDBManager *)getInstance {
    static GTDBManager *sharedInstance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        sharedInstance = [[GTDBManager alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _sourceDBPath = [[NSBundle mainBundle] pathForResource:@"testDB" ofType:@"db"];
        [self reloadDB];
    }
    return self;
}

- (FMDatabase *)getDB {
    return _db;
}

- (void)openDB {
    [_db open];
}

- (void)closeDB {
    [_db close];
}

- (void)reloadDB {
    if (_db) {
        [_db close];
        _db = nil;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _dbPath = [documentPath stringByAppendingPathComponent:@"TestDB.db"];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    @synchronized([GTDBManager class]) {
        NSError *error = nil;
        if ([fileManager fileExistsAtPath:_dbPath]) {
            [fileManager removeItemAtPath:_dbPath error:&error];
        }
        if ([fileManager copyItemAtPath:_sourceDBPath toPath:_dbPath error:&error]) {
            NSLog(@"复制DB成功：%@", _dbPath);
            _db = [[FMDatabase alloc] initWithPath:_dbPath];
            [_db open];
        }
    }
}

- (NSMutableArray *)excuseQueryWithModel:(BaseModel *)model {
    unsigned int outCount = 0;
    Class cls = model.class;
    NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:0];
    objc_property_t *pros = class_copyPropertyList(cls, &outCount);
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t pro = pros[i];
        Ivar ivar = class_getInstanceVariable(cls, ivar_getName(ivars[i]));
        object_setIvar(model, ivar, [NSString stringWithUTF8String:property_getName(pro)]);
    }
    
    FMResultSet *result = [_db executeQuery:@"select * from customers"];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"customer_name"];
        NSLog(@"result name:%@", name);
    }
    
    return resultList;
}

@end
