
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "includes.h"
#include "alt_ucosii_simple_error_check.h"
#include "reader_writer.h"



/* Definition of shared_buf_sem Semaphore */
OS_EVENT *mutex_no_accessing;
OS_EVENT *mutex_reader_count;
OS_EVENT *mutex_no_waiting;

/* Definition of Task Stacks */
OS_STK reader_1_stk[TASK_STACKSIZE];
OS_STK reader_2_stk[TASK_STACKSIZE];
OS_STK reader_3_stk[TASK_STACKSIZE];
OS_STK writer_stk[TASK_STACKSIZE];

// number of readers accessing the buffer
unsigned char readers = 0;

void elipsis(){
	INT8U i;
	for(i=0; i<3; i++){
		printf(".");
		OSTimeDlyHMSM(0,0,1,0);
	}
}

void reader(void *pdata){
	INT8U return_code;

	while(true)
	{
		OSSemPend(mutex_no_waiting, 0, &return_code);

		OSSemPend(mutex_reader_count, 0, &return_code);
        if (readers == 0)
            OSSemPend(mutex_no_accessing, 0, &return_code);
        readers++;
        OSSemPost(mutex_no_waiting);
        OSSemPost(mutex_reader_count);

        printf("\e[1;36mReader %d: ", pdata);
        INT8U index = 0;
        while(index < book_mark){
            printf("%s ", book[index][0]);
            index += 1;
        }
        printf("\n");

        OSSemPend(mutex_reader_count, 0, &return_code);
        readers--;
        if (readers == 0)
            OSSemPost(mutex_no_accessing);
        OSSemPost(mutex_reader_count);
        
        OSTimeDlyHMSM(0,0,1,0);
	}
}

void writer(void *pdata){
	INT8U return_code;

	while(true){

		OSSemPend(mutex_no_waiting, 0 , &return_code);
		OSSemPend(mutex_no_accessing, 0 , &return_code);
        OSSemPost(mutex_no_waiting);

		if(book_mark == WORDS_IN_BOOK -1){
			book_mark = 0;
		}

		book[book_mark][0] = pangram[book_mark][0];
		printf("\e[1;31mWriter: %s \n", book[book_mark][0]);

		book_mark += 1;

        OSSemPost(mutex_no_accessing);

        OSTimeDlyHMSM(0,0,1,0);
	}
}


void  reader_writer_init()
{
	INT8U return_code = OS_NO_ERR;
	book_mark = 0;

	//initialize pangram
	pangram[0][0] = "A\0";
	pangram[1][0] = "quick\0";
	pangram[2][0] = "brown\0";
	pangram[3][0] = "fox\0";
	pangram[4][0] = "jumps\0";
	pangram[5][0] = "over\0";
	pangram[6][0] = "the\0";
	pangram[7][0] = "lazy\0";\
	pangram[8][0] = "dog\0";

	//create writer
	return_code = OSTaskCreate(writer, NULL, (void*)&writer_stk[TASK_STACKSIZE-1], WRITER_PRIO);
	alt_ucosii_check_return_code(return_code);

	//create reader
	return_code = OSTaskCreate(reader, (void*)1, (void*)&reader_1_stk[TASK_STACKSIZE-1], READER_1_PRIO);
	alt_ucosii_check_return_code(return_code);

	return_code = OSTaskCreate(reader, (void*)2, (void*)&reader_2_stk[TASK_STACKSIZE-1], READER_2_PRIO);
	alt_ucosii_check_return_code(return_code);

	return_code = OSTaskCreate(reader, (void*)3, (void*)&reader_3_stk[TASK_STACKSIZE-1], READER_3_PRIO);
	alt_ucosii_check_return_code(return_code);
}


int main (int argc, char* argv[], char* envp[])
{
    printf("\e[0m");
    printf("----------------------\n");
    
    mutex_no_accessing = OSSemCreate(1);
    mutex_reader_count = OSSemCreate(1);
    mutex_no_waiting = OSSemCreate(1);

    printf("Init..\n");

	reader_writer_init();
    
    printf("Starting..\n");

	OSStart();

	return 0;
}
