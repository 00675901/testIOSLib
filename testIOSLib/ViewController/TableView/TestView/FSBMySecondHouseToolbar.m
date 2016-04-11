//
//  Created by G on 16/03/30.
//  Copyright © 2015年 fangstar. All rights reserved.
//

//#import "FSBMySecondHouseMoreView.h"
#import "FSBMySecondHouseMoreLayout.h"
#import "FSBMySecondHouseToolbar.h"
#import "FSBMySecondHouseToolbarContentView.h"

#define colorNull [UIColor colorWithRed:3 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0]
#define colorLine [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1.0]

@interface FSBMySecondHouseToolbar () <FSBMySecondHouseToolbarContentViewDelegate, FMNetworkProtocol>

@property (nonatomic, strong) NSMutableDictionary *sourceData;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<FSBSecondHouseMoreModel *> *> *contentList;
@property (nonatomic, strong) UIButton *btClose;
@property (retain, nonatomic) UIButton *currButton;

@property (retain, nonatomic) NSMutableArray<FSBMySecondHouseToolbarContentView *> *viewListIndex;
@property (retain, nonatomic) UILabel *currBottomLine;

@property (nonatomic, strong) NSMutableArray *requestArray;

@property (nonatomic, assign) int initHeight;
@property (nonatomic, assign) int contentHeight;

//筛选页面
//@property (nonatomic, strong) FSBMySecondHouseMoreView *fsbMoreView;
@property (nonatomic, strong) FSBMySecondHouseMoreLayout *fsbMoreView;

@end

@implementation FSBMySecondHouseToolbar

#pragma mark - 页面初始化方法
- (void)dealloc {
    [_fsbMoreView removeFromSuperview];
}

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
        _requestArray = [NSMutableArray array];
        [self testLocalData];
//        [self initRequestData];
        return self;
    }
    return nil;
}

-(void)initRequestData{
    FMNetworkRequest *request = [[FSNetworkManager sharedInstance] getMySecondHouseParamsByUID:@"10420" networkDelegate:self];
    [_requestArray addObject:request];
}

#warning 本地测试数据
-(void)testLocalData{
    NSString *testDataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SecondHouseParamsData" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *testData = (NSDictionary *)[testDataStr objectFromJSONString];
    _sourceData = [NSMutableDictionary dictionaryWithDictionary:[testData objectForKey:@"data"]];
    [self initContentData];
}

/**
 *  初始化数据
 */
- (void)initContentData {
    _contentList = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSDictionary *data in [_sourceData objectForKey:@"house_source"]) {
        FSBSecondHouseMoreModel *tempModel = [[FSBSecondHouseMoreModel alloc] init];
        tempModel.moreName = [data objectForKey:@"name"];
        tempModel.moreId = [data objectForKey:@"id"];
        [tempList addObject:tempModel];
    }
    [_contentList addObject:tempList];

    tempList = [NSMutableArray array];
    for (NSDictionary *data in [_sourceData objectForKey:@"house_type"]) {
        FSBSecondHouseMoreModel *tempModel = [[FSBSecondHouseMoreModel alloc] init];
        tempModel.moreName = [data objectForKey:@"name"];
        tempModel.moreId = [data objectForKey:@"id"];
        [tempList addObject:tempModel];
    }
    [_contentList addObject:tempList];

    //自定义筛选按钮
    tempList = [NSMutableArray array];
    FSBSecondHouseMoreModel *tempModel = [[FSBSecondHouseMoreModel alloc] init];
    tempModel.moreName = @"筛选";
    tempModel.moreId = @"-1";
    [tempList addObject:tempModel];
    [_contentList addObject:tempList];

    [self initBackground];
}
/**
 *  初始化背景界面
 */
- (void)initBackground {
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    _btClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [_btClose addTarget:self action:@selector(closeAllView) forControlEvents:UIControlEventTouchUpInside];
    _btClose.backgroundColor = [UIColor clearColor];
    [self addSubview:_btClose];
    [self initBtnContents];
}
/**
 *  初始化内容按钮
 */
- (void)initBtnContents {
    _viewListIndex = [NSMutableArray array];
    int i = 0;
    UIView *btnView = [[UIView alloc] initWithFrame:self.bounds];
    [btnView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:btnView];

    UILabel *tempBottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, btnView.bounds.size.height, btnView.bounds.size.width, 1)];
    tempBottomLine.backgroundColor = colorLine;
    [btnView addSubview:tempBottomLine];
    _currBottomLine = [[UILabel alloc] init];
    _currBottomLine.backgroundColor = btnView.backgroundColor;
    [_currBottomLine setHidden:YES];
    [btnView addSubview:_currBottomLine];

    for (NSArray<FSBSecondHouseMoreModel *> *list in _contentList) {
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

        [tempBtn setTitle:list[0].moreName forState:UIControlStateNormal];
        [tempBtn setTitleColor:colorNull forState:UIControlStateNormal];
        [tempBtn setTitleColor:colorTint forState:UIControlStateHighlighted];
        [tempBtn setTitleColor:colorTint forState:UIControlStateSelected];
        [tempBtn setTitleColor:colorNull forState:UIControlStateHighlighted | UIControlStateSelected];

        [tempBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [tempBtn setTag:i];
        [btnView addSubview:tempBtn];

        [self showSpreadView:tempBtn];
        //判断打开的页面
        if ([@"-1" isEqualToString:list[0].moreId]) {
            [tempBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [tempBtn addTarget:self action:@selector(btnStatusAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        i++;
    }
}

#pragma mark - 控制显示方法
/**
 *  控制展开View按钮的选中状态
 *
 *  @param sender 索引
 */
- (void)btnStatusAction:(UIButton *)sender {
    if (sender == _currButton) {
        _currButton.selected = _currButton.selected ? NO : YES;
        [_viewListIndex[_currButton.tag] setHidden:!_currButton.isSelected];
        [_currBottomLine setHidden:!_currButton.isSelected];
        if (_currButton.isSelected) {
            [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        } else {
            [self setFrame:CGRectMake(0, 0, ScreenWidth, _initHeight)];
        }
    } else {
        [_currButton setSelected:NO];
        [_viewListIndex[_currButton.tag] setHidden:!_currButton.isSelected];

        _currButton = sender;

        [_currButton setSelected:YES];
        [_viewListIndex[_currButton.tag] setHidden:!_currButton.isSelected];
        [_currBottomLine setHidden:!_currButton.isSelected];
        [_currBottomLine setFrame:CGRectMake(_currButton.frame.origin.x + 1, _currButton.frame.origin.y + _currButton.bounds.size.height, _currButton.bounds.size.width - 1, 1)];

        [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
}

/**
 *  隐藏所有展开View
 */
- (void)closeAllView {
    for (UIView *tagView in _viewListIndex) {
        [tagView setHidden:YES];
    }
    if (_currButton) {
        [_currButton setSelected:NO];
    }
    [_currBottomLine setHidden:YES];
    [self setFrame:CGRectMake(0, 0, ScreenWidth, _initHeight)];
}

/**
 *  显示筛选View
 *
 *  @param sender 索引
 */
- (void)showMoreView:(UIButton *)sender {
    [self closeAllView];
    if (!self.fsbMoreView) {
        //                _fsbMoreView = [[FSBMySecondHouseMoreView alloc] init];
        _fsbMoreView = [[FSBMySecondHouseMoreLayout alloc] initWithSourceData:_sourceData];
        _fsbMoreView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:_fsbMoreView];
    }
    [_fsbMoreView showView];
}
/**
 *  显示展开View
 *
 *  @param sender 索引
 */
- (void)showSpreadView:(UIButton *)sender {
    //计算高度
    int tempH = [_contentList[sender.tag] count];
    tempH *= _contentHeight; //每个项目高度;
    FSBMySecondHouseToolbarContentView *tempView = [[FSBMySecondHouseToolbarContentView alloc] initWithFrame:CGRectMake(0, _initHeight + 1, self.bounds.size.width, tempH) contentHeight:_contentHeight DataSour:_contentList[sender.tag]];
    tempView.delegate = self;
    tempView.hidden = YES;
    [self addSubview:tempView];
    [_viewListIndex addObject:tempView];
}

#pragma mark - 内容按钮回调
- (void)clickCallBack:(int)index {
    NSLog(@"callBak:%@", _contentList[_currButton.tag][index].moreId);
    [_currButton setTitle:_contentList[_currButton.tag][index].moreName forState:UIControlStateNormal];
    [self btnStatusAction:_currButton];
}

#pragma mark - FMNetwork Delegate
- (void)fmNetworkFinished:(FMNetworkRequest *)fmNetworkRequest {
    if ([fmNetworkRequest.requestName isEqualToString:kReq_Probe_GetMySecondHouseParams]) {
        NSLog(@"Date:%@", fmNetworkRequest.responseData);
        _sourceData = [NSMutableDictionary dictionaryWithDictionary:fmNetworkRequest.responseData];
        [self initContentData];
    }
}

- (void)fmNetworkFailed:(FMNetworkRequest *)fmNetworkRequest {
    if ([fmNetworkRequest.requestName isEqualToString:kReq_Probe_GetMySecondHouseParams]) {
        [[BaseAlert sharedInstance] dismiss];
        [[BaseAlert sharedInstance] showMessage:fmNetworkRequest.responseData];
    }
}

@end
