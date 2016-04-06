//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBTestMoreView.h"

static CGFloat const moreViewOffsetX = 42.0f;
#define SHOW_FRAME CGRectMake(moreViewOffsetX, 0, ScreenWidth - moreViewOffsetX, ScreenHeight)

@interface FSBTestMoreView () {
    IBOutlet UIView *_moreView;
    IBOutlet UIScrollView *_moreTable;
}

@property (nonatomic, assign) BOOL showMoreView;

@end

@implementation FSBTestMoreView

- (FSBTestMoreView *)init {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FSBTestMoreView" owner:self options:nil];
    for (id obj in nibs) {
        if ([obj isKindOfClass:[FSBTestMoreView class]]) {
            self = obj;
            break;
        }
    }
    self.backgroundColor = [UIColor clearColor];
    [self initBackgroudView];
    [self initDataView];
    return self;
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
- (void)tapMoreBackView:(UITapGestureRecognizer *)gesture {
    [self hiddenMoreView];
}
- (void)initDataView {
    //    [_moreView setFrame:SHOW_FRAME];
    //    [self addSubview:_moreView];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.myLeftMargin = moreViewOffsetX;
    scrollView.myRightMargin = ScreenWidth - moreViewOffsetX;
    [self addSubview:scrollView];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    //    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10); //设置布局内的子视图离自己的边距.
    contentLayout.myLeftMargin = 0;
    contentLayout.myRightMargin = 0; //同时指定左右边距为0表示宽度和父视图一样宽
    [scrollView addSubview:contentLayout];

    for (int i = 0; i < 10; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(handleLabelShow:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"点击按钮显示隐藏文本-%d", i + 1] forState:UIControlStateNormal];
        btn.tag = i + 1;
        if (i % 2 == 0) {
            [btn setBackgroundColor:[UIColor grayColor]];
        } else {
            [btn setBackgroundColor:[UIColor greenColor]];
        }
        btn.myLeftMargin = 0;
        btn.myRightMargin = 0;
        btn.myHeight = 60;
        //        [btn sizeToFit];
        [contentLayout addSubview:btn];
    }
}
- (void)show {
    if (!self.showMoreView) {
        _showMoreView = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = FMURectSetX(self.frame, 0);
        }];
    }
}
- (void)hiddenMoreView {
    if (self.showMoreView) {
        _showMoreView = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = FMURectSetX(self.frame, ScreenWidth);
        }];
    }
}

- (void)handleLabelShow:(UIButton *)sender {
    NSLog(@"%d", sender.tag);
    sender.hidden = YES;
}
@end
