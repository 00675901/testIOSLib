//
//  ViewController.m
//  testIOSLib
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTTableViewController.h"

#import "Customers.h"

@interface GTTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *testTableView;
    NSMutableArray *testTVData;
    NSMutableArray *testTVDataIndex;
}

@end

@implementation GTTableViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    testTVData = [NSMutableArray array];
    testTVDataIndex = [NSMutableArray array];
    [self addTableView];
}

//初始化[testTabelView]使用的数据
- (void)initTableViewData:(NSMutableArray *)array {
    NSMutableDictionary *contact = [NSMutableDictionary dictionary];
    //以首字母为索引,进行数据分组
    for (Customer *cu in array) {
        NSMutableArray *tempdata = [contact objectForKey:cu.customer_name_letter];
        if (tempdata) {
            [tempdata addObject:cu];
        } else {
            int asciiCode = [cu.customer_name_letter characterAtIndex:0];
            if (asciiCode >= 'a' && asciiCode <= 'z') {
                [contact setObject:[NSMutableArray arrayWithObject:cu] forKey:cu.customer_name_letter];
            } else {
                tempdata = [contact objectForKey:@"#"];
                if (tempdata) {
                    [tempdata addObject:cu];
                } else {
                    [contact setObject:[NSMutableArray arrayWithObject:cu] forKey:@"#"];
                }
            }
        }
    }
    //从a-z排序数据以及索引
    NSArray *sortedKyes = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"#", nil];
    for (NSString *key in sortedKyes) {
        Customer *temp = [contact objectForKey:key];
        if (temp) {
            [testTVDataIndex addObject:key];
            [testTVData addObject:temp];
        }
    }
}
//测试tableView
- (void)addTableView {
    testTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    testTableView.dataSource = self;
    testTableView.delegate = self;
    [self.view addSubview:testTableView];
}

#pragma mark - -----dataSource方法-----
//返回section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [testTVData count];
}
//返回section对应的row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [testTVData[section] count];
}
//返回数据cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *group = testTVData[indexPath.section];
    static NSString *cellIdentifier = @"testUITableViewCellid1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [group[indexPath.row] customer_name];
    cell.detailTextLabel.text = [group[indexPath.row] customer_phone];
    return cell;
}
//返回section title说明
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return testTVDataIndex[section];
}
////返回section foot说明
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    return testTVDataIndex[section];
//}
//返回每组标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return testTVDataIndex;
}

#pragma mark - -----tableView delegate方法-----
//设置section title高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
////设置section foot高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 40;
//}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Customer *tempdata = testTVData[indexPath.section][indexPath.row];
    NSLog(@"%d,%d------%@", indexPath.section, indexPath.row, tempdata.customer_name);
}
//重新设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
