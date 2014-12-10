//
//  UINavigationController+Storyboards.m
//  Storyboards
//
//  Created by Ilya Puchka on 08.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "UINavigationController+Storyboards.h"
#import "UIViewController+Storyboards.h"
#import <objc/runtime.h>

typedef void (*ObjCMsgSendReturnNil)(id, SEL);

@implementation UINavigationController (Storyboards)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleAwakeFromNib];
    });
}

+ (void)swizzleAwakeFromNib
{
    SEL sel = @selector(awakeFromNib);
    Method method = class_getInstanceMethod([UITabBarController class], sel);
    ObjCMsgSendReturnNil originalImp = (ObjCMsgSendReturnNil)method_getImplementation(method);
    
    IMP adjustedImp = imp_implementationWithBlock(^void(UINavigationController *instance) {
        originalImp(instance, sel);
        if ([instance isKindOfClass:[UINavigationController class]]) {
            NSArray *newViewControllers = [instance viewControllersWithViewController:[instance viewControllers]];
            [instance setViewControllers:newViewControllers];
        }
    });
    
    method_setImplementation(method, adjustedImp);
}

- (NSArray *)viewControllersWithViewController:(NSArray *)viewControllers
{
    NSMutableArray *mViewControllers = [viewControllers mutableCopy];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        UIViewController *newVC = [UIViewController viewControllerFromStoryboardWithName:vc.storyboardName
                                                                withStoryboardIdentifier:vc.storyboardIdentifier];
        if (newVC) {
            [mViewControllers replaceObjectAtIndex:idx withObject:newVC];
        }
    }];
    return [mViewControllers copy];
}

@end
