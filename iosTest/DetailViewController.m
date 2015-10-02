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
@property (nonatomic, retain) UIScrollView *playerDetailScroll;

@property (nonatomic, retain) NSMutableArray *playerDatas;
@property BOOL isEditing;
@property BOOL keyboardIsUp;
@property float playerListHeight;

@property NSInteger selectedPlayerIndex;
@property (nonatomic, retain) NSArray *positionArray;

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) NSMutableArray *capturedImage;

-(void) setPlayerDetailInfo:(NSInteger) index;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self viewInit];

    [self registerForKeyboardNotification];
    
    self.positionArray = @[@"FW", @"ST", @"CM", @"LM", @"RM", @"CDM", @"DF", @"GK"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isEditing = NO;
    [self.playerTableView setEditing:NO animated:YES];
    self.keyboardIsUp = NO;
    [self.playerDescription endEditing:YES];
//    [self.playerDescription resignFirstResponder];
//    [self.playerDescription becomeFirstResponder];
    
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataInit
{
    
    
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
    self.playerListHeight = viewHeightWithoutNavigationbar * 2 / 3;
    float playerDetailContainerHeight = viewHeightWithoutNavigationbar / 7;
    float playerDetailContainerWidth = self.view.frame.size.width * 2 / 3;
    float savePlayerInfoButtonHeight = 30;
    
    self.title = [NSString stringWithFormat: @"Detail"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playerTableView = [[[UITableView alloc] init] autorelease];
    self.playerTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.playerListHeight);

    self.playerTableView.delegate = self;
    self.playerTableView.dataSource = self;
    [self.view addSubview:self.playerTableView];
    
    // tableView edit button
    UIBarButtonItem *teamOrderEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTableView)];
    
    self.navigationItem.rightBarButtonItem = teamOrderEditButton;
    
    [teamOrderEditButton release];
    
    self.playerDetailScroll = [[UIScrollView alloc] init];
    self.playerDetailScroll.frame = CGRectMake(0, self.playerListHeight, self.view.frame.size.width, viewHeightWithoutNavigationbar - self.playerListHeight);
    self.playerDetailScroll.backgroundColor = [UIColor lightGrayColor];
    [self.playerDetailScroll setContentSize:CGSizeMake(self.view.frame.size.width, viewHeightWithoutNavigationbar - self.playerListHeight)];
//    [self.playerDetailScroll sizeToFit];
    
    [self.view addSubview:self.playerDetailScroll];
    
    UIView *playerDetail = [[UIView alloc] init];
    playerDetail.frame = CGRectMake(0, 0, playerDetailContainerWidth, playerDetailContainerHeight);
//    playerDetail.backgroundColor = [UIColor grayColor];
    [self.playerDetailScroll addSubview:playerDetail];
    NSLog(@"viewInit");
    self.playerName = [[[UILabel alloc] init] autorelease];
    self.playerName.frame = CGRectMake(5, 5, playerDetailContainerWidth - 5, playerDetailContainerHeight / 3);
    self.playerName.backgroundColor = [UIColor orangeColor];
    self.playerName.text = @"NAME";
    
    self.playerName.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *nameTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInputAlert)];
    [self.playerName addGestureRecognizer:nameTapGesture];
    [nameTapGesture release];
    
    [playerDetail addSubview:self.playerName];
    
    self.playerPosition = [[[UILabel alloc] init] autorelease];
    self.playerPosition.frame = CGRectMake(5, playerDetailContainerHeight / 3 + 7, playerDetailContainerWidth - 5, playerDetailContainerHeight / 3);
    self.playerPosition.backgroundColor = [UIColor orangeColor];
    self.playerPosition.text = @"POSITION";
    
    self.playerPosition.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *positionTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChangePositionAlert)];
    [self.playerPosition addGestureRecognizer:positionTapGesture];
    [positionTapGesture release];
    
    [playerDetail addSubview:self.playerPosition];
    
    self.playerImage = [[[UIImageView alloc] init] autorelease];
    self.playerImage.frame = CGRectMake( playerDetailContainerWidth, 0, self.view.frame.size.width - playerDetailContainerWidth - 5, playerDetailContainerHeight);
//    self.playerImage.backgroundColor = [UIColor redColor];
    self.playerImage.bounds = CGRectInset(self.playerImage.frame, 5.0f, 5.0f);
    [self.playerImage.layer setBorderWidth:3.0];
    [self.playerImage.layer setBorderColor:[[UIColor redColor] CGColor]];
    
    
    self.playerImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImagePickerForPhotoPicker)];
    [self.playerImage addGestureRecognizer:imageTapGesture];
    [imageTapGesture release];
    
    [self.playerDetailScroll addSubview:self.playerImage];
    
    self.playerDescription = [[[UITextView alloc] init] autorelease];
    self.playerDescription.frame = CGRectMake(0, playerDetailContainerHeight, self.view.frame.size.width, viewHeightWithoutNavigationbar - self.playerListHeight - playerDetailContainerHeight - savePlayerInfoButtonHeight);
    self.playerDescription.bounds = CGRectInset(self.playerDescription.frame, 5.0f, 5.0f);
//    playerDescription.backgroundColor = [UIColor grayColor];
    self.playerDescription.delegate = self;
    [self.playerDetailScroll addSubview:self.playerDescription];
    
    UIButton *savePlayerInfoButton = [[UIButton alloc] init];
    savePlayerInfoButton.frame = CGRectMake( self.view.frame.size.width - 10 - 70, viewHeightWithoutNavigationbar - self.playerListHeight - savePlayerInfoButtonHeight- 2, 70, savePlayerInfoButtonHeight);
    [savePlayerInfoButton setTitle:@"SAVE" forState:UIControlStateNormal];
    savePlayerInfoButton.backgroundColor = [UIColor orangeColor];
    [savePlayerInfoButton addTarget:self action:@selector(savePlayerInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.playerDetailScroll addSubview:savePlayerInfoButton];
    
    [self.playerDetailScroll release];
    [playerDetail release];
    [savePlayerInfoButton release];
}

#pragma mark - tableView
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

//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    NSArray *teamInfo = [[self.playerDatas objectAtIndex:sourceIndexPath.row] copy];
//    
//    [self.playerDatas removeObjectAtIndex:sourceIndexPath.row];
//    [self.playerDatas insertObject:teamInfo atIndex:destinationIndexPath.row];
//    
//    [teamInfo release];
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != self.selectedPlayerIndex)
    {
        self.selectedPlayerIndex = indexPath.row;
        [self setPlayerDetailInfo:indexPath.row];
    }
}

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

#pragma mark - softkeyboard notification
-(void)registerForKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object: NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillHideNotification object:NULL];
}

-(void) keyboardWasShown:(NSNotification *)aNotification
{
    NSLog(@"keyboardWasShown %@", aNotification.name);
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    int animateDistance = kbSize.height;
    
    if(self.keyboardIsUp)
    {
        self.keyboardIsUp = NO;
        self.playerTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.playerListHeight);
    }else{
        self.keyboardIsUp = YES;
        self.playerTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.playerListHeight - kbSize.height );
    }
    
    const int movementDistance = animateDistance;
    const float movementDuration = 0.3f;
    int movement = (self.keyboardIsUp ? -movementDistance : movementDistance);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.playerDetailScroll.frame = CGRectOffset(self.playerDetailScroll.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)savePlayerInfo
{
    NSMutableArray *playerInfo = [[NSMutableArray alloc] initWithArray: [self.playerDatas objectAtIndex:self.selectedPlayerIndex]];
    NSMutableArray *playerInfoForModify = [[NSMutableArray alloc] init];
    
    [playerInfoForModify addObject: self.playerName.text];
    [playerInfoForModify addObject: self.playerPosition.text];
    [playerInfoForModify addObject: self.playerDescription.text];
    [playerInfoForModify addObject: [playerInfo objectAtIndex:0]];
    
    NSInteger result = [[DBManager getInstance] modifyPlayerInfo:playerInfoForModify];

    if(result == 1){
        [playerInfo replaceObjectAtIndex:2 withObject:self.playerName.text];
        [playerInfo replaceObjectAtIndex:3 withObject:self.playerPosition.text];
        [playerInfo replaceObjectAtIndex:5 withObject:self.playerDescription.text];
  
        [self.playerDatas replaceObjectAtIndex:self.selectedPlayerIndex withObject:playerInfo];

        [[DataManager getInstance] modifyPlayerInfo:playerInfoForModify];
    }
    
    [playerInfo release];
    [playerInfoForModify release];
    
    [self.playerTableView reloadData];
    [self.view endEditing:YES];
}

#pragma mark - player info input
// name alert
-(void) showInputAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NAME" message:@"Enter a player name" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;  
    UITextField *inputTextField = [alert textFieldAtIndex:0];
    
    inputTextField.text = self.playerName.text;
    
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1: // name 변경
            if(buttonIndex == 1){
                self.playerName.text = [[alertView textFieldAtIndex:0] text];
                
                [self savePlayerInfo];
            }

            break;
            
        default:
            break;
    }
}

// position actionsheet
-(void) showChangePositionAlert
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"POSITION" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                   otherButtonTitles:self.positionArray[0],
                                                                    self.positionArray[1],
                                                                    self.positionArray[2],
                                                                    self.positionArray[3],
                                                                    self.positionArray[4],
                                                                    self.positionArray[5],
                                                                    self.positionArray[6],
                                                                    self.positionArray[7],
                                                                    nil];
    
    [popupQuery showInView:self.view];
    [popupQuery release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.playerPosition.text = self.positionArray[0];
            break;
        case 1:
            self.playerPosition.text = self.positionArray[1];
            break;
        case 2:
            self.playerPosition.text = self.positionArray[2];
            break;
        case 3:
            self.playerPosition.text = self.positionArray[3];
            break;
        case 4:
            self.playerPosition.text = self.positionArray[4];
            break;
        case 5:
            self.playerPosition.text = self.positionArray[5];
            break;
        case 6:
            self.playerPosition.text = self.positionArray[6];
            break;
        case 7:
            self.playerPosition.text = self.positionArray[7];
            break;
            
        default:
            break;
    }
    
    [self savePlayerInfo];
}

// image imagePickerPhotoPicker
-(void)showImagePickerForPhotoPicker
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    UIImagePickerControllerSourceTypePhotoLibrary
//    UIImagePickerControllerSourceTypeSavedPhotosAlbum
}

-(void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{

    if(self.playerImage.isAnimating)
    {
        [self.playerImage stopAnimating];
    }
    
    if([self.capturedImage count] > 0)
    {
        [self.capturedImage removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"imagePickerController");
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if(!image) image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if(image)
        NSLog(@"image is null");
    
    [self.capturedImage addObject:image];

    [self finishAndUpdate];
}

-(void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if([self.capturedImage count] > 0)
    {
        if([self.capturedImage count] == 1)
        {
            [self.playerImage setImage:[self.capturedImage objectAtIndex:0]];
        }else{

        }
        
        [self.capturedImage removeAllObjects];
    }

    self.imagePickerController = nil;
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
