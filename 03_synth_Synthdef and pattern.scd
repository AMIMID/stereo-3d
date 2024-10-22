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

(
~b= Buffer.alloc(s,2048);
~t= Buffer.alloc(s,2048);
var env,sig,wt,angle=0,level,levels;

~levels=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*angle+((360-(360/1.6180339887499))/10).degrad).imag);
};
env = Env(~levels,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~b.loadCollection(wt);
sig.plot;
)


(
////////fractal
		{
var signal,wt,m=0,amp;

~level=45.round(1).collect{m=m+1;amp=m.reciprocal};
~phase=45.collect{pi};
signal=Signal.sineFill(1024,~level,~phase);

wt = signal.asWavetable;
~t.loadCollection(wt);
//signal.plot;
		}.value;
{
var c,angle=0,c_real,c_imag,z;



~c = 5.collect{
 	c_real=exp(Complex(0,1)*angle.degrad).real;
	c_imag=exp(Complex(0,1)*angle.degrad).imag;
 	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
 	c=Complex(c_real,c_imag);
 };
z=Complex(0,0);

~j = (1440*2).collect{
	c=~c.[4];
	z=z.pow(2)+c;
	z.theta.round(0.000001);
}

}.value;
{
var phase1,phase2,angle1=0,angle2=0,m=2,pl1=0,pl2=0;

~posL=1440.collect{

	phase1=exp(Complex(0,1)*(angle1.degrad*~j.[pl1])).theta;
	pl1=pl1=1;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1=(Complex(sin(phase1.round(0.0001)*m),sin(phase1.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase1.round(0.0001)*m),cos(phase1.round(0.0001)*m)).rho).round(0.0001);

};

~posR=1440.collect{

	phase2=exp(Complex(0,1)*(angle2.degrad*~j.[pl2])).theta;
	pl2=pl2=1;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=(Complex(sin(phase2.round(0.0001)*m),sin(phase2.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase2.round(0.0001)*m),cos(phase2.round(0.0001)*m)).rho).round(0.0001).neg;
};

}.value;

{
var phase,angle=0,mag,phase1,angle1=0,mag1,m=2,pl1=0,pl2=0;

~magL = 1440.collect{

	phase=exp(Complex(0,1)*(angle.degrad*~j.[pl1])).theta;
	pl1=pl1=1;
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	mag=Complex(cos(phase.round(0.0001)*m),cos(phase.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase.round(0.0001)*m),cos(phase.round(0.0001)*m)).rho.round(0.0001);
	};

~magR = 1440.collect{

	phase1=exp(Complex(0,1)*(angle1.degrad*~j.[pl2])).theta;
	pl2=pl2=1;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	mag1=Complex(sin(phase1.round(0.0001)*m),sin(phase1.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase1.round(0.0001)*m),cos(phase1.round(0.0001)*m)).rho.round(0.0001);
	};
}.value;

(
~magR=~magR/(2.sqrt);
~magL=~magL/(2.sqrt);
)

{
var dur=2,ph1,ph2,ph3,ph4,ph5,ph6,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0;
var sph1,sph2,sph3,sph4,sph5,sph6,sph7,sph8,sph9;
var n1,n2,n3,n4,n5,n6,n7,n8,n9,mult=12;
var mag1,mag2,mag3,mag4,mag5,mag6,mag7,mag8,mag9,rythm;
var index1,index2,index3,index4,index5,index6,pl7=0,pl8=0,pl9=0,t1,t2,t3,t4,t5,t6;
var pl10=0,pl11=0,pl12=0,pl13=0,pl14=0,pl15=0;

///////////////////////L-system algae variable a,b rules:a=ab b=a , n3 for n0=a
rythm=[1,1/1,1,1,1/1];

~dur1 = (45*~time).collect{
	ph1=Cartesian(~magx1.[pl1],~magy1.[pl1],~magz1.[pl1]).rho/(2.sqrt);
	index1=rythm.wrapAt(pl7);
	pl7=pl7+1;
	pl1=pl1+1;
	ph1=(ph1*dur).round(1/32);
	t1=ph1*index1;

	};

~dur2 = (45*~time).collect{
	ph2=Cartesian(~magx2.[pl2],~magy2.[pl2],~magz2.[pl2]).rho/(2.sqrt);
	index2=rythm.wrapAt(pl8);
	pl8=pl8+1;
	pl2=pl2+1;
	ph2=(ph2*dur).round(1/32);
	t2=ph2*index2;
	};

~dur3 = (45*~time).collect{
	ph3=Cartesian(~magx3.[pl6],~magy3.[pl3],~magz3.[pl3]).rho/(2.sqrt);
	index3=rythm.wrapAt(pl9);
	pl9=pl9+1;
	pl3=pl3+1;
	ph3=(ph3*dur).round((1/32));
	t3=ph3*index3;
	};

~dur4 = (45*~time).collect{
	ph4=Cartesian(~magx4.[pl10],~magy4.[pl10],~magz4.[pl10]).rho/(2.sqrt);
	index4=rythm.wrapAt(pl11);
	pl11=pl11+1;
	pl10=pl10+1;
	ph4=(ph4*dur).round((1/32));
	t4=ph4*index4;
	};
~dur5 = (45*~time).collect{
	ph5=Cartesian(~magx5.[pl12],~magy5.[pl12],~magz5.[pl12]).rho/(2.sqrt);
	index5=rythm.wrapAt(pl13);
	pl13=pl13+1;
	pl12=pl12+1;
	ph5=(ph5*dur).round((1/32));
	t5=ph5*index5;
	};

~dur6 = (45*~time).collect{
	ph6=Cartesian(~magx6.[pl14],~magy6.[pl14],~magz6.[pl14]).rho/(2.sqrt);
	index6=rythm.wrapAt(pl9);
	pl15=pl15+1;
	pl14=pl14+1;
	ph6=(ph6*dur).round((1/32));
	t6=ph6*index6;
	};



~nx = (45*~time).collect{
	//mag1=Cartesian(~magx1.[pl4],~magy1.[pl4],~magz1.[pl4]).rho/(2.sqrt);
	mag1=1;
	sph1=Complex(~magL.[pl4],~magR.[pl4]);x;
	pl4=pl4+1;
	n1=(sph1).round(1);
	};

~ny = (45*~time).collect{
	//mag2=Cartesian(~magx1.[pl5],~magy1.[pl5],~magz1.[pl5]).rho/(2.sqrt);
	mag2=1;
	sph2=Spherical(mag2*mult,~az.[pl5],~el.[pl5]).y;
	pl5=pl5+1;
	n2=(sph2).round(1);
	};

~nz = (45*~time).collect{
	//mag3=Cartesian(~magx1.[pl6],~magy1.[pl6],~magz1.[pl6]).rho/(2.sqrt);
	mag3=1;
	sph3=Spherical(mag3*mult,~az.[pl6],~el.[pl6]).z;
	pl6=pl6+1;
	n3=(sph3).round(1);
};
}.value;
)


////////////////////osc

(
SynthDef.new(\ostereo,
{
		arg decay,nx,ny,speed=1,octave=4;
var signal1,signal2,env,pl=0,m=1,fund=55,freq1,freq2,amp1,amp2;
var pos1,pos2,phase1,phase2,ph1,ph2,mag,fundamental=32,freq,pitch1,pitch2;
var chainx,chainy,amp,rq=1,cutt,f,pl1=0,pl2=0,bank1=2,bank2=90;

		pitch1=2.pow(nx/12);
		pitch2=2.pow(ny/12);

		freq=fundamental*octave;
		fundametal=fundamental*speed.reciprocal;

bank1.do{
bank2.do{

		pos1=~posL.[pl1]/(2.sqrt);
		pos2=~posR.[pl1]/(2.sqrt);
		//phase1=~phase1.[pl];
		//phase2=~phase2.[pl];
				mag=Complex(~magL.[pl2].[pl1],~magR.normalize(0,1).[pl2].[pl1]);

		//ph1=SinOsc.ar(mag.reciprocal,phase1,mag);
		//ph2=SinOsc.ar(mag.reciprocal,phase2,mag);
		mag=mag.round(0.00000001);


		ph1=exp(Complex(0,1)*(2pi*mag.real).mod(2pi)).theta;
		ph2=exp(Complex(0,1)*(2pi*mag.imag).mod(2pi)).theta;

		amp1=m.reciprocal*octave.reciprocal*speed*pitch1.reciprocal;
		amp2=m.reciprocal*octave.reciprocal*speed*pitch2.reciprocal;
		f=freq*m;
		cutt=mag.rho/(2.sqrt);
		rq=cutt/1;

env=EnvGen.ar(Env.sine(decay,0.1),doneAction:2);

	//	signal1=BPF.ar(Osc.ar(~b.bufnum,freq1,ph1,amp1),fund*cutt.reciprocal,rq,1/rq.sqrt);
	//	signal2=BPF.ar(Osc.ar(~b.bufnum,freq1,ph2,amp2),fund*cutt.reciprocal,rq,1/rq.sqrt);


	signal1=Osc.ar(~t.bufnum,f*pitch1,ph1,amp1)*env;
	signal2=Osc.ar(~t.bufnum,f*pitch2,ph2,amp2)*env;
	m=m+1;

		Out.ar(0,Pan2.ar(LeakDC.ar(signal1),pos1,mag.rho/(2.sqrt)));
		Out.ar(0,Pan2.ar(LeakDC.ar(signal2),pos2,mag.rho/(2.sqrt)));
pl1=pl1+1;
			};
					pl2=pl2+1;
		m=m+1;
}
}).add;
)

(
a=Pdef(\1, Pbind(\instrument, \ospace1,
	\dur,Pseq(~dur1.mirror,1),
\nx,PdegreeToKey(Pseq(~nx.mirror,inf),Scale.phrygian),
	\ny,PdegreeToKey(Pseq(~ny.mirror,inf),Scale.phrygian),
		\out1,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\out2,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\octave,Prand([1,2,4],inf),
	\rpr,Pseq(~rot_speed.mirror,inf),
	\decay,Pbrown(0.01111,0.04444,0.01111,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
b=Pdef(\2, Pbind(\instrument, \ospace1,
	\dur,Pseq(~dur2.mirror,1),
\nx,PdegreeToKey(Pseq(~nx.mirror,inf),Scale.phrygian),
	\ny,PdegreeToKey(Pseq(~ny.mirror,inf),Scale.phrygian),
		\out1,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\out2,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
			\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.mirror,inf),
	\decay,Pbrown(0.01111,0.04444,0.01111,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
c=Pdef(\3, Pbind(\instrument, \ospace1,
	\dur,Pseq(~dur3.mirror,1),
\nx,PdegreeToKey(Pseq(~nx.mirror,inf),Scale.phrygian),
	\ny,PdegreeToKey(Pseq(~ny.mirror,inf),Scale.phrygian),
		\out1,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\out2,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
			\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.mirror,inf),
	\decay,Pbrown(0.01111,0.04444,0.01111,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
d=Pdef(\4, Pbind(\instrument, \ospace1,
	\dur,Pseq(~dur4.mirror,1),
\nx,PdegreeToKey(Pseq(~nx.mirror,inf),Scale.phrygian),
	\ny,PdegreeToKey(Pseq(~ny.mirror,inf),Scale.phrygian),
		\out1,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\out2,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
			\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.mirror,inf),
	\decay,Pbrown(0.01111,0.04444,0.01111,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
e=Pdef(\5, Pbind(\instrument, \ospace1,
	\dur,Pseq(~dur5.mirror,1),
\nx,PdegreeToKey(Pseq(~nx.mirror,inf),Scale.phrygian),
	\ny,PdegreeToKey(Pseq(~ny.mirror,inf),Scale.phrygian),
		\out1,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\out2,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.mirror,inf),
	\decay,Pbrown(0.01111,0.04444,0.01111,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
f=Pdef(\6, Pbind(\instrument, \ospace1,
	\dur,Pseq(~dur6.mirror,1),
\nx,PdegreeToKey(Pseq(~nx.mirror,inf),Scale.phrygian),
	\ny,PdegreeToKey(Pseq(~ny.mirror,inf),Scale.phrygian),
		\out1,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\out2,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.mirror,inf),
	\decay,Pbrown(0.01111,0.04444,0.01111,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
	);
TempoClock.default.tempo_(1);
/////with tempo 1 and time 1 overall duration of a is 2.08 min

	/////////////////////scales
Scale.directory;

(
Tdef.new(\h,{
//loop({
a.play;
(120).wait;
b.play;
(120).wait;
c.play;
(120).wait;
d.play;
(120).wait;
e.play;
(120).wait;
f.play;
//	})
})
)


//Tdef(\h).stop;
Tdef(\h).play;
//Tdef(\h).clear;
