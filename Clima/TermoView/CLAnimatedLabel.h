//
//  CLAnimatedLabel.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/4/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAnimatableLabel.h"

@interface CLAnimatedLabel : AUIAnimatableLabel

- (void)animateFrom:(NSNumber *)aFrom toNumber:(NSNumber *)aTo;

@end
