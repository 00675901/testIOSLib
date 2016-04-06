//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSBMySecondMoreViewCollectionCellDelegate <NSObject>

@optional
- (void)onclickCallBack:(NSIndexPath *)indexPath;

@end

@interface FSBMySecondMoreViewCollectionCell : UICollectionViewCell

@property (nonatomic, assign) id<FSBMySecondMoreViewCollectionCellDelegate> delegate;

- (void)setIndexPath:(NSIndexPath *)indexPath;
@end
