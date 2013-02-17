//
//  LRPEncryptionTransformer.h
//  Repassitory
//
//  Created by Lansdon Page on 2/15/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRPEncryptionTransformer : NSValueTransformer
{}

/**
 * Returns the key used for encrypting / decrypting values during transformation.
 */
- (NSString*)key;

@end