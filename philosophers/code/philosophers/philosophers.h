/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Dining Philosophers                                 *
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

#ifndef ENUMERATIONS_H_
#define ENUMERATIONS_H_

#define NUM_EATERS      5
#define TASK_STACKSIZE  2048

// eater states
enum eater_states {
    THINKING,
    EATING,
    WAITING_LEFT,
    WAITING_RIGHT,
    PUTTING_LEFT,
    PUTTING_RIGHT
};

// eater structure
typedef struct {
    int num;            // which eater are we
    int right_fork;     // index of fork to our right
    int left_fork;      // index of fork to our left
    int time;           // how much time to think and eat
    int bites;          // how many bites of food
    int state;          // which state the eater is in
} Eater;

#endif
