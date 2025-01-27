{smcl}
{hline}
{hi:help nwxtregress}{right: v. 0.02 - 11. August 2021}

{hline}
{title:Title}

{p 4 4}{cmdab:nwxtreg:ress} - Network Regressions in Stata with unbalanced panel data and time varying network structures or spatial weight matrices.{p_end}

{title:Contents}
{p 4}{help nwxtregress##syntax:Syntax}{p_end}
{p 4}{help nwxtregress##description:Description}{p_end}
{p 4}{help nwxtregress##options:Options}{p_end}
{p 4}{help nwxtregress##DIE:Direct, Indirect and Total Effects}{p_end}
{p 4}{help nwxtregress##postest:Postestimation}{p_end}
{p 4}{help nwxtregress##saved_vales:Saved Values}{p_end}
{p 4}{help nwxtregress##examples:Examples}{p_end}
{p 4}{help nwxtregress##references:References}{p_end}
{p 4}{help nwxtregress##about:About, Authors and Version History}{p_end}


{marker syntax}{title:Syntax}

{p 4}{ul:Spatial Autocorrelation Model (SAR)}{p_end}

{p 4 13}{cmdab:nwxtreg:ress} {depvar} [{indepvars}]  [if] {cmd:,}
 {cmd:dvarlag(W1[,}{it:options1}{cmd:])}
 [{it:mcmcoptions}
 {cmd:nosparse}]
 {p_end}

{p 4}{ul:Spatial Durbin Model (SAR)}{p_end}

{p 4 13}{cmdab:nwxtreg:ress} {depvar} [{indepvars}]  [if] {cmd:,}
    {cmd:dvarlag(W1[,}{it:options1}{cmd:])}
    {cmd:ivarlag(W2[,}{it:options1}{cmd:])}
    [{it:mcmcoptions}
    {cmd:nosparse}]
{p_end}

{p 4 13}where {cmd:W1} and {cmd:W2} are spatial weight matrices. Default is {help Sp} object.
{cmd:dvarlag()} and {cmd:ivarlag()} define the spatial lag of the dependent
and independent variables. 
{cmd:ivarlag()} is repeatable with different spatial weights.{p_end}

{p 4}{ul: Maintenance}{p_end}

{p 4 13}{cmd:nwxtregress , [update version]}{p_end}

{p 8}{cmd:version} displays version. 
{cmd:update} updates {cmd:nwxtregress} from {browse "https://janditzen.github.io/nwxtregress/":GitHub}
using {help net install}.{p_end}

{p 4}{ul:General Options}{p_end}
{synoptset 20}{...}
{synopt:Option}Description{p_end}
{synoptline}
{synopt:{it:nosparse}}do not convert weight matrix internally to a sparse matrix{p_end}
{synopt:{it:asarray(name)}}change name of array with estimation results and info{p_end}
{synoptline}
{p2colreset}{...}

{p 4}{ul:{it:Options1}}{p_end}
{synoptset 20}{...}
{synopt:Option}Description{p_end}
{synoptline}
{synopt:{it:mata}}declares weight matrix is mata matrix.{p_end}
{synopt:{it:frame(name)}}name of the frame for weight matrix data.{p_end}
{synopt:{it:sparse}}if weight matrix is sparse.{p_end}
{synopt:{it:timesparse}}weight matrix is sparse and varying over time.{p_end}
{synopt:{it:id(string)}}vector of IDs if W is a non sparse mata matrix{p_end}
{synopt:{ul:norm}alize(string)}which normalization to use.
{synoptline}
{p2colreset}{...}

{p 4}{ul:{it:mcmcoptions}}{p_end}
{synoptset 20}{...}
{synopt:Option}Description{p_end}
{synoptline}
{synopt:{it:draws()}}number of griddy gibs draws, default 2000{p_end}
{synopt:{it:gridlength()}}grid length, default 1000{p_end}
{synopt:{it:nomit()}}number of omitted draws, default 500{p_end}
{synopt:{it:barrypace(numlist)}}settings for BarryPace Trick. Order is iterations, maxorder. Default is 50 and 100{p_end}
{synopt:{it:usebp}}use BarryPace trick instead of LUD for inverse of (I−ρW).{p_end}
{synopt:{it:seed(#)}}sets the seed{p_end}
{synoptline}
{p2colreset}{...}

{p 4 4}Data has to be xtset before using {cmd:nwxtregress}; see {help xtset}. {depvars} and {indepvars}  may contain time-series operators, see {help tsvarlist}.{p_end}

{marker description}{title:Description}

{p 4 4}{cmd:nwxtregress} estimates Spatial Autoregressive (SAR) or Spatial Durbin (SDM) models. The spatial weight matrices are allowed to be time varying and the dataset can be unbalanced.{p_end}

{p 4 4}The SAR is:{p_end}

{col 8}Y = rho W1 Y + beta X + eps

{p 4 4}The SDM is:{p_end}

{col 8}Y = rho W1 Y + beta X + gamma W2 X + eps

{p 4 4}where W1 and W2 are spatial weight matrices, Y the dependent and X the independent variables.{p_end}


{p 4 4}{cmd:nwxtregress} can handle spatial weights in three formats:
1. square matrix, 2. sparse and 3. time sparse.{break}
Sparse matrices have the advantage that they save space and thus computational time
and allow for time varying weights.{break}
The {help Sp} environment only supports the square matrix format. 
{cmd:nwxtregress} can read square, sparse and time sparse formats if the 
data for the weights is in {help mata} or saved in a {help frame}.{p_end}

{p 6 6}{ul:1. Square matrix format}: the spatial weights are a matrix with dimension N_g x N_g. It is time constant. {break}
An Example with a 5 x 5 matrix is:{p_end}

{col 12}        1    2    3    4
{col 12}    +---------------------+
{col 12}  1 |   0   .1   .2    0  |
{col 12}  2 |   0    0   .1   .2  |
{col 12}  3 |  .3   .1    0    0  |
{col 12}  4 |  .2    0   .2    0  |
{col 12}    +---------------------+

{p 6 6}{ul:2. Sparse format}: The sparse matrix format is a {it:v} x 3 matrix, 
where {it:v} is the number of non-zero elements in the spatial weight matrix. 
The weight matrix is time constant.
The first column indicates the destination, the second the origin of the flow.{break}
A sparse matrix of the matrix from above is:{p_end}

{col 12}Destination {col 25}Origin{col 35}Flow
{col 12}1 {col 25}2 {col 35}0.1
{col 12}1 {col 25}3 {col 35}0.2
{col 12}2 {col 25}3 {col 35}0.1
{col 12}2 {col 25}4 {col 35}0.2
{col 12}3 {col 25}1 {col 35}0.3
{col 12}3 {col 25}2 {col 35}0.1
{col 12}4 {col 25}1 {col 35}0.2
{col 12}4 {col 25}3 {col 35}0.2

{p 6 6}{ul:3. Time-Sparse format}: The time sparse format can handle time varying spatial weights. 
The first column indicates the time period, the remaining are the same as
for the sparse matrix.{break}
For example, if there are two time periods and we have the matrix from 
above for the first and the square for the second period:{p_end}

{col 12}Time {col 20}Destination {col 35}Origin{col 45}Flow
{col 12}1 {col 20}1 {col 35}2 {col 45}0.1
{col 12}1 {col 20}1 {col 35}3 {col 45}0.2
{col 12}1 {col 20}2 {col 35}3 {col 45}0.1
{col 12}1 {col 20}2 {col 35}4 {col 45}0.2
{col 12}1 {col 20}3 {col 35}1 {col 45}0.3
{col 12}1 {col 20}3 {col 35}2 {col 45}0.1
{col 12}1 {col 20}4 {col 35}1 {col 45}0.2
{col 12}1 {col 20}4 {col 35}3 {col 45}0.2
{col 15}({it:next time period})
{col 12}2 {col 20}1 {col 35}2 {col 45}0.1
{col 12}2 {col 20}1 {col 35}3 {col 45}0.4
{col 12}2 {col 20}2 {col 35}3 {col 45}0.1
{col 12}2 {col 20}2 {col 35}4 {col 45}0.4
{col 12}2 {col 20}3 {col 35}1 {col 45}0.9
{col 12}2 {col 20}3 {col 35}2 {col 45}0.1
{col 12}2 {col 20}4 {col 35}1 {col 45}0.4
{col 12}2 {col 20}4 {col 35}3 {col 45}0.4

{p 4 4}Internally, {cmd:nextregress} will always use the time sparse format. 
This ensures that unbalanced panels do not pose a problem. 
{cmd:nextregress} comes with functions for creating sparse matrices,
coplying a sparse matrix into a squared format, 
and functions for mathematical operations (transpose and multiplication).{p_end}


{marker options}{...}
{title:Options}

{phang}
{opt frame(name)} declares weight matrix is saved in a frame. Default is to use a spatial weight matrix from the Sp environmen

{phang}
{opt mata} declares weight matrix is mata matrix. Default is to use a spatial weight matrix from the Sp environment.

{phang}
{opt sparse} if weight matrix is in sparse format. Sparse format implies that the first two column define the origin and the destination of the flow, the third column the value of the flow.

{phang}
{opt timesparse} weight matrix is sparse and varying over time. As sparse but first column includes the time period. Implies option {cmd:mata}.

{phang}
{opt id(string)}  vector of IDs if W is a non sparse mata matrix.

{phang}
{opt norm:alization(string)} which normalization to use for spatial weight matrix.
Default is row normalisation. 
Can be {it:none}, {it:row} (default), {it:{ul:col}umn}, {it:{ul:spec}tral} or {it:minmax}, see {help spmatrix_create##normalize:spmatrix create}.
The normalisation is done for each time period individually.

{phang}
{opt nosparse} not convert weight matrix internally to a sparse matrix.

{phang}
{opt asarray(name)} {cmd:nwxtregress} saves intermediate results such as the spatial weight matrix 
in an internal time sparse format, 
residuals and results from the MCMC in an array, see {help nwxtregress##saved_vales:stored values}.
It is not recommended to change contents of the array and the option to change the name 
should only be rarely used.
The default name is {it:_NWXTREG_OBJECT#}, where {it:#} is a counter if
the array already existed.{p_end}

{phang}
{opt draws()} number of griddy gibs draws, default 2000.

{phang}
{opt gridlength()} grid length, default 1000.

{phang}
{opt nomit()} number of omitted draws, default 500.

{phang}
{opt barrypace(numlist)} settings for BarryPace Trick. Order is iterations, maxorder. Default is 50 and 100.

{phang}
{opt usebp} use BarryPace trick instead of LUD for inverse of (I−ρW).

{phang}
{opt seed(#)} sets the {help seed}.

{phang}
{opt version} display version.

{phang}
{opt update} update from Github.


{marker DIE}{...}
{title:Direct, indirect and total Effects}

{p 4 4}Direct, indirect and total effects can be calculated using {cmd:estat impact}. The syntax is:{p_end}

{p 8 13}{cmd:estat} impact [{varlist}] [, options]{p_end}

{synoptset 20}{...}
{synopt:Options}Description{p_end}
{synoptline}
{synopt:{it:seed(#)}}set seed for Barry Pace matrix inversion.{p_end}
{synopt:{it:array(name)}}name of array with saved contents from {cmd:nwxtregress}, see {help nwxtregress##saved_vales:stored results}.{p_end}
{synoptline}
{p2colreset}{...}

{p 4 4}{varlist} defines the variables for which the direct, indirect and total effects are displayed.
If not specified, then {cmd:estat impact} will calculate the effects for all explanatory variables ({indepvars}).{p_end}

{p 4 4}{cmd:estat impact} saves the following in {cmd:r()}:{p_end}

{col 4} Matrices
{col 8}{cmd: r(b_direct)}{col 27} Coefficient Matrix of direct effects
{col 8}{cmd: r(V_direct)}{col 27} Variance covariance matrix of direct effects
{col 8}{cmd: r(b_indirect)}{col 27} Coefficient Matrix of indirect effects
{col 8}{cmd: r(V_indirect)}{col 27} Variance covariance matrix of indirect effects 
{col 8}{cmd: r(b_total)}{col 27} Coefficient Matrix of total effects
{col 8}{cmd: r(V_total)}{col 27} Variance covariance matrix of total effects

{marker postest}{title:Postestimation commands}

{p 4 4}{help predict} can be used after {cmd:nwxtregress}.{p_end}

{p 4 4}The syntax for {cmd:predict} is:{p_end}

{p 8 13}{cmd:predict} [{help data_types:type}] {varname} [, options]

{synoptset 20}{...}
{synopt:Options}Description{p_end}
{synoptline}
{synopt:{it:xb}}calculate linear prediction.{p_end}
{synopt:{it:res}}calculate residuals.{p_end}
{synopt:{it:replace}}replace if {varname} exists.{p_end}
{synopt:{it:array(name)}}name of array with saved contents from {cmd:nwxtregress}, see {help nwxtregress##saved_vales:stored results}.{p_end}
{synoptline}
{p2colreset}{...}


{marker saved_vales}{title:Stored Values}

{p 4}{cmd:nwxtregress test} stores the following in {cmd:e()}:{p_end}

{col 4} Matrices
{col 8}{cmd: e(b)}{col 27} Coefficient Matrix. 
{col 8}{cmd: e(V)}{col 27} Variance-Covariance Matrix. 

{col 4} Scalars
{col 8}{cmd: e(N)}{col 27} Number of observations
{col 8}{cmd: e(N_g)}{col 27} Number of groups
{col 8}{cmd: e(T)}{col 27} Number of time periods
{col 8}{cmd: e(Tmin)}{col 27} Minimum number of time periods
{col 8}{cmd: e(Tavg)}{col 27} Average number of time periods
{col 8}{cmd: e(Tmax)}{col 27} Maximum number of time periods
{col 8}{cmd: e(K)}{col 27} Number of regressors excluding spatial lags
{col 8}{cmd: e(Kfull)}{col 27} Number of regressors including spatial lags
{col 8}{cmd: e(r2)}{col 27} R-squared
{col 8}{cmd: e(r2_a)}{col 27} adjusted R-squared
{col 8}{cmd: e(MCdraws)}{col 27} Number of MCMC draws

{col 4} Macros
{col 8}{cmd: e(sample)}{col 27} Sample

{p 4 4}In addition to {cmd:e()} and {cmd:r()} {cmd:nwxtregress} saves informations about the estimation
 in a mata {help mata array:array}.
The contents are the weight matrix in time sparse format, residuals and results from the MCMC.
Storing those saves time for {cmd:estat impact} and {help predict}.
The name default name of the array is {it:_NWXTREG_OBJECT#}, but can be set with the option {cmd:asarray()}.
In general it is not recommended to change this setting.{p_end}

{marker examples}{...}
{title:Examples}

{p 4 4}An example dataset with USE/MAKE table data from the BEA’s website and links between industries is available {browse "https://github.com/JanDitzen/nwxtregress/tree/main/examples":GitHub}. 
The dataset {it:IO.dta} contains the linkages (spatial weights) and the dataset {it:VA.dta} the firm data. 
We want to estimate capital consumption by using compensation and net surplus as explanatory variables.{p_end}

{p 4 4}First we load the data from the IO dataset and convert into a SP object for the year 1998.{p_end}

{col 8}{stata "use https://janditzen.github.io/nwxtregress/examples/IO.dta"}
{col 8}{stata keep if Year == 1998}
{col 8}{stata replace sam = 0 if sam < 0}
{col 8}{stata replace sam = 0 if ID1==ID2}
{col 8}{stata keep ID1 ID2 sam}
{col 8}{stata reshape wide sam, i(ID1) j(ID2)}
{col 8}{stata spset ID1}
{col 8}{stata spmatrix fromdata WSpmat = sam* , replace}

{p 4 4}Next, we load the dataset with the firm data and estimate a SAR with a time constant spatial weight matrix. 
We also obtain the total, direct and indirect effects using {cmd:estat impact}. 
For reproducibility we set a {it:seed}.{p_end}

{col 8}{stata "use https://janditzen.github.io/nwxtregress/examples/VA.dta"}
{col 8}{stata nwxtregress cap_cons compensation net_surplus , dvarlag(WSpmat) seed(1234)}
{col 8}{stata estat impact}

{p 4 4}The disadvantage is that the spatial weight are constant across time 
and we had to get rid of all negative numbers.
To allow for time varying spatial weights, we load the W dataset again and but load it into 
the {help frame} IO:{p_end}

{col 8}{stata frame create IO}
{col 8}{stata "frame IO: use https://janditzen.github.io/nwxtregress/examples/IO.dta"}

{p 4 4}Using the VA dataset again, we can estimate the SAR model with time varying spatial weights. 
To do so we use the options {cmd:frame(name)}, where {it:name} indicates the frame
and the weight matrix name corresponds to the variable names.
The data is in timesparse format so we need to use the option {it:timesparse}.
Finally it is nessary to define the year identifier and the origin and destination of the 
flows using the {cmd:id()} option:{p_end}

{col 8}{stata nwxtregress cap_cons compensation net_surplus ,dvarlag(sam, frame(IO) id(Year ID1 ID2)  timesparse) seed(1234) }

{p 4 4}Alternatively we can load the spatial weight matrix into mata:{p_end}

{col 8}{stata "frame IO: putmata Wt = (Year ID1 ID2 sam), replace"}
{col 8}{stata nwxtregress cap_cons compensation net_surplus , dvarlag(Wt, mata timesparse) seed(1234)}

{p 4 4}If we want to estimate an SDM by adding the option {cmd:ivarlag()}:{p_end}

{col 8}{stata "nwxtregress cap_cons compensation net_surplus , dvarlag(Wt,mata timesparse) ivarlag(Wt: compensation,mata timesparse )  seed(1234)"}

{p 4 4}We can also define two different spatial weight matrices:{p_end}

{col 8}{stata "mata: Wt2 = Wt[selectindex(Wt[.,4]:>2601.996),.]"}
{col 8}{stata "nwxtregress cap_cons compensation net_surplus , dvarlag(Wt, mata timesparse) ivarlag(Wt: net_surplus, mata timesparse) ivarlag(Wt2: compensation, mata timesparse) seed(1234)"}

{p 4 4}Total, direct and indirect effects can be calculated using {cmd:estat impact}:{p_end}

{col 8}{stata estat impact}

{p 4 4}To predict fitted values and residuals {cmd: predict} can be used:{p_end}

{col 8}{stata predict xb}
{col 8}{stata predict residuals, residual}


{marker references}{title:References}


{marker about}{title:How to install}

{p 4 4}The latest version of the nwxtregress package can be obtained by typing in Stata:{p_end}

{col 8}{stata "net from https://janditzen.github.io/nwxtregress/"}


{title:Acknowledgments}

{p 4 4}We are grateful to James LeSage for guidance and for sharing code that was instrumental to our ability to create the {cmd:nwxtreg} command. 
This article also benefited from comments from Zack Liu, Ioannis Spyridopoulos, and Adam Winegar. 
All remaining errors are our own.{p_end}

{p 4 4}Jan Ditzen acknowledges financial support from Italian Ministry MIUR under 
the PRIN project Hi-Di NET - Econometric Analysis of High Dimensional Models
 with Network Structures in Macroeconomics and Finance (grant 2017TA7TYC).{p_end}


{title:Authors}

{p 4}Jan Ditzen (Free University of Bozen-Bolzano){p_end}
{p 4}Email: jan.ditzen@unibz.it{p_end}
{p 4}Web: {browse www.jan.ditzen.net}{p_end}

{p 4}William Grieser (Texas Christian University){p_end}
{p 4}Email: w.grieser@tcu.edu{p_end}
{p 4}Web: {browse www.williamgrieser.com/}{p_end}

{p 4}Morad Zekhnini (Michigan State University){p_end}
{p 4}Email: zekhnini@msu.edu{p_end}
{p 4}Web: {browse "https://sites.google.com/view/moradzekhnini/home"}{p_end}

{title:Changelog}
{p 4 4}{ul:Version 0.03 (alpha)}{p_end}
{p 8 8}- Bugs in sparse matrix multiplication and return if non sparse matrix is used fixed.{p_end}
