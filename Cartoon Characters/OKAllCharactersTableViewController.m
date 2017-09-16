//
//  OKAllCharactersTableViewController.m
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKAllCharactersTableViewController.h"
#import "OKFavoriteCharacter+CoreDataProperties.h"
#import "OKCharacterTableViewCell.h"
#import "OKDetailsViewController.h"
#import "OKServerManager.h"
#import "OKDataManager.h"
#import "OKCharacter.h"
#import "OKUtils.h"

@interface OKAllCharactersTableViewController ()

@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) NSMutableArray* showCharacters;
@property (nonatomic, strong) NSArray* allCharacters;

@end

@implementation OKAllCharactersTableViewController

static NSString* category = @"The_Muppets_Characters";
static NSInteger limit = 75;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Characters";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.context = [OKDataManager sharedManager].persistentContainer.viewContext;

    [self createSegmentedControl];
    [self getAllCharactersForWiki];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.character && self.segmentedControl.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
    } else if (self.character && self.segmentedControl.selectedSegmentIndex == 1) {
        [self.tableView beginUpdates];
        [self.showCharacters removeObjectAtIndex:self.indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - Actions

- (void)actionSegmentedControl:(UISegmentedControl*)sender {
    [self.showCharacters removeAllObjects];
    
    if (sender.selectedSegmentIndex == 0) {
        
        [self.showCharacters addObjectsFromArray:self.allCharacters];
        
    } else {
        
        for (OKCharacter* character in self.allCharacters) {
            if (character.isFavorite == YES) {
                [self.showCharacters addObject:character];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Methods

- (void)createSegmentedControl {
    NSArray* items = @[@"ALL", @"FAVORITE"];
    UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor blackColor];
    [segmentControl addTarget:self action:@selector(actionSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.segmentedControl = segmentControl;
}

- (void)getAllCharactersForWiki {
    
    [[OKServerManager sharedManager]
     getCharactersWithCategory:category
     limit:limit
     onSuccess:^(NSArray *characters) {
         
         NSArray* sortArray = [characters sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
             return [[obj1 nameCharacter] compare:[obj2 nameCharacter]];
         }];
         
         self.allCharacters = [NSArray arrayWithArray:sortArray];
         self.showCharacters = [NSMutableArray arrayWithArray:sortArray];
         [self checkWhetherAFavoriteCharacter];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
         
     } onFailure:^(NSError *error) {
         NSLog(@"Error - %@", [error localizedDescription]);
     }];
}

- (void)getImageForCharacter:(OKCharacter*)character  cell:(OKCharacterTableViewCell*)cell {
    
    cell.characterImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.characterImageView.layer.cornerRadius = cell.characterImageView.frame.size.width / 2;
    cell.characterImageView.clipsToBounds = YES;
    cell.characterImageView.image = nil;
    
    __weak OKCharacterTableViewCell* weakCell = cell;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSURL* urlString = [NSURL URLWithString:character.linkImageCharacter];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:urlString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            
            [UIView transitionWithView:weakCell.characterImageView
                              duration:0.3f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakCell.characterImageView.image = image;
                                character.imageCharacter = image;
                            } completion:nil];
            
            [weakCell layoutSubviews];
            
        });
    });
}

- (void)getImageForButton:(OKCharacter*)character  cell:(OKCharacterTableViewCell*)cell {
    
    UIImage* onImage = FAVORITE_IS_ON_IMAGE;
    UIImage* offImage = FAVORITE_IS_OFF_IMAGE;
    
    if (character.isFavorite == YES) {
        [cell.favoriteButton setImage:onImage forState:UIControlStateNormal];
    } else {
        [cell.favoriteButton setImage:offImage forState:UIControlStateNormal];
    }
}

- (NSArray*)allFavoriteCharacters {
    NSFetchRequest* request = [NSFetchRequest new];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"OKFavoriteCharacter"
                                                   inManagedObjectContext:self.context];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* allCharacters = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    return allCharacters;
}

- (void)saveFavoriteCharacterFromCharacter:(OKCharacter*)character {
    OKFavoriteCharacter* favCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"OKFavoriteCharacter"
                                                                      inManagedObjectContext:self.context];
    favCharacter.nameCharacter = character.nameCharacter;
    favCharacter.textAboutCharacter = character.textAboutCharacter;
    favCharacter.linkWikiCharacter = character.linkWikiCharacter;
    favCharacter.idCharacter = character.idCharacter;
   
    NSData* imageData = UIImagePNGRepresentation(character.imageCharacter);
    favCharacter.imageCharacter = imageData;
    
    [[OKDataManager sharedManager] saveContext];
}

- (void)deleteFavoriteCharacter:(OKCharacter*)character {
    NSArray* allFavCharacters = [self allFavoriteCharacters];
    
    for (OKFavoriteCharacter* favCharacter in allFavCharacters) {
        if (favCharacter.idCharacter == character.idCharacter) {
            [self.context deleteObject:favCharacter];
            [[OKDataManager sharedManager] saveContext];
        }
    }
}

- (void)checkWhetherAFavoriteCharacter {
    NSArray* allFavCharacters = [self allFavoriteCharacters];

    for (OKFavoriteCharacter* favCharacter in allFavCharacters) {
        for (OKCharacter* character in self.allCharacters) {
            if (favCharacter.idCharacter == character.idCharacter) {
                character.isFavorite = YES;
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showCharacters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    OKCharacterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[OKCharacterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    OKCharacterTableViewCell* myCell = (OKCharacterTableViewCell*)cell;
    
    OKCharacter* character = [self.showCharacters objectAtIndex:indexPath.row];

    myCell.characterNameLabel.text = character.nameCharacter;
    myCell.characterTextLabel.text = character.textAboutCharacter;
    
    if (!character.imageCharacter) {
        [self getImageForCharacter:character cell:myCell];
    } else {
        myCell.characterImageView.image = character.imageCharacter;
    }
    
    [self getImageForButton:character cell:myCell];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OKCharacterTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    float alpha = cell.backgroundImageView.alpha;
    cell.backgroundImageView.alpha = 1.f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.backgroundImageView.alpha = alpha;
    });

    OKCharacter* character = [self.showCharacters objectAtIndex:indexPath.row];
    OKDetailsViewController* vc = [OKDetailsViewController new];
    vc.delegate = self;
    vc.character = character;
    vc.indexPath = indexPath;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - OKCellDelegate

- (void)didClickButtonOnCellAtIndexPath:(NSIndexPath*)cellIndexPath withData:(id)data {
    UIButton* sender = (UIButton*)data;
    UIImage* imageOff = FAVORITE_IS_OFF_IMAGE;
    UIImage* imageOn = FAVORITE_IS_ON_IMAGE

    OKCharacter* character = [self.showCharacters objectAtIndex:cellIndexPath.row];
    
    if ([sender.imageView.image isEqual:imageOff]) {
        [sender setImage:imageOn forState:UIControlStateNormal];
        [self saveFavoriteCharacterFromCharacter:character];
        character.isFavorite = YES;
    } else {
        [sender setImage:imageOff forState:UIControlStateNormal];
        [self deleteFavoriteCharacter:character];
        character.isFavorite = NO;
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.tableView beginUpdates];
        [self.showCharacters removeObjectAtIndex:cellIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

@end
