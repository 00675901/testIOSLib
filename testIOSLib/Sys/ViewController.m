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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [self testTempJson];
    
    Customer *cu = [[Customer alloc] initWithDictionary:NULL];
    
//    [gtm excuseQueryWithModel:cu];
    
    NSLog(@"======%@,%@,%@,%@,%@======", cu.customer_id, cu.contant_id, cu.customer_name, cu.customer_phone, cu.customer_name_letter);
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
