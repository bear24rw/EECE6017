/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Traffic Light                                       *
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

#include "alt_ucosii_simple_error_check.h"

#ifndef __TRAFFIC_H__
#define __TRAFFIC_H__

#define TASK_STACKSIZE  2048

// light delay constants
#define PRI_GREEN_TIME      6
#define PRI_YELLOW_TIME     2
#define PRI_RED_TIME        2

#define SEC_GREEN_TIME      3
#define SEC_YELLOW_TIME     2
#define SEC_RED_TIME        2

#define TURN_GREEN_TIME     3
#define TURN_YELLOW_TIME    2
#define TURN_RED_TIME       2

#define WALK_GREEN_TIME     4
#define WALK_YELLOW_TIME    3
#define WALK_RED_TIME       2

#define FLASH_TIME          1


// light indexes
#define PRI_1       2
#define PRI_2       5
#define TURN_1      1
#define TURN_2      4
#define SEC_1       0
#define SEC_2       3

// task a
enum traffic_states {
    PRI_GREEN,
    PRI_YELLOW,
    PRI_RED,
    SEC_GREEN,
    SEC_YELLOW,
    SEC_RED
};

// task b
enum turn_lane_states {
    CHECK_CARS,
    WAIT_FOR_GREEN,
    TURN_GREEN,
    TURN_YELLOW,
    TURN_RED
};

// task c
enum cross_walk_states {
    CHECK_WALK,
    WAIT_FOR_RED,
    WALK_GREEN,
    WALK_YELLOW,
    WALK_RED
};

enum emergency_states {
    CHECK_EMERGENCY,
    FLASH_RED_ON,
    FLASH_RED_OFF
};


// task e
enum broken_states {
    CHECK_BROKEN,
    FLASH_ON,
    FLASH_OFF
};

enum light_states {
    RED,
    YELLOW,
    GREEN,
    WAITING,    // used for crosswalk
    OFF         // used for flashing
};

extern int lights[];
extern int manual_mode;
extern int selected_light;
extern int emergency_duration;

// helper functions to make code more readable
extern inline void pend(OS_EVENT *pevent);
extern inline void post(OS_EVENT *pevent);

#define delay(x)     OSTimeDlyHMSM(0,0,x,0)
#define delay_ms(x)  OSTimeDlyHMSM(0,0,0,x)

#endif
