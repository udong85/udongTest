 //
//  ViewController.m
//  iosTest
//
//  Created by udong on 2015. 8. 28..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import "Base.h"

@implementation Base

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)copyToArrayObject:(NSMutableArray *)toArray fromArrayObject:(NSArray *)fromArray
{
    for(id object in fromArray)
    {
        [toArray addObject:object];
    }
}

@end
