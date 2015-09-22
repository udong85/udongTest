//
//  DBManager.h
//  iosTest
//
//  Created by udong on 2015. 9. 18..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DataManager.h"

@interface DBManager : NSObject

+(DBManager *)getInstance;
-(void)connectDataBase;

@end
