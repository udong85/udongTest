//
//  DBManager.m
//  iosTest
//
//  Created by udong on 2015. 9. 18..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import "DBManager.h"

@interface DBManager()

@property (nonatomic) sqlite3 *dataBaseManager;
@property (nonatomic, retain) NSString *databasePath;

@end

@implementation DBManager

static DBManager *mDBManager;

+(instancetype) getInstance
{
    if(!mDBManager)
    {
        @synchronized(mDBManager){
            if(!mDBManager)
            {
                mDBManager = [[DBManager alloc] init];
            }
        }
    }
    
    return mDBManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"DBManager init");
    }
    return self;
}

#pragma DataBase

-(void)connectDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    self.databasePath = [documentDirectory stringByAppendingPathComponent:@"soccer.db"];
    NSLog(@"%@", self.databasePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    if([fileManager fileExistsAtPath: self.databasePath] == NO)
//    {
        if(sqlite3_open([self.databasePath UTF8String], &_dataBaseManager) == SQLITE_OK)    // DB 를 열면서 없으면 생성
        {
            NSLog(@"DB open success!");
            [self dropTable];
            // 테이블 생성
            [self createTable];
        }else{
            NSLog(@"sqlite DB open error. DB will be closed");
            sqlite3_close(_dataBaseManager);
        }
//    }else{
//        [self initSoccerDataIntoDataManager];
//    }
}

-(void)dropTable
{
    const char *sql;
    sqlite3_stmt *statement = NULL;
    
    if(sqlite3_open([self.databasePath UTF8String], &_dataBaseManager) == SQLITE_OK)
   {
       sql = "DROP table TEAM";
       if(sqlite3_prepare_v2(_dataBaseManager, sql, -1, &statement, NULL) == SQLITE_OK)
       {
           if(sqlite3_step(statement) == SQLITE_DONE)
           {
               NSLog(@"TEAM table DROP");
           }
       }
       
       sql = "DROP table PLAYER";
       if(sqlite3_prepare_v2(_dataBaseManager, sql, -1, &statement, NULL) == SQLITE_OK)
       {
           if(sqlite3_step(statement) == SQLITE_DONE)
           {
               NSLog(@"PLAYER table DROP");
           }
       }
   }
    
}

-(void)createTable
{
    char *errorMessage;
    const char *sqlStatement;
    NSLog(@"creaetTable");
    // create TEAM table
    sqlStatement = "CREATE TABLE IF NOT EXISTS TEAM(tm_cd varchar(4) PRIMARY KEY, tm_embl varchar(100), lg_nm varchar(20), tm_nm varchar(20))";
    
    if(sqlite3_exec(_dataBaseManager, sqlStatement, NULL, NULL, &errorMessage) == SQLITE_OK)
    {
        NSLog(@"create TEAM table success.");
    }else{
        NSLog(@"create TEAM table fail. [error message] : %s", errorMessage);
    }
    
    // create PLAYER table
    sqlStatement = "CREATE TABLE IF NOT EXISTS PLAYER(plr_cd varchar(4) PRIMARY KEY, tm_cd varchar(4), plr_nm varchar(20), plr_pst varchar(2), plr_img varchar(30), plr_desc text)";
    
    if(sqlite3_exec(_dataBaseManager, sqlStatement, NULL, NULL, &errorMessage) == SQLITE_OK)
    {
        NSLog(@"create PLAYER table success.");
    }else{
        NSLog(@"create PLAYER table fail.");
    }
    
    // 초기 데이터 생성
    [self insertInitailDataIntoTable];
}

-(void)insertInitailDataIntoTable
{
    //    char *errorMessage;
    const char *sql;
    sqlite3_stmt *statement = NULL;
    
    if(sqlite3_open([self.databasePath UTF8String], &_dataBaseManager) == SQLITE_OK){
        // team info insert
        sql = "INSERT INTO TEAM(tm_cd, tm_embl, lg_nm, tm_nm) values (?,?,?,?)";
        if(sqlite3_prepare_v2(self.dataBaseManager, sql,  -1, &statement, NULL) == SQLITE_OK){
            NSMutableArray *teamDataList = [NSMutableArray arrayWithArray:@[  // 팀 코드, 엠블럼 이미지 주소, 리그명, 팀명
                                                                     @[@"T001",    @"",    @"primera league",      @"real madrid"],
                                                                     @[@"T002",    @"iv_fc_barcelona.png",    @"primera league",      @"FC barcelona"],
                                                                     @[@"T003",    @"iv_manchester_united.png",    @"preminum league",     @"manchester united"],
                                                                     @[@"T004",    @"",    @"preminum league",     @"asnal"],
                                                                     @[@"T005",    @"",    @"preminum league",     @"manchester city"],
                                                                     @[@"T006",    @"iv_chealsea.png",    @"preminum league",     @"chelcea"],
                                                                     @[@"T007",    @"",    @"bundesliga league",     @"Bayern Munchen"]
                                                                     ]];
            for(NSInteger i=0; i<[teamDataList count]; i++){
                NSArray *teamData = [teamDataList objectAtIndex:i];
                
                sqlite3_bind_text(statement, 1, [[teamData objectAtIndex:0] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [[teamData objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [[teamData objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[teamData objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
                NSLog(@"teamData %@", [teamData objectAtIndex:3]);
                if(sqlite3_step(statement) != SQLITE_DONE){
//                    NSLog(@"INSERT TEAM table DATA fail. [ERROR CODE] : %d, [ERROR MESSAGE] : %s", sqlite3_errcode(self.dataBaseManager), sqlite3_errmsg(self.dataBaseManager));
//                    sqlite3_finalize(statement);
//                    sqlite3_close(self.dataBaseManager);
//                    return;
                };
                sqlite3_reset(statement);
            }
            NSLog(@"team data insert success.");
        }else{
            NSLog(@"INSERT TEAM table DATA prepare fail. [ERROR CODE] : %d, [ERROR MESSAGE] : %s", sqlite3_errcode(self.dataBaseManager), sqlite3_errmsg(self.dataBaseManager));
            sqlite3_finalize(statement);
            sqlite3_close(self.dataBaseManager);
        }
        
        sqlite3_finalize(statement);
        
        // player info insert
        sql = "INSERT INTO PLAYER(plr_cd, tm_cd, plr_nm, plr_pst, plr_img, plr_desc) values (?,?,?,?,?,?)";
        if(sqlite3_prepare_v2(self.dataBaseManager, sql,  -1, &statement, NULL) == SQLITE_OK){
            
            NSMutableArray *playerDataList = [NSMutableArray arrayWithArray:@[     // 선수 코드, 소속팀 코드, 선수명, 포지션, 이미지 주소, 상세 설명
                                                                       @[@"P001", @"T001", @"크리스티아누 호날두", @"FW", @"호날두.png", @"현역 선수중 메시와 신계 선수. 몸이 좋다!! 패션 센스는 꽝."],
                                                                       @[@"P002", @"T002", @"리오넬 메시", @"FW", @"메시.png", @"현존 사기 캐릭"],
                                                                       @[@"P003", @"T002", @"수아레즈", @"FW", @"", @"성격은 지랄맞지만 잘하긴 잘한다. 못생김"],
                                                                       @[@"P004", @"T006", @"오스카", @"MF", @"", @"잘하는거 같은데 피지컬이 약해서... 왠지 먼가 아쉽다."],
                                                                       @[@"P005", @"T006", @"에당 아자르", @"MF", @"아자르.png", @"벨기에 에이스!!! 요즘 꽃이 핀다. 좀 더 올라온다면 인간계 최강자가 될수도."],
                                                                       @[@"P006", @"T001", @"가레스 베일", @"FW", @"", @"한때 인간계 최강자로 꼽혔지만, 요즘은 잘 모르겠다. 레알마드리드 간판 공격수 BBC 중에 하나지만 평타정도인듯"],
                                                                       @[@"P007", @"T002", @"네이마르", @"FW", @"", @"바로셀로나 간판 공격수. 빠르고 드리블이 좋지만, 먼가 저돌적이다. 추후에 큰 부상으로 선수 생활 끝날꺼 같은 느낌이다."],
                                                                       @[@"P008", @"T003", @"루니", @"FW", @"루니.png", @"원래는 공격수였으나 요즘은 공격형 미들필더, 쉐도우 스트라이커까지 다방면에서 훌륭한 선수다. 맨유하면 루니!! 루니하면 맨유!!"],
                                                                       @[@"P009", @"T004", @"메수트 외질", @"MF", @"외질.png", @"독일의 특급 미들필더. 공을 아름답게 찬다는 말이 어울리는 선수. 유연하고 정확한 패스로 경기를 이끌어간다. 이런 미들필더 한명이면 축구가 재미있어지고 쉬워진다."],
                                                                       @[@"P010", @"T004", @"올리비아 지루", @"FW", @"", @"아스날 원톱 공격수. 전형적으로 뱅거가 좋아하는 스타일. 결정력 있는 공격수. 미들필더에서 만들어주면 어떻게해서든 골을 넣게 만드는 선수를 원하는 뱅거스타일. 딱히 공을 만들어서 골을 만들지는 않지만 찬스가 왔을때 놓치지 않는다. 다만 사생활이 더럽다. 스캔들이 끊이지 않음"],
                                                                       @[@"P011", @"T005", @"다비드 실바", @"MF", @"실바.png", @"맨체스터 시티를 이끌어가는 미들필드. 중원의 사령관. 에이스는 이래야 된다는 걸 보여준다. 많은 활동량으로 동료들에게 기회를 만들어주면서도 자신이 골을 넣기도 한다."],
                                                                       @[@"P012", @"T005", @"콤파니", @"DF", @"", @"벨기에 수비수. 그가 있어 뒤가 든든하다. 안정적이면서도 세트피스에서는 골을 만들어낸다."],
                                                                       @[@"P013", @"T003", @"데 헤아", @"GK", @"", @"맨유의 수문장. 긴팔에 동물적 감각으로 골문을 지킨다. 이번시즌 맨유와 불화설이 있어 떠날줄 알았는데, 남았다."],
                                                                       @[@"P014", @"T005", @"야야 투레", @"MF", @"", @"엄청난 피지컬에도 무서운 파괴력이 있는 선수. 그가 공을 잡으면 왠지 안정적이다. 팀이 어려울때 한방이 있는 선수"],
                                                                       @[@"P015", @"T005", @"라임 스털링", @"FW", @"", @"어린놈이 패기가 남다르다. 잘하긴하는데 멘탈은 아직 미성숙. 리버풀에 있을때 3S 시절 기대했었는데, 이미 머 다 무너졌으니... 맨유에서서 얼마나 잘 할지는 지켜봐야 할듯. 아직까지는 잘 되고 있다."],
                                                                       @[@"P016", @"T005", @"나스리", @"MF", @"", @"아스날 시절 기대되는 선수였지만, 요즘들어서 큰 인상을 주지 못하는 선수. 그래도 가끔씩 조커로 기용된다."],
                                                                       @[@"P017", @"T005", @"아게로", @"FW", @"", @"아르헨티나 간판 공격수. 지난시즌 프리미어리그 득점왕. 역시 한방이 있는 선수"],
                                                                       @[@"P018", @"T005", @"에딘 제코", @"FW", @"", @"기대를 안고 맨시티에 입단하였지만 큰 성과는 잘 모르겠다. 한때 먹튀 논란이 있던 선수. 하지만 지금은 적응이후 올라오는 선수"],
                                                                       @[@"P019", @"T005", @"조 하트", @"GK", @"", @"맨체스터 시티의 수문장. 잉글랜드 대표팀 골키퍼. 잘한다 ㅋㅋ"],
                                                                       
                                                                       ]];
            for(NSInteger i=0; i<[playerDataList count]; i++){
                NSArray *playerData = [playerDataList objectAtIndex:i];
                
                sqlite3_bind_text(statement, 1, [[playerData objectAtIndex:0] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [[playerData objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [[playerData objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[playerData objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [[playerData objectAtIndex:4] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [[playerData objectAtIndex:5] UTF8String], -1, SQLITE_TRANSIENT);
                
                if(sqlite3_step(statement) != SQLITE_DONE){
//                    NSLog(@"INSERT PLAYER table DATA prepare fail. [ERROR CODE] : %d, [ERROR MESSAGE] : %s", sqlite3_errcode(self.dataBaseManager), sqlite3_errmsg(self.dataBaseManager));
//                    sqlite3_finalize(statement);
//                    sqlite3_close(self.dataBaseManager);
//                    return;
                };
                sqlite3_reset(statement);
            }
            NSLog(@"player data insert success.");
        }else{
            NSLog(@"INSERT PLAYER table DATA fail. [ERROR CODE] : %d, [ERROR MESSAGE] : %s", sqlite3_errcode(self.dataBaseManager), sqlite3_errmsg(self.dataBaseManager));
            sqlite3_finalize(statement);
            sqlite3_close(self.dataBaseManager);
        }
        
        sqlite3_finalize(statement);
    }
    
    [self initSoccerDataIntoDataManager];
}

-(void)initSoccerDataIntoDataManager
{
    NSLog(@"initSoccerDataIntoDataManager");
    sqlite3_stmt    *statement;
    
    if(sqlite3_open([self.databasePath UTF8String], &_dataBaseManager) == SQLITE_OK)
    {
        NSString *sql = @"SELECT tm_cd, tm_embl, lg_nm, tm_nm FROM TEAM";
        
        if(sqlite3_prepare_v2(self.dataBaseManager, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            NSMutableArray *teamDataList = [[NSMutableArray alloc] init];
            while(sqlite3_step(statement) == SQLITE_ROW){
                NSLog(@"while loop... ");
                [teamDataList addObject: @[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)],
                                          [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)],
                                          [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)],
                                          [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)],
                                          ]];
            }
            
            [[DataManager getInstance] setTeamListData:teamDataList];
            NSLog(@"team Data count : %lu", [teamDataList count]);
            [teamDataList release];
        }else{
            NSLog(@"SELECT TEAM table fail. [ERROR CODE] : %d, [ERROR MESSAGE] : %s", sqlite3_errcode(self.dataBaseManager), sqlite3_errmsg(self.dataBaseManager));
        }
        
        sqlite3_finalize(statement);
        
        // player data setting
        sql = @"SELECT plr_cd, tm_cd, plr_nm, plr_pst, plr_img, plr_desc FROM PLAYER";
        
        if(sqlite3_prepare_v2(self.dataBaseManager, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            NSMutableArray *playerDataList = [[NSMutableArray alloc] init];
            while(sqlite3_step(statement) == SQLITE_ROW){
                NSLog(@"while loop...");
                [playerDataList addObject: @[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)],
                                           [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)],
                                           [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)],
                                           [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)],
                                           [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)],
                                           [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 5)],
                                           ]];
            }
            
            [[DataManager getInstance] setPlayerData:playerDataList];
            NSLog(@"player Data count : %lu", [playerDataList count]);
            [playerDataList release];
        }else{
            NSLog(@"SELECT PLAYER table fail. [ERROR CODE] : %d, [ERROR MESSAGE] : %s", sqlite3_errcode(self.dataBaseManager), sqlite3_errmsg(self.dataBaseManager));
        }
        
        sqlite3_finalize(statement);
    }
}

@end
