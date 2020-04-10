First Pass
================

# Generic Results

Dependent variables are either the chapter 12 bankruptcy rate, the 90+
day delinquency rate of production loans, or the 90+ day delinquency
rate of farmland loans. Chapter 12 data begin in 1990 while the
delinquency rates begin in 1994.

## Panel fixed effects and with controls

Fixed effects for both county and year.

<table style="text-align:center">

<caption>

<strong>County Fixed Effects Results</strong>

</caption>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="6">

Inverse Hyperbolic Sine of

</td>

</tr>

<tr>

<td>

</td>

<td colspan="6" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

Ch. 12 Rate

</td>

<td>

Ch. 12 Rate

</td>

<td>

Production Delinq.

</td>

<td>

Production Delinq.

</td>

<td>

Farmland Delinq.

</td>

<td>

Farmland Delinq.

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(1)

</td>

<td>

(2)

</td>

<td>

(3)

</td>

<td>

(4)

</td>

<td>

(5)

</td>

<td>

(6)

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

dday\_good

</td>

<td>

0.0002<sup>\*\*</sup>

</td>

<td>

0.0001

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*</sup>

</td>

<td>

0.00000<sup>\*\*</sup>

</td>

<td>

0.00000

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.0001)

</td>

<td>

(0.0001)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

dday34

</td>

<td>

\-0.002<sup>\*\*</sup>

</td>

<td>

\-0.001

</td>

<td>

\-0.0001<sup>\*\*\*</sup>

</td>

<td>

\-0.0001<sup>\*\*\*</sup>

</td>

<td>

\-0.0001<sup>\*\*\*</sup>

</td>

<td>

\-0.0001<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.001)

</td>

<td>

(0.001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00002)

</td>

<td>

(0.00002)

</td>

</tr>

<tr>

<td style="text-align:left">

prec

</td>

<td>

0.0002

</td>

<td>

0.0001

</td>

<td>

0.00000

</td>

<td>

\-0.00000

</td>

<td>

0.00001<sup>\*\*</sup>

</td>

<td>

0.00001<sup>\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.0002)

</td>

<td>

(0.0003)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00001)

</td>

<td>

(0.00001)

</td>

</tr>

<tr>

<td style="text-align:left">

I(prec2)

</td>

<td>

\-0.00000

</td>

<td>

\-0.00000

</td>

<td>

\-0.000

</td>

<td>

\-0.000

</td>

<td>

\-0.000<sup>\*\*</sup>

</td>

<td>

\-0.000<sup>\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(covered\_impute/1000)

</td>

<td>

\-0.00003

</td>

<td>

0.00001

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00004)

</td>

<td>

(0.00005)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(subsidy/1000)

</td>

<td>

\-0.0001<sup>\*\*\*</sup>

</td>

<td>

\-0.00004<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(indemnity/1000)

</td>

<td>

\-0.00000

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

0.000

</td>

<td>

0.000

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(farmland\_val\_per\_acre\_interp/1000)

</td>

<td>

</td>

<td>

\-0.251<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.006<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.010<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.053)

</td>

<td>

</td>

<td>

(0.001)

</td>

<td>

</td>

<td>

(0.002)

</td>

</tr>

<tr>

<td style="text-align:left">

lag(I(farmland\_val\_per\_acre\_interp/1000))

</td>

<td>

</td>

<td>

0.333<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.008<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.012<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.062)

</td>

<td>

</td>

<td>

(0.001)

</td>

<td>

</td>

<td>

(0.002)

</td>

</tr>

<tr>

<td style="text-align:left">

I(farms\_interp/1000)

</td>

<td>

</td>

<td>

\-0.454<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.001

</td>

<td>

</td>

<td>

\-0.010<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.096)

</td>

<td>

</td>

<td>

(0.002)

</td>

<td>

</td>

<td>

(0.003)

</td>

</tr>

<tr>

<td style="text-align:left">

livestock\_share

</td>

<td>

</td>

<td>

0.218<sup>\*</sup>

</td>

<td>

</td>

<td>

0.006<sup>\*\*</sup>

</td>

<td>

</td>

<td>

0.011<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.132)

</td>

<td>

</td>

<td>

(0.002)

</td>

<td>

</td>

<td>

(0.004)

</td>

</tr>

<tr>

<td style="text-align:left">

pct\_irrigated

</td>

<td>

</td>

<td>

\-1.081<sup>\*</sup>

</td>

<td>

</td>

<td>

0.018

</td>

<td>

</td>

<td>

0.025<sup>\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.620)

</td>

<td>

</td>

<td>

(0.012)

</td>

<td>

</td>

<td>

(0.013)

</td>

</tr>

<tr>

<td style="text-align:left">

unemp\_rate

</td>

<td>

</td>

<td>

3.758<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.051<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.133<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.686)

</td>

<td>

</td>

<td>

(0.014)

</td>

<td>

</td>

<td>

(0.022)

</td>

</tr>

<tr>

<td style="text-align:left">

I(total\_branches/1000)

</td>

<td>

</td>

<td>

0.981

</td>

<td>

</td>

<td>

0.043<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.022

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.984)

</td>

<td>

</td>

<td>

(0.012)

</td>

<td>

</td>

<td>

(0.019)

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

County FEs

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

</tr>

<tr>

<td style="text-align:left">

Year FEs

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

</tr>

<tr>

<td style="text-align:left">

Observations

</td>

<td>

48,018

</td>

<td>

35,901

</td>

<td>

42,843

</td>

<td>

36,103

</td>

<td>

42,841

</td>

<td>

36,100

</td>

</tr>

<tr>

<td style="text-align:left">

R<sup>2</sup>

</td>

<td>

0.004

</td>

<td>

0.009

</td>

<td>

0.005

</td>

<td>

0.014

</td>

<td>

0.008

</td>

<td>

0.020

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

<em>Note:</em>

</td>

<td colspan="6" style="text-align:right">

Robust standard errors, p\<0.1 <sup>+</sup>; p\<0.05 <sup>++</sup>;
p\<0.01 <sup>+++</sup>

</td>

</tr>

</table>

## County fixed and with controls

Only county fixed effects, the year fixed effects are omitted.

<table style="text-align:center">

<caption>

<strong>County Fixed Effects Results</strong>

</caption>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="6">

Inverse Hyperbolic Sine of

</td>

</tr>

<tr>

<td>

</td>

<td colspan="6" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

Ch. 12 Rate

</td>

<td>

Ch. 12 Rate

</td>

<td>

Production Delinq.

</td>

<td>

Production Delinq.

</td>

<td>

Farmland Delinq.

</td>

<td>

Farmland Delinq.

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(1)

</td>

<td>

(2)

</td>

<td>

(3)

</td>

<td>

(4)

</td>

<td>

(5)

</td>

<td>

(6)

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

dday\_good

</td>

<td>

\-0.001<sup>\*\*\*</sup>

</td>

<td>

\-0.0002<sup>\*\*</sup>

</td>

<td>

0.00000

</td>

<td>

0.00000

</td>

<td>

0.00001<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.0001)

</td>

<td>

(0.0001)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

dday34

</td>

<td>

0.0003

</td>

<td>

0.001

</td>

<td>

0.00001

</td>

<td>

\-0.00003<sup>\*\*</sup>

</td>

<td>

0.0001<sup>\*\*\*</sup>

</td>

<td>

0.00000

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.001)

</td>

<td>

(0.001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00002)

</td>

<td>

(0.00002)

</td>

</tr>

<tr>

<td style="text-align:left">

prec

</td>

<td>

\-0.00002

</td>

<td>

0.0001

</td>

<td>

0.00000

</td>

<td>

0.00000

</td>

<td>

0.00002<sup>\*\*\*</sup>

</td>

<td>

0.00001<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.0002)

</td>

<td>

(0.0003)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00001)

</td>

</tr>

<tr>

<td style="text-align:left">

I(prec2)

</td>

<td>

0.000

</td>

<td>

\-0.00000

</td>

<td>

\-0.000

</td>

<td>

\-0.000

</td>

<td>

\-0.000<sup>\*\*</sup>

</td>

<td>

\-0.000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(covered\_impute/1000)

</td>

<td>

\-0.0004<sup>\*\*\*</sup>

</td>

<td>

\-0.00005

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00004)

</td>

<td>

(0.00005)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(subsidy/1000)

</td>

<td>

\-0.0001<sup>\*\*\*</sup>

</td>

<td>

\-0.0001<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(indemnity/1000)

</td>

<td>

\-0.00000

</td>

<td>

\-0.00000

</td>

<td>

0.000

</td>

<td>

0.00000<sup>\*\*</sup>

</td>

<td>

\-0.00000

</td>

<td>

0.000

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(farmland\_val\_per\_acre\_interp/1000)

</td>

<td>

</td>

<td>

\-0.334<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.008<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.013<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.052)

</td>

<td>

</td>

<td>

(0.001)

</td>

<td>

</td>

<td>

(0.002)

</td>

</tr>

<tr>

<td style="text-align:left">

lag(I(farmland\_val\_per\_acre\_interp/1000))

</td>

<td>

</td>

<td>

0.293<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.007<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.014<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.057)

</td>

<td>

</td>

<td>

(0.001)

</td>

<td>

</td>

<td>

(0.002)

</td>

</tr>

<tr>

<td style="text-align:left">

I(farms\_interp/1000)

</td>

<td>

</td>

<td>

\-1.153<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.010<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.017<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.100)

</td>

<td>

</td>

<td>

(0.002)

</td>

<td>

</td>

<td>

(0.003)

</td>

</tr>

<tr>

<td style="text-align:left">

livestock\_share

</td>

<td>

</td>

<td>

\-0.170

</td>

<td>

</td>

<td>

0.001

</td>

<td>

</td>

<td>

0.004

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.131)

</td>

<td>

</td>

<td>

(0.002)

</td>

<td>

</td>

<td>

(0.004)

</td>

</tr>

<tr>

<td style="text-align:left">

pct\_irrigated

</td>

<td>

</td>

<td>

\-2.248<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.003

</td>

<td>

</td>

<td>

0.014

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.634)

</td>

<td>

</td>

<td>

(0.012)

</td>

<td>

</td>

<td>

(0.013)

</td>

</tr>

<tr>

<td style="text-align:left">

unemp\_rate

</td>

<td>

</td>

<td>

4.557<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.082<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.188<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.518)

</td>

<td>

</td>

<td>

(0.010)

</td>

<td>

</td>

<td>

(0.015)

</td>

</tr>

<tr>

<td style="text-align:left">

I(total\_branches/1000)

</td>

<td>

</td>

<td>

0.682

</td>

<td>

</td>

<td>

0.036<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.010

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.890)

</td>

<td>

</td>

<td>

(0.012)

</td>

<td>

</td>

<td>

(0.019)

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

County FEs

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

</tr>

<tr>

<td style="text-align:left">

Year FEs

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

</tr>

<tr>

<td style="text-align:left">

Observations

</td>

<td>

48,018

</td>

<td>

35,901

</td>

<td>

42,843

</td>

<td>

36,103

</td>

<td>

42,841

</td>

<td>

36,100

</td>

</tr>

<tr>

<td style="text-align:left">

R<sup>2</sup>

</td>

<td>

0.038

</td>

<td>

0.029

</td>

<td>

0.018

</td>

<td>

0.025

</td>

<td>

0.005

</td>

<td>

0.034

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

<em>Note:</em>

</td>

<td colspan="6" style="text-align:right">

Robust standard errors, p\<0.1 <sup>+</sup>; p\<0.05 <sup>++</sup>;
p\<0.01 <sup>+++</sup>

</td>

</tr>

</table>

## Time fixed and with controls

Only time fixed effects, no county fixed effects.

<table style="text-align:center">

<caption>

<strong>Time Fixed Effects Results</strong>

</caption>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td colspan="6">

Inverse Hyperbolic Sine of

</td>

</tr>

<tr>

<td>

</td>

<td colspan="6" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

Ch. 12 Rate

</td>

<td>

Ch. 12 Rate

</td>

<td>

Production Delinq.

</td>

<td>

Production Delinq.

</td>

<td>

Farmland Delinq.

</td>

<td>

Farmland Delinq.

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(1)

</td>

<td>

(2)

</td>

<td>

(3)

</td>

<td>

(4)

</td>

<td>

(5)

</td>

<td>

(6)

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

dday\_good

</td>

<td>

0.0001<sup>\*\*</sup>

</td>

<td>

\-0.00001

</td>

<td>

\-0.00000

</td>

<td>

\-0.00000<sup>\*</sup>

</td>

<td>

0.00000

</td>

<td>

\-0.00000

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00004)

</td>

<td>

(0.00004)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

dday34

</td>

<td>

\-0.0002

</td>

<td>

0.0003

</td>

<td>

0.00001

</td>

<td>

0.00001

</td>

<td>

\-0.00001

</td>

<td>

0.00000

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.001)

</td>

<td>

(0.001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00002)

</td>

<td>

(0.00002)

</td>

<td>

(0.00002)

</td>

</tr>

<tr>

<td style="text-align:left">

prec

</td>

<td>

\-0.001<sup>\*\*\*</sup>

</td>

<td>

\-0.0004

</td>

<td>

\-0.00001<sup>\*\*\*</sup>

</td>

<td>

\-0.00000

</td>

<td>

\-0.00002<sup>\*\*\*</sup>

</td>

<td>

\-0.00001<sup>\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.0002)

</td>

<td>

(0.0002)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(prec2)

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000

</td>

<td>

0.000

</td>

<td>

\-0.000

</td>

<td>

0.000<sup>\*\*\*</sup>

</td>

<td>

0.000

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

<td>

(0.000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(covered\_impute/1000)

</td>

<td>

0.0002<sup>\*\*\*</sup>

</td>

<td>

0.0001<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

<td>

0.00000<sup>\*\*</sup>

</td>

<td>

0.00000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00002)

</td>

<td>

(0.00002)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(subsidy/1000)

</td>

<td>

\-0.00003<sup>\*\*\*</sup>

</td>

<td>

\-0.00002<sup>\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00001)

</td>

<td>

(0.00001)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(indemnity/1000)

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000

</td>

<td>

\-0.00000

</td>

<td>

0.000

</td>

<td>

\-0.00000<sup>\*\*\*</sup>

</td>

<td>

\-0.00000

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

<td>

(0.00000)

</td>

</tr>

<tr>

<td style="text-align:left">

I(farmland\_val\_per\_acre\_interp/1000)

</td>

<td>

</td>

<td>

\-0.431<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.008<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.014<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.050)

</td>

<td>

</td>

<td>

(0.001)

</td>

<td>

</td>

<td>

(0.002)

</td>

</tr>

<tr>

<td style="text-align:left">

lag(I(farmland\_val\_per\_acre\_interp/1000))

</td>

<td>

</td>

<td>

0.421<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.009<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.015<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.053)

</td>

<td>

</td>

<td>

(0.001)

</td>

<td>

</td>

<td>

(0.002)

</td>

</tr>

<tr>

<td style="text-align:left">

I(farms\_interp/1000)

</td>

<td>

</td>

<td>

0.132<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

\-0.001

</td>

<td>

</td>

<td>

\-0.003<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.024)

</td>

<td>

</td>

<td>

(0.0004)

</td>

<td>

</td>

<td>

(0.001)

</td>

</tr>

<tr>

<td style="text-align:left">

livestock\_share

</td>

<td>

</td>

<td>

0.144<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.0003

</td>

<td>

</td>

<td>

0.004<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.049)

</td>

<td>

</td>

<td>

(0.001)

</td>

<td>

</td>

<td>

(0.001)

</td>

</tr>

<tr>

<td style="text-align:left">

pct\_irrigated

</td>

<td>

</td>

<td>

1.228<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.004<sup>\*</sup>

</td>

<td>

</td>

<td>

0.004<sup>\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.128)

</td>

<td>

</td>

<td>

(0.002)

</td>

<td>

</td>

<td>

(0.002)

</td>

</tr>

<tr>

<td style="text-align:left">

unemp\_rate

</td>

<td>

</td>

<td>

1.990<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.033<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.087<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.560)

</td>

<td>

</td>

<td>

(0.009)

</td>

<td>

</td>

<td>

(0.017)

</td>

</tr>

<tr>

<td style="text-align:left">

I(total\_branches/1000)

</td>

<td>

</td>

<td>

0.735<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.025<sup>\*\*\*</sup>

</td>

<td>

</td>

<td>

0.029<sup>\*\*\*</sup>

</td>

</tr>

<tr>

<td style="text-align:left">

</td>

<td>

</td>

<td>

(0.281)

</td>

<td>

</td>

<td>

(0.009)

</td>

<td>

</td>

<td>

(0.009)

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

County FEs

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

<td>

No

</td>

</tr>

<tr>

<td style="text-align:left">

Year FEs

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

<td>

Yes

</td>

</tr>

<tr>

<td style="text-align:left">

Observations

</td>

<td>

48,018

</td>

<td>

35,901

</td>

<td>

42,843

</td>

<td>

36,103

</td>

<td>

42,841

</td>

<td>

36,100

</td>

</tr>

<tr>

<td style="text-align:left">

R<sup>2</sup>

</td>

<td>

0.011

</td>

<td>

0.030

</td>

<td>

0.008

</td>

<td>

0.021

</td>

<td>

0.016

</td>

<td>

0.029

</td>

</tr>

<tr>

<td colspan="7" style="border-bottom: 1px solid black">

</td>

</tr>

<tr>

<td style="text-align:left">

<em>Note:</em>

</td>

<td colspan="6" style="text-align:right">

Robust standard errors, p\<0.1 <sup>+</sup>; p\<0.05 <sup>++</sup>;
p\<0.01 <sup>+++</sup>

</td>

</tr>

</table>
