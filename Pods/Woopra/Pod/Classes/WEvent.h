//
//  WEvent.h
//  WTracker
//
//  Created by Boris Remizov on 1/23/13.
//
//

#import "WPropertiesContainer.h"
#import <Foundation/Foundation.h>

@interface WEvent : WPropertiesContainer

- (id)initWithName:(NSString*)name;

+ (WEvent*)eventWithName:(NSString*)name;

@end
