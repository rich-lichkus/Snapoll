//
//  CKPlusButton.m
//  Snapoll
//
//  Created by Richard Lichkus on 7/7/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKPlusButton.h"
#import "PaintCodeImages.h"

@interface CKPlusButton()

@property (nonatomic) CGFloat brightness;

@end

@implementation CKPlusButton

-(void)drawRect:(CGRect)rect{

    switch (self.state) {
        case UIControlStateHighlighted:
                [PaintCodeImages drawCirclePlusIconWithSelected:YES];
            break;
        case UIControlStateNormal:
                [PaintCodeImages drawCirclePlusIconWithSelected:NO];
            break;
    }
    

}

-(void) setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setNeedsDisplay];
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

-(void)setHighlighted:(BOOL)value {
    [super setHighlighted:value];
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)value {
    [super setSelected:value];
    [self setNeedsDisplay];
}


// Add the following methods to the bottom
- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}
@end
