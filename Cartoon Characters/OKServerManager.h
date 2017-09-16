//
//  OKServerManager.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OKServerManager : NSObject

+ (OKServerManager*)sharedManager;

- (void)getCharactersWithCategory:(NSString*)category
                            limit:(NSInteger)limit
                        onSuccess:(void(^)(NSArray* characters))success
                        onFailure:(void(^)(NSError* error))failure;

- (void)getDetailsCharacterWithId:(NSInteger)idCharacter
                    abstractLimit:(NSInteger)abstractLimit
                        onSuccess:(void(^)(NSArray* array))success
                        onFailure:(void(^)(NSError* error))failure;

@end
