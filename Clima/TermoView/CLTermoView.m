//
//  CLTermoView.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLTermoView.h"
#import "CLAnimatedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Picker.h"

#define DEGR 50;

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CLTermoView () 

@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) UIImage *termoSpectrum;
@property (nonatomic, strong) CLAnimatedLabel *tempLabel;



@end

@implementation CLTermoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    
    if ([_circle superlayer]) 
        [_circle removeFromSuperlayer];
    
    _termoSpectrum = [UIImage imageNamed:@"color_spectrum.png"];
    
    int radius = self.frame.size.width / 2;
    _circle = [CAShapeLayer layer];
    // Make a circular shape
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                         radius:radius - 10
                                                     startAngle:DEGREES_TO_RADIANS(-90)
                                                       endAngle:DEGREES_TO_RADIANS(270)
                                                      clockwise:NO];
    
    _circle.path = [aPath CGPath];
    
    // Configure the apperence of the circle
    _circle.fillColor = [UIColor clearColor].CGColor;
    _circle.strokeColor = [UIColor blueColor].CGColor;
    _circle.lineWidth = 20;
    _circle.strokeEnd = 0.0;
    // Add to parent layer
    [self.layer addSublayer:_circle];
    
    _tempLabel = [[CLAnimatedLabel alloc] initWithFrame:self.bounds];
    _tempLabel.backgroundColor = [UIColor clearColor];
    _tempLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:_tempLabel];
    

    _temperature = -40;
    _tempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:45];
}



- (UIColor *)colorByValue:(CGFloat)value {
    CGPoint valuePosition = CGPointMake(_termoSpectrum.size.width * value, 1);
    return [_termoSpectrum colorAtPosition:valuePosition];
}

- (CAKeyframeAnimation *)colorAnimationFromValue:(CGFloat)fromValue
                                         toValue:(CGFloat)toValue
                                         keyPath:(NSString *)keyPath
{
    
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *keyTimes = [NSMutableArray array];
    int from = fromValue * DEGR;
    int to = toValue * DEGR;
    
    if (from < to) {
        for (int i = from; i <= to; i ++) {
            CGFloat value = ((float)i)/DEGR;
            CGFloat position = i / (float)abs(to - from);
#warning Check this please!
            [values addObject:(id)[self colorByValue:value].CGColor];
            [keyTimes addObject:@(position)];
        }
    } else {
        for (int i = from; i >= to; i--) {
            CGFloat value = ((float)i)/DEGR;
            CGFloat position = i / (float)abs(from - to);
            
            [values addObject:(id)[self colorByValue:value].CGColor];
            [keyTimes addObject:@(position)];
        }
    }
    CAKeyframeAnimation *colorAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    colorAnimation.values               = values;
    colorAnimation.duration             = 3.0;  // "animate over 3 seconds or so.."
    colorAnimation.repeatCount          = 1.0;  // Animate only once..
    colorAnimation.removedOnCompletion  = NO;   // Remain stroked after the animation..
    colorAnimation.fillMode             = kCAFillModeForwards;
    colorAnimation.timingFunction       = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return colorAnimation;
}

- (void)addAnimationToValue:(CGFloat)value {
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 3.0;  // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    drawAnimation.fillMode            = kCAFillModeForwards;
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue           = @(_circle.strokeEnd);
    drawAnimation.toValue             = @(value);
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction      = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    drawAnimation.delegate = self;

    CAKeyframeAnimation *colorAnimation = [self colorAnimationFromValue:_circle.strokeEnd toValue:value keyPath:@"strokeColor"];
    CAKeyframeAnimation *textColorAnimation = [self colorAnimationFromValue:_circle.strokeEnd toValue:value keyPath:@"foregroundColor"];
    
    // Add the animation to the circle
    [_circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    [_circle addAnimation:colorAnimation forKey:@"flashStrokeColor"];
    [_tempLabel.textLayer addAnimation:textColorAnimation forKey:@"flashTextColor"];
}

- (void)setTemperature:(CGFloat)temperature {
    NSLog(@"%s", __FUNCTION__);
    if ((int)temperature != (int)_temperature) {
        [_tempLabel animateFrom:@(_temperature) toNumber:@(temperature)];
        _temperature = temperature;
        
        [self addAnimationToValue:fabsf(-40 - _temperature) / 80.0f];
    }
    

    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        _circle.strokeEnd = [[(CABasicAnimation *)anim toValue] floatValue];
    }
}

@end
