//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCategoryViewControllerDelegate <NSObject>

@required
- (void)imageCategoryCallBack:(NSString*)categoryName;

@end

@interface ImageCategoryViewController : UIViewController

@property (nonatomic, assign) id<ImageCategoryViewControllerDelegate> delegate;

@end
