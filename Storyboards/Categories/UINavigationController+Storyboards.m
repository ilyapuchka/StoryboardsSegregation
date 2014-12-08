//
//  UINavigationController+Storyboards.m
//  Storyboards
//
//  Created by Ilya Puchka on 08.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "UINavigationController+Storyboards.h"
#import "UIViewController+Storyboards.h"
#import "NSObject+Swizzling.h"

@implementation UINavigationController (Storyboards)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(awakeFromNib) withSelector:@selector(storyboards_awakeFromNib)];
    });
}

- (void)storyboards_awakeFromNib
{
    [self storyboards_awakeFromNib];
    
    NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        UIViewController *newVC = [UIViewController viewControllerFromStoryboardWithName:vc.storyboardName
                                                                withStoryboardIdentifier:vc.storyboardIdentifier];
        if (newVC) {
            [viewControllers replaceObjectAtIndex:idx withObject:newVC];
        }
    }];
    [self setViewControllers:viewControllers];
}

@end
