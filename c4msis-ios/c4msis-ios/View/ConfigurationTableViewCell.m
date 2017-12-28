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
    // Initialization code
    self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)detailAction:(id)sender {
}
@end
