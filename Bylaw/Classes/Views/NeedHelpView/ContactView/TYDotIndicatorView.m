//
//  TYDotIndicatorView.m
//  TYDotIndicatorView
//
//  Created by Tu You on 14-1-12.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "TYDotIndicatorView.h"


//static const CGFloat dotSeparatorDistance = 12.0f;

@interface TYDotIndicatorView ()

@property (nonatomic, assign) TYDotIndicatorViewStyle dotStyle;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, retain) NSMutableArray *dots;
@property (nonatomic, assign) BOOL animating;

@end

@implementation TYDotIndicatorView

- (id)initWithFrame:(CGRect)frame
           dotStyle:(TYDotIndicatorViewStyle)style
           dotColor:(UIColor *)dotColor
            dotSize:(CGSize)dotSize
          dotNumber:(NSInteger)dotNu
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _dotStyle = style;
        _dotSize = dotSize;
    
        _dots = [[NSMutableArray alloc] init];
        
//        CGFloat xPos = CGRectGetWidth(frame) / 2 - dotSize.width * 3 / 2 - dotSeparatorDistance;
//        CGFloat yPos = CGRectGetHeight(frame) / 2 - _dotSize.height / 2;
        
        
        CGFloat xPos = CGRectGetWidth(frame) / 2 - _dotSize.width / 2;
        CGFloat yPos = CGRectGetHeight(frame)/(dotSize.height * (dotNumber+1));
        
        dotNumber=dotNu;
        for (int i = 0; i < dotNumber; i++)
        {
            CAShapeLayer *dot = [CAShapeLayer new];
            dot.path = [self createDotPath].CGPath;
            dot.frame = CGRectMake(xPos, yPos, _dotSize.width, _dotSize.height);
            dot.opacity = 0.3 * i;
            dot.fillColor = dotColor.CGColor;
            
            [self.layer addSublayer:dot];
            
            [_dots addObject:dot];
            
            yPos = yPos + (_dotSize.height + _dotSize.height);
        }

    }
    return self;
}

- (UIBezierPath *)createDotPath
{
    CGFloat cornerRadius = 0.0f;
    if (_dotStyle == TYDotIndicatorViewStyleSquare)
    {
        cornerRadius = 0.0f;
    }
    else if (_dotStyle == TYDotIndicatorViewStyleRound)
    {
        cornerRadius = 2;
    }
    else if (_dotStyle == TYDotIndicatorViewStyleCircle)
    {
        cornerRadius = self.dotSize.width / 2;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height) cornerRadius:cornerRadius];
    
    return bezierPath;
}

- (CAAnimation *)fadeInAnimation:(CFTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0.3f);
    animation.toValue = @(1.0f);
    animation.duration = 0.9f;
    animation.beginTime = delay;
    animation.autoreverses = YES;
    
    animation.repeatCount = HUGE_VAL;
    return animation;
}

- (void)startAnimating
{
    if (_animating)
    {
        return;
    }

    for (int i = 0; i < _dots.count; i++)
    {
        [_dots[i] addAnimation:[self fadeInAnimation:i * 0.4] forKey:@"fadeIn"];
    }
    
    _animating = YES;
}

- (void)stopAnimating
{
    if (!_animating)
    {
        return;
    }
    
    for (int i = 0; i < _dots.count; i++)
    {
        [_dots[i] addAnimation:[self fadeInAnimation:i * 0.4] forKey:@"fadeIn"];
    }
    
    _animating = NO;
}

- (BOOL)isAnimating
{
    return _animating;
}

- (void)removeFromSuperview
{
    [self stopAnimating];
    
    [super removeFromSuperview];
}

@end
