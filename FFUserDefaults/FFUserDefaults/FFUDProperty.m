//
//  FFUDProperty.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUDProperty+Internal.h"
#import "NSString+CamelCase.h"
#import <objc/runtime.h>

static NSString *const FFUDKeyPrefix = @"FFUD";

extern NSString *FFUDKeyForPropertyName(NSString *propertyName)
{
    return [FFUDKeyPrefix stringByAppendingString:propertyName];
}

extern NSString *FFUDPropertyNameForUDKey(NSString *userDefaultsKey)
{
    return [userDefaultsKey substringFromIndex:FFUDKeyPrefix.length];
}

@interface FFUDProperty ()
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
@end

@implementation FFUDProperty

+ (NSString *)fullTypeForPrimitiveShortType:(NSString *)type
{
    NSDictionary *types =  @{@"c": @"char",
                             @"d": @"double",
                             @"i": @"int",
                             @"q": @"integer",
                             @"f": @"float",
                             @"l": @"long",
                             @"L": @"unsignedLong",
                             @"s": @"short",
                             @"S": @"unsignedShort",
                             @"B": @"bool",
                             @"I": @"unsignedInt",
                             @"Q": @"unsignedInteger"
                             };
    //    @{@"^?": @"function pointer",
    //      @"^v", @"void pointer"};
    return types[type];
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.fullType = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"fullType"];
        self.shortType = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"shortType"];
        self.primitive = [aDecoder decodeBoolForKey:@"primitive"];
        self.instanceVariable = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"instanceVariable"];
        self.getter = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"getter"];
        self.setter = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"setter"];
        self.readonly = [aDecoder decodeBoolForKey:@"readonly"];
        self.nonatomic = [aDecoder decodeBoolForKey:@"nonatomic"];
        self.dynamic = [aDecoder decodeBoolForKey:@"dynamic"];
        self.copy = [aDecoder decodeBoolForKey:@"copy"];
        self.weak = [aDecoder decodeBoolForKey:@"weak"];
        self.strong = [aDecoder decodeBoolForKey:@"strong"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.fullType forKey:@"fullType"];
    [aCoder encodeObject:self.shortType forKey:@"shortType"];
    [aCoder encodeBool:self.primitive forKey:@"primitive"];
    [aCoder encodeObject:self.instanceVariable forKey:@"instanceVariable"];
    [aCoder encodeObject:self.getter forKey:@"getter"];
    [aCoder encodeObject:self.setter forKey:@"setter"];
    [aCoder encodeBool:self.readonly forKey:@"readonly"];
    [aCoder encodeBool:self.nonatomic forKey:@"nonatomic"];
    [aCoder encodeBool:self.dynamic forKey:@"dynamic"];
    [aCoder encodeBool:self.copy forKey:@"copy"];
    [aCoder encodeBool:self.weak forKey:@"weak"];
    [aCoder encodeBool:self.strong forKey:@"strong"];
}

#pragma mark - NSObject
- (NSString *)description
{
    NSString *(^StringFromBOOL)(BOOL b) = ^NSString *(BOOL b) {
        return (b) ? @"YES" : @"NO";
    };
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"<%@ %p> {", NSStringFromClass([self class]), self];
    [desc appendFormat:@"%@ %@ (%@):\r", self.name, self.fullType, self.shortType];
    [desc appendFormat:@"    - instance variable: %@\r", self.instanceVariable];
    [desc appendFormat:@"    - getter: %@\r", self.getter];
    [desc appendFormat:@"    - setter: %@\r", self.setter];
    [desc appendFormat:@"    - primitive: %@\r", StringFromBOOL(self.isPrimitive)];
    [desc appendFormat:@"    - readonly: %@\r", StringFromBOOL(self.isReadonly)];
    [desc appendFormat:@"    - nonatomic: %@\r", StringFromBOOL(self.isNonatomic)];
    [desc appendFormat:@"    - dynamic: %@\r", StringFromBOOL(self.isDynamic)];
    [desc appendFormat:@"    - copy: %@\r", StringFromBOOL(self.isCopy)];
    [desc appendFormat:@"    - weak: %@\r", StringFromBOOL(self.isWeak)];
    [desc appendFormat:@"    - strong: %@\r}", StringFromBOOL(self.isStrong)];
    return [desc copy];
}

- (NSUInteger)hash
{
    return self.name.hash ^ self.fullType.hash ^ self.shortType.hash;
}

- (BOOL)isEqual:(id)object
{
    if (!object) return NO;
    if (![object isKindOfClass:[self class]]) return NO;
    __typeof(self) obj = object;
    return [obj.name isEqualToString:self.name] &&
    [obj.shortType isEqualToString:self.shortType] &&
    [obj.fullType isEqualToString:self.fullType];
}

#pragma mark - Properties
- (NSString *)getter
{
    if (!_getter) {
        _getter = [self.name copy];
    }
    return _getter;
}

- (NSString *)setter
{
    if (!_setter) {
        _setter = [NSString stringWithFormat:@"set%@:", [self.name camelCaseString]];
    }
    return _setter;
}

- (NSString *)userDefaultsKey
{
    NSString *camelCaseName = [self.name camelCaseString];
    NSString *key = [FFUDKeyPrefix stringByAppendingString:camelCaseName];
    return key;
}

- (NSString *)getterFormat
{
    NSString *standardFormat = @"@:";
    if (self.isPrimitive) {
        return [NSString stringWithFormat:@"%@%@", self.shortType, standardFormat];
    } else {
        if ([self.shortType isEqualToString:@"@"]) {
            return [NSString stringWithFormat:@"@%@", standardFormat];
        } else {
            return [NSString stringWithFormat:@"@\"%@\"%@", self.shortType, standardFormat];
//            return [NSString stringWithFormat:@"@%@", standardFormat];
        }
        
    }
}

- (NSString *)setterFormat
{
    NSString *standardFormat = @"v@:";
    if (self.isPrimitive) {
        return [NSString stringWithFormat:@"%@%@", standardFormat, self.shortType];
    } else {
        if ([self.shortType isEqualToString:@"@"]) {
            return [NSString stringWithFormat:@"%@@", standardFormat];
        } else {
            return [NSString stringWithFormat:@"%@@\"%@\"", standardFormat, self.shortType];
//            return [NSString stringWithFormat:@"%@@", standardFormat];
        }
    }
}

@end

extern FFUDProperty *FFUDPropertyForObjCProperty(objc_property_t property) {
    FFUDProperty *prop = [[FFUDProperty alloc] init];
    prop.name = [NSString stringWithUTF8String:property_getName(property)];
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    printf("attributes=%s\n", attributes);
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            if (attribute[1] != '@') {
                // it's a C primitive type:
                const char *type = [[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
                prop.shortType = [NSString stringWithUTF8String:type];
                prop.fullType = [FFUDProperty fullTypeForPrimitiveShortType:prop.shortType];
                prop.primitive = YES;
            } else if (attribute[1] == '@' && strlen(attribute) == 2) {
                // it's an ObjC id type:
                prop.shortType = @"@";
                prop.fullType = @"id";
            } else if (attribute[1] == '@') {
                // it's another ObjC object type:
                const char *type = (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
                prop.shortType = [NSString stringWithUTF8String:type];
                prop.fullType = [NSString stringWithUTF8String:type];
            }
        } else if (attribute[0] == 'V') { // Instance Variable
            prop.instanceVariable = [NSString stringWithUTF8String:(const char *)[[NSData dataWithBytes:(attribute + 1)
                                                                                                 length:strlen(attribute) - 1] bytes]];
        } else if (attribute[0] == 'R') { // Readonly
            prop.readonly = YES;
        } else if (attribute[0] == 'N') { // Nonatomic
            prop.nonatomic = YES;
        } else if (attribute[0] == 'D') { // Dynamic
            prop.dynamic = YES;
        } else if (attribute[0] == 'G') { // Getter
            prop.getter = [NSString stringWithUTF8String:(const char *)[[NSData dataWithBytes:(attribute + 1)
                                                                                       length:strlen(attribute) - 1] bytes]];
        } else if (attribute[0] == 'S') { // Setter
            prop.setter = [NSString stringWithUTF8String:(const char *)[[NSData dataWithBytes:(attribute + 1)
                                                                                       length:strlen(attribute) - 1] bytes]];
        } else if (attribute[0] == 'C') { // Copy
            prop.copy = YES;
        } else if (attribute[0] == '&') { // Strong
            prop.strong = YES;
        } else if (attribute[0] == 'W') { // Weak
            prop.weak = YES;
        }
    }
    return prop;
}
