extern "C" {
void var004_no_pragmas(int* c, const int* a, const int* b, const int len) {
    for (int x = 0; x < len; ++x) {
        int sumA = 0;
        int sumB = 0;
        int volA = a[x];
        int volB = b[x];
        for (int i = 0; i < 32; i++) {
            sumA += (volA) & 1;
            volA = volA/2;
            sumB += (volB) & 1;
            volB = volB/2;
        }
        if (sumA > sumB)
            c[x] = sumA;
        else
            c[x] = sumB;

    }
}
}

extern "C" {
void var004_pipelined(int* c, const int* a, const int* b, const int len) {
    for (int x = 0; x < len; ++x) {
	#pragma HLS PIPELINE
        int sumA = 0;
        int sumB = 0;
        int volA = a[x];
        int volB = b[x];
        for (int i = 0; i < 32; i++) {
	    #pragma HLS PIPELINE
            sumA += (volA) & 1;
            volA = volA/2;
            sumB += (volB) & 1;
            volB = volB/2;
        }
        if (sumA > sumB)
            c[x] = sumA;
        else
            c[x] = sumB;

    }
}
}



extern "C" {
void var004_unrolled(int* c, const int* a, const int* b, const int len) {
    for (int x = 0; x < len; ++x) {
        #pragma HLS UNROLL factor=2
        int sumA = 0;
        int sumB = 0;
        int volA = a[x];
        int volB = b[x];
        for (int i = 0; i < 32; i++) {
            sumA += (volA) & 1;
            volA = volA/2;
            sumB += (volB) & 1;
            volB = volB/2;
        }
        if (sumA > sumB)
            c[x] = sumA;
        else
            c[x] = sumB;

    }
}
}


extern "C" {
void var004_pipe_unroll(int* c, const int* a, const int* b, const int len) {
    for (int x = 0; x < len; ++x) {
        #pragma HLS PIPELINE
        #pragma HLS UNROLL factor=2
        int sumA = 0;
        int sumB = 0;
        int volA = a[x];
        int volB = b[x];
        for (int i = 0; i < 32; i++) {
            sumA += (volA) & 1;
            volA = volA/2;
            sumB += (volB) & 1;
            volB = volB/2;
        }
        if (sumA > sumB)
            c[x] = sumA;
        else
            c[x] = sumB;

    }
}
}