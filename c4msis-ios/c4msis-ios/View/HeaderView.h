//
//  HeaderView.h
//  c4msis-ios
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadorView;

@interface HeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton* button;

@property (nonatomic, strong) RadorView* radorView;

@property (nonatomic, strong) UILabel* contentLabel;

@end
