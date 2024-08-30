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
	levels=level.rrand(exp(Complex(0,1)*angle+(0.12/1.6180339887499)).imag);
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

		ph1=SinOsc.ar(~magL.[pl].reciprocal,phase1);
		ph2=SinOsc.ar(~magR.[pl].reciprocal,phase2);

		env1=EnvGen.ar(Env([1/10,1/10],[200]),doneAction:2,levelScale:m.reciprocal);
		env2=EnvGen.ar(Env([1/10,1/10],[200]),doneAction:2,levelScale:m.reciprocal);

		signal1=LPF.ar(Osc.ar(~b,fund*m,ph1,SinOsc.ar(~magL.[pl].reciprocal,phase1,mul:~magL.[pl],add:1)),3000);
		signal2=LPF.ar(Osc.ar(~b,fund*m,ph2,SinOsc.ar(~magR.[pl].reciprocal,phase2,mul:~magR.[pl],add:1)),3000);

	m=m+1;

pl=pl+1;
		Out.ar(0,Pan2.ar(signal1*env1,pos1));
		Out.ar(0,Pan2.ar(signal2*env2,pos2));

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

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	//phase1=(Complex(cos(phase1.round(0.00001)*1),0).rho*(Complex(cos(phase1.round(0.00001)*3),1).rho)).round(0.00001);
	phase1=Complex(cos(phase1.round(0.00001)*1),0).rho.round(0.00001);
	phase1=phase1/(2.sqrt);

};

~pos1R=365.collect{

	phase2=exp(Complex(0,1)*angle2.degrad).theta;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=Complex(0,cos(phase2.round(0.00001)*1)).rho.neg.round(0.00001);
	phase2=phase2/(2.sqrt);
};

)

(
var phase,angle=0,mag,phase1,angle1=0,mag1;

~magL = 365.collect{

	phase=exp(Complex(0,1)*angle.degrad).theta;
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	//mag=(Complex(cos(phase.round(0.00001)*3),0).rho*Complex(cos(phase.round(0.00001)*0),0).rho).round(0.00001);
	mag=Complex(cos(phase.round(0.00001)*1),0).rho.round(0.00001);
	mag=mag/(2.sqrt);
	};

~magR = 365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	mag1=Complex(0,sin(phase1.round(0.00001)*1)).rho.round(0.00001);
	mag1=mag1/(2.sqrt);
	};
)
