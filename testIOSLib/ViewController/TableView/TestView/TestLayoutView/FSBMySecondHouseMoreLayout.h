//
//  Created by G on 16/3/30.
//  Copyright © 2016年 fangstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, actionType) {
    actionTypeNew,              //打开新窗口
    actionTypeShow,             //隐藏单选项
    actionTypeInput,            //单项输入框
    actionTypeMultiInput,       //多项输入框
    actionTypeShowMultiInput,   //隐藏多项输入框
    actionTypeChoice            //单选项
};

@interface FSBSHParamsModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, assign) int lineWidth;
@property (nonatomic, assign) int actionType;
@property (nonatomic, strong) NSMutableArray *params;

- (FSBSHParamsModel *)initWithName:(NSString *)name FieldName:(NSString *)fieldName LineWidth:(int)lineWidth ActionType:(actionType)actionType;

@end

@interface FSBMySecondHouseMoreLayout : UIView

- (FSBMySecondHouseMoreLayout *)initWithSourceData:(NSMutableDictionary *)sourceData;
- (void)showView;

@end
