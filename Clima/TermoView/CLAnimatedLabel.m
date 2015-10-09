//
//  CLAnimatedLabel.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/4/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLAnimatedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface CLAnimatedLabel ()

@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *to;
@property (nonatomic, assign) CFTimeInterval startTime;

@end

@implementation CLAnimatedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)animateFrom:(NSNumber *)aFrom toNumber:(NSNumber *)aTo {

    self.from = aFrom; // or from = [aFrom retain] if your not using @properties
    self.to = aTo;     // ditto
    
    self.text = [NSString stringWithFormat:@"%.f°", _from.floatValue];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateNumber:)];
    
    _startTime = CACurrentMediaTime();
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animateNumber:(CADisplayLink *)link {
    static float DURATION = 3.0;
    float dt = ([link timestamp] - _startTime) / DURATION;
    if (dt >= 1.0) {
        self.text = [NSString stringWithFormat:@"%.f°", _to.floatValue];
        [link invalidate];
//        return;
    }
    
    float current = ([_to floatValue] - [_from floatValue]) * dt + [_from floatValue];
    self.text = [NSString stringWithFormat:@"%.f°", current];
}

@end
