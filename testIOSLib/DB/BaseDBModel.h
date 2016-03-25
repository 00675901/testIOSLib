/**
 *  数据库表映射基类,用于绑定model与数据库,并操作数据库
 *
 *  Created by admin on 16/3/23.
 *  Copyright © 2016年 admin. All rights reserved.
 */

@interface BaseDBModel : NSObject

@property (nonatomic) Class baseModelClass;
@property (nonatomic, retain) GTDBManager* baseDB;
@property (nonatomic, retain) NSString* tabelName; //表名

- (id)initWithModelClass:(Class)modelClass;

- (NSMutableArray*)excuseQueryAll;
- (NSMutableArray*)parseQueryResult:(FMResultSet*)result;

@end
