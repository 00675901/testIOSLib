//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"

#import "Customers.h"

#import "GTTableViewController.h"
#import "ImageShowViewController.h"

@interface ViewController () {
    IBOutlet UIButton *addImageBtn;
    IBOutlet UIScrollView *imageScrollView;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self testTableView];
    //    [self getImages];
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
    Customers *tempc = [Customers getInstance];
    NSMutableArray *result = [tempc excuseQueryAll];
    
    GTTableViewController *gtTabel = [[GTTableViewController alloc] initWithData:result];
    [self.navigationController pushViewController:gtTabel animated:YES];

    NSLog(@"======testTableView Run Over======");
}

//测试图片编辑页面
- (IBAction)testImageEditor {
    NSLog(@"======testImageEditor Run Over======");
}

////测试本地文件读取
//- (void)getImages {
//    GTStorageManager *gtsm = [GTStorageManager sharedInstance];
//    NSArray *imageList = [gtsm fetchArrayForFileName:@"testImageList"];
//    int count = 0;
//    for (NSString *path in imageList) {
//        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageScrollView.bounds.size.width * count, 0, imageScrollView.bounds.size.width, imageScrollView.bounds.size.height)];
//        [tempImageView setImage:[gtsm fetchImageForFileName:path]];
//        [imageScrollView addSubview:tempImageView];
//        count++;
//    }
//    [imageScrollView setContentSize:CGSizeMake(imageScrollView.bounds.size.width * count, 0)];
//}

@end
