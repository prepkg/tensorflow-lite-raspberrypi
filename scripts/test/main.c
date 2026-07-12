#include <stdio.h>
#include <tensorflow/lite/version.h>

int main(void) {
    printf("%s\n", TFLITE_VERSION_STRING);

    return 0;
}
