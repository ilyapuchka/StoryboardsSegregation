//
//  UIStoryboardSegue+Storyboards.m
//  Storyboards
//
//  Created by Ilya Puchka on 08.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "UIStoryboardSegue+Storyboards.h"
#include "UIViewController+Storyboards.h"
#import "NSObject+Swizzling.h"

@implementation UIStoryboardSegue (Storyboards)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(initWithIdentifier:source:destination:) withSelector:@selector(storyboards_initWithIdentifier:source:destination:)];
    });
}

- (instancetype)storyboards_initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    return [self storyboards_initWithIdentifier:identifier
                                         source:source
                                    destination:[self destinationWithDestination:destination]];
}

- (UIViewController *)destinationWithDestination:(UIViewController *)destination
{
    UIViewController *newDestination = [UIViewController viewControllerFromStoryboardWithName:destination.storyboardName
                                                                     withStoryboardIdentifier:destination.storyboardIdentifier];
    return newDestination?:destination;
}

@end
