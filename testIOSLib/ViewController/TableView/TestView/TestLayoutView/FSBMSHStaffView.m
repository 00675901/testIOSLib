//
//  Created by G on 16/4/11.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBMSHStaffView.h"

@interface FSBMSHStaffView () <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_contentTable;
}

@property (nonatomic, strong) NSMutableArray *sourceData;

@end

@implementation FSBMSHStaffView

- (void)startDataView:(NSString *)str {
    [self testLocalData];
    NSLog(@"staff:%@", str);
}

#warning 用本地数据测试
- (void)testLocalData {
    NSString *testDataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yuangong" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *testData = (NSDictionary *)[testDataStr objectFromJSONString];
    _sourceData = [NSMutableArray arrayWithArray:[testData objectForKey:@"data"]];
    [_contentTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sourceData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _sourceData[indexPath.row];
    static NSString *cellIdentifierLeft = @"UITableViewStaffCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierLeft];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierLeft];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xEDEDED alpha:1.0];
    [cell.textLabel setHighlightedTextColor:[UIColor colorWithHex:0x1E93FA alpha:1.0]];
    [cell.textLabel setText:dic[@"staff_name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _sourceData[indexPath.row];
    NSLog(@"%@", dic[@"staff_name"]);
}

- (IBAction)certainFunction:(UIButton *)sender {
    NSLog(@"testtesttest staff staff");
}

@end
