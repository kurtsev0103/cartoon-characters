//
//  OKCharacterTableViewCell.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKCellDelegate.h"

@interface OKCharacterTableViewCell : UITableViewCell

//delegate
@property (nonatomic, weak) id <OKCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath* cellIndexPath;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *characterTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)actionAddOrRemoveFavoriteCharacter:(UIButton *)sender;

@end
