//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBMySecondHouseMoreLayout.h"

static CGFloat const moreViewOffsetX = 42.0f;
#define SHOW_FRAME CGRectMake(moreViewOffsetX, 0, ScreenWidth - moreViewOffsetX, ScreenHeight)
#define CONTENT_HEIGHT 35 //未展开内容高度
#define colorBlue [UIColor colorWithHex:0x2093FA alpha:1.0]
#define colorGray [UIColor colorWithHex:0xE2E2E2 alpha:1.0]
#define colorGray_1 [UIColor colorWithHex:0xA2A2A2 alpha:1.0]

@interface FSBMySecondHouseMoreLayout () {
    IBOutlet UIView *_moreView;
    IBOutlet UIScrollView *_moreTable;
}

@property (nonatomic, assign) BOOL showMoreView;
@property (nonatomic, retain) MyLinearLayout *myContentView;
@property (nonatomic, retain) NSMutableArray<MyBaseLayout *> *dataList;

@property (nonatomic, retain) NSMutableArray<NSString *> *nameIndex;
@property (nonatomic, retain) NSMutableArray<NSString *> *dataIndex;

@property (nonatomic, retain) MyBaseLayout *view2;

@end

@implementation FSBMySecondHouseMoreLayout

- (FSBMySecondHouseMoreLayout *)init {
    if (self = [super init]) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FSBMySecondHouseMoreLayout" owner:self options:nil];
        for (id obj in nibs) {
            if ([obj isKindOfClass:[FSBMySecondHouseMoreLayout class]]) {
                self = obj;
                break;
            }
        }
        self.backgroundColor = [UIColor clearColor];
        [self initBackgroudView];
        [self initDataView];
        return self;
    }
    return nil;
}
- (void)tapMoreBackView:(UITapGestureRecognizer *)gesture {
    [self hiddenMoreView];
}
- (void)initBackgroudView {
    _showMoreView = NO;
    UIView *moreBackView = [[UIView alloc] init];
    moreBackView.frame = self.bounds;
    moreBackView.backgroundColor = [UIColor blackColor];
    moreBackView.alpha = 0.5f;
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoreBackView:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [moreBackView addGestureRecognizer:singleRecognizer];
    [self addSubview:moreBackView];
}

#pragma mark - 初始化界面/项目/显示数据
//初始化页面数据
- (void)initContentData {
    //    _nameIndex=[NSMutableArray arrayWithCapacity:17];

    _dataList = [NSMutableArray arrayWithCapacity:17];
    
    //    [_dataList addObject:[self createNewButton:@"楼盘名称" bottomLine:2]];
    //    [_dataList addObject:[self createTextfileButton:@"房号" bottomLine:6]];
    //    [_dataList addObject:[self createMultiDataButton:[NSArray arrayWithObjects:@"出租", @"出售", @"租售价", nil] LineCount:3 bottomLine:6]];
    //    [_dataList addObject:[self createMultiDataButton:[NSArray arrayWithObjects:@"有效", @"无效", @"暂缓", @"预定", @"已租", @"已售", nil] LineCount:3 bottomLine:6]];
    //    [_dataList addObject:[self createNewButton:@"用途" bottomLine:2]];
    //    [_dataList addObject:[self createMultiDataButton:[NSArray arrayWithObjects:@"公寓", @"住宅", @"商铺", @"写字楼", @"商住", @"车位", @"别墅", @"其他", @"厂房", @"车库", nil] LineCount:3 bottomLine:2]];
    //    [_dataList addObject:[self createNewButton:@"户型" bottomLine:6]];
    [_dataList addObject:[self createNewButton:@"部门" bottomLine:2]];
    [_dataList addObject:[self createNewButton:@"员工" bottomLine:2]];
    [_dataList addObject:[self createNewButton:@"片区" bottomLine:6]];
    [_dataList addObject:[self createNewButton:@"租价" bottomLine:2]];
    //    [_dataList addObject:[self createNewButton:@"售价" bottomLine:2]];
    //    [_dataList addObject:[self createRangeButton:@"面积" FirstDefault:@"请输入面积" SecondDefault:@"请输入面积" bottomLine:2 Symbol:@"m²"]];
    //    [_dataList addObject:[self createMultiDataButton:[NSArray arrayWithObjects:@"60m²以下", @"60-80m²", @"80-100m²", @"100-120m²", @"120-150m²", @"150-200m²", @"200-250m²", @"250m²以上", nil] LineCount:3 bottomLine:2]];
    //    [_dataList addObject:[self createRangeButton:@"时间" FirstDefault:@"请输入开始时间" SecondDefault:@"请输入结束时间" bottomLine:2 Symbol:@""]];
    //    [_dataList addObject:[self createNewButton:@"上下架" bottomLine:2]];
    //    [_dataList addObject:[self createSingleButton:@"重置" bottomLine:2]];

        [_myContentView  addSubview:[self createNewButton:@"楼盘名称" bottomLine:2]];
        [_myContentView addSubview:[self createTextfileButton:@"房号" bottomLine:6]];
    
    MyBaseLayout *view1 = [self createNewButton:@"用途" bottomLine:0];
    _view2 = [self createMultiDataButton:[NSArray arrayWithObjects:@"公寓", @"住宅", @"商铺", @"写字楼", @"商住", @"车位", @"别墅", @"其他", @"厂房", @"车库", nil] LineCount:3 bottomLine:0];
    
    MyLinearLayout *tempView = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    tempView.padding = UIEdgeInsetsMake(0, 0, 5, 0);
    tempView.bottomBorderLine = [self createLine:colorLine LineBorad:6];
    tempView.gravity = MyMarginGravity_Horz_Fill; //让子视图全部水平填充
    
    [tempView addSubview:view1];
    [tempView addSubview:_view2];
    [_myContentView addSubview:tempView];
}
//初始化页面显示内容
- (void)initDataView {
    [_moreView setFrame:SHOW_FRAME];
    [self addSubview:_moreView];

    _moreTable.marginGravity = MyMarginGravity_Fill;
    _moreTable.alwaysBounceVertical = YES;

    _myContentView = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    _myContentView.myLeftMargin = 0;
    _myContentView.myRightMargin = 0; //同时指定左右边距为0表示宽度和父视图一样宽
    _myContentView.gravity = MyMarginGravity_Horz_Fill; //让子视图全部水平填充
    [_myContentView setTarget:self action:@selector(handleHideKeyboard:)];
    [_moreTable addSubview:_myContentView];

    //初始化页面数据
    [self initContentData];
    //初始化页面显示内容
    for (MyBaseLayout *view in _dataList) {
        [_myContentView addSubview:view];
    }
}

/**
 *  创建打开新窗口/显示/隐藏选项项目
 *
 *  @param title 标题
 *  @param line  下边框宽度
 *
 *  @return MyRelativeLayout
 */
- (MyRelativeLayout *)createNewButton:(NSString *)title bottomLine:(int)line {
    MyRelativeLayout *elLayout = [MyRelativeLayout new];
    //设置布局内的子视图离自己的边距.
    elLayout.padding = UIEdgeInsetsMake(5, 10, 5, 0);
    //设置下边线
    elLayout.bottomBorderLine = [self createLine:colorLine LineBorad:line];
    //左右边距，不包裹子视图，整体高度。
    elLayout.backgroundColor = [UIColor whiteColor];
    elLayout.myLeftMargin = 0;
    elLayout.myRightMargin = 0;
    elLayout.heightDime.equalTo(@(CONTENT_HEIGHT+line));
    //标题
    UILabel *titlelab = [UILabel new];
    titlelab.myTopMargin = 0;
    titlelab.myBottomMargin = 0;
    titlelab.leftPos.equalTo(@0);
    titlelab.text = title;
    titlelab.font = [UIFont systemFontOfSize:14];
    [titlelab sizeToFit];
    [elLayout addSubview:titlelab];
    //内容
    UILabel *conlab = [UILabel new];
    conlab.myTopMargin = 0;
    conlab.myBottomMargin = 0;
    conlab.leftPos.equalTo(titlelab.rightPos).offset(5);
    conlab.rightPos.equalTo(@45);
    conlab.text = @"";
    //    conlab.text = @"很长的测试数据很长的测试数据很长的测试数据很长的测试数据很长的测试数据";
    //    conlab.text = @"测试数据";
    [conlab setTextAlignment:NSTextAlignmentRight];
    conlab.font = [UIFont systemFontOfSize:14];
    [conlab sizeToFit];
    [elLayout addSubview:conlab];
    //按钮位置
    UIButton *button = [UIButton new];
    button.myTopMargin = 0;
    button.myBottomMargin = 0;
    button.leftPos.equalTo(conlab.rightPos);
    button.rightPos.equalTo(@0);
    //设置按钮显示内容
    [button setTitle:@">" forState:UIControlStateNormal];
    [button setTitleColor:colorGray forState:UIControlStateNormal];
    [button setTitleColor:colorTint forState:UIControlStateHighlighted];
    [button setTitleColor:colorTint forState:UIControlStateSelected];
    [button setTitleColor:colorGray forState:UIControlStateHighlighted | UIControlStateSelected];
    [button addTarget:self action:@selector(showNextItem:) forControlEvents:UIControlEventTouchUpInside];
    [elLayout addSubview:button];

    return elLayout;
}
/**
 *  创建文本框项目
 *
 *  @param title 标题
 *  @param line  下边框宽度
 *
 *  @return MyRelativeLayout
 */
- (MyRelativeLayout *)createTextfileButton:(NSString *)title bottomLine:(int)line {
    MyRelativeLayout *rlLayout = [MyRelativeLayout new];
    //设置布局内的子视图离自己的边距.
    rlLayout.padding = UIEdgeInsetsMake(0, 10, 5, 10);
    //设置下边线
    rlLayout.bottomBorderLine = [self createLine:colorLine LineBorad:line];
    //左右边距，不包裹子视图，整体高度
    rlLayout.backgroundColor = [UIColor whiteColor];
    rlLayout.myLeftMargin = 0;
    rlLayout.myRightMargin = 0;
    rlLayout.heightDime.equalTo(@CONTENT_HEIGHT);
    //标题
    UILabel *titlelab = [UILabel new];
    titlelab.myTopMargin = 0;
    titlelab.myBottomMargin = 0;
    titlelab.leftPos.equalTo(@0);
    titlelab.text = title;
    titlelab.font = [UIFont systemFontOfSize:14];
    [titlelab sizeToFit];
    [rlLayout addSubview:titlelab];
    //文本框
    UITextField *textView = [UITextField new];
    textView.myTopMargin = 0;
    textView.myBottomMargin = 0;
    textView.leftPos.equalTo(titlelab.rightPos).offset(10);
    textView.rightPos.equalTo(@0);
    [rlLayout addSubview:textView];
    return rlLayout;
}

/**
 *  创建多数据项目
 *
 *  @param lineCount 每行数据的数量
 *  @param line 下边框宽度
 *
 *  @return MyFlowLayout
 */
- (MyFlowLayout *)createMultiDataButton:(NSArray *)data LineCount:(int)lineCount bottomLine:(int)line {
    MyFlowLayout *mflayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:lineCount];
    mflayout.bottomBorderLine = [self createLine:colorLine LineBorad:line];
    mflayout.backgroundColor = [UIColor whiteColor];
    mflayout.averageArrange = YES;
    mflayout.padding = UIEdgeInsetsMake(-5, 10, 10, 10);
    mflayout.subviewHorzMargin = 25;
    mflayout.subviewVertMargin = 5;
    mflayout.wrapContentHeight = YES;
    int i = 0;
    for (NSString *str in data) {
        //        UIButton *button = [UIButton new];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.myTopMargin = 5;
        button.myBottomMargin = 5;
        //设置按钮显示内容
        //Image
        [button setBackgroundColor:[UIColor whiteColor]];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        button.imageView.contentMode = UIViewContentModeCenter;
        //显示标题
        [button setTitle:str forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitleColor:colorGray_1 forState:UIControlStateNormal];
        //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(showNewView) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        //边框/圆角
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        [button.layer setBorderUIColor:colorGray];

        [button sizeToFit];
        [mflayout addSubview:button];
        i++;
    }
    return mflayout;
}

/**
 *  创建范围选择项目
 *
 *  @param title 标题
 *  @param line  下边框宽度
 *
 *  @return MyRelativeLayout
 */
- (MyLinearLayout *)createRangeButton:(NSString *)title FirstDefault:(NSString *)firstDefault SecondDefault:(NSString *)secondDefault bottomLine:(int)line Symbol:(NSString *)symbol {
    MyLinearLayout *rlLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    //设置布局内的子视图离自己的边距.
    rlLayout.padding = UIEdgeInsetsMake(0, 10, 5, 5);
    //子视图在垂直方向填满
    rlLayout.gravity = MyMarginGravity_Vert_Fill;
    //设置下边线
    rlLayout.bottomBorderLine = [self createLine:colorLine LineBorad:line];
    //左右边距，不包裹子视图，整体高度为
    rlLayout.backgroundColor = [UIColor whiteColor];
    rlLayout.myLeftMargin = 0;
    rlLayout.myRightMargin = 0;
    rlLayout.heightDime.equalTo(@CONTENT_HEIGHT);
    //标题
    UILabel *titlelab = [UILabel new];
    titlelab.leftPos.equalTo(@0);
    titlelab.text = title;
    titlelab.font = [UIFont systemFontOfSize:14];
    [titlelab sizeToFit];
    [rlLayout addSubview:titlelab];
    //范围1文本框
    UITextField *textView = [UITextField new];
    textView.leftPos.equalTo(titlelab.rightPos).offset(5);
    textView.placeholder = firstDefault;
    textView.textAlignment = NSTextAlignmentCenter;
    [textView setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    textView.weight = 0.1;
    [textView setFont:[UIFont systemFontOfSize:12]];
    [rlLayout addSubview:textView];
    //分隔符号"-"
    titlelab = [UILabel new];
    titlelab.leftPos.equalTo(textView.rightPos);
    titlelab.text = @"-";
    titlelab.font = [UIFont systemFontOfSize:14];
    [titlelab sizeToFit];
    [rlLayout addSubview:titlelab];
    //范围2文本框
    textView = [UITextField new];
    textView.leftPos.equalTo(titlelab.rightPos);
    textView.placeholder = secondDefault;
    textView.textAlignment = NSTextAlignmentCenter;
    [textView setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    textView.weight = 0.1;
    [textView setFont:[UIFont systemFontOfSize:12]];
    [rlLayout addSubview:textView];
    //单位符号
    titlelab = [UILabel new];
    titlelab.leftPos.equalTo(textView.rightPos);
    titlelab.text = symbol;
    titlelab.font = [UIFont systemFontOfSize:14];
    [titlelab sizeToFit];
    [rlLayout addSubview:titlelab];

    //操作按钮
    UIButton *button = [UIButton new];
    button.leftPos.equalTo(titlelab.rightPos);
    //设置按钮显示内容
    [button setTitle:@">" forState:UIControlStateNormal];
    [button setTitleColor:colorGray forState:UIControlStateNormal];
    [button setTitleColor:colorTint forState:UIControlStateHighlighted];
    [button setTitleColor:colorTint forState:UIControlStateSelected];
    [button setTitleColor:colorGray forState:UIControlStateHighlighted | UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:self action:@selector(showNewView) forControlEvents:UIControlEventTouchUpInside];
    [rlLayout addSubview:button];

    return rlLayout;
}
/**
 *  创建单个居中按钮项目
 *
 *  @param title 标题
 *  @param line  下边框宽度
 *
 *  @return MyRelativeLayout
 */
- (MyRelativeLayout *)createSingleButton:(NSString *)title bottomLine:(int)line {
    MyRelativeLayout *elLayout = [MyRelativeLayout new];
    //设置布局内的子视图离自己的边距.
    elLayout.padding = UIEdgeInsetsMake(20, 50, 20, 50);
    //设置下边线
    elLayout.bottomBorderLine = [self createLine:colorLine LineBorad:line];
    //左右边距都是10，不包裹子视图，整体高度为50。
    elLayout.backgroundColor = [UIColor whiteColor];
    elLayout.myLeftMargin = 0;
    elLayout.myRightMargin = 0;
    elLayout.heightDime.equalTo(@70);
    //按钮位置
    UIButton *button = [UIButton new];
    button.myTopMargin = 0;
    button.myBottomMargin = 0;
    button.myLeftMargin = 0;
    button.myRightMargin = 0;
    //设置按钮显示内容
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 1;
    [button.layer setBorderUIColor:[UIColor colorWithHex:0x2093FA alpha:1.0]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0x2093FA alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:colorTint forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(showNewView) forControlEvents:UIControlEventTouchUpInside];
    [elLayout addSubview:button];

    return elLayout;
}

/**
 *  根据UIColor生成UIImage,主要用作Button Image
 *
 *  @param color 颜色UIColor
 *
 *  @return UIImage
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  生成项目边框线
 *
 *  @param color      颜色UIColor
 *  @param boardWidth 宽度
 *
 *  @return 项目边框线
 */
- (MyBorderLineDraw *)createLine:(UIColor *)color LineBorad:(int)boardWidth {
    MyBorderLineDraw *line = [[MyBorderLineDraw alloc] initWithColor:color];
    line.thick = boardWidth;
    return line;
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

#pragma mark-- Handle Method
- (void)handleHideKeyboard:(id)sender {
    [self endEditing:YES];
}

- (void)handleLabelHidden:(UIButton *)sender {
    _myContentView.beginLayoutBlock = ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    };
    _myContentView.endLayoutBlock = ^{
        [UIView commitAnimations];
    };
}

- (void)handleLabelShow {
    _myContentView.beginLayoutBlock = ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    };
    _myContentView.endLayoutBlock = ^{
        [UIView commitAnimations];
    };
}

- (void)showNewView:(UIButton *)sender {
    NSLog(@"OnClick-OnClick:%d", sender.tag);
}

- (void)showNextItem:(UIButton *)sender {
    _view2.hidden=_view2.isHidden?NO:YES;
    NSLog(@"OnClick-OnClick-OnClick:%d", sender.tag);
}

@end
