m4_include(`commons.m4')

_HEADER(`Cabling in rack cabinet and Z3')

_HL1(`Cabling in rack cabinet and Z3')

<p>Take a rack cabinet, like this one:</p>

<p><img src="Assembled_Network_Cabinets_Server_Rack_Telecom_Standard_Supreme_Quality_Product_3152_7.jpg"></p>

<p>Let's say, there are 8 1U devices, maybe servers, routers and whatnot, named as A, B, C, D, E, F, G, H.
Devices must be connected by cables: probably twisted pair or whatever network engineers using today.
Some devices must be connected by several cables (2 cables, 3 or 4):</p>

_PRE_BEGIN
A <--- 1 cable  ---> H
A <--- 2 cables ---> E
B <--- 4 cables ---> F
C <--- 1 cable  ---> G
C <--- 1 cable  ---> D
C <--- 1 cable  ---> E
D <--- 3 cables ---> H
G <--- 1 cable  ---> H
_PRE_END

<p>The problem: how we can place these 8 devices in such an order, so that sum of all cable lengths would be as short as possible?</p>

_PRE_BEGIN
m4_include(`blog/cabling_Z3/cabling.py')
_PRE_END

<p>Each 1 in diff_X_X variables and in final_sum means a cable of length enough to connect two 1U devices placed adjacently.
So we measure cable lengths in "units".</p>

<p>Minimizing:</p>

_PRE_BEGIN
m4_include(`blog/cabling_Z3/min.txt')
_PRE_END

<p>So we need a cable of 19 units to cut it and connect everything.</p>

<p>Essentially, we're asking Z3 to find such values for A, B, C, D, E, F, G, H, so that the following expression would be as small as possible:</p>

_PRE_BEGIN
diff_A_H +                                                                                                             
diff_A_E*2 +
diff_B_F*4 +
diff_C_G +
diff_C_D +
diff_C_E +
diff_D_H*3 +
diff_G_H
_PRE_END

<p>Just for fun, we can maximize solution (comment "s.minimize()" and uncomment "s.maximize()"):</p>

_PRE_BEGIN
m4_include(`blog/cabling_Z3/max.txt')
_PRE_END

<p>Further work: it's not a problem to extend this script for several types of cables: network, power, etc, and minimize them as well.
Even more, we can assign priorities: maybe, we can live with longer network cables, but want to minimize lengths of power cables at first.
</p>

_FOOTER()

