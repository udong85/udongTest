//
//  AppDelegate.h
//  iosTest
//
//  Created by udong on 2015. 8. 28..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"
#import "Base.h"
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CategoryViewController *categoryViewController;
    UINavigationController *navi;
}
@property (strong, nonatomic) UIWindow *window;


@end

