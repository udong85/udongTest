//
//  DataManager.h
//  iosTest
//
//  Created by udong on 2015. 8. 28..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataManager : NSObject
{
//    NSMutableArray *teamListData;
//    NSMutableArray *playerData;
}

+(DataManager *)getInstance;

//-(NSMutableArray *)getTeamListData;
//-(NSMutableArray *)getPlayerListData;

-(void)dataInit;

@property (nonatomic, retain) NSMutableArray *teamListData;
@property (nonatomic, retain) NSMutableArray *playerData;
@end
