//
//  ViewController.m
//  VTHacks
//
//  Created by Vincent Ngo on 3/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)wtf:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
