//
//  CategoryTableViewCell.m
//  iosTest
//
//  Created by udong on 2015. 9. 2..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import "TeamTableViewCell.h"

@interface TeamTableViewCell()

@property (nonatomic, retain) NSString *emblemUrl;
@property (nonatomic, retain) NSString *leagueName;
@property (nonatomic, retain) NSString *teamName;

@property (nonatomic, retain) UIImageView *emblemImageView;
@property (nonatomic, retain) UILabel *leagueNameLabel;
@property (nonatomic, retain) UILabel *teamNameLabel;

@end

@implementation TeamTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    float cellHeight = self.frame.size.height;
    
    if(self){
        self.emblemImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, cellHeight - 10, cellHeight - 10)] autorelease];
        self.emblemImageView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.emblemImageView];
        
        self.leagueNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(cellHeight, 0, self.frame.size.width - cellHeight, (cellHeight) / 3)] autorelease];
        self.leagueNameLabel.backgroundColor = [UIColor whiteColor];
        self.leagueNameLabel.textColor = [UIColor grayColor];
        [self.leagueNameLabel setFont:[UIFont systemFontOfSize:8]];
//        TVLeagueName.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        [TVLeagueName setEditable:NO];
        [self.leagueNameLabel setUserInteractionEnabled:NO];
        [self.leagueNameLabel addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
//        TVLeagueName.font = [UIFont fontWithName:@"Arial" size:10.0f];

        [self.contentView  addSubview:self.leagueNameLabel];
        
        self.teamNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(cellHeight, (cellHeight) / 3,
                                                                   self.frame.size.width - cellHeight, (cellHeight) * 2 / 3)] autorelease];
        self.teamNameLabel.backgroundColor = [UIColor whiteColor];
        self.teamNameLabel.textColor = [UIColor blackColor];
        self.teamNameLabel.textAlignment = NSTextAlignmentRight;
        [self.teamNameLabel setFont:[UIFont systemFontOfSize:15]];
//        [TVTeamName setEditable:NO];
        [self.teamNameLabel setUserInteractionEnabled:NO];
//        TVTeamName.textContainer.lineFragmentPadding = 0;
//        TVTeamName.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        TVTeamName.font = [UIFont fontWithName:@"Arial" size:13.0f];
        
        [self.contentView addSubview:self.teamNameLabel];
    }
    
    return self;
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

-(void) setTeamName:(NSString *)team league:(NSString *)league emblem:(NSString *)emblem
{
    self.teamName = team;
    self.leagueName = league;
    self.emblemUrl = emblem;
    
    [self.teamNameLabel setText: self.teamName];
    [self.leagueNameLabel setText: self.leagueName];
    [self.emblemImageView setImage:[UIImage imageNamed:self.emblemUrl]];
}

@end
