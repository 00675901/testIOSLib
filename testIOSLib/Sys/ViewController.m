//
//  ViewController.m
//  testIOSLib
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "AllBeans.h"
#import "GTDBManager.h"
#import "ViewController.h"

#import "Customers.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Customers *tempc = [Customers getInstance];
    
    NSMutableArray *result = [tempc excuseQueryAll];
    NSLog(@"%d",[result count]);
    for (Customer* cu in result){
        NSLog(@"======%@,%@,%@,%@,%@======", cu.customer_id, cu.contact_id, cu.customer_name, cu.customer_phone, cu.customer_name_letter);;
    }
    
    NSMutableArray *result2 = [tempc excuseQueryWithName:@"'哈哈'"];
    NSLog(@"%d",[result2 count]);
    for (Customer* cu in result2){
        NSLog(@"======%@,%@,%@,%@,%@======", cu.customer_id, cu.contact_id, cu.customer_name, cu.customer_phone, cu.customer_name_letter);;
    }
    
}

- (void)testTempJson {
    GTDBManager *gtm = [GTDBManager getInstance];
    FMDatabase *gtdb = [gtm getDB];
    FMResultSet *result = [gtdb executeQuery:@"select * from customers"];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"customer_name"];
        NSLog(@"result name:%@", name);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
