//
//  ABLabel.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/15.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ABLabel.h"

@implementation ABLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    [super drawTextInRect:rect];
    
    if (self.underLineEnable) {
        CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
        CGContextSetLineWidth(c, 2.0f);
        CGPoint leftPoint = CGPointMake(0, self.frame.size.height);
        CGPoint rightPoint = CGPointMake(self.frame.size.width, self.frame.size.height);
        CGContextMoveToPoint(c, leftPoint.x, leftPoint.y);
        CGContextAddLineToPoint(c, rightPoint.x, rightPoint.y);
        CGContextStrokePath(c);
    }
}


@end
