/*
 *  nonstdlib.h
 *  KwSing
 *
 *  Created by YeeLion on 11-3-1.
 *  Copyright 2011 Kuwo Beijing Co., Ltd. All rights reserved.
 *
 */

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#ifndef _KUWO_STDLIB_H__
#define _KUWO_STDLIB_H__

#ifdef __cplusplus
extern "C" {
#endif
    
#define MINCHAR     0x80        
#define MAXCHAR     0x7f        
#define MINSHORT    0x8000      
#define MAXSHORT    0x7fff      
#define MINLONG     0x80000000  
#define MAXLONG     0x7fffffff  
#define MAXBYTE     0xff        
#define MAXWORD     0xffff      
#define MAXDWORD    0xffffffff  

//
// Return the number of elements in a statically sized array.
//   DWORD Buffer[100];
//   RTL_NUMBER_OF(Buffer) == 100
// This is also popularly known as: NUMBER_OF, ARRSIZE, _countof, NELEM, etc.
//
#define RTL_NUMBER_OF_V1(A) (sizeof(A)/sizeof((A)[0]))

#if defined(__cplusplus) && \
    !defined(MIDL_PASS) && \
    !defined(RC_INVOKED) && \
    !defined(_PREFAST_) && \
    (_MSC_FULL_VER >= 13009466) && \
    !defined(SORTPP_PASS)
    //
    // RtlpNumberOf is a function that takes a reference to an array of N Ts.
    //
    // typedef T array_of_T[N];
    // typedef array_of_T &reference_to_array_of_T;
    //
    // RtlpNumberOf returns a pointer to an array of N chars.
    // We could return a reference instead of a pointer but older compilers do not accept that.
    //
    // typedef char array_of_char[N];
    // typedef array_of_char *pointer_to_array_of_char;
    //
    // sizeof(array_of_char) == N
    // sizeof(*pointer_to_array_of_char) == N
    //
    // pointer_to_array_of_char RtlpNumberOf(reference_to_array_of_T);
    //
    // We never even call RtlpNumberOf, we just take the size of dereferencing its return type.
    // We do not even implement RtlpNumberOf, we just decare it.
    //
    // Attempts to pass pointers instead of arrays to this macro result in compile time errors.
    // That is the point.
    //
    extern "C++" // templates cannot be declared to have 'C' linkage
    template <typename T, size_t N>
    char (*RtlpNumberOf( UNALIGNED T (&)[N] ))[N];

    #define RTL_NUMBER_OF_V2(A) (sizeof(*RtlpNumberOf(A)))
    
#else
    #define RTL_NUMBER_OF_V2(A) RTL_NUMBER_OF_V1(A)
#endif

#ifdef ENABLE_RTL_NUMBER_OF_V2
    #define RTL_NUMBER_OF(A) RTL_NUMBER_OF_V2(A)
#else
    #define RTL_NUMBER_OF(A) RTL_NUMBER_OF_V1(A)
#endif

//
// ARRAYSIZE is more readable version of RTL_NUMBER_OF_V2, and uses
// it regardless of ENABLE_RTL_NUMBER_OF_V2
//
// _ARRAYSIZE is a version useful for anonymous types
//
#define ARRAYSIZE(A)    RTL_NUMBER_OF_V2(A)
#define _ARRAYSIZE(A)   RTL_NUMBER_OF_V1(A)

#ifdef __cplusplus
}

#endif


#endif  // _KUWO_STDLIB_H__
