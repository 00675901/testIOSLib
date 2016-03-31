//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSBMySecondHouseToolbarContentViewDelegate <NSObject>

@required
- (void)clickCallBack:(int)tag;

@end

@interface FSBMySecondHouseToolbarContentView : UIView

@property (nonatomic, assign, readonly) int contentH;
@property (nonatomic, assign) id<FSBMySecondHouseToolbarContentViewDelegate> delegate;

- (FSBMySecondHouseToolbarContentView *)initWithFrame:(CGRect)frame contentHeight:(int)height DataSour:(NSArray *)array;

@end
