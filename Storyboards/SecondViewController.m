//
//  SecondViewController.m
//  Storyboards
//
//  Created by Ilya Puchka on 07.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"unwind segue triggered");
}

@end
