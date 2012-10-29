/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Readers Writers                                     *
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

// number of reader tasks to spawn
#define NUM_READERS     3

// maximum number of characters in a word
#define MAX_WORD_SIZE   6

// number of words in a book
#define WORDS_IN_BOOK   9

#define TASK_STACKSIZE  2048

#define WRITER_PRIO     15
#define READER_PRIO     16

#define printf_reader(...) { printf("\e[1;36m"); printf(__VA_ARGS__);}
#define printf_writer(...) { printf("\e[1;31m"); printf(__VA_ARGS__);}
//#define printf_debug(...) { printf("\e[1;30m"); printf(__VA_ARGS__);}
#define printf_debug(...)

#endif /* ENUMERATIONS_H_ */
