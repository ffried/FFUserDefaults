//
//  FFUDProperty+Internal.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUDProperty.h"

@interface FFUDProperty (Internal)
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortType;
@property (nonatomic, strong) NSString *fullType;
@property (nonatomic, strong) NSString *instanceVariable;
@property (nonatomic, strong) NSString *getter;
@property (nonatomic, strong) NSString *setter;

@property (nonatomic, getter = isPrimitive) BOOL primitive;
@property (nonatomic, getter = isReadonly) BOOL readonly;
@property (nonatomic, getter = isNonatomic) BOOL nonatomic;
@property (nonatomic, getter = isDynamic) BOOL dynamic;
@property (nonatomic, getter = isCopy) BOOL copy;
@property (nonatomic, getter = isWeak) BOOL weak;
@property (nonatomic, getter = isStrong) BOOL strong;

+ (NSString *)fullTypeForPrimitiveShortType:(NSString *)type;
@end
