m4_include(`commons.m4')

_HEADER_HL1(`16-May-2015: Tweaking LLVM Obfuscator + quick look into some of LLVM internals.')

<p>Code obfuscating is a good example of _HTML_LINK(`http://en.wikipedia.org/wiki/Security_through_obscurity',`security through obscurity') 
and is intended to make things harder for reverse engineer.</p>

<p>In past, I tried to _HTML_LINK(`http://blog.yurichev.com/node/58',`patch Tiny C compiler to produce really messy code'), 
which, as far as I known, can be easily simplified by Hex-Rays decompiler.</p>

<p>One of the much more known examples is _HTML_LINK(`https://github.com/obfuscator-llvm/obfuscator/wiki',`LLVM Obfuscator'), 
which is set of transformation passes for LLVM.</p>

<p>One of its transform passes is _HTML_LINK(`https://github.com/obfuscator-llvm/obfuscator/blob/llvm-3.5/lib/Transforms/Obfuscation/Substitution.cpp',`substitution of some primitive operation like AND or XOR to much more messy code').</p>

<p>For the sake of experiment, I tried to add support of _HTML_LINK(`http://blog.yurichev.com/node/86',`one really strange XOR equivalent I accidentally found using Aha! superoptimizer').
This is <i>(((x & y) * -2) + (x + y))</i>, which is, hard to believe, behaves just like XOR operation without actual XOR operation.</p>

<p>So here we go, let's open <i>lib/Transforms/Obfuscation/Substitution.cpp</i> file and add this:</p>

<pre>
// Implementation of a = (((x & y) * -2) + (x + y))
void Substitution::xorSubstitutionAha(BinaryOperator *bo) {
  Type *ty = bo->getType();

  // get operands
  Value *x = bo->getOperand(0);
  Value *y = bo->getOperand(1);

  ConstantInt *co = (ConstantInt *)ConstantInt::get(ty, -2, true /* isSigned */); // -2

  // first half of expression: (x & y) * -2
  BinaryOperator *op1 = BinaryOperator::Create(Instruction::Mul, 
					       BinaryOperator::Create(Instruction::And, y, x, "", bo), 
					       co, // -2
					       "", bo);

  // second half of expression: x + y
  BinaryOperator *op2 = BinaryOperator::Create(Instruction::Add,
					       x,
					       y,
					       "", bo);
  // sum up both halves
  BinaryOperator *op = BinaryOperator::Create(Instruction::Add,
					       op1,
					       op2,
					       "", bo);
  bo->replaceAllUsesWith(op);
}
</pre>

<p>The function takes expression in form <i>x^y</i> on input and returns its transformed version.</p>

<p>At the first 3 lines of the function, we get type of values and both of arguments.</p>

<p>We then construct -2 signed value, then construct both halves of expression and finally, join them at the end
using ADD operation.</p>

<p>Resulting expression has all this stuff inside.</p>

<p>It may be hard to understand for newbies, but LISPers will grasp this at very first sight.
<i>Value</i> C++ class is the object containing actual value inside plus some information about its type.
<i>ConstantInt</i> class is probably the same.
<i>BinaryOperator</i> C++ class, perhaps, has at least three members: operation and two links (pointers) to other
classes, which could has type of <i>Value</i> or <i>BinaryOperator</i>.
Thus, expression elements can be combined, nested, sliced, etc.</p>

<p><i>op1</i> can be graphically represented in this form:</p>

<pre>
op1 = +-----+
      | MUL |
      |     | ----> +-----+
      |     | --+   | AND |         +-----------+
      +-----+   |   |     | ------> | (Value) x |
                |   |     | ---+    +-----------+
                |   +-----+    |
                |              |    +-----------+
                |              +--> | (Value) y |
                |                   +-----------+
                |
                +---> +------------------+
                      | (ConstantInt) -2 |
                      +------------------+
</pre>

<p><i>op2</i> is just:</p>

<pre>
op2 = +-----+                      
      | AND |         +-----------+
      |     | ------> | (Value) x |
      |     | ---+    +-----------+
      +-----+    |                 
                 |    +-----------+
                 +--> | (Value) y |
                      +-----------+
</pre>

<p><i>op</i> is construction of ADD operation with two pointers to both halves we've just constructed:</p>

<pre>
op = +-----+
     | ADD |
     |     | ------------------> +-----+                             
     |     | ---> +-----+        | MUL |                             
     +-----+      | ADD |        |     | ----> +-----+                    +-----------+
                  |     | ---+   |     | --+   | AND |            +-----> | (Value) x | <-----+
                  |     | -+ |   +-----+   |   |     | -----------+   	  +-----------+       |
                  +-----+  | |             |   |     | --------------+	                      |
                           | |             |   +-----+               |	  +-----------+       |
                           | |             |                         +--> | (Value) y | <---------+
                           | |             +---> +------------------+	  +-----------+       |   |
                           | |                   | (ConstantInt) -2 |                         |   |
                           | |                   +------------------+                         |   |
                           | |                                                                |   |
                           | +----------------------------------------------------------------+   |
                           +----------------------------------------------------------------------+
</pre>

<p>All rectangular blocks has <i>BinaryOperation</i> type, except when it's noted explicitly.
Arrows shows how objects has pointers to other objects.<p>

<p>Resulting expression is not stored in memory in this precise form, it's in fact a pointers to other parts, which were constructed some time ago.
For example, both <i>x</i> and <i>y</i> values are used twice in our expression, but there is no need to duplicate them,
let both places where <i>x</i> is used, be pointing to the single <i>Value</i> object holding <i>x</i>.</p>

<p>Other LLVM transform passes may build other expressions around this one, or they may slice it, reconstruct, rework, replace parts, etc. 
In fact, this is what compilers do most of the time.</p>

<p>As far as I know, learning LISP (or Scheme) is simplest possible way to get understanding of such things, which are really makes life of programmer easier.
I strongly encourage every programmer to learn LISP (or any its variant) basics, even if he/she would never write a single line of LISP code.<p>

<p>On comparing LISP to LLVM: primitive LISP element can hold some value (called atom) or can have links to other elements (called cons cell), thus allowing to build huge trees of data and code.
LISP _HTML_LINK(`http://en.wikipedia.org/wiki/Homoiconicity',`is homoiconic language') (surprisingly, assembly language is also homoiconic), 
it's when disctinction between data and code is blurred. 
Any code can be represented as data and otherwise. 
This allows to build new functions on fly, using the very same operations and data primitives for both data and code.</p>

<p>Now back to o-LLVM.
Aside from my tweak, there are _HTML_LINK(`https://github.com/yurichev/obfuscator/blob/cef63dd6139fe2acbbcc61f34bd1b5994866b40f/lib/Transforms/Obfuscation/Substitution.cpp',`two other XOR substitution functions').
I disabled them temporarily and now I'll try to test what I did.</p>

<p>test.c:</p>

<pre>
#include <stdio.h>

int test_XOR(int a, int b)
{
	return a^b;
};

int main()
{
#define C 0xBADF00D
	printf ("%x\n", test_XOR (test_XOR (0x12345678, C), C));
};
</pre>

<pre>
$ bin/clang test.c -c -o test -mllvm -sub
$ objdump -d test

test2:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <test_XOR>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	89 7d fc             	mov    %edi,-0x4(%rbp)
   7:	89 75 f8             	mov    %esi,-0x8(%rbp)
   a:	8b 75 fc             	mov    -0x4(%rbp),%esi
   d:	8b 7d f8             	mov    -0x8(%rbp),%edi
  10:	89 f8                	mov    %edi,%eax
  12:	21 f0                	and    %esi,%eax
  14:	69 c0 fe ff ff ff    	imul   $0xfffffffe,%eax,%eax
  1a:	01 fe                	add    %edi,%esi
  1c:	01 f0                	add    %esi,%eax
  1e:	5d                   	pop    %rbp
  1f:	c3                   	retq   
</pre>

<p>Yeah, that works.</p>

<p>I also compiled all the stuff in Cygwin.
I had some problems with compiling, and here is _HTML_LINK(`https://github.com/yurichev/obfuscator/commit/9f9bd6a2c9fddd2c19bced4546477e62889d629a',`my patch') to enable this. Not sure if it's correct.<p>

<p>Compiling (cygwin): <i>bin/clang -mllvm -sub test.c -o test -mcmodel=large</i></p>

<p>Interestingly, o-LLVM under Cygwin generates slightly different code:</p>

<pre>
sub_1004010E0   proc near

var_8           = dword ptr -8
var_4           = dword ptr -4

                push    rbp
                mov     rbp, rsp
                push    rax
                mov     [rbp+var_4], ecx
                mov     [rbp+var_8], edx
                mov     ecx, [rbp+var_4]
                mov     eax, edx
                and     eax, ecx
                add     eax, eax
                add     ecx, edx
                sub     ecx, eax
                mov     eax, ecx
                add     rsp, 8
                pop     rbp
                retn
sub_1004010E0   endp
</pre>

<p>There is no <i>imul</i> instruction and there are no -2 constant.
The resulting expression is reshuffled: <i>y + x - 2 * (x & y)</i>, but it has the very same effect as original one.
Perhaps, some additional LLVM optimization pass made things more optimized: of course, multiplication
by -2 is slower than single add operation.<p>

<p>OK, so _HTML_LINK(`https://github.com/yurichev/obfuscator/commits/XOR_experiment2',`I enabled two other XOR functions') and now o-LLVM picking XOR functions randomly:</p>

<pre>
#define NUMBER_XOR_SUBST 3

...

    funcXor[0] = &Substitution::xorSubstitution;
    funcXor[1] = &Substitution::xorSubstitutionRand;
    funcXor[2] = &Substitution::xorSubstitutionAha; // our function

...

        case Instruction::Xor:
            (this->*
             funcXor[llvm::cryptoutils->get_range(NUMBER_XOR_SUBST)])(cast<BinaryOperator>(inst));
</pre>

_HL2(`Tests')

<p>So far so good, but test?
Tests are crucial, compiler tests are arch-crucial, obfuscator tests are arch<sup>2</sup>-crucial.
Any single unnoticed typo may lead to nasty hard-to-find bugs.</p>

<p>o-LLVM developers mentioned they use OpenSSL for tests (compile OpenSSL by o-LLVM and then run OpenSSL tests).
So did I.
Here is also my small OpenSSL fork and patch to enable o-LLVM obfuscator: 
_HTML_LINK_AS_IS(`https://github.com/yurichev/openssl/commit/56bdb20af29c5617733bf7b195844177ed043614').<p>

<p>Now I run it. Correct your path to o-LLVM where clang binary is, if you want to run this yourself:</p>

<pre>
export PATH=$PATH:~/src/llvm-obfuscator/build/bin
./Configure linux-x86_64-clang
make
make test
</pre>

<p>OpenSSL tests now works much slower. No wonder.
Now it's a time for a slightly deranged mood: when I enable "sub" o-LLVM pass (<i>Instructions Substitution</i>), 
OpenSSL tests works, but with other obfuscations (fla (<i>Control Flow Flattening</i>) and bcg (<i>Bogus Control Flow</i>)) tests are not passed.
Ouch, something wrong.
Of course, I could do something wrong or introduce a bug somewhere.
Nevertheless, judging by OpenSSL tests, our added XOR function is working fine.</p>

<p>Keep in mind, code obfuscation is not a real protection against motivated reverse engineer.
On an untangling of o-LLVM obfuscated code, there is well known article about it: 
_HTML_LINK_AS_IS(`http://blog.quarkslab.com/deobfuscation-recovering-an-ollvm-protected-program.html')</p>

_HL2(`Twine')

<p>LLVM is my favorite open-source C++ project for learning.
Some time ago I found nice <a href="http://llvm.org/docs/ProgrammersManual.html#the-twine-class">Twine class (and/or data structure)</a> there.</p>

<p>Understanding how Twine operates may also help to understand how expressions are constructed in LLVM and LISP.<p>

<p>So. Many programmers know that text string concatenation task is somewhat costly if strings are growing (O(n) complexity class, speed is linearly depending on size of data).
Imagine, we need to devise a string class (or library) which will work as fast as possible (memory trade-off accepted).
One of solutions is data structure called <a href="http://en.wikipedia.org/wiki/Rope_%28data_structure%29">Rope</a>.
Rope is very efficient in text editors.
Imagine you write text editor. Probably, one thing first came to mind is to represent internal buffer as array of strings.
OK, but what strings are long and user inserting characters somewhere in the middle? You expand string byte-by-byte at each keystroke.
This implies heavy memory usage.
On contrary, Rope is a tree where each node pointing to part of text.
Loaded text file may be stored somewhere as a static text blob which will never be modified.
Instead, when user press "Enter" in the middle of the string, new node in Rope is created, pointing to the first half of string and to the next.
When user splice strings, two nodes in the Rope are connected in a way to indicate that these two strings are now spliced.
It is not a problem to remove just one character in the middle of 10Gb text string or to insert it.
Actual text buffer can be showed to the user on screen, but it can never be in the memory in this form.
The whole text file will be (re)constructed only when user save file to disk.
Oh, there is even Rope implementation in C++ STL from SGI: _HTML_LINK_AS_IS(`https://www.sgi.com/tech/stl/Rope.html').</p>

<p>Twine is simplified version of Rope. Each Twine object may represent a string or pointers to two other strings.</p>

<p>Now example from LLVM:</p>

<pre>
  // Emit the code (index) for the abbreviation.
  if (isVerbose())
    OutStreamer->AddComment("Abbrev [" + Twine(Abbrev.getNumber()) +
                            "] 0x" + Twine::utohexstr(Die.getOffset()) +
                            ":0x" + Twine::utohexstr(Die.getSize()) + " " +
                            dwarf::TagString(Abbrev.getTag()));
</pre>
( _HTML_LINK(`https://github.com/llvm-mirror/llvm/blob/579cebfb15c5f80cc8bbc7d51da9f7827424125a/lib/CodeGen/AsmPrinter/AsmPrinterDwarf.cpp#L250',`lib/CodeGen/AsmPrinter/AsmPrinterDwarf.cpp') )

<p>This piece of code is probably provides some debugging output. When writing such code in C++ using <i>std::string</i>, numbers are converted into
strings and all strings spliced using <i>operator+()</i> method.
But what is going here is string constructed using Twine, without actual string splicing and number-to-string conversion done.
Twine objects are nested to each other in form of tree.
Splicing is done only when there is a need to.
Those who concern about speed of constructing debugging strings, may add global flags to set debugging level.
And if current debugging level is lower than some value, debugging string will not be constructed at all.
On contrary, Twine allows to construct all strings as fast as possible, but splice them only while output.
So actual string concatenation is deferred.</p>

<p>Here we can see that <i>Twine::operator+</i> is either constucts new Twine object using two strings or call <i>.concat()</i> method 
which connects second string (called <i>Suffix</i> there) to the current one (called <i>Prefix</i> in their lingo):
_HTML_LINK_AS_IS(`http://llvm.org/docs/doxygen/html/Twine_8h_source.html#l00487').</p>

<p>So concatenation is always O(1) (algorithm speed is not depending on size of data and always takes the same time), no matter how many Twine objects are behind those two objects which we currently splicing.
On the other hand, memory consumption is bigger than to store a simple C-string.</p>

<p>Actual splicing is done only when <i>.str()</i> method is called: _HTML_LINK_AS_IS(`http://llvm.org/docs/doxygen/html/Twine_8cpp_source.html#l00016')</p>

<p>In fact, Twine behaves just like somewhat limited LISP _HTML_LINK(`http://en.wikipedia.org/wiki/Cons',`cons cell'): its elements are always strings/numbers or links to another Twine objects.</p>

<p>Twine can be implemented probably in any programming language.
And it is misnomer to my taste. I would rather call it <i>Knot</i> or maybe <i>StringKnot</i>.</p>

_HL2(`Pattern matching and term rewriting systems')

<p>When expression is represented as a tree (which is, frankly speaking, always), some magic things are possible.
LLVM has pattern matcher which operates on trees.
It is like regular expressions in some sense, but much more cooler.
They are used in LLVM extensively to simplify expressions.</p>

<p>For example:</p>

<pre>
  // (X >> A) << A -> X
  Value *X;
  if (match(Op0, m_Exact(m_Shr(m_Value(X), m_Specific(Op1)))))
    return X;
</pre>
( _HTML_LINK(`https://github.com/llvm-mirror/llvm/blob/f23c6af13d9c4a4920a935de303140cc83b2bbaa/lib/Analysis/InstructionSimplify.cpp#L1397',`lib/Analysis/InstructionSimplify.cpp') )

<p>In this example, <i>match()</i> sets <i>X</i> so it will point to the sub-expression and it will be returned as simplified expression.</p>

<p>Another cool example is detecting and replacing the whole expression into BSWAP instruction:</p>

<pre>
  // (A | B) | C  and  A | (B | C)                  -> bswap if possible.
  // (A >> B) | (C << D)  and  (A << B) | (B >> C)  -> bswap if possible.
  if (match(Op0, m_Or(m_Value(), m_Value())) ||
      match(Op1, m_Or(m_Value(), m_Value())) ||
      (match(Op0, m_LogicalShift(m_Value(), m_Value())) &&
       match(Op1, m_LogicalShift(m_Value(), m_Value())))) {
    if (Instruction *BSwap = MatchBSwap(I))
      return BSwap;
</pre>
( _HTML_LINK(`https://github.com/llvm-mirror/llvm/blob/e027d74733de7dc086c9d2190d14884e9240ce89/lib/Transforms/InstCombine/InstCombineAndOrXor.cpp#L2200',`lib/Transforms/InstCombine/InstCombineAndOrXor.cpp') )

<p><i>match()</i> function internals is surprisingly simple.</p>

<p>I would say, this is because it can be viewed as <a href="http://en.wikipedia.org/wiki/Rewriting#Term_rewriting_systems">term rewriting system (TRS)</a> 
(which is also simple).
The whole compiler (especially optimizer) can be viewed as TRS working on abstract syntax tree, finding something known to it and transforming
it according to its rules. It does this as long as there is something left to "rewrite".
Obfuscated XOR function which I showed in this article is just another rule for TRS: each time TRS seeing XOR somewhere in the tree, it is then
replacing it to one of tree obfuscated XOR functions, picked randomly.</p>

<p>By the way, old-school soviet programmers of USSR era may recall that compilers was called "translators" in Russian-language computer science books.
I would say this was a better name. 
Compiler doesn't compile (linker does), it rather translates from one language to another, according to a set of rules.</p>

<p>Oh, and by the way, decompiler can also be viewed as TRS.</p>

_BLOG_FOOTER()
