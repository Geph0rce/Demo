//
//  DemoHitTestView.m
//  demo
//
//  Created by Roger on 16/03/2018.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "DemoHitTestView.h"

@implementation DemoHitTestView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView && self.viewToHitTest) {
        hitTestView = self.viewToHitTest;
    }
    return hitTestView;
}

@end
