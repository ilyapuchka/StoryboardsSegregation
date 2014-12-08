//
//  MyCustomSegue.m
//  Storyboards
//
//  Created by Ilya Puchka on 08.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "MyCustomSegue.h"

@implementation MyCustomSegue

- (void)perform
{
    [self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
}

@end
