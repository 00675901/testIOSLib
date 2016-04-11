//
//  Created by G on 16/4/11.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBMSHBlockView.h"

@interface FSBMSHBlockView () <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_leftTable;
    IBOutlet UITableView *_rightTable;
}

@property (nonatomic, strong) NSMutableArray *sourceData;
@property (nonatomic, assign) int currCount;
@property (nonatomic, assign) int currLeftIndex;

@end

@implementation FSBMSHBlockView

- (void)startDataView:(NSString *)str {
    NSLog(@"FSBMSHBlockView:%@", str);

    [self testLocalData];
}

#warning 用本地数据测试
- (void)testLocalData {
    NSString *testDataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pianqu" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *testData = (NSDictionary *)[testDataStr objectFromJSONString];
    _sourceData = [NSMutableArray arrayWithArray:[testData objectForKey:@"data"]];
    [_leftTable reloadData];
    //默认选中第一项
    [_leftTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:_leftTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (IBAction)certainFunction:(UIButton *)sender {
    NSLog(@"testtesttest FSBMSHBlockView FSBMSHBlockView");
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTable) {
        return [_sourceData count];
    } else {
        return _currCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTable) {
        _currLeftIndex = indexPath.row;
        NSDictionary *dic = _sourceData[indexPath.row];
        static NSString *cellIdentifierLeft = @"UITableViewBlockLeftCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierLeft];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierLeft];
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xEDEDED alpha:1.0];
        [cell.textLabel setHighlightedTextColor:[UIColor colorWithHex:0x1E93FA alpha:1.0]];
        [cell.textLabel setText:dic[@"district_name"]];
        return cell;
    } else {
        NSDictionary *dic = _sourceData[_currLeftIndex];
        static NSString *cellIdentifierRight = @"UITableViewBlockRightCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierRight];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierRight];
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        NSArray *list = dic[@"district_block"];
        [cell.textLabel setHighlightedTextColor:[UIColor colorWithHex:0x1E93FA alpha:1.0]];
        [cell.textLabel setText:list[indexPath.row][@"block_name"]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTable) {
        _currLeftIndex = indexPath.row;
        NSDictionary *dic = _sourceData[indexPath.row];
        NSArray *list = dic[@"district_block"];
        _currCount = [list count];
        [_rightTable reloadData];
    } else {
        NSDictionary *dic = _sourceData[_currLeftIndex];
        NSArray *list = dic[@"district_block"];
        NSLog(@"%@", list[indexPath.row][@"block_name"]);
    }
}

@end
