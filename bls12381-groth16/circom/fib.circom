pragma circom 2.1.4;

template Fib(N) {
	signal input a1;
	signal input a2;

	signal output out;

	if (N == 1) {
		out <== a1; 
	}
	else if (N == 2) {
		out <== a2;
	}
	else {
		var b1 = a1;
		var b2 = a1 + a2;
		var i = N - 2;

		var inter = 0;

		while (i > 0) {
			inter = b2;
			b2 = b2 + b1;
			b1 = inter;
			
			i--;
		}

		out <== b2;
	}

}

component main = Fib(5);
