m4_include(`commons.m4')

_HEADER_HL1(`[SMT][Z3][Python] Job Shop Scheduling/Problem')

<p>You have number of machines and number of jobs.
Each jobs consists of tasks, each task is to be processed on a machine, in specific order.</p>

<p>Probably, this can be a restaurant, each dish is a job.
However, a dish is to be cooked in a multi-stage process, and each stage/task require specific kitchen appliance and/or chef.
Each appliance/chef at each moment can be busy with only one single task.</p>

<p>The problem is to schedule all jobs/tasks so that they will finish as soon as possible.</p>

<p>See also:
_HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Job_shop_scheduling'),
_HTML_LINK_AS_IS(`https://developers.google.com/optimization/scheduling/job_shop').</p>

<p>The program:</p>

_PRE_BEGIN
m4_include(`blog/job_shop/job.py')
_PRE_END

<p>( Syntax-highlighted version: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/job_shop/job.py') )</p>

<p>The solution for the 3*3 (3 jobs and 3 machines) problem:</p>

_PRE_BEGIN
m4_include(`blog/job_shop/r1.txt')
_PRE_END

<p>It takes ~20s on my venerable Intel Xeon E31220 3.10GHz to solve 10*10 (10 jobs and 10 machines) problem from _HTML_LINK(`http://support.sas.com/documentation/cdl/en/orcpug/63973/HTML/default/viewer.htm#orcpug_clp_sect048.htm',`sas.com'):
_HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/job_shop/r2.txt',`r2.txt').</p>

<p>Further work: makespan can be decreased gradually, or maybe binary search can be used...</p>

_BLOG_FOOTER()

