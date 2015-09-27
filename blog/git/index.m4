m4_include(`commons.m4')

_HEADER_HL1(`Some of git internals')

_HL2(`Simple test file tree')

_HL3(`Initial commit')

<p>Here is my test file tree. There are two files and "src" subdirectory, where another two files are stored:</p>

_PRE_BEGIN
install.txt
readme.txt
src         --> hello.c
                world.c
_PRE_END

<p>Here is their contents:</p>

<p>install.txt:</p>

_PRE_BEGIN
here are install instructions
_PRE_END

<p>readme.txt:</p>

_PRE_BEGIN
this is readme file
_PRE_END

<p>src/hello.c:</p>

_PRE_BEGIN
// this is source code for the "hello world" program
_PRE_END

<p>src/world.c:</p>

_PRE_BEGIN
// another piece of source code
_PRE_END

<p>Now I'm adding all these 4 files to git and making initial commit. A lot of files in .git subdirectory are created.
Let's focus first on "objects" directory.
It has these files:</p>

_PRE_BEGIN
./objects/4a/cde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad
./objects/61/d7f2fcb4d4aa0c55abb07f0cca6fd6ffa91e00
./objects/2e/c39aec17a9e53d21dcdafd8cdbe3ae7ada8c57
./objects/8b/35c7d4622c1aa11531166e4bd7d1901c9d5d2b
./objects/ef/875aac086693ff89d2a21dbe2a78c34f053a73
./objects/25/457e6ce216a231dc45ad1f08449c72d2a3a674
./objects/d7/a7d9d04d26cfbfe4a492a737f4f81d993dbce6
_PRE_END

<p>As we may know, all these files are compressed using Zlib compressor.
And there is "zpipe" util which can help to decompress Zlib-compressed files
(present at least in _HTML_LINK(`http://packages.ubuntu.com/trusty/science/opencaster',`opencaster') package in Ubuntu, 
_HTML_LINK(`http://www.opensource.apple.com/source/zlib/zlib-37.2/zlib/examples/zpipe.c',`source code')).</p>

<p>Let's start with first file:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/4a/cde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad
blob 54// this is source code for the "hello world" program
_PRE_END

<p>Wow, that's familiar to us. But the file compressed is prepended by "blob 54" string. "blob" mean this object has "blob" type, i.e., contain file.
"54" is length of "blob".
There is also zero byte inside, which is visible in hexdump:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/4a/cde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad | hexdump -C
00000000  62 6c 6f 62 20 35 34 00  2f 2f 20 74 68 69 73 20  |blob 54.// this |
00000010  69 73 20 73 6f 75 72 63  65 20 63 6f 64 65 20 66  |is source code f|
00000020  6f 72 20 74 68 65 20 22  68 65 6c 6c 6f 20 77 6f  |or the "hello wo|
00000030  72 6c 64 22 20 70 72 6f  67 72 61 6d 0a 0a        |rld" program..|
0000003e
_PRE_END

<p>We may have heard that object ID in git is SHA1 of the contents. 
It is indeed so. 
But contents is prepended by a string consisting of object type and object size (what we just saw).
We may check if this is true:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/4a/cde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad | sha1sum
4acde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad  -
_PRE_END

<p>True, indeed. But the first byte of SHA1 sum is subdirectory, all the rest are file name for compressed object.
There are other ways to calculate git SHA1 sum: _HTML_LINK_AS_IS(`http://stackoverflow.com/questions/552659/assigning-git-sha1s-without-git').</p>

<p>Let's proceed to other files:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/61/d7f2fcb4d4aa0c55abb07f0cca6fd6ffa91e00
blob 33// another piece of source code
_PRE_END

<p>The next one:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/2e/c39aec17a9e53d21dcdafd8cdbe3ae7ada8c57
...
(Ouch, there is some unprintable contents.)
_PRE_END

<p>Let's try hexdump:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/2e/c39aec17a9e53d21dcdafd8cdbe3ae7ada8c57 | hexdump -C
00000000  74 72 65 65 20 37 30 00  31 30 30 36 34 34 20 68  |tree 70.100644 h|
00000010  65 6c 6c 6f 2e 63 00 4a  cd e9 ab 6d d9 bf 43 9f  |ello.c.J...m..C.|
00000020  f2 cb dd b4 7d 5e 96 b1  f2 e3 ad 31 30 30 36 34  |....}^.....10064|
00000030  34 20 77 6f 72 6c 64 2e  63 00 61 d7 f2 fc b4 d4  |4 world.c.a.....|
00000040  aa 0c 55 ab b0 7f 0c ca  6f d6 ff a9 1e 00        |..U.....o.....|
0000004e
_PRE_END

<p>Now this is the most interesting part: this object has compressed "tree" object.
In other words, this is just list of files in directory.
Using naked eye, we can spot "tree" object type at start, then "70" (object size), then access rights of "hello.c" file, then access rights for "world.c" file.
Both file names are clearly visible.</p>

<p>Using git we can print this obejct in prettier form:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ git cat-file -p 2ec39aec17a9e53d21dcdafd8cdbe3ae7ada8c57
100644 blob 4acde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad    hello.c
100644 blob 61d7f2fcb4d4aa0c55abb07f0cca6fd6ffa91e00    world.c
_PRE_END

<p>These two hashes are IDs of objects where files are stored.
You can find these IDs in hex dump, they are stored there in binary form to make things faster and more compact.
Interestingly: the compressed object of "tree" type enlists descending objects in the tree,
but doesn't specify their types, because their types can be easily deduced from the objects itself.</p>

<p>So this "tree" has file list of "src" subdirectory.
There are also no file/directory timestamps, because git doesn't preserve them.</p>

<p>Let's proceed to the rest of files:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/8b/35c7d4622c1aa11531166e4bd7d1901c9d5d2b
blob 21this is readme file
_PRE_END

<p>Another "tree" object:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/ef/875aac086693ff89d2a21dbe2a78c34f053a73 | hexdump -C
00000000  74 72 65 65 20 31 30 37  00 31 30 30 36 34 34 20  |tree 107.100644 |
00000010  69 6e 73 74 61 6c 6c 2e  74 78 74 00 d7 a7 d9 d0  |install.txt.....|
00000020  4d 26 cf bf e4 a4 92 a7  37 f4 f8 1d 99 3d bc e6  |M&......7....=..|
00000030  31 30 30 36 34 34 20 72  65 61 64 6d 65 2e 74 78  |100644 readme.tx|
00000040  74 00 8b 35 c7 d4 62 2c  1a a1 15 31 16 6e 4b d7  |t..5..b,...1.nK.|
00000050  d1 90 1c 9d 5d 2b 34 30  30 30 30 20 73 72 63 00  |....]+40000 src.|
00000060  2e c3 9a ec 17 a9 e5 3d  21 dc da fd 8c db e3 ae  |.......=!.......|
00000070  7a da 8c 57                                       |z..W|
00000074
_PRE_END

<p>It contains file list of the root directory: two files "install.txt" and "readme.txt" and also "src" subdirectory.
Let's dump it using git utility:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ git cat-file -p ef875aac086693ff89d2a21dbe2a78c34f053a73
100644 blob d7a7d9d04d26cfbfe4a492a737f4f81d993dbce6    install.txt
100644 blob 8b35c7d4622c1aa11531166e4bd7d1901c9d5d2b    readme.txt
040000 tree 2ec39aec17a9e53d21dcdafd8cdbe3ae7ada8c57    src
_PRE_END

<p>IDs of files are IDs of objects where its contents is stored.
ID of "src" tree is just ID of another "tree" object, which was inspected by us earlier.</p>

<p>The next object:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/25/457e6ce216a231dc45ad1f08449c72d2a3a674
commit 189tree ef875aac086693ff89d2a21dbe2a78c34f053a73
author Dennis Yurichev <dennis@yurichev.com> 1442582288 +0300
committer Dennis Yurichev <dennis@yurichev.com> 1442582288 +0300

initial commit
_PRE_END

<p>This is object representing "commit". It has ID of tree plus some additional information, including date/time of commit.
We can be sure that this is where current HEAD pointing:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ cat HEAD
ref: refs/heads/master

dennis@wombat:~/tmp/test/.git$ cat refs/heads/master
25457e6ce216a231dc45ad1f08449c72d2a3a674
_PRE_END

<b>25457e6ce216a231dc45ad1f08449c72d2a3a674</b> is ID of object with "commit" information we just saw.</b>

<p>And the last object is just another blob:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/d7/a7d9d04d26cfbfe4a492a737f4f81d993dbce6
blob 31here are install instructions
_PRE_END

_HL3(`Adding "cloned" file')

<p>Now let's add another file, which has exact contents of what we already have:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ cp src/hello.c src/hello.c_copy
_PRE_END

<p>These objects we see after commit:</p>

_PRE_BEGIN
./objects/4a/cde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad
./objects/61/d7f2fcb4d4aa0c55abb07f0cca6fd6ffa91e00
./objects/2e/c39aec17a9e53d21dcdafd8cdbe3ae7ada8c57
./objects/8b/35c7d4622c1aa11531166e4bd7d1901c9d5d2b
./objects/2c/2a5998e0fbbb227605c9e48f8120d4a1326215 (new file)
./objects/ef/875aac086693ff89d2a21dbe2a78c34f053a73
./objects/0f/98834ba27232f2bd0d3fc8954ec805812cea3e (new file)
./objects/7b/911b9bc417505e7fbe329c1496ac55b9bf971d (new file)
./objects/25/457e6ce216a231dc45ad1f08449c72d2a3a674
./objects/d7/a7d9d04d26cfbfe4a492a737f4f81d993dbce6
_PRE_END

<p>There are 3 new objects. But no objects removed (because git doesn't delete anything).
What is inside of new objects?</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/7b/911b9bc417505e7fbe329c1496ac55b9bf971d | hexdump -C
00000000  74 72 65 65 20 31 31 30  00 31 30 30 36 34 34 20  |tree 110.100644 |
00000010  68 65 6c 6c 6f 2e 63 00  4a cd e9 ab 6d d9 bf 43  |hello.c.J...m..C|
00000020  9f f2 cb dd b4 7d 5e 96  b1 f2 e3 ad 31 30 30 36  |.....}^.....1006|
00000030  34 34 20 68 65 6c 6c 6f  2e 63 5f 63 6f 70 79 00  |44 hello.c_copy.|
00000040  4a cd e9 ab 6d d9 bf 43  9f f2 cb dd b4 7d 5e 96  |J...m..C.....}^.|
00000050  b1 f2 e3 ad 31 30 30 36  34 34 20 77 6f 72 6c 64  |....100644 world|
00000060  2e 63 00 61 d7 f2 fc b4  d4 aa 0c 55 ab b0 7f 0c  |.c.a.......U....|
00000070  ca 6f d6 ff a9 1e 00                              |.o.....|
00000077
_PRE_END

<p>... or:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ git cat-file -p 7b911b9bc417505e7fbe329c1496ac55b9bf971d
100644 blob 4acde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad    hello.c
100644 blob 4acde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad    hello.c_copy
100644 blob 61d7f2fcb4d4aa0c55abb07f0cca6fd6ffa91e00    world.c
_PRE_END

<p>This is the new "tree" object for "src" subdirectory, it has copied file.
But what is important: IDs are the same!
Because they have the same contents, so git hadn't added another copy of file!
git is content-addressable storage, about which you can read more here: _HTML_LINK_AS_IS(`http://yurichev.com/blog/CAS').</p>

<p>The "tree" is different, however, so this new object is created.
Older "tree" version of this directory is still present and always be.</p>

<p>Now the second object:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/0f/98834ba27232f2bd0d3fc8954ec805812cea3e | hexdump -C
00000000  74 72 65 65 20 31 30 37  00 31 30 30 36 34 34 20  |tree 107.100644 |
00000010  69 6e 73 74 61 6c 6c 2e  74 78 74 00 d7 a7 d9 d0  |install.txt.....|
00000020  4d 26 cf bf e4 a4 92 a7  37 f4 f8 1d 99 3d bc e6  |M&......7....=..|
00000030  31 30 30 36 34 34 20 72  65 61 64 6d 65 2e 74 78  |100644 readme.tx|
00000040  74 00 8b 35 c7 d4 62 2c  1a a1 15 31 16 6e 4b d7  |t..5..b,...1.nK.|
00000050  d1 90 1c 9d 5d 2b 34 30  30 30 30 20 73 72 63 00  |....]+40000 src.|
00000060  7b 91 1b 9b c4 17 50 5e  7f be 32 9c 14 96 ac 55  |{.....P^..2....U|
00000070  b9 bf 97 1d                                       |....|
00000074
_PRE_END

<p>... or:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ git cat-file -p 0f98834ba27232f2bd0d3fc8954ec805812cea3e
100644 blob d7a7d9d04d26cfbfe4a492a737f4f81d993dbce6    install.txt
100644 blob 8b35c7d4622c1aa11531166e4bd7d1901c9d5d2b    readme.txt
040000 tree 7b911b9bc417505e7fbe329c1496ac55b9bf971d    src
_PRE_END

<p>It has new "tree" object for root directory. It has changed because ID of "src" has changed its ID (because it has different content and SHA1 hash).</p>

<p>The last object:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/2c/2a5998e0fbbb227605c9e48f8120d4a1326215
commit 236tree 0f98834ba27232f2bd0d3fc8954ec805812cea3e
parent 25457e6ce216a231dc45ad1f08449c72d2a3a674
author Dennis Yurichev <dennis@yurichev.com> 1442585229 +0300
committer Dennis Yurichev <dennis@yurichev.com> 1442585229 +0300

second commit
_PRE_END

<p>It is the second "commit" object.
In contrast of the initial commit object we already saw, this one has "parent" link, which is ID of previous commit object.
Oh, and the current HEAD pointing to this new (second) commit:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ cat refs/heads/master
2c2a5998e0fbbb227605c9e48f8120d4a1326215
_PRE_END

<p>If the "cat-file" output is too raw for you, there is always "git show" utility, which shows object contents in prettier form:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ git show 2c2a5998e0fbbb227605c9e48f8120d4a1326215
commit 2c2a5998e0fbbb227605c9e48f8120d4a1326215
Author: Dennis Yurichev <dennis@yurichev.com>
Date:   Fri Sep 18 17:07:09 2015 +0300

    second commit

diff --git a/src/hello.c_copy b/src/hello.c_copy
new file mode 100644
index 0000000..4acde9a
--- /dev/null
+++ b/src/hello.c_copy
@@ -0,0 +1,2 @@
+// this is source code for the "hello world" program
+
_PRE_END

<p>By the way, old object files were not modified after the second commit!
Of course not, they still has the same IDs.</p>

_HL3(`Deleting file')

<p>Let's delete some file:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ rm install.txt
_PRE_END

<p>This is objects list after third commit:</p>

_PRE_BEGIN
./objects/4a/cde9ab6dd9bf439ff2cbddb47d5e96b1f2e3ad
./objects/61/d7f2fcb4d4aa0c55abb07f0cca6fd6ffa91e00
./objects/2e/c39aec17a9e53d21dcdafd8cdbe3ae7ada8c57
./objects/8b/35c7d4622c1aa11531166e4bd7d1901c9d5d2b
./objects/ea/7af6190471c3571899ae68281fbd9b3bf82c71 (new file)
./objects/2c/2a5998e0fbbb227605c9e48f8120d4a1326215
./objects/0c/077dd09d6ff4a8c90bf14226ce5060db57ad94 (new file)
./objects/ef/875aac086693ff89d2a21dbe2a78c34f053a73
./objects/0f/98834ba27232f2bd0d3fc8954ec805812cea3e
./objects/7b/911b9bc417505e7fbe329c1496ac55b9bf971d
./objects/25/457e6ce216a231dc45ad1f08449c72d2a3a674
./objects/d7/a7d9d04d26cfbfe4a492a737f4f81d993dbce6
_PRE_END

<p>What is in new files?</p>

<p>First:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ git cat-file -p 0c077dd09d6ff4a8c90bf14226ce5060db57ad94
100644 blob 8b35c7d4622c1aa11531166e4bd7d1901c9d5d2b    readme.txt
040000 tree 7b911b9bc417505e7fbe329c1496ac55b9bf971d    src
_PRE_END

<p>Second:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test/.git$ zpipe -d < objects/ea/7af6190471c3571899ae68281fbd9b3bf82c71
commit 256tree 0c077dd09d6ff4a8c90bf14226ce5060db57ad94
parent 2c2a5998e0fbbb227605c9e48f8120d4a1326215
author Dennis Yurichev <dennis@yurichev.com> 1442587436 +0300
committer Dennis Yurichev <dennis@yurichev.com> 1442587436 +0300
_PRE_END

<p>There are just two objects created: new tree for root directory and new commit.
By the way, other objects wasn't modified in this case as well.</p>

_HL3(`Recreating repository')

<p>Would it be possible for me to create such demo repository with the same IDs?
Yes: if you'll recreate all text files byte-by-byte, so they will have the same SHA1 IDs, both blobs and trees.
But "commit" objects will be different, because, likely, you'll create it under your name/email and in another time.
But if you'll go so far, you can recreate commit objects just like mine, of course.</p>

<p>Nonetheless, for those who interested, the repositories I experimented with are here: 
_HTML_LINK_AS_IS(`https://github.com/dennis714/yurichev.com/tree/master/blog/git/files').</p>

_HL3(`Trees are always sorted')

<p>... otherwise, two identical trees could result in different SHA1 IDs.
This is hash tree (or Merkle tree): _HTML_LINK_AS_IS(`https://en.wikipedia.org/wiki/Merkle_tree').</p>

_HL2(`Linux Kernel tree')

<p>I've cloned _HTML_LINK(`https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/',`latest Linux kernel') and git checked out all the files.
But let's see, would it be possible to walk on file tree of some specific Linux release without checking out all the files (there are a lot of them, so it's slow!)
When I write this article, current Linux kernel version is v4.3-rc1, but let's take a look on v3.0:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git show v3.0
tag v3.0
Tagger: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jul 21 19:17:29 2011 -0700

Linux 3.0

w00t!
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4o3cgACgkQF3YsRnbiHLvw3gCfYIx8Sw/s3s4LNh8ij7Rb3ltt
9RsAoJgdZdHrRrWeB3G1q92FcJtbMHu9
=m0tn
-----END PGP SIGNATURE-----

commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jul 21 19:17:23 2011 -0700

    Linux 3.0
    ...
_PRE_END

<p>This is a "tag" object (4th one, there are no more object types in git: blob, tree, commit, tag).
Here we can see commit ID: 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe. Let's see:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git cat-file -p 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
tree df32c75242bf8d797ccd43af8ce8e294f35cd8fd
parent 1f922d07704c501388a306c78536bca7432b3934
author Linus Torvalds <torvalds@linux-foundation.org> 1311301043 -0700
committer Linus Torvalds <torvalds@linux-foundation.org> 1311301043 -0700
Linux 3.0
_PRE_END

<p>Now this is "commit" object, it has link to tree ID df32c75242bf8d797ccd43af8ce8e294f35cd8fd.
Let's take a look into the tree:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git cat-file -p df32c75242bf8d797ccd43af8ce8e294f35cd8fd
100644 blob 9dacde0a4b2dcec4ce33013354b6c46738daaef7    .gitignore
100644 blob 353ad5607156f0f2d4b5138f1b5d9db529933aa8    .mailmap
100644 blob ca442d313d86dc67e0a2e5d584b465bd382cbf5c    COPYING
100644 blob 1deb331d96edbe60f3026ce4175dc0efe3bffaa4    CREDITS
040000 tree dfcc154f765364b00ea39827f9e337314b498291    Documentation
100644 blob 2114113ceca2801770c57ac07c78fff2b0b8a477    Kbuild
100644 blob c13f48d65898487105f0193667648382c90d0eda    Kconfig
100644 blob 187282da92137a2ea147bcb0f664e0e99d90e681    MAINTAINERS
100644 blob 6a5bdad524affe34c62141ae9678da115fcc28ee    Makefile
100644 blob 0d5a7ddbe3ee8d108bf7079909ddcec30dfb4560    README
100644 blob 55a6074ccbb715d99b642fa510d3c993121f453d    REPORTING-BUGS
040000 tree 3c904b66b173d88f424b957c9d63d9df9a7dfceb    arch
040000 tree 1a854f3d15191bd1313eee6561bc2f5192e70281    block
040000 tree 99f9616822f57a4a138e96b3e125be382adca109    crypto
040000 tree 912f6edfe690c212e2ea8a2d912372c9657689ba    drivers
040000 tree 0bfbce5a445d533c1e84a53db5e7665d49e8141d    firmware
040000 tree e9a60176c0b7aa680f16a744a813075f3d7fcdf5    fs
040000 tree 7caa537dae98db80e1d7e4b8de800e3ca98a9330    include
040000 tree 5746e99029889fab537a87c5b410619d328a70da    init
040000 tree 0bcfb00e995f70e15d50fb488826215f35d7e6a7    ipc
040000 tree 29cafccb28f5a39ec85392099f3d980afcbec5e7    kernel
040000 tree ea9f4393812615ca8667f4b6be6de0fa6a20e3c6    lib
040000 tree 90fd1ee8343340a2e5e9089312c32f5dbde313c4    mm
040000 tree be49bafeb7aeeb9dcce2da58717cb1d60101d9ae    net
040000 tree c8074a39cb7977631a23de3d3df1563f7e99fddb    samples
040000 tree f66d97ab104ae00a8f1e3f337e0d3b112a3d4ecc    scripts
040000 tree db1c9d45c75a87a0eab10bd081272ad2c7410340    security
040000 tree 76c0db062b1dfdae7960e45511b38519f33edbb7    sound
040000 tree 9699f25d5bcb2784cc710785777748836a8cfcfb    tools
040000 tree 1e3684ddfd7c6b964e6ca2ad6498e3f8b24a7762    usr
040000 tree ab7e9c5a83bd4ea0b265a745933cec9e89e30946    virt
_PRE_END

<p>This is how Linux kernel root tree looked like in version v3.0.
Let's peek into the "arch" subdirectory:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git cat-file -p 3c904b66b173d88f424b957c9d63d9df9a7dfceb
100644 blob 7414689203208919d7de8758e750cf4e2d8f0961    .gitignore
100644 blob 26b0e2397a5724140bc8683fedd6bbae67706fe5    Kconfig
040000 tree 2b990a6397576c8e00940f1c817adf8e1a5df273    alpha
040000 tree fc015283e022339d799c9eedd23d4f62e92e0aec    arm
040000 tree 794853b6df19fc8a8eeb54926962b496f0e6c941    avr32
040000 tree 4697f8f4c2668cd4c088330a1010cc4c47af7dcf    blackfin
040000 tree 336265a1bb4ce023a7b1e0fcd36cfe9a38ff35f2    cris
040000 tree f94cb4276f51f312ce7338c7108ebf2038bc508a    frv
040000 tree b4ca635f1f809680e3afb681a0c8ca9969cc56a7    h8300
040000 tree 9bf423815cfb3f3f50f065d3d202f22afd8c8952    ia64
040000 tree cd73a96bb8b271cd4dc7ccc25f507886724418a4    m32r
040000 tree c4e86bbe47f34dd22d2f1c70e0e5a75d920274a1    m68k
040000 tree d58fa182a92f15ced603cc103f80f9a40b07f013    microblaze
040000 tree 949a999878382076e88e933771a682e0b0eeae04    mips
040000 tree 4f29482ed729593246f9c32d2fc09bb3ddc15d0a    mn10300
040000 tree de143a7b81bd6eaedbd5bc2ce7f995d3b415ec27    parisc
040000 tree f6ea0236658d350aded70545e2f0f46ea9e47783    powerpc
040000 tree c4fd94dd807ef9935576b1f6d90e0e6b727f8f57    s390
040000 tree 5ec2a83d90b6856f39f7fef6493de9c9864d045f    score
040000 tree 27b918c6fe277006b8b8f7515ef1bdcbad018cac    sh
040000 tree 06697af330f49913a3d816e4a97255cc55542bcb    sparc
040000 tree bee5e83168bc3d578e144b43357771f5da984230    tile
040000 tree d68a235cb0b4fb29a64c3e274844de884d775355    um
040000 tree b828e78dbcd3530484b285d4bd3e7570e9659b19    unicore32
040000 tree 9b877cfb8890bad2ae9f0f310ddf6e44596f3315    x86
040000 tree f9941e6c45c878838ba4390dc26b8d06b13369c4    xtensa
_PRE_END

<p>What the <b>arch/Kconfig</b> file had inside in Linux v3.0?</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git cat-file -p 26b0e2397a5724140bc8683fedd6bbae67706fe5

#
# General architecture dependent options
#

config OPROFILE
        tristate "OProfile system profiling"
        depends on PROFILING
        depends on HAVE_OPROFILE
        select RING_BUFFER
        select RING_BUFFER_ALLOW_SWAP
        help
          OProfile is a profiling system capable of profiling the
          whole system, include the kernel, kernel modules, libraries,
          and applications.

          If unsure, say N.
...
_PRE_END

<p>All IDs are real, so anyone can get Linux kernel git repository and repeat my steps.
Isn't it cool?</p>

_HL2(`SHA1')

<p>SHA1 is cryptographically secure, so as a developer, you can identify your tree using just one single SHA1 ID.
It's _HTML_LINK(`https://en.wikipedia.org/wiki/SHA-1#Cryptanalysis_and_validation',`extremely hard') (at least as of current SHA1 cryptoanalysis state) 
to tamper any file in your tree so ID will stay the same.</p>

_HL2(`.git/HEAD')

<p>This text file usually has a name of current branch:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ cat .git/HEAD
ref: refs/heads/master
_PRE_END

<p>... which is, in turn, has ID of the last commit:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ cat .git/refs/heads/master
d2315fbf4d1497c8876cc4801c250fc59e987487
_PRE_END

_HL2(`git log')

<p>When you run "git log", it shows the information about commit to which .git/HEAD is pointing.
Then it takes commit ID from a "parent" link and does the same.
Then again, recursively.
It stops when it finds a commit with no "parent" link, i.e., the first one.</p>

_HL2(`Two types of git tags')

<p>Lightweight tag is just a pointer to some commit.
Here I create a pointer to the very first commit in my demo repository:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ git log
...
commit 25457e6ce216a231dc45ad1f08449c72d2a3a674
Author: Dennis Yurichev <dennis@yurichev.com>
Date:   Fri Sep 18 16:18:08 2015 +0300

    initial commit

dennis@wombat:~/tmp/test$ git tag v1 25457e6ce216a231dc45ad1f08449c72d2a3a674

dennis@wombat:~/tmp/test$ git tag
v1

dennis@wombat:~/tmp/test$ cat .git/refs/tags/v1
25457e6ce216a231dc45ad1f08449c72d2a3a674
_PRE_END

<p>Lightweight tags are stored in text files under <b>.git/refs/tags</b></p>

<p>"Annotated" tag is a tag stored in an object with "tag" type.
It has an additional (optionally PGP-signed) text and a link to commit ID.
Here I use "v3.0" in command line as alias of object ID with "tag" type:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git cat-file -t v3.0
tag

dennis@bigbox:~/src/linux-kernel/linux-git$ git cat-file -p v3.0
object 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
type commit
tag v3.0
tagger Linus Torvalds <torvalds@linux-foundation.org> 1311301049 -0700

Linux 3.0

w00t!
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4o3cgACgkQF3YsRnbiHLvw3gCfYIx8Sw/s3s4LNh8ij7Rb3ltt
9RsAoJgdZdHrRrWeB3G1q92FcJtbMHu9
=m0tn
-----END PGP SIGNATURE-----

dennis@bigbox:~/src/linux-kernel/linux-git$ git cat-file -p 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
tree df32c75242bf8d797ccd43af8ce8e294f35cd8fd
parent 1f922d07704c501388a306c78536bca7432b3934
author Linus Torvalds <torvalds@linux-foundation.org> 1311301043 -0700
committer Linus Torvalds <torvalds@linux-foundation.org> 1311301043 -0700

Linux 3.0
_PRE_END

_HL2(`Branching')

<p>Branching is just diverging from some commit to two or more different commits.
You create a new branch, but "master" branch still points to some commit.
You do some work, and then you can see a difference between your current branch and "master".
You can checkout files from "master" branch again, or from any other commit.</p>

_HL2(`Merging')

<p>Let's create new branch:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ git branch new_branch

dennis@wombat:~/tmp/test$ git checkout new_branch
Switched to branch 'new_branch'

dennis@wombat:~/tmp/test$ vi readme.txt

dennis@wombat:~/tmp/test$ vi src/hello.c

dennis@wombat:~/tmp/test$ git diff
diff --git a/readme.txt b/readme.txt
index 8b35c7d..3b7f9f2 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,2 +1,4 @@
 this is readme file
+I'll add some very cool feature A in this branch!
+
diff --git a/src/hello.c b/src/hello.c
index 4acde9a..3176765 100644
--- a/src/hello.c
+++ b/src/hello.c
@@ -1,2 +1,4 @@
 // this is source code for the "hello world" program

+// new feature A!
+

dennis@wombat:~/tmp/test$ git commit -a -m"feature A"
[new_branch 1782b8d] feature A
 2 files changed, 4 insertions(+)
_PRE_END

<p>Now we switching to master and creating another branch:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ git checkout master
Switched to branch 'master'

dennis@wombat:~/tmp/test$ git branch another_branch

dennis@wombat:~/tmp/test$ git checkout another_branch
Switched to branch 'another_branch'

dennis@wombat:~/tmp/test$ vi readme.txt

dennis@wombat:~/tmp/test$ vi src/world.c

dennis@wombat:~/tmp/test$ git diff
diff --git a/readme.txt b/readme.txt
index 8b35c7d..a55e832 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,2 +1,4 @@
 this is readme file

+feature B added!
+
diff --git a/src/world.c b/src/world.c
index 61d7f2f..661d47f 100644
--- a/src/world.c
+++ b/src/world.c
@@ -1,2 +1,3 @@
 // another piece of source code

+// feature B is here

dennis@wombat:~/tmp/test$ git commit -a -m"feature B"
[another_branch 085eb71] feature B
 2 files changed, 3 insertions(+)
_PRE_END

<p>These heads has 3 different IDs, each of which pointing to 3 different trees.
master - original tree; "new_branch" is where "feature A" has been added; "another_branch" is where "feature B" has been added.</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ cat .git/refs/heads/another_branch
085eb716475f3f2c83ccd7f0ef0b363697049f2e

dennis@wombat:~/tmp/test$ cat .git/refs/heads/master
ea7af6190471c3571899ae68281fbd9b3bf82c71

dennis@wombat:~/tmp/test$ cat .git/refs/heads/new_branch
1782b8ddab75fb4fdc7fd10a6d122c3321057eca
_PRE_END

<p>Let's merge "another_branch" and "new_branch" (current branch is still "another_branch"):</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ git merge new_branch
Auto-merging readme.txt
CONFLICT (content): Merge conflict in readme.txt
Automatic merge failed; fix conflicts and then commit the result.

dennis@wombat:~/tmp/test$ vi readme.txt

dennis@wombat:~/tmp/test$ git commit -a -m"conflict resolved"
[another_branch d2315fb] conflict resolved
_PRE_END

<p>Merge commit is the commit with two "parent" links (which are two commit IDs):</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ git log
commit d2315fbf4d1497c8876cc4801c250fc59e987487
Merge: 085eb71 1782b8d
Author: Dennis Yurichev <dennis@yurichev.com>
Date:   Sun Sep 20 14:11:11 2015 +0300
    conflict resolved

dennis@wombat:~/tmp/test$ git cat-file -p d2315fbf4d1497c8876cc4801c250fc59e987487
tree e46fc118b45d21b16d8a9739ceea24e998acd628
parent 085eb716475f3f2c83ccd7f0ef0b363697049f2e
parent 1782b8ddab75fb4fdc7fd10a6d122c3321057eca
author Dennis Yurichev <dennis@yurichev.com> 1442747471 +0300
committer Dennis Yurichev <dennis@yurichev.com> 1442747471 +0300

conflict resolved
_PRE_END

<p>"tree" points to the newly consructed (during merge) file tree.</p>

<p>"another_branch" text file is now pointing to the last commit we just made:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ cat .git/refs/heads/another_branch
d2315fbf4d1497c8876cc4801c250fc59e987487
_PRE_END

<p>(All other heads wasn't changed during merge).</p>

<p>Make the current branch as "master":</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ git checkout master
Switched to branch 'master'

dennis@wombat:~/tmp/test$ git merge another_branch
Updating ea7af61..d2315fb
Fast-forward
 readme.txt  | 4 ++++
 src/hello.c | 2 ++
 src/world.c | 1 +
 3 files changed, 7 insertions(+)
_PRE_END

<p>Now master branch has the same ID as "another_branch", they are indistinguishable:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ cat .git/refs/heads/master
d2315fbf4d1497c8876cc4801c250fc59e987487

dennis@wombat:~/tmp/test$ cat .git/refs/heads/another_branch
d2315fbf4d1497c8876cc4801c250fc59e987487

dennis@wombat:~/tmp/test$ cat .git/refs/heads/new_branch
1782b8ddab75fb4fdc7fd10a6d122c3321057eca
_PRE_END

<p>Now we can delete other branches safely, which is merely deleting the pointer files (all objects files are left untouched):</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ git branch -d another_branch
Deleted branch another_branch (was d2315fb).

dennis@wombat:~/tmp/test$ git branch -d new_branch
Deleted branch new_branch (was 1782b8d).

dennis@wombat:~/tmp/test$ ls .git/refs/heads/
master
_PRE_END

_HL2(`git stash')

<p>git stash command commites your changes into a separate commit ID and restores file tree from your last commit (or current HEAD, which wasn't touched yet).
All these commit IDs are saved in .git/refs/stash text file:</p>

_PRE_BEGIN
dennis@wombat:~/tmp/test$ vi readme.txt

dennis@wombat:~/tmp/test$ git diff
diff --git a/readme.txt b/readme.txt
index 8b35c7d..1907f4f 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,2 +1,4 @@
 this is readme file

+let me write more here... ouch, I've been interrupted.
+

dennis@wombat:~/tmp/test$ git stash
Saved working directory and index state WIP on master: ea7af61 third commit: install.txt deleted
HEAD is now at ea7af61 third commit: install.txt deleted

dennis@wombat:~/tmp/test$ cat .git/refs/stash
a7ef0db2f3cd7b16653360c78b6051b0e6252b22

dennis@wombat:~/tmp/test$ git stash list
stash@{0}: WIP on master: ea7af61 third commit: install.txt deleted

dennis@wombat:~/tmp/test$ git show a7ef0db2f3cd7b16653360c78b6051b0e6252b22
commit a7ef0db2f3cd7b16653360c78b6051b0e6252b22
Merge: ea7af61 13f7229
Author: Dennis Yurichev <dennis@yurichev.com>
Date:   Sun Sep 20 13:47:38 2015 +0300

    WIP on master: ea7af61 third commit: install.txt deleted

diff --cc readme.txt
index 8b35c7d,8b35c7d..1907f4f
--- a/readme.txt
+++ b/readme.txt
@@@ -1,2 -1,2 +1,4 @@@
  this is readme file
++let me write more here... ouch, I've been interrupted.
++
_PRE_END

_HL2(`Pull requests')

<p>Pull request is an offer to merge changes from other's tree.
Let's say, @while0pass at GitHub wants to fix a bug in my repository ( _HTML_LINK_AS_IS(`https://github.com/dennis714/RE-for-beginners/') ).
He/she makes "fork" on GitHub, which is cloning (or copying) repository to his own account ( _HTML_LINK_AS_IS(`https://github.com/while0pass/RE-for-beginners') ).
He makes change and commits it on his local computer: _HTML_LINK_AS_IS(`https://github.com/dennis714/RE-for-beginners/pull/73/files').
His repository is now different from what is on my GitHub account at the moment: it has one additional commit.
He then pushes his repository to his personal space at GitHub, in other words, to his fork of my repository.
Now he making "pull request", an offer to me to grab the changes: _HTML_LINK_AS_IS(`https://github.com/dennis714/RE-for-beginners/pull/73').
If everything can go smoothly, GitHub can merge automatically.</p>

<p>Now my own GitHub repository at _HTML_LINK_AS_IS(`https://github.com/dennis714/RE-for-beginners/') has commit from @while0pass.
But at the time, on my local computer, I worked on repository and made some changes and commited them.
Let's say, I forgot about @while0pass's contribution and trying to push my changes to my GitHub account.
git doesn't allow to do so ("remote rejected"), because repositories (my local and current at GitHub) are different.
So I first pull changes from my GitHub account to my local computer, which is also a merging, I merge my work with @while0pass's work.
Only after that I can push the most updated version of repository to my GitHub repository.</p>

<p>In case of conflicts (two developers edited a same line in a same file),
GitHub offers to merge on your local computer, because it requires conflict resolution in your text editor
(constructing a line from two versions of line): _HTML_LINK_AS_IS(`https://help.github.com/articles/checking-out-pull-requests-locally/').</p>

<p>In this case I would clone @while0pass's repository from _HTML_LINK_AS_IS(`https://github.com/while0pass/RE-for-beginners.git') to my own repository,
and do the work locally. This is what people do who do not use GitHub.</p>

<p>Pull request may contain several commits, like that one: _HTML_LINK_AS_IS(`https://github.com/dennis714/RE-for-beginners/pull/69').</p>

<p>Pull request is not mandatory: I can merge it with my tree, may not, or may do this in the future at the right moment.</p>

_HL2(`Detached head')

<p>The .git/HEAD file usually contains current branch name.
For very basic git usage, current head is always pointing to a "master" branch.</p>

<p>Now let's say I want to compile Linux kernel v3.0.
How to check out files for Linux v3.0?</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git checkout v3.0
Checking out files: 100% (56057/56057), done.
Note: checking out 'v3.0'.
You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at 02f8c6a... Linux 3.0
_PRE_END

<p>Let's see current HEAD file contents:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ cat .git/HEAD
02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
_PRE_END

<p>That means, the current head is now points to somewhere in the middle of the whole Linux commit history.
It is indeed points to the commit where author added "v3.0" tag:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git show 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jul 21 19:17:23 2011 -0700

    Linux 3.0

...
_PRE_END

<p>Now I can compile Linux v3.0.
How to get back?
Just checkout files of the "master" branch:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ git checkout master
Checking out files: 100% (56057/56057), done.
Previous HEAD position was 02f8c6a... Linux 3.0
Switched to branch 'master'
Your branch is up-to-date with 'origin/master'.
_PRE_END

<p>Current head is now points to "master" branch:</p>

_PRE_BEGIN
dennis@bigbox:~/src/linux-kernel/linux-git$ cat .git/HEAD
ref: refs/heads/master
_PRE_END

<p>What if I want to change something in v3.0 and commit my changes? Well, it's not possible to overwrite commits happens after "v3.0" commit.
But you can create new branch stemming from "v3.0" commit (as git proposes) and work there.</p>

_HL2(`git fsck')

<p>So, speaking theoretically, git objects form a graph.
But sometimes, some objects may be dropped due to some operations:</p>

<blockquote>
Usually, dangling blobs and trees aren't very interesting. They're
almost always the result of either being a half-way mergebase (the blob
will often even have the conflict markers from a merge in it, if you
have had conflicting merges that you fixed up by hand), or simply
because you interrupted a 'git fetch' with ^C or something like that,
leaving _some_ of the new objects in the object database, but just
dangling and useless.
</blockquote>
<p>( _HTML_LINK_AS_IS(`https://github.com/git/git/blob/master/Documentation/user-manual.txt') )</p>

<p>In this case, object will be present, but its ID will never be used.
It's like a file on filesystem which is deleted (no file system data structures has its address or ID), but its contents is still on your disk.
It's also possible in git, and "git fsck" does cleanup: the utility forms a graph and drops objects which are not member of the graph.</p>

_HL2(`Git packfiles')

<p>Keep each object in each file under .git subdirectory is good for 1) demonstration, like this one; 2) faster access to objects.
But more economical way of keeping records is to store objects in compressed "pack files".
The objects there are addressed in the same way, but stored in the single file 
(like _HTML_LINK(`https://en.wikipedia.org/wiki/Doom_WAD',`WAD file in DOOM game') or PAK file in Quake game).
"git gc" command forces git to pack your objects to packfiles.</p>

_HL2(`git as versioning file system.')

<p>This is why git is often called _HTML_LINK(`https://en.wikipedia.org/wiki/Versioning_file_system',`versioning FS'):
besides the fact git stores each version of each file, it also stores the whole file tree at each moment of time.</p>

_BLOG_FOOTER()

