//
//  OKDataManager.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface OKDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (OKDataManager*)sharedManager;

@end
