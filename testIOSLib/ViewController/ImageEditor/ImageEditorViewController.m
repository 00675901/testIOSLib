//
//  Created by G on 16/3/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTCollectionAddViewCell.h"
#import "GTCollectionViewCell.h"
#import "GTCollectionViewHeader.h"
#import "ImageCategoryViewController.h"
#import "ImageEditorViewController.h"
#import "TZImagePickerController.h"

@interface ImageEditorViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ImageCategoryViewControllerDelegate, GTCollectionViewCellDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *dataArrayIndex;

@end

@implementation ImageEditorViewController

static NSString *cellIdentifierView = @"GTUICollectionViewCellID";
static NSString *cellIdentifierAddView = @"GTUICollectionAddViewCellID";
static NSString *headerIdentifier = @"collectionheaderView";

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
    [self setNavtitle:@"编辑图片"];
    //    [self pickImages];
}

- (void)initCollectionView {
    [_collectionView registerNib:[UINib nibWithNibName:@"GTCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifierView];
    [_collectionView registerNib:[UINib nibWithNibName:@"GTCollectionAddViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifierAddView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"GTCollectionViewHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
}

// 设置导航
- (void)setupNavigationBar {
    _titleLab = [[UILabel alloc] initWithFont:[UIFont boldSystemFontOfSize:18] andText:@"编辑图片" andColor:[UIColor blackColor]];

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
- (void)pickImages:(NSIndexPath *)indexPath {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingVideo = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        for (UIImage *image in photos) {
            [_dataArray[indexPath.section] insertObject:image atIndex:[_dataArray[indexPath.section] count] - 1];
            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}

#pragma mark - CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_dataArrayIndex count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section + 1 == [_dataArrayIndex count]) {
        GTCollectionAddViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierAddView forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor grayColor]];
        return cell;
    }
    GTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierView forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor grayColor]];
    if (indexPath.row + 1 != [_dataArray[indexPath.section] count]) {
        [cell setData:_dataArray[indexPath.section][indexPath.row] Label:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row] IndexPath:indexPath];
        cell.delegate = self;
    } else {
        [cell setDataLabel:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row]];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        GTCollectionViewHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        [view setTitle:_dataArrayIndex[indexPath.section]];
        return view;
    }
    return nil;
}

#pragma mark - CollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section + 1 == [_dataArrayIndex count]) {
        return CGSizeZero;
    }
    return CGSizeMake(100, 30);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section + 1 == [_dataArrayIndex count]) {
        return CGSizeMake(300, 50);
    }
    return CGSizeMake(100, 125);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section + 1 == [_dataArrayIndex count]) {
        return UIEdgeInsetsMake(20, 10, 20, 10);
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section + 1 == [_dataArrayIndex count]) {
        //添加新分类
        ImageCategoryViewController *igcv = [[ImageCategoryViewController alloc] init];
        igcv.delegate = self;
        [self.navigationController pushViewController:igcv animated:YES];
    } else if (indexPath.row + 1 == [_dataArray[indexPath.section] count]) {
        //        [_dataArray[indexPath.section] insertObject:@"+" atIndex:[_dataArray[indexPath.section] count] - 1];
        //        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        [self pickImages:indexPath];
    }
}

#pragma mark - ImageCategoryViewControllerDelegate
- (void)imageCategoryCallBack:(NSString *)categoryName {
    [_dataArrayIndex insertObject:categoryName atIndex:[_dataArrayIndex count] - 1];
    [_dataArray insertObject:[NSMutableArray arrayWithObjects:@"+", nil] atIndex:[_dataArray count] - 1];
    [_collectionView insertSections:[NSIndexSet indexSetWithIndex:[_dataArrayIndex count] - 2]];
}

#pragma mark - GTCollectionViewCellDelegate
- (void)deleteData:(NSIndexPath *)indexPath {
    NSLog(@"%d---%d", indexPath.section, indexPath.row);
    [_dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

- (void)initData {
    _dataArrayIndex = [NSMutableArray array];
    [_dataArrayIndex addObject:@"封面图"];
    [_dataArrayIndex addObject:@"户型图"];
    [_dataArrayIndex addObject:@"atlast"];

    _dataArray = [NSMutableArray array];
    [_dataArray addObject:[NSMutableArray arrayWithObjects:@"+", nil]];
    [_dataArray addObject:[NSMutableArray arrayWithObjects:@"+", nil]];
    [_dataArray addObject:[NSMutableArray arrayWithObjects:@"+", nil]];
}

@end
