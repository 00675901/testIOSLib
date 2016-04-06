//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "FSBMySecondMoreViewCollectionCell.h"

@interface FSBMySecondMoreViewCollectionCell ()

@property (retain, nonatomic) NSIndexPath* cellIndexPath;

@end

@implementation FSBMySecondMoreViewCollectionCell

- (void)awakeFromNib {
    //    [_cImage setHidden:YES];
    //    [_cContent setHidden:YES];
    //    [_deleteButton setHidden:YES];
}

- (void)setIndexPath:(NSIndexPath*)indexPath {
    _cellIndexPath = indexPath;
}

-(IBAction)viewCallBack{
    [_delegate onclickCallBack:_cellIndexPath];
}

@end
