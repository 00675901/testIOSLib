//
//  Created by G on 16/03/30.
//  Copyright © 2015年 fangstar. All rights reserved.
//

#import "FSBMySecondHouseToolbar.h"
#import "FSBMySecondHouseToolbarContentView.h"

@interface FSBMySecondHouseToolbar () <FSBMySecondHouseToolbarContentViewDelegate>

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, strong) UIButton *btClose;
@property (retain, nonatomic) UIButton *currButton;

@property (retain, nonatomic) NSMutableArray<FSBMySecondHouseToolbarContentView *> *viewListIndex;
@property (retain, nonatomic) NSMutableArray<UILabel *> *bottomLineIndex;

@property (nonatomic, assign) int initHeight;
@property (nonatomic, assign) int contentHeight;

@end

@implementation FSBMySecondHouseToolbar

- (FSBMySecondHouseToolbar *)init {
    return [self initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
}

- (FSBMySecondHouseToolbar *)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame contentHeight:frame.size.height];
}

- (FSBMySecondHouseToolbar *)initWithFrame:(CGRect)frame contentHeight:(int)height {
    if (self = [super initWithFrame:frame]) {
        _initHeight = frame.size.height;
        _contentHeight = height;
        [self initBtns];
        [self initContents];
        return self;
    }
    return nil;
}

- (void)initBtns {
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    _btClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [_btClose addTarget:self action:@selector(closeAllView) forControlEvents:UIControlEventTouchUpInside];
    _btClose.backgroundColor = [UIColor clearColor];
    [self addSubview:_btClose];
    _contentList = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@"全部", @"我的房源", @"我的收藏", nil], [NSArray arrayWithObjects:@"不限", @"优选网(独家)", @"房星网", nil], [NSArray arrayWithObjects:@"筛选", nil], nil];
}

- (void)initContents {
    _viewListIndex = [NSMutableArray array];
    _bottomLineIndex = [NSMutableArray array];
    int i = 0;
    UIView *btnView = [[UIView alloc] initWithFrame:self.bounds];
    [btnView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:btnView];
    for (NSArray *list in _contentList) {
        CGRect tempFrame = CGRectMake(i * (ScreenWidth / [_contentList count]), 0, ScreenWidth / [_contentList count], self.bounds.size.height);

        if (i != 0 && i != [list count]) {
            UILabel *tempLabelLine = [[UILabel alloc] initWithFrame:CGRectMake(i * tempFrame.size.width, tempFrame.origin.y, 1, tempFrame.size.height)];
            tempLabelLine.backgroundColor = colorLine;
            [btnView addSubview:tempLabelLine];
        }

        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempBtn setFrame:tempFrame];

        [tempBtn setImage:[UIImage imageNamed:@"head_tabbar_arrow_down"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"head_tabbar_arrow_up"] forState:UIControlStateHighlighted];
        [tempBtn setImage:[UIImage imageNamed:@"head_tabbar_arrow_up"] forState:UIControlStateSelected];
        [tempBtn setImage:[UIImage imageNamed:@"head_tabbar_arrow_down"] forState:UIControlStateHighlighted | UIControlStateSelected];
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, tempFrame.size.width - 20, 0, 0)];

        [tempBtn setTitle:list[0] forState:UIControlStateNormal];
        [tempBtn setTitleColor:colorNull forState:UIControlStateNormal];
        [tempBtn setTitleColor:colorTint forState:UIControlStateHighlighted];
        [tempBtn setTitleColor:colorTint forState:UIControlStateSelected];
        [tempBtn setTitleColor:colorNull forState:UIControlStateHighlighted | UIControlStateSelected];
        [tempBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];

        [tempBtn addTarget:self action:@selector(btnStatusAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempBtn setTag:i];

        [btnView addSubview:tempBtn];
        
        UILabel *tempBottomLine = [[UILabel alloc] initWithFrame:CGRectMake(i * tempFrame.size.width, tempFrame.origin.y + tempBtn.bounds.size.height, tempBtn.bounds.size.width, 1)];
        tempBottomLine.backgroundColor = colorLine;
        [btnView addSubview:tempBottomLine];
        [_bottomLineIndex addObject:tempBottomLine];

        //计算高度
        int tempH = [_contentList[i] count];
        tempH *= _contentHeight; //每个项目高度;
        FSBMySecondHouseToolbarContentView *tempView = [[FSBMySecondHouseToolbarContentView alloc] initWithFrame:CGRectMake(0, _initHeight + 1, self.bounds.size.width, tempH) contentHeight:_contentHeight DataSour:_contentList[i]];
        tempView.delegate = self;
        tempView.hidden = YES;
        [self addSubview:tempView];

        [_viewListIndex addObject:tempView];
        i++;
    }
}

- (void)btnStatusAction:(UIButton *)sender {
    if (sender == _currButton) {
        _currButton.selected = _currButton.selected ? NO : YES;
        [_viewListIndex[_currButton.tag] setHidden:!_currButton.isSelected];
        if (_currButton.isSelected) {
            [_bottomLineIndex[_currButton.tag] setBackgroundColor:[UIColor whiteColor]];
            [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        } else {
            [_bottomLineIndex[_currButton.tag] setBackgroundColor:colorLine];
            [self setFrame:CGRectMake(0, 0, ScreenWidth, _initHeight)];
        }
    } else {
        [_currButton setSelected:NO];
        [_viewListIndex[_currButton.tag] setHidden:!_currButton.isSelected];
        [_bottomLineIndex[_currButton.tag] setBackgroundColor:colorLine];

        _currButton = sender;

        [_currButton setSelected:YES];
        [_viewListIndex[_currButton.tag] setHidden:!_currButton.isSelected];
        [_bottomLineIndex[_currButton.tag] setBackgroundColor:[UIColor whiteColor]];

        [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
}

- (void)closeAllView {
    for (UIView *tagView in _viewListIndex) {
        [tagView setHidden:YES];
    }
    if (_currButton) {
        [_currButton setSelected:NO];
    }
    [self setFrame:CGRectMake(0, 0, ScreenWidth, _initHeight)];
}

#pragma mark - 内容按钮回调
- (void)clickCallBack:(int)tag {
    NSLog(@"callBak:%d", tag);
    [_currButton setTitle:_contentList[_currButton.tag][tag] forState:UIControlStateNormal];
    [self btnStatusAction:_currButton];
}

@end