//
//  DetailViewController.m
//  iosTest
//
//  Created by udong on 2015. 9. 3..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import "DetailViewController.h"
@interface DetailViewController ()

@property (nonatomic, retain) UITableView *playerTableView;
@property (nonatomic, retain) UILabel *playerName;
@property (nonatomic, retain) UILabel *playerPosition;
@property (nonatomic, retain) UIImageView *playerImage;
@property (nonatomic, retain) UITextView *playerDescription;

@property (nonatomic, retain) NSMutableArray *playerDatas;
@property BOOL isEditing;

-(void) setPlayerDetailInfo:(NSInteger) index;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self viewInit];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataInit
{
    self.isEditing = NO;
    [self.playerTableView setEditing:NO animated:YES];
    
    if(!self.playerDatas){
        self.playerDatas = [[[NSMutableArray alloc] init] autorelease];
    }
    [self.playerDatas removeAllObjects];

    self.playerName.text = @"";
    self.playerPosition.text = @"";
    self.playerDescription.text = @"";
    self.playerImage.image = [UIImage imageNamed:@""];
    NSArray *allPlayers = [DataManager getInstance].playerData;

    for(int i=0; i < [allPlayers count] ; i++){
        NSMutableArray *playerData = [allPlayers objectAtIndex:i];
        if([self.teamCode isEqualToString:[playerData objectAtIndex:1]] ){
            NSLog(@"add");
            [self.playerDatas addObject:playerData];
        }
    }
    
    if(self.playerDatas.count > 0){
        NSLog(@"count is ..");
        [self setPlayerDetailInfo:0];
    }
    
    [self.playerTableView reloadData];
    
}

- (void)dealloc
{
    [super dealloc];
}

-(void)viewInit
{
    float viewHeightWithoutNavigationbar = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);        // view height - navigationbar height - statusbar height
    float playerListHeight = viewHeightWithoutNavigationbar * 2 / 3;
    float playerDetailContainerHeight = viewHeightWithoutNavigationbar / 7;
    float playerDetailContainerWidth = self.view.frame.size.width * 2 / 3;
    
    self.title = [NSString stringWithFormat: @"Detail"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playerTableView = [[[UITableView alloc] init] autorelease];
    self.playerTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, playerListHeight);

    self.playerTableView.delegate = self;
    self.playerTableView.dataSource = self;
    [self.view addSubview:self.playerTableView];
    
    // tableView edit button
    UIBarButtonItem *teamOrderEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTableView)];
    
    self.navigationItem.rightBarButtonItem = teamOrderEditButton;
    
    [teamOrderEditButton release];
    
    UIScrollView *playerDetailScroll = [[UIScrollView alloc] init];
    playerDetailScroll.frame = CGRectMake(0, playerListHeight, self.view.frame.size.width, viewHeightWithoutNavigationbar - playerListHeight);
    playerDetailScroll.backgroundColor = [UIColor lightGrayColor];
    [playerDetailScroll setContentSize:CGSizeMake(self.view.frame.size.width, viewHeightWithoutNavigationbar - playerListHeight)];
    [playerDetailScroll sizeToFit];
    
    [self.view addSubview:playerDetailScroll];
    
    UIView *playerDetail = [[UIView alloc] init];
    playerDetail.frame = CGRectMake(0, 0, playerDetailContainerWidth, playerDetailContainerHeight);
//    playerDetail.backgroundColor = [UIColor grayColor];
    [playerDetailScroll addSubview:playerDetail];
    NSLog(@"viewInit");
    self.playerName = [[[UILabel alloc] init] autorelease];
    self.playerName.frame = CGRectMake(5, 0, playerDetailContainerWidth, playerDetailContainerHeight / 3);
//    playerName.backgroundColor = [UIColor redColor];
    self.playerName.text = @"NAME";
    [playerDetail addSubview:self.playerName];
    
    self.playerPosition = [[[UILabel alloc] init] autorelease];
    self.playerPosition.frame = CGRectMake(5, playerDetailContainerHeight / 3, playerDetailContainerWidth, playerDetailContainerHeight / 3);
//    playerPosition.backgroundColor = [UIColor orangeColor];
    self.playerPosition.text = @"POSITION";
    [playerDetail addSubview:self.playerPosition];
    
    self.playerImage = [[[UIImageView alloc] init] autorelease];
    self.playerImage.frame = CGRectMake( playerDetailContainerWidth, 0, self.view.frame.size.width - playerDetailContainerWidth - 5, playerDetailContainerHeight);
//    self.playerImage.backgroundColor = [UIColor redColor];
    self.playerImage.bounds = CGRectInset(self.playerImage.frame, 5.0f, 5.0f);
    [self.playerImage.layer setBorderWidth:3.0];
    [self.playerImage.layer setBorderColor:[[UIColor redColor] CGColor]];
    [playerDetailScroll addSubview:self.playerImage];
    
    self.playerDescription = [[[UITextView alloc] init] autorelease];
    self.playerDescription.frame = CGRectMake(0, playerDetailContainerHeight, self.view.frame.size.width, viewHeightWithoutNavigationbar - playerListHeight - playerDetailContainerHeight);
    self.playerDescription.bounds = CGRectInset(self.playerDescription.frame, 5.0f, 5.0f);
//    playerDescription.backgroundColor = [UIColor grayColor];
    [playerDetailScroll addSubview:self.playerDescription];
    
    [playerDetailScroll release];
    [playerDetail release];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.playerDatas count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableViewIdentifier = @"cell";
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];

    if(cell == nil){
        cell = [[[PlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewIdentifier] autorelease];
    }
    
    //    NSMutableDictionary *teamData = [teamDatas lastObject];
    NSMutableArray *playerData = [self.playerDatas objectAtIndex:indexPath.row];
    
    [cell setPlayerName:[playerData objectAtIndex:2] playerPosition:[playerData objectAtIndex:3] playerImgUrl:[playerData objectAtIndex:4]];
    return cell;
}

-(void) setPlayerDetailInfo:(NSInteger) index
{
    NSMutableArray *playerData = [self.playerDatas objectAtIndex:index];
    
    [self.playerName setText:[playerData objectAtIndex:2]];
    [self.playerPosition setText:[playerData objectAtIndex:3]];
    [self.playerImage setImage:[UIImage imageNamed:[playerData objectAtIndex:4]]];
    [self.playerDescription setText:[playerData objectAtIndex:5]];
    
    NSLog(@"setPlayerDetailInfo , %@", [playerData objectAtIndex:2]);
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSArray *teamInfo = [[self.playerDatas objectAtIndex:sourceIndexPath.row] copy];
    
    [self.playerDatas removeObjectAtIndex:sourceIndexPath.row];
    [self.playerDatas insertObject:teamInfo atIndex:destinationIndexPath.row];
    
    [teamInfo release];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [self setPlayerDetailInfo:indexPath.row];
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)] autorelease];
//    
//    headerView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
//    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.9].CGColor;
//    headerView.layer.borderWidth = 1.0;
//    //    [headerView setTitle:@"TEAM" forState:UIControlStateNormal];
//    
//    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 50, 5, 40, 10) ];
//    [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
//    
//    [headerView addSubview:editBtn];
//    
//    [editBtn release];
//    
//    return headerView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

-(void)editTableView
{
    if(self.isEditing)
    {
        [self.playerTableView setEditing:NO animated:YES];
        self.isEditing = NO;
    }else{
        [self.playerTableView setEditing:YES animated:YES];
        self.isEditing = YES;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
