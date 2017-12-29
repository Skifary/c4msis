//
//  ConfigurationTableViewCell.m
//  c4msis-ios
//
//  Created by Skifary on 25/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ConfigurationTableViewCell.h"

@implementation ConfigurationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
