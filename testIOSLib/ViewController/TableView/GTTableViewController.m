//
//  ViewController.m
//  testIOSLib
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTTableViewCell.h"
#import "GTTableViewController.h"

#import "FSBMySecondHouseToolbar.h"

@interface GTTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *testTableView;
}

@property (nonatomic, retain) FSBMySecondHouseToolbar *toolBar;
@property (nonatomic, retain) NSMutableArray *testTVData;
@property (nonatomic, retain) NSMutableArray *testTVDataIndex;

@end

@implementation GTTableViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

// 设置导航
//    [self setupNavigationBar];
//    [self setupNaviBarBackGround];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addTableView];

    [self initToolsBar]; //测试FangStar页面方法
}

//初始化
- (GTTableViewController *)initWithData:(NSMutableArray *)array {
    if (self = [super init]) {
        [self initTableViewData:array];
        return self;
    }
    return nil;
}

//初始化[testTabelView]使用的数据
- (void)initTableViewData:(NSMutableArray *)array {

    _testTVData = [NSMutableArray array];
    _testTVDataIndex = [NSMutableArray array];
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
        NSArray *tempList = [contact objectForKey:key];
        if (tempList) {
            [_testTVDataIndex addObject:key];
            [_testTVData addObject:tempList];
        }
    }
    NSLog(@"keys:%d,data:%d", [_testTVDataIndex count], [_testTVData count]);
}
//添加tableView
- (void)addTableView {
    testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40 - 60 - 5) style:UITableViewStylePlain];
    testTableView.dataSource = self;
    testTableView.delegate = self;
    testTableView.scrollEnabled = YES;
    testTableView.showsVerticalScrollIndicator = YES;

    testTableView.sectionIndexColor = [UIColor blackColor]; //改变索引的颜色
    if (IOS7_OR_LATER) { //<7.0 系统无此方法
        testTableView.sectionIndexBackgroundColor = [UIColor clearColor]; //索引背景色
    }

    [self.view addSubview:testTableView];
}

#pragma mark - -----dataSource方法-----
//返回section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_testTVData count];
}
//返回section对应的row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_testTVData[section] count];
}
//返回数据cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *group = _testTVData[indexPath.section];
    static NSString *cellIdentifier = @"testUITableViewCellid1";
    GTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        //        cell = [[GTTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GTTableViewCell" owner:self options:nil] lastObject];
    }
    [cell setData:group[indexPath.row]];
    return cell;
}
//返回section title说明
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _testTVDataIndex[section];
}
////返回section foot说明
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    return testTVDataIndex[section];
//}
//返回每组标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _testTVDataIndex;
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
    Customer *tempdata = _testTVData[indexPath.section][indexPath.row];
    NSLog(@"%d,%d------%@", indexPath.section, indexPath.row, tempdata.customer_name);
}

//重新设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - 测试fangstar页面

/**
 *  筛选工具栏
 */
- (void)initToolsBar {
    _toolBar = [[FSBMySecondHouseToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) contentHeight:100];
    [self.view addSubview:_toolBar];
}

@end
