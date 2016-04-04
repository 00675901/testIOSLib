//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTCollectionViewCell.h"

@interface GTCollectionViewCell ()

@property (retain, nonatomic) IBOutlet UIImageView* cImage;
@property (retain, nonatomic) IBOutlet UILabel* cContent;
@property (retain, nonatomic) IBOutlet UILabel* cTitle;
@property (retain, nonatomic) IBOutlet UIButton* deleteButton;

@property (retain, nonatomic) NSIndexPath* cellIndexPath;

@end

@implementation GTCollectionViewCell

- (void)awakeFromNib {
    [_cImage setHidden:YES];
    [_cContent setHidden:YES];
    [_deleteButton setHidden:YES];
}

- (void)setData:(UIImage*)dataImage Label:(NSString*)name IndexPath:(NSIndexPath*)indexPath {
    [_cImage setHidden:NO];
    [_cContent setHidden:YES];
    [_deleteButton setHidden:NO];
    [_cTitle setText:name];
    _cellIndexPath = indexPath;
}

- (void)setDataLabel:(NSString*)name {
    [_cImage setHidden:YES];
    [_cContent setHidden:NO];
    [_deleteButton setHidden:YES];
    [_cTitle setText:name];
}

- (IBAction)deleteItms:(UIButton*)sender {
    [_delegate deleteData:_cellIndexPath];
}
@end
