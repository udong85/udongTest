//
//  CategoryViewController.h
//  iosTest
//
//  Created by udong on 2015. 8. 31..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "TeamTableViewCell.h"
#import "DetailViewController.h"
#import "DataManager.h"

@interface CategoryViewController : Base <UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (nonatomic, retain) NSMutableArray *test;
-(void)viewInit;
@end
