
#ifndef ENUMERATIONS_H_
#define ENUMERATIONS_H_

#define MAX_WORD_SIZE 6
#define WORDS_IN_BOOK 9

char* pangram[WORDS_IN_BOOK][MAX_WORD_SIZE];
char* book[WORDS_IN_BOOK][MAX_WORD_SIZE];
INT8U book_mark;

#define true 1
#define false 0

#define TASK_STACKSIZE 2048

#define WRITER_PRIO     16
#define READER_1_PRIO   15
#define READER_2_PRIO   14
#define READER_3_PRIO   13

#endif /* ENUMERATIONS_H_ */
