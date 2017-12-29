//
//  ConfigurationTableViewCell.h
//  c4msis-ios
//
//  Created by Skifary on 25/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkedImageView;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property (weak, nonatomic) IBOutlet UILabel *configurationNameLabel;

@end
