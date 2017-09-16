//
//  OKFavoriteCharacter+CoreDataProperties.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKFavoriteCharacter+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OKFavoriteCharacter (CoreDataProperties)

+ (NSFetchRequest<OKFavoriteCharacter *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nameCharacter;
@property (nullable, nonatomic, copy) NSString *textAboutCharacter;
@property (nullable, nonatomic, copy) NSString *linkWikiCharacter;
@property (nullable, nonatomic, retain) NSData *imageCharacter;
@property (nonatomic) int64_t idCharacter;

@end

NS_ASSUME_NONNULL_END
