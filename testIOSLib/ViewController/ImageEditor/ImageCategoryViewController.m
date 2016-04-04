//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ImageCategoryViewController.h"

@interface ImageCategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation ImageCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航
    [self setupNavigationBar];
    [self setNavtitle:@"请先选择图片分类"];
}

- (void)initCollectionView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
}

// 设置导航
- (void)setupNavigationBar {
    _titleLab = [[UILabel alloc] initWithFont:[UIFont boldSystemFontOfSize:18] andText:@"请先选择图片分类" andColor:[UIColor blackColor]];
    _titleLab.frame = CGRectMake(0, 0, 80, 26);
    [self.navigationItem setTitleView:_titleLab];
    // 自定义返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"top_lf_arrow_lf"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 35, 50);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.backBarButtonItem = nil;
}

- (void)setNavtitle:(NSString *)title {
    _titleLab.text = title;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}
//返回数据cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"GTImageCateGoryViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [cell.textLabel setText:_dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate imageCategoryCallBack:_dataArray[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:@"客厅"];
    [_dataArray addObject:@"卧室"];
    [_dataArray addObject:@"阳台"];
    [_dataArray addObject:@"厨房"];
    [_dataArray addObject:@"卫生间"];
    [_dataArray addObject:@"小区外景"];
}

@end
