//
//  CLTermoView.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLAnimatedLabel.h"

@interface CLTermoView : UIView

@property (nonatomic, assign) CGFloat temperature;
@property (nonatomic, strong) CLAnimatedLabel *tempLabel;

@end
