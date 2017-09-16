//
//  OKCellDelegate.h
//  Cartoon Characters
//
//  Created by Oleksandr Kurtsev on 14.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OKCellDelegate <NSObject>

- (void)didClickButtonOnCellAtIndexPath:(NSIndexPath*)cellIndexPath withData:(id)data;

@end
