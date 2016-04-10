//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import "FSBMySecondHouseMoreLayout.h"

static CGFloat const moreViewOffsetX = 42.0f;
#define SHOW_FRAME CGRectMake(moreViewOffsetX, 0, ScreenWidth - moreViewOffsetX, ScreenHeight)
#define CONTENT_HEIGHT 40 //未展开内容高度
#define colorBlue [UIColor colorWithHex:0x2093FA alpha:1.0]
#define colorGray [UIColor colorWithHex:0xE2E2E2 alpha:1.0]
#define colorGray_1 [UIColor colorWithHex:0xA2A2A2 alpha:1.0]
#define DATANIL @"dataNil"

/**
 数据索引model
 - returns: FSBSHParamsModel
 */
@implementation FSBSHParamsModel
- (FSBSHParamsModel *)initWithName:(NSString *)name FieldName:(NSString *)fieldName LineWidth:(int)lineWidth ActionType:(actionType)actionType {
    if (self = [super init]) {
        _name = name;
        _fieldName = fieldName;
        _lineWidth = lineWidth;
        _actionType = actionType;
        _params = [NSMutableArray array];
    }
    return self;
}
@end

@interface FSBMySecondHouseMoreLayout () <UIScrollViewDelegate> {
    IBOutlet UIView *_moreView;
    IBOutlet UIScrollView *_moreTable;
    IBOutlet UIActivityIndicatorView *_loadView;
}
@property (nonatomic, retain) NSMutableDictionary *sourceData; //源数据

@property (nonatomic, assign) BOOL showMoreView;
@property (nonatomic, strong) MyLinearLayout *myContentView;

@property (nonatomic, strong) NSMutableArray<FSBSHParamsModel *> *dataIndex; //源数据与项目的索引
@property (nonatomic, strong) NSMutableArray<MyBaseLayout *> *dataViewIndex; //源数据与项目的索引
@property (nonatomic, strong) NSMutableDictionary *dataOption; //处理所有要操作(显示/隐藏/赋值)的元素
@property (nonatomic, strong) NSMutableDictionary *dataSelected; //处理所有需要改变选中状态的元素

@end

@implementation FSBMySecondHouseMoreLayout

- (FSBMySecondHouseMoreLayout *)initWithSourceData:(NSMutableDictionary *)sourceData {
    if (self = [super init]) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FSBMySecondHouseMoreLayout" owner:self options:nil];
        for (id obj in nibs) {
            if ([obj isKindOfClass:[FSBMySecondHouseMoreLayout class]]) {
                self = obj;
                break;
            }
        }
        self.backgroundColor = [UIColor clearColor];
        _sourceData = sourceData;
        [self initBackgroudView];
        //初始化页面显示内容
        [self initDataView];
    }
    return self;
}
- (void)tapMoreBackView:(UITapGestureRecognizer *)gesture {
    [self hiddenView];
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

- (void)showView {
    if (!self.showMoreView) {
        _showMoreView = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = FMURectSetX(self.frame, 0);
        }];
    }
}
- (void)hiddenView {
    if (self.showMoreView) {
        _showMoreView = NO;
        [self handleHideKeyboard:nil];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = FMURectSetX(self.frame, ScreenWidth);
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self handleHideKeyboard:nil];
}

//初始化页面显示内容
- (void)initDataView {
    [_moreView setFrame:SHOW_FRAME];
    [self addSubview:_moreView];
    [self setUserInteractionEnabled:NO];

    _moreTable.marginGravity = MyMarginGravity_Fill;
    _moreTable.alwaysBounceVertical = YES;
    _moreTable.delegate = self;

    //    [[BaseAlert sharedInstance] showLodingWithMessage:@"正在加载..."];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //初始化数据索引
        [self initDataIndex];
    }];
    [operation setCompletionBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //内容容器
            _myContentView = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
            _myContentView.myLeftMargin = 0;
            _myContentView.myRightMargin = 0; //同时指定左右边距为0表示宽度和父视图一样宽
            _myContentView.gravity = MyMarginGravity_Horz_Fill; //让子视图全部水平填充
            [_myContentView setTarget:self action:@selector(handleHideKeyboard:)];
            [_moreTable addSubview:_myContentView];
            //显示内容
            for (MyBaseLayout *items in _dataViewIndex) {
                [_myContentView addSubview:items];
            }
            [_loadView stopAnimating];
            [self setUserInteractionEnabled:YES];
        }];

    }];
    [queue addOperation:operation];
}

#pragma mark - 初始化界面/项目/显示数据
//初始化数据索引
- (void)initDataIndex {
    _dataIndex = [NSMutableArray array];
    FSBSHParamsModel *tempModel = [[FSBSHParamsModel alloc] initWithName:@"楼盘名称" FieldName:DATANIL LineWidth:2 ActionType:actionTypeNew];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"房号" FieldName:DATANIL LineWidth:6 ActionType:actionTypeInput];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:DATANIL FieldName:@"house_sell_data" LineWidth:6 ActionType:actionTypeChoice];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:DATANIL FieldName:@"house_data" LineWidth:2 ActionType:actionTypeChoice];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"用途" FieldName:@"house_use" LineWidth:2 ActionType:actionTypeShow];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"户型" FieldName:@"house_rooms" LineWidth:6 ActionType:actionTypeShow];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"部门" FieldName:DATANIL LineWidth:2 ActionType:actionTypeNew];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"员工" FieldName:DATANIL LineWidth:2 ActionType:actionTypeNew];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"片区" FieldName:DATANIL LineWidth:6 ActionType:actionTypeNew];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"租价" FieldName:@"house_hire" LineWidth:2 ActionType:actionTypeShow];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"售价" FieldName:@"house_sell" LineWidth:2 ActionType:actionTypeShow];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"面积" FieldName:@"house_proportion" LineWidth:2 ActionType:actionTypeShowMultiInput];
    [tempModel.params addObject:@"请输入面积"];
    [tempModel.params addObject:@"请输入面积"];
    [tempModel.params addObject:@"m²"];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"日期" FieldName:@"house_sort" LineWidth:2 ActionType:actionTypeShow];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"时间" FieldName:DATANIL LineWidth:2 ActionType:actionTypeMultiInput];
    [tempModel.params addObject:@"请输入开始时间"];
    [tempModel.params addObject:@"请输入结束时间"];
    [tempModel.params addObject:@""];
    [_dataIndex addObject:tempModel];

    tempModel = [[FSBSHParamsModel alloc] initWithName:@"上下架" FieldName:@"house_grounding_data" LineWidth:2 ActionType:actionTypeShow];
    [_dataIndex addObject:tempModel];

    //初始化页面数据
    [self initContentData];
}

//初始化页面数据
- (void)initContentData {
    _dataViewIndex = [NSMutableArray array];
    _dataOption = [NSMutableDictionary dictionary];
    _dataSelected = [NSMutableDictionary dictionary];
    int i = 0;
    for (FSBSHParamsModel *mod in _dataIndex) {
        MyBaseLayout *tempView;
        switch (mod.actionType) {
            case actionTypeNew:
                //打开新窗口
                tempView = [self createTCBItemWithTag:i Title:mod.name bottomLineWidth:mod.lineWidth Action:@selector(showNewView:)];
                break;
            case actionTypeShow:
                //隐藏单选项
                tempView = [self createShowMultiDataItemWithTag:i Title:mod.name Data:[_sourceData objectForKey:mod.fieldName] bottomLineWidth:mod.lineWidth ItemsAction:@selector(itemChoiceFunction:)];
                break;
            case actionTypeInput:
                //单输入框项
                tempView = [self createTIItemWithTag:i Title:mod.name bottomLineWidth:mod.lineWidth];
                break;
            case actionTypeMultiInput:
                //多输入框项
                tempView = [self createRangeItemWithTag:i Title:mod.name bottomLineWidth:mod.lineWidth Action:nil FirstDefault:mod.params[0] SecondDefault:mod.params[1] Symbol:mod.params[2]];
                break;
            case actionTypeShowMultiInput:
                //隐藏多项输入框
                tempView = [self createShowMultiInputDataItemWithTag:i Title:mod.name Data:[_sourceData objectForKey:mod.fieldName] bottomLineWidth:mod.lineWidth ItemsAction:@selector(itemChoiceInputFunction:) FirstDefault:mod.params[0] SecondDefault:mod.params[1] Symbol:mod.params[2]];
                break;
            case actionTypeChoice:
                //单选项
                tempView = [self createMultiDataItemWithTag:i Data:[_sourceData objectForKey:mod.fieldName] LineCount:3 bottomLineWidth:mod.lineWidth Action:@selector(choiceFunction:)];
                tempView.padding = UIEdgeInsetsMake(5, 5, 5, 5);
                break;
        }
        tempView.tag = i;
        [_dataViewIndex addObject:tempView];
        i++;
    }
    [_dataViewIndex addObject:[self createSingleButton:@"重置" bottomLineWidth:2]];
    //设置默认值
    [self resetAll:nil];
}

#pragma mark - 基础组件

/**
 *  获取一个水平方向LinearLayout
 *
 *  @return LinearLayout
 */
- (MyLinearLayout *)getLinearLayoutHorz:(int)bottomLineWidth {
    MyLinearLayout *llLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    llLayout.backgroundColor = [UIColor whiteColor];
    //设置布局内的子视图离自己的边距.
    llLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    //子视图在垂直方向填满
    llLayout.gravity = MyMarginGravity_Vert_Fill;
    //设置下边线
    llLayout.bottomBorderLine = [self getLine:colorLine LineWidth:bottomLineWidth];
    //左右边距，不包裹子视图，整体高度为
    llLayout.wrapContentWidth = NO;
    llLayout.wrapContentHeight = NO;
    llLayout.heightDime.equalTo(@CONTENT_HEIGHT);
    return llLayout;
}
/**
 *  生成项目边框线
 *
 *  @param color      颜色UIColor
 *  @param boardWidth 宽度
 *
 *  @return 项目边框线
 */
- (MyBorderLineDraw *)getLine:(UIColor *)color LineWidth:(int)width {
    MyBorderLineDraw *line = [[MyBorderLineDraw alloc] initWithColor:color];
    line.thick = width;
    return line;
}
/**
 *  获取LinearLayout使用的标签
 *
 *  @param text   内容
 *  @param weight 比重
 *
 *  @return UILabel
 */
- (UILabel *)getLLLabel:(NSString *)text Weight:(int)weight {
    UILabel *titlelab = [UILabel new];
    if (text) {
        titlelab.text = text;
    }
    titlelab.font = [UIFont systemFontOfSize:14];
    titlelab.adjustsFontSizeToFitWidth = YES;
    if (weight > 0) {
        titlelab.weight = weight;
    } else {
        [titlelab sizeToFit];
    }
    return titlelab;
}

/**
 *  获取LinearLayout使用的文本框
 *
 *  @param text   内容
 *  @param weight 比重
 *
 *  @return UITextField
 */
- (UITextField *)getLLTextField:(NSString *)text Weight:(int)weight {
    UITextField *textView = [UITextField new];
    [textView setFont:[UIFont systemFontOfSize:12]];
    if (text) {
        textView.placeholder = text;
    }
    if (weight > 0) {
        textView.weight = weight;
    } else {
        [textView sizeToFit];
    }
    textView.adjustsFontSizeToFitWidth = YES;
    textView.textAlignment = NSTextAlignmentCenter;
    [textView setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    return textView;
}

/**
 *  获取LinearLayout使用的按钮
 *
 *  @param text   显示text
 *  @param sel    点击回调
 *  @param weight 比重
 *
 *  @return UIButton
 */
- (UIButton *)getLLButton:(NSString *)text Action:(SEL)sel Weight:(int)weight {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (weight > 0) {
        button.weight = weight;
    } else {
        [button sizeToFit];
    }
    if (text) {
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:colorGray forState:UIControlStateNormal];
        [button setTitleColor:colorTint forState:UIControlStateHighlighted];
        [button setTitleColor:colorTint forState:UIControlStateSelected];
        [button setTitleColor:colorGray forState:UIControlStateHighlighted | UIControlStateSelected];
    }
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 内容组件
/**
 *  创建标题-内容-按钮项目
 *
 *  组件结构及比重:title(0)-content(6)-button(2)
 *
 *  @param title 标题
 *  @param width 下边框宽度
 *  @param sel   按钮动作
 *
 *  @return MyLinearLayout
 */
- (MyLinearLayout *)createTCBItemWithTag:(int)tag Title:(NSString *)title bottomLineWidth:(int)width Action:(SEL)sel {
    MyLinearLayout *llLayout = [self getLinearLayoutHorz:width];
    [llLayout setBackgroundColor:[UIColor whiteColor]];
    //标题
    UILabel *titlelab = [self getLLLabel:title Weight:0];
    [llLayout addSubview:titlelab];
    //内容
    UILabel *conlab = [self getLLLabel:nil Weight:8];
    [_dataOption setObject:conlab forKey:[NSString stringWithFormat:@"%d-%d", tag, 1]]; //管理要操作的UI
    [conlab setText:@"测试数据测试"];
    [conlab setTextAlignment:NSTextAlignmentRight];
    [llLayout addSubview:conlab];
    //按钮
    UIButton *button = [self getLLButton:@">" Action:sel Weight:2];
    button.tag = tag;
    [llLayout addSubview:button];
    return llLayout;
}
/**
 *  创建标题-输入框项目
 *
 *  组件结构及比重:title(0)-inputField(1)
 *
 *  @param title 标题
 *  @param width  下边框宽度
 *
 *  @return MyLinearLayout
 */
- (MyLinearLayout *)createTIItemWithTag:(int)tag Title:(NSString *)title bottomLineWidth:(int)width {
    MyLinearLayout *llLayout = [self getLinearLayoutHorz:width];
    //标题
    UILabel *titlelab = [self getLLLabel:title Weight:0];
    [llLayout addSubview:titlelab];
    //文本框
    UITextField *textView = [self getLLTextField:@"请输入房号" Weight:1];
    [_dataOption setObject:textView forKey:[NSString stringWithFormat:@"%d-%d", tag, 1]];
    textView.tag = tag;
    [llLayout addSubview:textView];
    return llLayout;
}

/**
 *  创建范围选择项目
 *
 *  组件结构及比重:title(0)-inputField(4)-UILabel(0)-inputField(4)-Button(2)
 *
 *  @param title         标题
 *  @param width         下边框宽度
 *  @param sel           按钮动作
 *  @param firstDefault  起始框默认值
 *  @param secondDefault 结束框默认值
 *  @param symbol        单位
 *
 *  @return MyLinearLayout
 */
- (MyLinearLayout *)createRangeItemWithTag:(int)tag Title:(NSString *)title bottomLineWidth:(int)width Action:(SEL)sel FirstDefault:(NSString *)firstDefault SecondDefault:(NSString *)secondDefault Symbol:(NSString *)symbol {
    MyLinearLayout *llLayout = [self getLinearLayoutHorz:width];
    //标题
    UILabel *titlelab = [self getLLLabel:title Weight:0];
    [llLayout addSubview:titlelab];
    //范围1文本框
    UITextField *textView = [self getLLTextField:firstDefault Weight:4];
    [textView setTextColor:colorBlue];
    [_dataOption setObject:textView forKey:[NSString stringWithFormat:@"%d-%d", tag, 1]];
    [llLayout addSubview:textView];
    //分隔符号"-"
    titlelab = [self getLLLabel:@"-" Weight:0];
    [llLayout addSubview:titlelab];
    //范围2文本框
    textView = [self getLLTextField:secondDefault Weight:4];
    [textView setTextColor:colorBlue];
    [_dataOption setObject:textView forKey:[NSString stringWithFormat:@"%d-%d", tag, 2]];
    [llLayout addSubview:textView];
    //单位符号
    titlelab = [self getLLLabel:symbol Weight:0];
    [llLayout addSubview:titlelab];
    //操作按钮
    if (sel) {
        UIButton *button = [self getLLButton:@">" Action:sel Weight:2];
        button.tag = tag;
        [llLayout addSubview:button];
    }
    return llLayout;
}

/**
 *  创建多数据项目
 *
 *  @param data      选项
 *  @param lineCount 每行项目数量
 *  @param width     下边框宽度
 *  @param sel       单选按钮动作
 *
 *  @return MyFlowLayout
 */
- (MyFlowLayout *)createMultiDataItemWithTag:(int)tag Data:(NSArray *)data LineCount:(int)lineCount bottomLineWidth:(int)width Action:(SEL)sel {
    MyFlowLayout *mflayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:lineCount];
    mflayout.bottomBorderLine = [self getLine:colorLine LineWidth:width];
    mflayout.backgroundColor = [UIColor whiteColor];
    mflayout.averageArrange = YES;
    mflayout.subviewHorzMargin = 25;
    mflayout.subviewVertMargin = 5;
    mflayout.wrapContentHeight = YES;
    int i = 0;
    for (NSDictionary *dic in data) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.myTopMargin = 5;
        button.myBottomMargin = 5;
        button.heightDime.equalTo(@30);
        //设置按钮显示内容
        [button setBackgroundColor:[UIColor whiteColor]];
        //显示标题
        //        [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [button setTitleColor:colorGray_1 forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        //边框/圆角
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        [button.layer setBorderUIColor:colorGray];
        [button sizeToFit];
        [mflayout addSubview:button];
        if (i == 0) {
            [_dataOption setObject:button forKey:[NSString stringWithFormat:@"%d-%d", tag, 0]]; //加入到操作项目,用于初始化赋值
        }
        i++;
    }
    return mflayout;
}

#pragma mark - 组合内容组件
/**
 *  隐藏单选按钮组件
 *
 *  组件结构:(标题-内容-按钮项目)+多数据项目
 *
 *  @param title 标题
 *  @param data  选项
 *  @param width 下边框宽度
 *  @param sel   隐藏单选按钮动作
 *
 *  @return MyLinearLayout
 */
- (MyLinearLayout *)createShowMultiDataItemWithTag:(int)tag Title:(NSString *)title Data:(NSArray *)data bottomLineWidth:(int)width ItemsAction:(SEL)sel {
    //(标题-内容-按钮项目)
    MyLinearLayout *view1 = [self createTCBItemWithTag:tag Title:title bottomLineWidth:0 Action:@selector(showNextItem:)];
    //多数据项目
    MyFlowLayout *view2 = [self createMultiDataItemWithTag:tag Data:data LineCount:3 bottomLineWidth:0 Action:sel];
    view2.tag = tag;
    view2.padding = UIEdgeInsetsMake(-5, 10, 5, 10);
    [_dataOption setObject:view2 forKey:[NSString stringWithFormat:@"MyFlowLayout_%d", tag]];
    MyLinearLayout *llLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    llLayout.padding = UIEdgeInsetsMake(0, 0, 5, 0);
    llLayout.bottomBorderLine = [self getLine:colorLine LineWidth:width];
    llLayout.gravity = MyMarginGravity_Horz_Fill; //让子视图全部水平填充
    [llLayout addSubview:view1];
    [llLayout addSubview:view2];
    [view2 setHidden:YES];
    return llLayout;
}

/**
 *  隐藏按钮多输入框组件
 *
 *  组件结构:范围选择项目+多数据项目
 *
 *  @param title 标题
 *  @param data  选项
 *  @param width 下边框宽度
 *  @param sel   隐藏单选按钮动作
 *
 *  @return MyLinearLayout
 */
- (MyLinearLayout *)createShowMultiInputDataItemWithTag:(int)tag Title:(NSString *)title Data:(NSArray *)data bottomLineWidth:(int)width ItemsAction:(SEL)sel FirstDefault:(NSString *)firstDefault SecondDefault:(NSString *)secondDefault Symbol:(NSString *)symbol {
    //范围选择项目
    MyLinearLayout *view1 = [self createRangeItemWithTag:tag Title:title bottomLineWidth:0 Action:@selector(showNextItem:) FirstDefault:firstDefault SecondDefault:secondDefault Symbol:symbol];
    //多数据项目
    MyFlowLayout *view2 = [self createMultiDataItemWithTag:tag Data:data LineCount:3 bottomLineWidth:0 Action:sel];
    view2.padding = UIEdgeInsetsMake(-5, 10, 5, 10);
    view2.tag = tag;
    [_dataOption setObject:view2 forKey:[NSString stringWithFormat:@"MyFlowLayout_%d", tag]];
    MyLinearLayout *llLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    llLayout.padding = UIEdgeInsetsMake(0, 0, 5, 0);
    llLayout.bottomBorderLine = [self getLine:colorLine LineWidth:width];
    llLayout.gravity = MyMarginGravity_Horz_Fill; //让子视图全部水平填充
    [llLayout addSubview:view1];
    [llLayout addSubview:view2];
    [view2 setHidden:YES];
    return llLayout;
}

/**
 *  创建重置按钮
 *
 *  @param title 标题
 *  @param line  下边框宽度
 *
 *  @return MyRelativeLayout
 */
- (MyRelativeLayout *)createSingleButton:(NSString *)title bottomLineWidth:(int)width {
    MyRelativeLayout *elLayout = [MyRelativeLayout new];
    //设置布局内的子视图离自己的边距.
    elLayout.padding = UIEdgeInsetsMake(20, 50, 20, 50);
    //设置下边线
    elLayout.bottomBorderLine = [self getLine:colorLine LineWidth:width];
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
    [button.layer setBorderUIColor:colorBlue];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:colorBlue forState:UIControlStateNormal];
    [button setTitleColor:colorTint forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(resetAll:) forControlEvents:UIControlEventTouchUpInside];
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
//- (UIImage *)createImageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return theImage;
//}

#pragma mark-- Handle Method
//结束编辑
- (void)handleHideKeyboard:(id)sender {
    [self endEditing:YES];
}
/**
 *  重置管理的项目为默认值
 *
 *  @param sender 索引
 */
- (void)resetAll:(UIButton *)sender {
    NSLog(@"重置--重置");
    for (NSString *key in _dataOption) {
        id item = [_dataOption objectForKey:key];
        if ([item isKindOfClass:[UITextField class]]) {
            [(UITextField *)item setText:@""];
        } else if ([item isKindOfClass:[UILabel class]]) {
            NSArray *tempList = [key componentsSeparatedByString:@"-"];
            if ([tempList count] > 0) {
                FSBSHParamsModel *mod = _dataIndex[[tempList[0] intValue]];
                [(UILabel *)item setText:[_sourceData objectForKey:mod.fieldName][0][@"name"]];
            }
        } else if ([item isKindOfClass:[UIButton class]]) {
            [self buttonActionStatus:(UIButton *)item];
        }
        //        else if([item isKindOfClass:[MyFlowLayout class]]){
        //            [(MyFlowLayout*)item setHidden:YES];
        //        }
    }
}

/**
 *  打开新View
 *
 *  @param sender 索引
 */
- (void)showNewView:(UIButton *)sender {
    [self handleHideKeyboard:nil];
    NSLog(@"打开新窗口:%d-----%d", [[sender superview] tag], sender.tag);
}
/**
 *  显示/隐藏多数据项
 *
 *  @param sender 索引
 */
- (void)showNextItem:(UIButton *)sender {
    [self handleHideKeyboard:nil];
    NSLog(@"显示/隐藏项目:%d----%d", [[sender superview] tag], sender.tag);
    MyFlowLayout *tempView = [_dataOption objectForKey:[NSString stringWithFormat:@"MyFlowLayout_%d", sender.tag]];
    [tempView setHidden:tempView.isHidden ? NO : YES];
    _myContentView.beginLayoutBlock = ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    };
    _myContentView.endLayoutBlock = ^{
        [UIView commitAnimations];
    };
}

/**
 *  单选
 *
 *  @param sender 索引
 */
- (void)choiceFunction:(UIButton *)sender {
    NSLog(@"单选按钮:%d--%d", [[sender superview] tag], sender.tag);
    FSBSHParamsModel *mod = _dataIndex[[[sender superview] tag]];
    NSDictionary *dic = [_sourceData objectForKey:mod.fieldName][sender.tag];
    NSLog(@"单选按钮-------name:%@,id:%@", dic[@"name"], dic[@"id"]);
    [self buttonActionStatus:sender];
}
/**
 *  隐藏单选项目onclick
 *
 *  @param sender 索引
 */
- (void)itemChoiceFunction:(UIButton *)sender {
    FSBSHParamsModel *mod = _dataIndex[[[sender superview] tag]];
    NSDictionary *dic = [_sourceData objectForKey:mod.fieldName][sender.tag];
    UILabel *tempLab = [_dataOption objectForKey:[NSString stringWithFormat:@"%d-%d", [[sender superview] tag], 1]];
    [tempLab setText:dic[@"name"]];
    [self buttonActionStatus:sender];
}
/**
 *  隐藏多输入框项目onclick
 *
 *  @param sender 索引
 */
- (void)itemChoiceInputFunction:(UIButton *)sender {
    FSBSHParamsModel *mod = _dataIndex[[[sender superview] tag]];
    NSDictionary *dic = [_sourceData objectForKey:mod.fieldName][sender.tag];
    NSArray *tempList = [dic[@"id"] componentsSeparatedByString:@"-"];
    UITextField *temptv1 = [_dataOption objectForKey:[NSString stringWithFormat:@"%d-%d", [[sender superview] tag], 1]];
    UITextField *temptv2 = [_dataOption objectForKey:[NSString stringWithFormat:@"%d-%d", [[sender superview] tag], 2]];
    if (2 == [tempList count]) {
        [temptv1 setText:tempList[0]];
        [temptv2 setText:tempList[1]];
    } else {
        [temptv1 setText:@""];
        [temptv2 setText:@""];
    }
    [self buttonActionStatus:sender];
}
/**
 *  处理按钮状态
 *
 *  @param sender 索引
 */
- (void)buttonActionStatus:(UIButton *)sender {
    [self handleHideKeyboard:nil];
    NSString *tempKey = [NSString stringWithFormat:@"%d", [[sender superview] tag]];
    UIButton *tempBtn = [_dataSelected objectForKey:tempKey];
    if (tempBtn) {
        [tempBtn setBackgroundColor:[UIColor whiteColor]];
        tempBtn.selected = NO;
    }
    sender.selected = YES;
    [sender setBackgroundColor:colorBlue];
    [_dataSelected setObject:sender forKey:tempKey];
}

@end
