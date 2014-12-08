//
//  UIViewController+Storyboards.h
//  Storyboards
//
//  Created by Ilya Puchka on 07.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Storyboards)

@property (nonatomic, copy) IBInspectable NSString *storyboardName;
@property (nonatomic, copy) IBInspectable NSString *storyboardIdentifier;

+ (instancetype)viewControllerFromStoryboardWithName:(NSString *)storyboardName
                            withStoryboardIdentifier:(NSString *)storyboardIdentifier;

@end
