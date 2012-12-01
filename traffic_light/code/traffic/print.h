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

// ANSI color codes
#define FG_BLACK        30
#define FG_RED          31
#define FG_GREEN        32
#define FG_YELLOW       33
#define FG_BLUE         34
#define FG_MAGENTA      35
#define FG_CYAN         36
#define FG_WHITE        37

#define BG_BLACK        40
#define BG_RED          41
#define BG_GREEN        42
#define BG_YELLOW       43
#define BG_BLUE         44
#define BG_MAGENTA      45
#define BG_CYAN         46
#define BG_WHITE        47

// ANSI control helper macros
#define set_color(x)        printf("\e[0;%dm", x)
#define set_color_bold(x)   printf("\e[1;%dm", x)
#define set_color_inv(x)    printf("\e[7;%dm", x)
#define goto_line(x,y)      printf("\e[%d;%dH",y,x)
#define clear_line()        printf("\e[K")
#define clear_screen()      printf("\e[2J")
#define reset_color()       printf("\e[0m")

void draw_init(void);
void draw_lights(void);
void draw_street(void);
void draw_car(char yes);
void draw_status(int y, const char *msg);
void draw_walk(int state);
void draw_reset(void);
void draw_background(void);
void draw_keymap(void);

#endif
