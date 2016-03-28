/**
 *  数据库操作类,用于数据库初始化,数据内容初始化等
 *
 *  Created by admin on 16/3/23.
 *  Copyright © 2016年 admin. All rights reserved.
 */

#import "GTDBManager.h"
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
        _sourceDBPath = [[NSBundle mainBundle] pathForResource:@"testCustomDB" ofType:@"db"];
        [self reloadDB];
    }
    return self;
}

- (FMDatabase *)getDB {
    return _db;
}

- (BOOL)openDB {
    return [_db open];
}

- (BOOL)closeDB {
    return [_db close];
}

/**
 *  重置初始化数据,将默认初始化数据库考到操作路径
 */
- (void)reloadDB {
    if (_db) {
        [_db close];
        _db = nil;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _dbPath = [documentPath stringByAppendingPathComponent:@"TestCustomDB.db"];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    @synchronized([GTDBManager class]) {
        NSError *error = nil;
        if ([fileManager fileExistsAtPath:_dbPath]) {
            [fileManager removeItemAtPath:_dbPath error:&error];
        }
        if ([fileManager copyItemAtPath:_sourceDBPath toPath:_dbPath error:&error]) {
            NSLog(@"复制DB成功：%@", _dbPath);
            _db = [[FMDatabase alloc] initWithPath:_dbPath];
        }
    }
}

@end
