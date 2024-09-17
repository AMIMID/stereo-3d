(
s.options.numWireBufs = 1024*1;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=1;
TempoClock.default.tempo_(120/120);
s.options.memSize = 8192*4;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 1;
s.waitForBoot
)

Server.killAll

/////////arrays
(
(
var phase,angle=0,phase1,angle1=90;

~phase1=365.collect{

	phase=exp(Complex(0,1)*angle.degrad).theta;
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	phase.round(0.000000001)
};
~phase2=365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1.round(0.000000001)
};

)

(
var phase1,phase2,angle1=0,angle2=0,m1=4,m2=4;

~posL=365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1=(Complex(sin(phase1.round(0.000000001)*m1),sin(phase1.round(0.000000001)*m1)).rho.round(0.000000001)*Complex(cos(phase1.round(0.000000001)*m1),cos(phase1.round(0.000000001)*m1)).rho).round(0.000000001);

};

~posR=365.collect{

	phase2=exp(Complex(0,1)*angle2.degrad).theta;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=(Complex(sin(phase2.round(0.000000001)*m2),sin(phase2.round(0.000000001)*m2)).rho.round(0.000000001)*Complex(cos(phase2.round(0.000000001)*m2),cos(phase2.round(0.000000001)*m2)).rho).neg.round(0.000000001);
};

)

(
var phase,angle=0,mag,phase1,angle1=0,mag1,m1=4,m2=4;

~magL = 365.collect{

	phase=exp(Complex(0,1)*angle.degrad).theta;
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	//mag=(Complex(cos(phase.round(0.000000001)*3),0).rho*Complex(cos(phase.round(0.000000001)*0),0).rho).round(0.000000001);
	mag=Complex(cos(phase.round(0.000000001)*m1),cos(phase.round(0.000000001)*m1)).rho.round(0.000000001)*Complex(sin(phase.round(0.000000001)*m1),sin(phase.round(0.000000001)*m1)).rho.round(0.000000001);
	};

~magR = 365.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	mag1=Complex(sin(phase1.round(0.000000001)*m2),sin(phase1.round(0.000000001)*m2)).rho.round(0.000000001)*Complex(cos(phase1.round(0.000000001)*m2),cos(phase1.round(0.000000001)*m2)).rho.round(0.000000001);
	};
)
)


//////////////synth
(
{
var signal1,signal2,env1,env2,pl=1;
var pos1,pos2,phase1,phase2,ph1,ph2;
var in1,in2, chainx,chainy,b=0;
var chainxx,chainyy,mag;
var frames= 2048;

	in1 = SoundIn.ar(0);
	 in2 =  SoundIn.ar(0);

	chainx = FFT(LocalBuf(frames), in1);
	chainy = FFT(LocalBuf(frames), in2);

360.do{

		pos1=~posL.[pl]/(2.sqrt);
		pos2=~posR.[pl]/(2.sqrt);
		phase1=~phase1.[pl];
		phase2=~phase2.[pl];
		mag=Complex(~magL.[pl]/(2.sqrt),~magR.[pl]/(2.sqrt)).rho/(2.sqrt);


	//	env1=EnvGen.ar(Env([1,1],[360]),doneAction:2);
		//env2=EnvGen.ar(Env([1,1],[360]),doneAction:2);

   chainxx = chainx.pvcollect(frames, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);
   chainyy = chainy.pvcollect(frames, {|mag, phase, index| [mag, phase]; }, frombin: b, tobin: b, zeroothers: 1);


		signal1=Pan2.ar(IFFT(PV_PhaseShift(chainxx,0.degrad)),pos1,mag);
		signal2=Pan2.ar(IFFT(PV_PhaseShift(chainyy,90.degrad)),pos2,mag);
b=b+1;
pl=pl+1;
		Out.ar(0,signal1);
		Out.ar(0,signal2);

}
}.play
)

//////////////////////vis

(
var  sph1,sph2,sph3,sph4,sph5,m_x=9,m_y=8,m_z=6;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z;
var az4=0,el4=0,az5=0,el5=0;

~az = (360).collect{

		az1=(az1+(1)).wrap(180.neg,180);

	el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph1=Spherical(1,az1.degrad,el1.degrad).theta.round(0.00001);

	};

~el = (360*100).collect{

		az2=(az2+(1)).wrap(180.neg,180);

	el2=(el2+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph2=Spherical(1,az2.degrad,el2.degrad).phi.round(0.00001);

	};

)

(
var data;
var az=0,el=0;
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r;
var r1,harm1,r2,harm2,rad;

data = (360).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=~magz.[pl];
	mag=Complex(~magR.[pl]/(2.sqrt)*600,~magL.[pl]/(2.sqrt)*600).rho/(2.sqrt);
	pl=pl+1;

	sph=Spherical(mag,az,el).asCartesian.asArray;


};

w = Window.new("3D Scatterplot", Rect(40,40, 1000, 800)).front;
a = ScatterView3d(w, Rect(0,0, 800,800), data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 1;
a.symbolColor = Color.white;
a.background = Color.black;

// Y Slider
Slider(w, Rect(820, 10, 10, 450)).action_{|me|
    a.rotY = me.value * 2pi;
    w.refresh;
};
// X Slider
Slider(w, Rect(870, 10, 10, 450)).action_{|me|
    a.rotX = me.value * 2pi;
    w.refresh;
};
// Z Slider
Slider(w, Rect(920, 10, 10, 450)).action_{|me|
    a.rotZ = me.value * 2pi;
    w.refresh;
};
)



