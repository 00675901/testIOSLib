//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBMySecondHouseMoreContentView.h"

static CGFloat const moreViewOffsetX = 42.0f;
@interface FSBMySecondHouseMoreContentView ()

@property (nonatomic, assign) BOOL showMoreView;

@end

@implementation FSBMySecondHouseMoreContentView

- (FSBMySecondHouseMoreContentView *)init {
    if (self = [super init]) {
        [self initBackgroudView];
        [self initDataView];
        return self;
    }
    return nil;
}

- (void)initBackgroudView {
    _showMoreView = NO;
    UIView *moreBackView = [[UIView alloc] init];
    moreBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    moreBackView.backgroundColor = [UIColor blackColor];
    moreBackView.alpha = 0.5f;
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoreBackView:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [moreBackView addGestureRecognizer:singleRecognizer];
    [self addSubview:moreBackView];
}

- (void)initDataView {
    UIView *uitv = [[UIView alloc] initWithFrame:CGRectMake(moreViewOffsetX, 0, ScreenWidth - moreViewOffsetX, ScreenHeight)];
    [uitv setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:uitv];
}

- (void)show {
    if (!self.showMoreView) {
        _showMoreView = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = FMURectSetX(self.frame, 0);
        }];
    }
}
- (void)tapMoreBackView:(UITapGestureRecognizer *)gesture {
    [self hiddenMoreView];
}

#pragma mark - 筛选页面功能
- (void)hiddenMoreView {
    if (self.showMoreView) {
        _showMoreView = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = FMURectSetX(self.frame, ScreenWidth);
        }];
    }
}

@end
