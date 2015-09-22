//
//  CategoryViewController.m
//  iosTest
//
//  Created by udong on 2015. 8. 31..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@property (nonatomic, retain) UITableView *teamList;
@property (nonatomic, retain) NSMutableArray *teamDatas;
@property BOOL isEditing;

@property (nonatomic, retain) DetailViewController *detailViewController;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self viewInit];
    
    self.teamDatas = [[DataManager getInstance] teamListData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isEditing = NO;
    [self.teamList setEditing:NO animated:YES];
}

- (void)dealloc
{
    [super dealloc];
    
//    [self.teamDatas release];
//    [self.teamList release];
//    [self.detailViewController release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewInit{
    // navigationvar title settiong
    self.title = [NSString stringWithFormat: @"Category"];
    
    // team tableview
    self.teamList = [[[UITableView alloc] init] autorelease];
    self.teamList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.teamList.dataSource = self;
    self.teamList.delegate = self;
    
    [self.view addSubview:self.teamList];
    
    // tableView edit button
    UIBarButtonItem *teamOrderEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTableView)];
    
    self.navigationItem.rightBarButtonItem = teamOrderEditButton;
    
    [teamOrderEditButton release];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.teamDatas count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableViewIdentifier = @"cell";
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    
    if(cell == nil){
        cell = [[[TeamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewIdentifier] autorelease];
        cell.frame = CGRectMake(0, 0, self.teamList.frame.size.width, self.teamList.rowHeight);
    }
    
    NSMutableArray *teamData = [[[DataManager getInstance] teamListData] objectAtIndex:indexPath.row];
    
    [cell setTeamName:[teamData objectAtIndex:3 ] league:[teamData objectAtIndex:2] emblem:[teamData objectAtIndex:1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!self.detailViewController)
        self.detailViewController = [[[DetailViewController alloc] init] autorelease];
    
    NSMutableArray *teamData = [self.teamDatas objectAtIndex:indexPath.row];
    [self.detailViewController setTeamCode:[teamData objectAtIndex:0]];
    
//    [self.detailViewController dataInit];
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSArray *teamInfo = [[self.teamDatas objectAtIndex:sourceIndexPath.row] copy];

    [self.teamDatas removeObjectAtIndex:sourceIndexPath.row];
    [self.teamDatas insertObject:teamInfo atIndex:destinationIndexPath.row];
    
    [teamInfo release];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    return YES;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSLog(@"viewForHeaderInSection");
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)] autorelease];
//    
//    headerView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
//    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.9].CGColor;
//    headerView.layer.borderWidth = 1.0;
//    
//    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 50, 5, 40, 10) ];
//    [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
//    
//    [headerView addSubview:editBtn];
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
        [self.teamList setEditing:NO animated:YES];
        self.isEditing = NO;
    }else{
        [self.teamList setEditing:YES animated:YES];
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
