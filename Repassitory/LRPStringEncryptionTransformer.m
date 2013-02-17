//
//  LRPStringEncryptionTransformer.m
//  Repassitory
//
//  Created by Lansdon Page on 2/16/13.
//  Copyright (c) 2013 Lansdon Page. All rights reserved.
//

#import "LRPStringEncryptionTransformer.h"

@implementation LRPStringEncryptionTransformer


+ (Class)transformedValueClass
{
    return [NSString class];
}

- (id)transformedValue:(NSString*)string
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [super transformedValue:data];
}

- (id)reverseTransformedValue:(NSData*)data {
    if (nil == data) {
        return nil;
    }
    
    data = [super reverseTransformedValue:data];
    
    return [[NSString alloc] initWithBytes:[data bytes]
                                    length:[data length]
                                  encoding:NSUTF8StringEncoding];
//            autorelease];
}

@end
