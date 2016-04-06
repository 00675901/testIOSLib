//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBMySecondHouseMoreView.h"
#import "FSBMySecondMoreViewCell.h"

static CGFloat const moreViewOffsetX = 42.0f;
#define SHOW_FRAME CGRectMake(moreViewOffsetX, 0, ScreenWidth - moreViewOffsetX, ScreenHeight)

@interface FSBMySecondHouseMoreView () <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIView *_moreView;
    IBOutlet UITableView *_moreTable;
}

@property (nonatomic, assign) BOOL showMoreView;

@end

@implementation FSBMySecondHouseMoreView

- (FSBMySecondHouseMoreView *)init {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FSBMySecondHouseMoreView" owner:self options:nil];
    for (id obj in nibs) {
        if ([obj isKindOfClass:[FSBMySecondHouseMoreView class]]) {
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
    [_moreView setFrame:SHOW_FRAME];
    [self addSubview:_moreView];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_moreTable == tableView) {
        return 3;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_moreTable == tableView) {
        static NSString *cellIdentifier = @"moreTableViewCellID1";
        FSBMySecondMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            //            cell = [[FSBMySecondMoreViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FSBMySecondMoreViewCell" owner:self options:nil] lastObject];
        }
        [cell initContentData:indexPath];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

@end
