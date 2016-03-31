//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTTableViewCell.h"

@interface GTTableViewCell ()

@property (retain, nonatomic) IBOutlet UILabel* cName;
@property (retain, nonatomic) IBOutlet UILabel* cContact;
@property (retain, nonatomic) IBOutlet UILabel* cPhone;
@property (retain, nonatomic) IBOutlet UILabel* cid;
@property (retain, nonatomic) IBOutlet UILabel* cNameLetter;
@property (nonatomic, strong) Customer* dataModel;

@end

@implementation GTTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setData:(Customer*)dataModel {
    _dataModel = dataModel;

    [_cName setText:_dataModel.customer_name];
    [_cPhone setText:_dataModel.customer_phone];
    [_cid setText:_dataModel.customer_id];
    [_cContact setText:_dataModel.contact_id];
    [_cNameLetter setText:_dataModel.customer_name_letter];

    NSLog(@"===%@,%@,%@,%@,%@===", _dataModel.customer_id, _dataModel.contact_id, _dataModel.customer_name, _dataModel.customer_phone, _dataModel.customer_name_letter);
    NSLog(@"===--%@,%@,%@,%@,%@--===", _cName.text, _cPhone.text, _cid.text, _cContact.text, _cNameLetter.text);
}

@end
