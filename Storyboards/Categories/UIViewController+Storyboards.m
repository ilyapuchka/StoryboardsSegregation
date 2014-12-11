//
//  UIViewController+Storyboards.m
//  Storyboards
//
//  Created by Ilya Puchka on 07.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "UIViewController+Storyboards.h"
#import <objc/runtime.h>

typedef void (*ObjCMsgSendReturnNil)(id, SEL);

@implementation UIViewController (Storyboards)

- (NSString *)storyboardName
{
    return objc_getAssociatedObject(self, @selector(storyboardName));
}

- (void)setStoryboardName:(NSString *)storyboardName
{
    objc_setAssociatedObject(self, @selector(storyboardName), storyboardName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)storyboardIdentifier
{
    return objc_getAssociatedObject(self, @selector(storyboardIdentifier));
}

- (void)setStoryboardIdentifier:(NSString *)storyboardIdentifier
{
    objc_setAssociatedObject(self, @selector(storyboardIdentifier), storyboardIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (instancetype)viewControllerFromStoryboardWithName:(NSString *)storyboardName withStoryboardIdentifier:(NSString *)storyboardIdentifier
{
    if (storyboardName.length > 0 && storyboardIdentifier.length > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        if (storyboard) {
            return [storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
        }
    }
    return nil;
}

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
    Method method = class_getInstanceMethod([UIViewController class], sel);
    ObjCMsgSendReturnNil originalImp = (ObjCMsgSendReturnNil)method_getImplementation(method);
    
    //UITabBarController and UINavigationController does not override -awakeFromNib, so we can swizzle UIViewController base implementation and check instance class.
    IMP adjustedImp = imp_implementationWithBlock(^void(UINavigationController *instance) {
        originalImp(instance, sel);
        if ([instance isKindOfClass:[UINavigationController class]] ||
            [instance isKindOfClass:[UITabBarController class]]) {
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
