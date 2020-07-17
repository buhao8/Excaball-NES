#include <stdio.h>

int main(int argc, char **argv)
{
    if (argc != 3) {
        printf("Usage: map2bin [file_in] [file_out]\n");
        return -1;
    }
    FILE *f_in = fopen(argv[1], "r");
    FILE *f_out = fopen(argv[2], "w");
    
    char c;
    while ((c = getc(f_in)) != EOF) {
        if (c != ' ' && c != '\n') {
            printf("%c", c);
            fputc(c - '0', f_out);
        }
    }
    int i;
    for (i = 0; i < 64; ++i) {
        fputc(0xFF, f_out);
    }
    fclose(f_in);
    fclose(f_out);
    return 0;
}
