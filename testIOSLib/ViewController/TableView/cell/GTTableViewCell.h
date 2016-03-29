//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* cName;
@property (weak, nonatomic) IBOutlet UILabel* cContact;
@property (weak, nonatomic) IBOutlet UILabel* cPhone;
@property (weak, nonatomic) IBOutlet UILabel* cid;
@property (weak, nonatomic) IBOutlet UILabel* cNameLetter;

- (void)reloadData:(Customer *)dataModel;

@end