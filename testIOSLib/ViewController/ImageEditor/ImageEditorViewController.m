//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ImageEditorViewController.h"
#import "TZImagePickerController.h"

@interface ImageEditorViewController () <TZImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation ImageEditorViewController

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
    [self setNavtitle:@"编辑图片"];
//    [self pickImages];
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
    _titleLab = [[UILabel alloc] initWithFont:[UIFont boldSystemFontOfSize:18] andText:@"testImageShowViewController" andColor:[UIColor blackColor]];

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

#pragma mark - TZImagePicker方法
- (IBAction)pickImages {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingVideo = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets){
        for (UIImage* image in photos) {
            NSLog(@"%@",[image accessibilityIdentifier]);
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}

//图片选择回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos{
    
}
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
     NSLog(@"cancel");
}
// User finish picking photo，if assets are not empty, user picking original photo.
// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{

}

// User finish picking video,
// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {

}
@end
