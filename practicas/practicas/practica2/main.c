#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <fcntl.h>
#include <time.h>

#define ROWS 15
#define COLS 1000
#define MAX_NUM 30000

int matriz[ROWS][COLS];
int fd[3][2];  // Pipe descriptors for communication with level 2 processes
int shm_id;    // Shared memory ID for communication with level 2 processes

void generate_matrix() {
    srand(time(NULL));
    for (int i = 0; i < ROWS; ++i)
        for (int j = 0; j < COLS; ++j)
            matriz[i][j] = rand() % (MAX_NUM + 1);
}

int is_prime(int num) {
    if (num <= 1) return 0;
    for (int i = 2; i * i <= num; ++i)
        if (num % i == 0) return 0;
    return 1;
}

void handle_signal(int sig) {
    printf("Proceso %d recibió la señal %d\n", getpid(), sig);
    exit(0);
}

void level3_process(int start_row) {
    int primes = 0;
    for (int j = 0; j < COLS; ++j) {
        if (is_prime(matriz[start_row][j])) {
            primes++;
            int fd_file = open("N3_pid.primos", O_WRONLY | O_CREAT | O_APPEND, 0666);
            if (fd_file < 0) {
                perror("open");
                exit(1);
            }
            dprintf(fd_file, "3:%d:%d\n", getpid(), matriz[start_row][j]);
            close(fd_file);
        }
    }
    exit(primes);
}

void level2_process(int start_row, int pipe_fd[2]) {
    signal(SIGINT, handle_signal);
    signal(SIGTERM, handle_signal);

    int pipe_level3[5][2];
    for (int i = 0; i < 5; ++i) {
        if (pipe(pipe_level3[i]) == -1) {
            perror("pipe");
            exit(1);
        }
        pid_t pid = fork();
        if (pid == 0) { // Proceso hijo (nivel 3)
            close(pipe_level3[i][0]); // Cerrar el descriptor de lectura
            level3_process(start_row + i);
        }
    }

    int total_primes = 0;
    for (int i = 0; i < 5; ++i) {
        int status;
        wait(&status);
        if (WIFEXITED(status)) {
            total_primes += WEXITSTATUS(status);
        }
    }

    write(pipe_fd[1], &total_primes, sizeof(int));
    close(pipe_fd[1]);

    int fd_file = open("N2_pid.primos", O_WRONLY | O_CREAT, 0666);
    if (fd_file < 0) {
        perror("open");
        exit(1);
    }
    dprintf(fd_file, "Inicio de ejecución\nProcesos creados\nTotal de primos: %d\n", total_primes);
    close(fd_file);

    pause();
}

int main() {
    signal(SIGINT, handle_signal);
    signal(SIGTERM, handle_signal);

    generate_matrix();

    // Crear pipes para comunicación con procesos de nivel 2
    for (int i = 0; i < 3; ++i) {
        if (pipe(fd[i]) == -1) {
            perror("pipe");
            exit(1);
        }
    }

    // Crear memoria compartida
    shm_id = shmget(IPC_PRIVATE, 3 * sizeof(int), IPC_CREAT | 0666);
    if (shm_id < 0) {
        perror("shmget");
        exit(1);
    }

    for (int i = 0; i < 3; ++i) {
        pid_t pid = fork();
        if (pid == 0) { // Proceso hijo (nivel 2)
            close(fd[i][0]); // Cerrar el descriptor de lectura
            level2_process(i * 5, fd[i]);
        }
    }

    int total_primes = 0;
    for (int i = 0; i < 3; ++i) {
        close(fd[i][1]); // Cerrar el descriptor de escritura
        int primes;
        read(fd[i][0], &primes, sizeof(int));
        total_primes += primes;
        close(fd[i][0]);
    }

    printf("Total de números primos: %d\n", total_primes);

    int fd_file = open("N1_pid.primos", O_WRONLY | O_CREAT, 0666);
    if (fd_file < 0) {
        perror("open");
        exit(1);
    }
    dprintf(fd_file, "Comienzo\nProcesos creados\nResultados recibidos\nTotal de primos: %d\n", total_primes);
    close(fd_file);

    shmctl(shm_id, IPC_RMID, NULL);

    return 0;
}
