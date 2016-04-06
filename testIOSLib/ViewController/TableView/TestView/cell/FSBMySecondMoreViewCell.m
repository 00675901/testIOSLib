//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "FSBMySecondMoreViewCell.h"
#import "FSBMySecondMoreViewCollectionCell.h"

@interface FSBMySecondMoreViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FSBMySecondMoreViewCollectionCellDelegate>

@property (retain, nonatomic) IBOutlet UICollectionView *cContact;
@property (retain, nonatomic) NSString *cellIdentifierView;
@property (retain, nonatomic) NSIndexPath *cellIndexPath;

@end

@implementation FSBMySecondMoreViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initContentData:(NSIndexPath *)indexPath {
    _cellIndexPath = indexPath;
    [self initCollectionView:_cellIndexPath];
}

- (void)initCollectionView:(NSIndexPath *)indexPath {
    NSLog(@"initCollectionView-%d-%d", indexPath.section, indexPath.row);
    _cellIdentifierView = [NSString stringWithFormat:@"FSBMySecondMoreViewCellID_%d_%d", indexPath.section, indexPath.row];

    [_cContact registerNib:[UINib nibWithNibName:@"FSBMySecondMoreViewCollectionCell" bundle:nil] forCellWithReuseIdentifier:_cellIdentifierView];
    _cContact.dataSource = self;
    _cContact.delegate = self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSBMySecondMoreViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifierView forIndexPath:indexPath];
    cell.delegate = self;
    [cell setIndexPath:indexPath];
    return cell;
}

#pragma mark - CollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 45);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - FSBMySecondMoreViewCollectionCellDelegate
- (void)onclickCallBack:(NSIndexPath *)indexPath {
    NSLog(@"%d-%d", indexPath.section, indexPath.row);
}

@end
