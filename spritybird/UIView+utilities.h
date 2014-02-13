//
//  UIView+utilities.h
//  reddito
//
//  Created by Alex on 08/07/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (utilities)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end
