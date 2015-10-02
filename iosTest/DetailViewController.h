//
//  DetailViewController.h
//  iosTest
//
//  Created by udong on 2015. 9. 3..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "DataManager.h"
#import "DBManager.h"
#import "PlayerTableViewCell.h"

@interface DetailViewController : Base <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
}

-(void)dataInit;
-(void)viewInit;

@property (nonatomic, strong) NSString *teamCode;
@end
