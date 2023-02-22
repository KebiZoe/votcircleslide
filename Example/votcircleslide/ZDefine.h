//
//  ZDefine.h
//  votcircleslide
//
//  Created by s.zengxiangxian@byd.com on 2023/2/17.
//  Copyright © 2023 s.zengxiangxian@byd.com. All rights reserved.
//

#ifndef ZDefine_h
#define ZDefine_h

//十六进制色值
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* ZDefine_h */
