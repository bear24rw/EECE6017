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
#define PRI_GREEN_TIME      5
#define PRI_YELLOW_TIME     1
#define PRI_RED_TIME        0   // really SEC_GREEN_TIME
#define SEC_GREEN_TIME      2
#define SEC_YELLOW_TIME     1
#define SEC_RED_TIME        0   // really PRI_GREEN_TIME
#define TURN_GREEN_TIME     2
#define TURN_YELLOW_TIME    2
#define TURN_RED_TIME       0

// light indexes
#define PRI_STRAIGHT_1      0
#define PRI_STRAIGHT_2      1
#define PRI_TURN_1          2
#define PRI_TURN_2          3
#define SEC_1               4
#define SEC_2               5

// traffic states
#define PRI_GREEN   0
#define PRI_YELLOW  1
#define PRI_RED     2 
#define SEC_GREEN   3
#define SEC_YELLOW  4
#define SEC_RED     5

// turn lane states
#define CHECK_CARS      0
#define WAIT_FOR_GREEN  1
#define TURN_GREEN      2
#define TURN_YELLOW     3
#define TURN_RED        4

enum light_states {
    RED,
    YELLOW,
    GREEN
};

// helper functions to make code more readable
extern inline void pend(OS_EVENT *pevent);
extern inline void post(OS_EVENT *pevent);

#define delay(x)     OSTimeDlyHMSM(0,0,x,0)
#define delay_ms(x)  OSTimeDlyHMSM(0,0,0,x)

#endif
