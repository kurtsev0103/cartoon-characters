//
//  OKFavoriteCharacter+CoreDataProperties.m
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKFavoriteCharacter+CoreDataProperties.h"

@implementation OKFavoriteCharacter (CoreDataProperties)

+ (NSFetchRequest<OKFavoriteCharacter *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OKFavoriteCharacter"];
}

@dynamic nameCharacter;
@dynamic textAboutCharacter;
@dynamic linkWikiCharacter;
@dynamic imageCharacter;
@dynamic idCharacter;

@end
