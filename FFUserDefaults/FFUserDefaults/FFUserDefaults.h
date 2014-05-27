//
//  FFUserDefaults.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFUserDefaults : NSObject

@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;

- (instancetype)initWithDefaults:(NSDictionary *)defaults;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context NS_REQUIRES_SUPER;

@end
