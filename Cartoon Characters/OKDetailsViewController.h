//
//  OKDetailsViewController.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OKCharacter;

@protocol OKDetailsViewControllerDelegate <NSObject>

@property (nonatomic, strong) OKCharacter* character;
@property (nonatomic, strong) NSIndexPath* indexPath;

@end

@interface OKDetailsViewController : UIViewController

//delegate
@property (weak, nonatomic) id <OKDetailsViewControllerDelegate> delegate;
@property (strong, nonatomic) OKCharacter* character;
@property (nonatomic, strong) NSIndexPath* indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *characterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *characterTextView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)actionAddOrRemoveFavoriteCharacter:(UIButton *)sender;

@end
