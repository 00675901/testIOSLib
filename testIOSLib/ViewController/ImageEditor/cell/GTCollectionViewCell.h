//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTCollectionViewCellDelegate <NSObject>

@optional
- (void)deleteData:(NSIndexPath *)indexPath;

@end

@interface GTCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<GTCollectionViewCellDelegate> delegate;

- (void)setData:(UIImage *)dataImage Label:(NSString *)name IndexPath:(NSIndexPath *)indexPath;
- (void)setDataLabel:(NSString *)name;

@end
