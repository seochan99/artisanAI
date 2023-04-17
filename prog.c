#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_LINE 80    // 명령어 길이 최대값
#define MAX_HISTORY 10 // 최대 저장할 명령어 수

int should_run = 1;         // 루프 제어 변수
char *history[MAX_HISTORY]; // 최근에 입력한 명령어를 저장할 배열
int history_count = 0;      // 저장된 명령어의 수

// 최근에 입력한 명령어를 출력하는 함수
void print_history()
{

    int i;
    // i = 0부터 history_count까지 반복
    for (i = 0; i < history_count; i++)
    {
        // history[i]에 저장된 명령어를 출력
        printf("%d %s\n", i + 1, history[i]);
    }
}

int main(void)
{
    char *args[MAX_LINE / 2 + 1]; // 파싱한 명령어를 저장할 배열
    int should_wait;              // 백그라운드 실행 여부
    int i, j;                     // 반복문 제어 변수

    // 루프 시작
    // should_run이 0이 될 때까지 반복
    while (should_run)
    {
        printf("osh> "); // 프롬프트 출력
        fflush(stdout);  // 버퍼 비우기

        // 명령어를 입력받음
        char line[MAX_LINE];
        // fgets() 함수로 입력받은 명령어를 line에 저장
        fgets(line, MAX_LINE, stdin);

        // 입력받은 명령어를 히스토리에 저장
        if (history_count < MAX_HISTORY)
        {
            // line에 저장된 명령어를 history[history_count]에 복사
            history[history_count] = strdup(line);
            // history_count를 1 증가
            history_count++;
        }
        else // history_count가 MAX_HISTORY와 같거나 클 때
        {
            free(history[0]); //
            for (i = 0; i < history_count - 1; i++)
            {
                history[i] = history[i + 1];
            }
            history[history_count - 1] = strdup(line);
        }

        // 개행 문자를 널 문자로 대체
        if (line[strlen(line) - 1] == '\n')
        {
            line[strlen(line) - 1] = '\0';
        }

        // 명령어 파싱
        i = 0;
        args[i] = strtok(line, " ");
        while (args[i] != NULL)
        {
            i++;
            args[i] = strtok(NULL, " ");
        }

        // 백그라운드 실행 여부 확인
        should_wait = 1;
        if (i > 0 && strcmp(args[i - 1], "&") == 0)
        {
            should_wait = 0;
            args[i - 1] = NULL;
        }

        // 종료 명령어 처리
        if (strcmp(args[0], "exit") == 0)
        {
            should_run = 0;
            break;
        }

        // 히스토리 명령어 처리
        if (strcmp(args[0], "history") == 0)
        {
            print_history();
            continue;
        }

        // 새 프로세스 생성
        pid_t pid;
        pid = fork();
        if (pid == 0)
        { // 자식 프로세스
            // execvp() 함수로 명령어 실행
            if (execvp(args[0], args) == -1)
            {
                printf("Invalid command\n");
            }
            exit(0);
        }
        else if (pid < 0)
        { // 오류 발생
            printf("Fork failed\n");
        }
        else
        { // 부모 프로세스
            if (should_wait)
            { // 백그라운드 실행이 아닐 경우, 자식 프로세스가 끝날
              // 때까지 기다림
                waitpid(pid, NULL, 0);
            }
        }
    }
    return 0;
}