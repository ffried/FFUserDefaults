//
//  FFUDProperty.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFUDProperty : NSObject <NSSecureCoding>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *shortType;
@property (nonatomic, strong, readonly) NSString *fullType;
@property (nonatomic, strong, readonly) NSString *instanceVariable;
@property (nonatomic, strong, readonly) NSString *getter;
@property (nonatomic, strong, readonly) NSString *setter;

@property (nonatomic, readonly, getter = isReadonly) BOOL readonly;
@property (nonatomic, readonly, getter = isNonatomic) BOOL nonatomic;
@property (nonatomic, readonly, getter = isDynamic) BOOL dynamic;
@property (nonatomic, readonly, getter = isCopy) BOOL copy;
@property (nonatomic, readonly, getter = isWeak) BOOL weak;
@property (nonatomic, readonly, getter = isStrong) BOOL strong;

@property (nonatomic, strong, readonly) NSString *userDefaultsKey;

@end
