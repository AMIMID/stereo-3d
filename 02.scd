(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(120/120);
s.options.memSize = 8192*64;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 64;
s.waitForBoot
)


Buffer.freeAll
~b= Buffer.alloc(s,2048);

(
var env,sig,wt,angle=0,level,levels;

~levels=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*angle+(0.5/1.6180339887499)).imag);
};
env = Env(~levels,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~b.loadCollection(wt);
sig.plot;
)
////////////////////osc

(
{
var signal1,signal2,env1,env2,pl=1,m=1,fund=55;
var pos1,pos2,phase1,phase2,ph1,ph2;

360.do{

		pos1=~pos1L.[pl];
		pos2=~pos1R.[pl];
		phase1=~phase1.[pl];
		phase2=~phase2.[pl];

		ph1=SinOsc.ar(1/3,phase1);
		ph2=SinOsc.ar(1/3,phase2);

		//env1=EnvGen.ar(Env([1],[20]),doneAction:2,levelScale:m.reciprocal);
		//env2=EnvGen.ar(Env([1],[20]),doneAction:2,levelScale:m.reciprocal);

		signal1=LPF.ar(Osc.ar(~b,fund*m,ph1,SinOsc.ar(1/3,phase1,mul:~magL.[pl])),8000);
		signal2=LPF.ar(Osc.ar(~b,fund*m,ph2,SinOsc.ar(1/3,phase2,mul:~magL.[pl])),8000);

	m=m+1;

pl=pl+1;
		Out.ar(0,Pan2.ar(signal1*m.reciprocal,pos1));
		Out.ar(0,Pan2.ar(signal2*m.reciprocal,pos2));

}
}.play
)


(
var phase,angle=0,phase1,angle1=90;

~phase1=365.collect{

	phase=exp(Complex(0,1)*angle.degrad).theta;
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	phase.round(0.00001)
};
~phase2=365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1.round(0.00001)
};

)

(
var phase1,phase2,angle1=0,angle2=0;

~pos1L=365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad);
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1=Complex(cos((phase1.theta.round(0.00001)*3)),0).rho.round(0.00001);
};

~pos1R=365.collect{

	phase2=exp(Complex(0,1)*angle2.degrad);
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=Complex(0,cos((phase2.theta.round(0.00001)*3))).rho.neg.round(0.00001);
};

)

(
var phase,angle=0,mag,phase1,angle1=0,mag1;

~magL = 365.collect{

	phase=exp(Complex(0,1)*angle.degrad);
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	mag=Complex(cos((phase.theta.round(0.00001)*3)),0).rho.round(0.00001);
	};

~magR = 365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad);
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	mag1=Complex(0,sin((phase1.theta.round(0.00001)*3))).rho.round(0.00001);

	};
)
