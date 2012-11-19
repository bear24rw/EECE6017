/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Print functions                                     *
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

#ifndef _PRINT_H_
#define _PRINT_H_

// types of prints
enum print_types {
    INFO,
    DEBUG
};

// ANSI control helper macros
#define set_color(x)        printf("\e[0;%dm", x)
#define set_color_bold(x)   printf("\e[1;%dm", x)
#define goto_line(x,y)      printf("\e[%d;%dH",y,x)
#define clear_line()        printf("\e[K")
#define clear_screen()      printf("\e[2J")

void init_print(void);
void print(int type, Eater eater);

#endif
