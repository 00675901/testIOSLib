/**
 *  数据库操作类,用于数据库初始化,数据内容初始化等
 *
 *  Created by admin on 16/3/23.
 *  Copyright © 2016年 admin. All rights reserved.
 */

#import "FMDatabase.h"
#import <Foundation/Foundation.h>

@interface GTDBManager : NSObject

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSString *dbPath;
@property (nonatomic, strong) NSString *sourceDBPath;

+ (GTDBManager *)getInstance;
- (id)init;
- (FMDatabase *)getDB;
- (BOOL)openDB;
- (BOOL)closeDB;
- (void)reloadDB;

@end
