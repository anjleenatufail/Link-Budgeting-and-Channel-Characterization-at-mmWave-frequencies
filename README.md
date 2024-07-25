# Link-Budgeting-and-Channel-Characterization-at-mmWave-frequencies
This project is an investigation into mmWave  propagation characteristics, channel modeling, link budgeting and power distribution among multiple hops between Transmitting and Receiving antennas. NYUSIM channel estimator has been used for channel estimation and its base script is modified in MATLAB that helps in generating channel matrix dataset.

**Description**

The aim is to observe channel model with Power delay profiles (PDP) for both 
directional and omnidirectional Antenna configuration, Path loss Exponent (PLE), power 
spectrum, path loss plots, Outdoor to Indoor (O2I) Penetration Loss etc. at millimeters 
Wavelength band for both LOS and NLOS environments using a open source novel, 
measurement based channel simulator NYUSIM.
 Obtaining this information is vital for the design and operation of future work 
systems for mm-wave spectrum. The project is mostly revolving around measuring the channel 
characterization parameters for mmWave frequencies and the path loss model in free space 
and other scenarios. The effect of foliage loss, the rainfall loss, building penetration loss and 
the effect of change in antenna polarization settings are also investigated.
 Taking the advancement of Machine Learning in recent years into account, 
this project also studies dataset generation for a channel whose Channel Impulse Response is 
time varying. As measurement of transmitter power and received power using mmWaves can’t 
be done because of unavailability of certain equipment. We have used NYUSIM for channel 
estimation at mmWave frequency range. Matlab script that helps in generation of this channel 
matrix dataset are thoroughly studied in this project. This channel matrix dataset can be further 
used by applying different machine learning predictive algorithms to predict future variations 
in the channel.
