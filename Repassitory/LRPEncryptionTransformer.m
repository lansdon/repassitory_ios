 //
//  LRPEncryptionTransformer.m
//  Repassitory
//
//  Created by Lansdon Page on 2/15/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPEncryptionTransformer.h"
#import "LRPAppState.h"
#import "LRPUser.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@implementation LRPEncryptionTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (NSString*)key
{
    // User key
    return [LRPAppState getKey];
//    return @"stuff";
}

- (id)transformedValue:(NSData*)data
{
    // If there's no key (e.g. during a data migration), don't try to transform the data
    if (nil == [self key])
    {
        return data;
    }
    
    if (nil == data)
    {
        return nil;
    }
//    return [data dataAES256EncryptedWithKey:[self key]];
    NSError *error = nil;
    return [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:[self key] error:&error];
}

- (id)reverseTransformedValue:(NSData*)data
{
    // If there's no key (e.g. during a data migration), don't try to transform the data
    if (nil == [self key])
    {
        return data;
    }
    
    if (nil == data)
    {
        return nil;
    }
    
//    return [data dataAES256DecryptedWithKey:[self key]];
    NSError *error = nil;
    return [RNDecryptor decryptData:data withPassword:[self key] error:&error];
}

@end