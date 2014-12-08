//
//  UIStoryboardSegue+Storyboards.m
//  Storyboards
//
//  Created by Ilya Puchka on 08.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "UIStoryboardSegue+Storyboards.h"
#include "UIViewController+Storyboards.h"
#import <objc/runtime.h>

typedef id (*ObjCMsgSendReturnId)(id, SEL, NSString *, UIViewController *, UIViewController *);

@implementation UIStoryboardSegue (Storyboards)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInitWithIdentifier];
    });
}

+ (void)swizzleInitWithIdentifier
{
    SEL sel = @selector(initWithIdentifier:source:destination:);
    Method method = class_getInstanceMethod([UIStoryboardSegue class], sel);
    ObjCMsgSendReturnId originalImp = (ObjCMsgSendReturnId)method_getImplementation(method);
    
    IMP adjustedImp = imp_implementationWithBlock(^id(UIStoryboardSegue *instance, NSString *identifier, id source, id destination) {
        return originalImp(instance, sel, identifier, source, [instance destinationWithDestination:destination]);
    });
    
    method_setImplementation(method, adjustedImp);
}

- (UIViewController *)destinationWithDestination:(UIViewController *)destination
{
    UIViewController *newDestination = [UIViewController viewControllerFromStoryboardWithName:destination.storyboardName
                                                                     withStoryboardIdentifier:destination.storyboardIdentifier];
    return newDestination?:destination;
}

@end
