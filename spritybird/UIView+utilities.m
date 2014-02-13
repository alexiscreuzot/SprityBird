//
//  UIView+utilities.m
//  reddito
//
//  Created by Alex on 08/07/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "UIView+utilities.h"

@implementation UIView (utilities)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
