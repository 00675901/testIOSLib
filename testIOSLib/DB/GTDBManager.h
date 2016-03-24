//
//  GTDBManager.h
//  testIOSLib
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BaseModel.h"
#import "Customer.h"
#import "FMDatabase.h"
#import <Foundation/Foundation.h>

@interface GTDBManager : NSObject

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSString *dbPath;
@property (nonatomic, strong) NSString *sourceDBPath;

+ (GTDBManager *)getInstance;
- (id)init;
- (FMDatabase *)getDB;
- (void)openDB;
- (void)closeDB;
- (void)reloadDB;

- (NSMutableArray *)excuseQueryWithModel:(BaseModel *)model;

@end
