//
//  PlayerTableViewCell.m
//  iosTest
//
//  Created by udong on 2015. 9. 10..
//  Copyright (c) 2015년 udong. All rights reserved.
//

#import "PlayerTableViewCell.h"

@interface PlayerTableViewCell ()

@property (nonatomic,retain) NSString *playerImgUrl;
@property (nonatomic,retain) NSString *playerPosition;
@property (nonatomic,retain) NSString *playerName;

@property (nonatomic,retain) UIImageView *playerImageView;
@property (nonatomic,retain) UILabel *playerPositionLabel;
@property (nonatomic,retain) UILabel *playerNameLabel;

@end

@implementation PlayerTableViewCell

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
        self.playerImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, cellHeight-10, cellHeight-10)] autorelease];
        self.playerImageView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.playerImageView];
        
        self.playerPositionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(cellHeight, 0, self.frame.size.width - cellHeight, self.frame.size.height / 3)] autorelease];
        self.playerPositionLabel.backgroundColor = [UIColor whiteColor];
        self.playerPositionLabel.textColor = [UIColor grayColor];
        [self.playerPositionLabel setFont:[UIFont systemFontOfSize:8]];
        
        [self.contentView addSubview:self.playerPositionLabel];
        
        self.playerNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(cellHeight, self.frame.size.height / 3, self.frame.size.width - cellHeight, self.frame.size.height * 2 / 3)] autorelease];
        self.playerNameLabel.backgroundColor = [UIColor whiteColor];
        self.playerNameLabel.textColor = [UIColor blackColor];
        [self.playerNameLabel setFont:[UIFont systemFontOfSize:15]];
        self.playerNameLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:self.playerNameLabel];
    }

    return self;
}

-(void)setPlayerName:(NSString *)name playerPosition:(NSString *)position playerImgUrl:(NSString *)imgUrl
{
    self.playerName = name;
    self.playerPosition = position;
    self.playerImgUrl = imgUrl;
    
    [self.playerNameLabel setText:self.playerName];
    [self.playerPositionLabel setText:self.playerPosition];
    [self.playerImageView setImage:[UIImage imageNamed:self.playerImgUrl]];
}

@end
