//
//  UIViewController+Storyboards.m
//  Storyboards
//
//  Created by Ilya Puchka on 07.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "UIViewController+Storyboards.h"
#import <objc/runtime.h>

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

@end
