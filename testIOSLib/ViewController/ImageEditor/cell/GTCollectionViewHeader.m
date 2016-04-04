//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTCollectionViewHeader.h"

@interface GTCollectionViewHeader ()

@property (retain, nonatomic) IBOutlet UILabel* cTitle;

@end

@implementation GTCollectionViewHeader

- (void)awakeFromNib {
}

- (void)setTitle:(NSString*)name {
    [_cTitle setText:name];
}

@end
