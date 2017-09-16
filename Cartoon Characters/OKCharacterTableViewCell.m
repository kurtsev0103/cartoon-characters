//
//  OKCharacterTableViewCell.m
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKCharacterTableViewCell.h"
#import "OKUtils.h"

@implementation OKCharacterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:@"OKCharacterTableViewCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
        
        UIImage* image = FAVORITE_IS_OFF_IMAGE;
        [self.favoriteButton setImage:image forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - Actions

- (IBAction)actionAddOrRemoveFavoriteCharacter:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButtonOnCellAtIndexPath:withData:)]) {
        [self.delegate didClickButtonOnCellAtIndexPath:_cellIndexPath withData:sender];
    }
}

@end
