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

INT16U lfsr = 0xACE1; // seed
INT8U i;
INT16U spread;
INT16U mask;
INT16U result;

OS_EVENT *lock;

void init_random(void) {
    lock = OSSemCreate(1);
}


INT16U random(INT16U min, INT16U max) {

    if (min > max) return 0;
    if (min == max) return min;

    OSSemPend(lock, 0, NULL);

    spread = max - min;

    // increase mask size until it is just bigger than our max value
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

    } while (result > spread);

    result += min;

    OSSemPost(lock);

    return result;
}

