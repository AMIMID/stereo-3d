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
////////////////////buffers
~l = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/00.wav",channels:0 );
~r = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/00.wav",channels:1 );

//////////////synth
(
{
var signal1,signal2,env1,env2,pl=1;
var pos1,pos2,phase1,phase2,ph1,ph2;
var in1,in2, chainx,chainy,b=0;
var chainxx,chainyy;

	 in1 = PlayBuf.ar(1, ~l.bufnum, BufRateScale.kr(~l), loop: 0, doneAction:2);
	 in2 = PlayBuf.ar(1, ~r.bufnum, BufRateScale.kr(~r), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);

360.do{

		pos1=~pos1L.[pl];
		pos2=~pos1R.[pl];
		phase1=~phase1.[pl];
		phase2=~phase2.[pl];


		env1=EnvGen.ar(Env([1/1,1/1],[360]),doneAction:2,levelScale:~magL.[pl]);
		env2=EnvGen.ar(Env([1/1,1/1],[360]),doneAction:2,levelScale:~magL.[pl]);

   chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);


		signal1=Pan2.ar(IFFT(PV_PhaseShift(chainxx,phase1)),pos1,env1);
		signal2=Pan2.ar(IFFT(PV_PhaseShift(chainyy,phase2)),pos2,env2);
b=b+1;
pl=pl+1;
		Out.ar(0,signal1);
		Out.ar(0,signal2);

}
}.play
)

/////////arrays
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
	phase1=Complex(cos(phase1.round(0.00001)*3),0).rho.round(0.00001);
	phase1=phase1/(2.sqrt);

};

~pos1R=365.collect{

	phase2=exp(Complex(0,1)*angle2.degrad).theta;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=Complex(0,cos(phase2.round(0.00001)*3)).rho.neg.round(0.00001);
	phase2=phase2/(2.sqrt);
};

)

(
var phase,angle=0,mag,phase1,angle1=0,mag1;

~magL = 365.collect{

	phase=exp(Complex(0,1)*angle.degrad).theta;
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	//mag=(Complex(cos(phase.round(0.00001)*3),0).rho*Complex(cos(phase.round(0.00001)*0),0).rho).round(0.00001);
	mag=Complex(cos(phase.round(0.00001)*3),0).rho.round(0.00001);
	mag=mag/(2.sqrt);
	};

~magR = 365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	mag1=Complex(0,sin(phase1.round(0.00001)*3)).rho.round(0.00001);
	mag1=mag1/(2.sqrt);
	};
)
