//
//  UIStoryboard+Storyboards.m
//  Restaurants
//
//  Created by Ilya Puchka on 09.12.14.
//  Copyright (c) 2014 Afisha. All rights reserved.
//

#import "UIStoryboard+Storyboards.h"
#import "UIViewController+Storyboards.h"
#import <objc/runtime.h>

typedef id (*ObjCMsgSendReturnId)(id, SEL, NSString *);

@implementation UIStoryboard (Storyboards)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInitViewController];
    });
}

+ (void)swizzleInitViewController
{
    SEL sel = @selector(instantiateViewControllerWithIdentifier:);
    Method method = class_getInstanceMethod([UIStoryboard class], sel);
    ObjCMsgSendReturnId originalImp = (ObjCMsgSendReturnId)method_getImplementation(method);
    
    IMP adjustedImp = imp_implementationWithBlock(^id(UITabBarController *instance, NSString *identifier) {
        UIViewController *viewController = originalImp(instance, sel, identifier);
        if ([instance class] == [UIStoryboard class]) {
            UIViewController *newViewController = [UIViewController viewControllerFromStoryboardWithName:viewController.storyboardName withStoryboardIdentifier:viewController.storyboardIdentifier];
            viewController = newViewController?:viewController;
        }
        return viewController;
    });
    
    method_setImplementation(method, adjustedImp);
}

@end
