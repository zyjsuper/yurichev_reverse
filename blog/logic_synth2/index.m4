m4_include(`commons.m4')

_HEADER_HL1(`Simple logic synthesis using Z3: exercise from TAOCP')

Found this exercise in _HTML_LINK(`http://www.cs.utsa.edu/~wagner/knuth/fasc0b.pdf',`TAOCP section 7.1.1 (Boolean basics)'):

<p><img src="page3.png" class="ImageBorder" /></p>

<p><img src="page34.png" class="ImageBorder" /></p>

<p>I', not clever enough to solve this manually, but I could try using logic synthesis, _HTML_LINK(`https://yurichev.com/blog/logic_synth/',`as I did before').
As they say, "machines should work; people should think".</p>

<p>My solutions for
_HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/logic_synth2/nand.txt',`NAND'),
_HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/logic_synth2/nand_constants.txt',`NAND with 0/1 constants'),
_HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/logic_synth2/andn.txt',`ANDN'),
_HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/logic_synth2/andn_constants.txt',`ANDN with 0/1 constants').</p>

<p>Correct answers from TAOCP:</p>

<p><img src="page51.png" class="ImageBorder" /></p>

<p>My solutions are slightly different: I haven't "pass through" instruction, so sometimes a value is copied from the input to the output using NAND/ANDN.
Also, my versions are sometimes different, but correct and has the same length.</p>

<p>The _HTML_LINK(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/logic_synth2/logic_for_TAOCP.py',`modified Z3Py script').</p>

_FOOTER()

