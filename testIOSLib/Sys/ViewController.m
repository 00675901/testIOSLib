//
//  ViewController.m
//  testIOSLib
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"

#import "Customers.h"
#import "GTTableViewCell.h"

@interface ViewController () {

}

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - -----测试方法-----
//测试数据库查询
- (IBAction)testDB {
    Customers *tempc = [Customers getInstance];
    NSMutableArray *result = [tempc excuseQueryWithName:@"'哈哈'"];
    NSLog(@"%d", [result count]);
    for (Customer *cu in result) {
        NSLog(@"======%@,%@,%@,%@,%@======", cu.customer_id, cu.contact_id, cu.customer_name, cu.customer_phone, cu.customer_name_letter);
    }
    NSLog(@"======testDB Run Over======");
}

//测试tableView
- (IBAction)testTableView {
    
    NSLog(@"======testTableView Run Over======");
}
@end
