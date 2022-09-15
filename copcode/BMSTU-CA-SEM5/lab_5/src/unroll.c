extern "C" {
	void var006_unrolled(int* c, const int* a, const int* b, const int len)
	{
		int minB = b[0];
		for (int i = 1; i < len; i++)
		{
			  #pragma HLS UNROLL  factor=2
			  if (minB > b[i])
			  {
				   minB = b[i];
			  }
		}
		int acc = 0;
		for(int i=0; i < len; i++)
		{
           #pragma HLS UNROLL  factor=2
		   acc += a[i] * minB;
		   c[i] = acc;
		}
	}
}

