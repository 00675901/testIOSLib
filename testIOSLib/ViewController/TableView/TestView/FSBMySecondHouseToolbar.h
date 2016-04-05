//
//  Created by G on 16/03/30.
//  Copyright © 2015年 fangstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSBMySecondHouseToolbarDelegate <NSObject>

@optional
- (void)showMoreView;

@end

@interface FSBMySecondHouseToolbar : UIView

@property (nonatomic, assign) id<FSBMySecondHouseToolbarDelegate> delegate;

- (FSBMySecondHouseToolbar *)initWithFrame:(CGRect)frame contentHeight:(int)height;

@end
