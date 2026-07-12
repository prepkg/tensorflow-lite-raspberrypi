#include <iostream>
#include <tensorflow/lite/version.h>

int main() {
    std::cout << TFLITE_VERSION_STRING << std::endl;

    return 0;
}
