//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTTableViewCell.h"

@implementation GTTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reloadData:(Customer *)dataModel {
    _cName.text = dataModel.customer_name;
    _cPhone.text = dataModel.customer_phone;
    _cid.text = dataModel.customer_id;
    _cContact.text = dataModel.contact_id;
    _cNameLetter.text = dataModel.customer_name_letter;
}

@end
