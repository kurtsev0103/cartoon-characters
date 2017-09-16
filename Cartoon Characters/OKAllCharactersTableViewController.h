//
//  OKAllCharactersTableViewController.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKCellDelegate.h"
#import "OKDetailsViewController.h"

@interface OKAllCharactersTableViewController : UITableViewController <OKCellDelegate, OKDetailsViewControllerDelegate>

@property (nonatomic, strong) OKCharacter* character;
@property (nonatomic, strong) NSIndexPath* indexPath;

@end
