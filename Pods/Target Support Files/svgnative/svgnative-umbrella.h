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

#import "svgnative/Config.h"
#import "svgnative/ports/cg/CGSVGRenderer.h"
#import "svgnative/Rect.h"
#import "svgnative/SVGDocument.h"
#import "svgnative/SVGNativeCWrapper.h"
#import "svgnative/SVGRenderer.h"

FOUNDATION_EXPORT double svgnativeVersionNumber;
FOUNDATION_EXPORT const unsigned char svgnativeVersionString[];

