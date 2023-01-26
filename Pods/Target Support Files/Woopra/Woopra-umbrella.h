#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WEvent.h"
#import "WPinger.h"
#import "WPropertiesContainer.h"
#import "WTracker.h"
#import "WVisitor.h"

FOUNDATION_EXPORT double WoopraVersionNumber;
FOUNDATION_EXPORT const unsigned char WoopraVersionString[];

