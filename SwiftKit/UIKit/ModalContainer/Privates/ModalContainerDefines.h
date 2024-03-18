//
//  ModalContainerDefines.h
//  MarkCamera
//
//  Created by quanhua peng on 2024/3/1.
//

#ifndef ModalContainerDefines_h
#define ModalContainerDefines_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define PI_SAFE_BLOCK(BLOCK, ...) \
    do { \
        __auto_type __in_macro_block = BLOCK; \
        if (__in_macro_block) { \
            __in_macro_block(__VA_ARGS__);\
        } \
    } while (0)


#endif /* ModalContainerDefines_h */
