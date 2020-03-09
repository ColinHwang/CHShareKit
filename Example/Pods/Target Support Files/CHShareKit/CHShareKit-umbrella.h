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

#import "CHShareKit.h"
#import "CHSKCredential.h"
#import "CHSKPlatformConfiguration.h"
#import "CHSKShare.h"
#import "CHSKShareMessage.h"
#import "CHSKUser.h"

FOUNDATION_EXPORT double CHShareKitVersionNumber;
FOUNDATION_EXPORT const unsigned char CHShareKitVersionString[];

