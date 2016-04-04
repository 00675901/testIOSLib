//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ImageEditorViewController.h"
#import "ImageShowViewController.h"

@interface ImageShowViewController ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation ImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航
    [self setupNavigationBar];
    [self setupNaviBarBackGround];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupNaviBarBackGround {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;

        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [navigationBar setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        // 导航背景色
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
}
// 设置导航
- (void)setupNavigationBar {
    _titleLab = [[UILabel alloc] initWithFont:[UIFont boldSystemFontOfSize:18] andText:@"图片浏览" andColor:[UIColor blackColor]];

    _titleLab.frame = CGRectMake(0, 0, 80, 26);

    [self.navigationItem setTitleView:_titleLab];

    // 自定义返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"top_lf_arrow_lf"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 35, 50);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeSystem];

    editorBtn.frame = CGRectMake(0, 0, 50, 50);
    [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editorBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [editorBtn addTarget:self action:@selector(editorView) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:editorBtn];

    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.backBarButtonItem = nil;
    [self.navigationItem setRightBarButtonItem:item2];
}

- (void)setNavtitle:(NSString *)title {
    _titleLab.text = title;
}

#pragma mark - 事件
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)editorView {
    ImageEditorViewController *ievc = [[ImageEditorViewController alloc] init];
    [self.navigationController pushViewController:ievc animated:YES];
}

@end
