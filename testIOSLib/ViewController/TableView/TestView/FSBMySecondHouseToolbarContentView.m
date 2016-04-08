//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBMySecondHouseToolbarContentView.h"

@interface FSBMySecondHouseToolbarContentView ()

@property (nonatomic, retain) NSArray<FSBSecondHouseMoreModel*> *dataSour;

@end

@implementation FSBMySecondHouseToolbarContentView

@synthesize contentH = _contentH;

- (FSBMySecondHouseToolbarContentView *)initWithFrame:(CGRect)frame contentHeight:(int)height DataSour:(NSArray<FSBSecondHouseMoreModel *> *)array {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _dataSour = array;
        _contentH = height;
        [self initContentWithFrame:frame];
        return self;
    }
    return nil;
}

- (void)initContentWithFrame:(CGRect)frame {
    UIScrollView *tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    int i = 0;
    for (FSBSecondHouseMoreModel *btn in _dataSour) {
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempBtn setFrame:CGRectMake(0, i * _contentH, self.bounds.size.width, _contentH)];

        [tempBtn setTitle:btn.moreName forState:UIControlStateNormal];
        [tempBtn setTitleColor:colorNull forState:UIControlStateNormal];
        [tempBtn setTitleColor:colorTint forState:UIControlStateHighlighted];
        [tempBtn setTitleColor:colorTint forState:UIControlStateSelected];
        [tempBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, frame.size.width - tempBtn.titleLabel.bounds.size.width - 40)];

        [tempBtn setTag:i];
        [tempBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tempView addSubview:tempBtn];

        UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(10, tempBtn.frame.origin.y + tempBtn.bounds.size.height, tempBtn.bounds.size.width - 20, 1)];
        [labelLine setBackgroundColor:colorNull];
        [tempView addSubview:labelLine];
        i++;
    }
    [tempView setContentSize:CGSizeMake(0, _contentH * i + 1)];
    [self addSubview:tempView];
}

- (void)btnClick:(UIButton *)sender {
    [_delegate clickCallBack:sender.tag];
}

@end
