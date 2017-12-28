//
//  Log.h
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#ifndef Log_h
#define Log_h

#ifdef DEBUG
#define Log(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define Log(...)
#endif

#ifdef DEBUG
#define LogCGRect(rect) NSLog(@"%@",NSStringFromCGRect(rect));
#else
#define LogCGRect(rect)
#endif

#ifdef DEBUG
#define LogCGPoint(point) NSLog(@"%@",NSStringFromCGPoint(point));
#else
#define LogCGPoint(point)
#endif

#endif /* Log_h */
