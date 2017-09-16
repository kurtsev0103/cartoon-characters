//
//  OKDetailsViewController.m
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKDetailsViewController.h"
#import "OKFavoriteCharacter+CoreDataProperties.h"
#import "OKServerManager.h"
#import "OKDataManager.h"
#import "OKCharacter.h"
#import "OKUtils.h"

@interface OKDetailsViewController ()

@property (nonatomic, strong) NSManagedObjectContext* context;

@end

@implementation OKDetailsViewController

static NSInteger limit = 500;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate.character = nil;
    self.delegate.indexPath = nil;
    
    if (self.character) {
        [self setParameters];
    }

    self.context = [OKDataManager sharedManager].persistentContainer.viewContext;
    
    UIImage* image = [UIImage imageNamed:@"safari.png"];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(actionGoToSite:)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)setParameters {
    
    self.characterNameLabel.text = self.navigationItem.title = self.character.nameCharacter;
    self.characterImageView.image = self.character.imageCharacter;
    
    [self getImageForButton];
    
    __weak UITextView* weakTextView = self.characterTextView;

    [[OKServerManager sharedManager]
     getDetailsCharacterWithId:self.character.idCharacter
     abstractLimit:limit
     onSuccess:^(NSArray *array) {
         
         self.character.textAboutCharacter = [array firstObject];

         dispatch_async(dispatch_get_main_queue(), ^{
             weakTextView.text = [array firstObject];
         });
         
     } onFailure:^(NSError *error) {
         NSLog(@"Error - %@", [error localizedDescription]);
     }];
}

- (void)getImageForButton {
    
    UIImage* onImage = FAVORITE_IS_ON_IMAGE;
    UIImage* offImage = FAVORITE_IS_OFF_IMAGE;
    
    if (self.character.isFavorite == YES) {
        [self.favoriteButton setImage:onImage forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:offImage forState:UIControlStateNormal];
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

- (void)saveFavoriteCharacterFromCharacter {
    OKFavoriteCharacter* favCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"OKFavoriteCharacter"
                                                                      inManagedObjectContext:self.context];
    favCharacter.nameCharacter = self.character.nameCharacter;
    favCharacter.textAboutCharacter = self.character.textAboutCharacter;
    favCharacter.linkWikiCharacter = self.character.linkWikiCharacter;
    favCharacter.idCharacter = self.character.idCharacter;
    
    NSData* imageData = UIImagePNGRepresentation(self.character.imageCharacter);
    favCharacter.imageCharacter = imageData;
    
    [[OKDataManager sharedManager] saveContext];
}

- (void)deleteFavoriteCharacter {
    NSArray* allFavCharacters = [self allFavoriteCharacters];
    
    for (OKFavoriteCharacter* favCharacter in allFavCharacters) {
        if (favCharacter.idCharacter == self.character.idCharacter) {
            [self.context deleteObject:favCharacter];
            [[OKDataManager sharedManager] saveContext];
        }
    }
}

#pragma mark - Actions

- (void)actionGoToSite:(UIBarButtonItem*)sender {
    NSString* baseURL = @"http://muppet.wikia.com";
    NSString* urlString = [NSString stringWithFormat:@"%@%@", baseURL, self.character.linkWikiCharacter];
    NSURL* url = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url
                                       options:@{}
                             completionHandler:nil];
}

- (IBAction)actionAddOrRemoveFavoriteCharacter:(UIButton *)sender {
    UIImage* imageOff = FAVORITE_IS_OFF_IMAGE;
    UIImage* imageOn = FAVORITE_IS_ON_IMAGE
    
    if ([sender.imageView.image isEqual:imageOff]) {
        [sender setImage:imageOn forState:UIControlStateNormal];
        [self saveFavoriteCharacterFromCharacter];
        self.character.isFavorite = YES;
    } else {
        [sender setImage:imageOff forState:UIControlStateNormal];
        [self deleteFavoriteCharacter];
        self.character.isFavorite = NO;
    }
    
    self.delegate.character = self.character;
    self.delegate.indexPath = self.indexPath;
}

@end
