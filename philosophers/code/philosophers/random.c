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
#include "includes.h"
#include "random.h"

INT16U lfsr = 0xACE1;   // random seed
INT8U i;
INT16U spread;          // diff between 'max' and 'min'
INT16U mask;            // bitmask to get the LFSR value close to the spread
INT16U result;          // result of bitmasking the lfsr value

OS_EVENT *lock;

void init_random(void) {
    lock = OSSemCreate(1);
}

// return a new random number between 'min' and 'max'
INT16U random(INT16U min, INT16U max) {

    // if min is greater than max there is nothing to choose between
    if (min > max) return 0;

    // if min equals max there is only one number to choose from
    if (min == max) return min;

    // capture the lock so we can work on the global variables
    OSSemPend(lock, 0, NULL);

    // figure out how much range there is
    // we are going to be generating number 0 -> spread
    // and then adding it back to 'min'
    spread = max - min;

    // use a bitmask to get the LFSR value as close as possible
    // increase mask size until it is just bigger than our spread value
    for (i = 1; i<16; i++) {

        mask = ~(0xFFFF << i);

        // if our masked value is bigger than max value
        if (mask > spread) break;
    }

    do { 
        // get new random number
        lfsr = (lfsr >> 1) ^ (-(lfsr & 1u) & 0xB400u);

        // mask the number to get it close to our spread
        result = lfsr & mask;

    // if the result, even after masking, is bigger than the spread try again
    } while (result > spread);

    // un-zero the value
    result += min;

    // we're done, release the lock
    OSSemPost(lock);

    return result;
}

