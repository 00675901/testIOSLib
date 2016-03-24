//
//  Customer.h
//  testIOSLib
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BaseModel.h"

@interface Customer : BaseModel

@property (nonatomic, retain) NSString* customer_id; //客户id
@property (nonatomic, retain) NSString* contant_id; //联系人ID
@property (nonatomic, retain) NSString* customer_name; //客户名称
@property (nonatomic, retain) NSString* customer_phone; //客户手机
@property (nonatomic, retain) NSString* customer_name_letter; //客户头像

- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)dictionaryValue;

@end
