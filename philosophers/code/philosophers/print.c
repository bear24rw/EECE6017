/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Random Number Gen                                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.              *
 ***************************************************************************/

#include <stdio.h>
#include <unistd.h>
#include <stdarg.h>
#include "includes.h"
#include "print.h"

// mutex to protect ourselves while we print out a line
OS_EVENT *print_lock;

// when set to 1 each eater will display its prints on the same line every time
// when set to 0 each print will be on a new line (like usual)
char print_inplace = 1;

// 1 = print out debug lines
// 0 = skip debug lines
char print_debug = 0;

// keeps track of how many times print got called
// used to make sure we are recieving the lines in
// the order in which they were printed
int print_count = 0;

// reset the print count
// create the mutex
void init_print(void) {
    print_count = 0;
    print_lock = OSSemCreate(1);
}

// prints out a line in this format:
//
// [print_count] [Eater: num] [Bites: bites] ...
//
void print(int type, int num, int bites, char *format, ...) {

    // if we are skipping debug lines don't do anything
    if (type == DEBUG && !print_debug) return;

    // obtain the lock so no other thread can interrupt us
    OSSemPend(print_lock, 0, NULL);

    // if we are printing each line in place go to a unique Y coordinate
    // depending on which eater we are, then clear the line
    if (print_inplace) {
        goto_line(1, num+1);
        clear_line();
    }

    // print which print number this is in gray
    set_color(30);
    printf("[%4d] ", print_count);

    // if print type is normal then choose a uniq color based on our number
    // other wise set the color to gray
    if (type == NORM)
        set_color(31+num);
    else
        set_color(30);

    // print which eater we are and how many bites we've taken
    printf("[Eater: %d] [Bites: %d] ", num, bites);

    // print the formatted string
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);

    // we just printed a line, increment the count
    print_count++;

    // we're done, release the lock
    OSSemPost(print_lock);
}

