m4_include(`commons.m4')

_HEADER_HL1(`[SMT][Z3][Python] Organize your backups')

<p>
In the era of audio cassettes (1980s, 1990s), many music lovers recorded their own mix tapes with tracks/songs they like.
Each side of audio cassette was 30 or 45 minutes.
The problem was to make such an order of songs, so that a minimal "silent" track at the end of each side would left.
</p>

<p>This is classic _HTML_LINK(`https://en.wikipedia.org/wiki/Bin_packing_problem',`bin packing problem'): all bins (cassettes) are equally sized.</p>

<p>Now let's advance this problem further: bins can be different.
You may want to backup your files to all sorts of storages you have: DVD-RW, USB-sticks, remote hosts, cloud storage accounts, etc.
This is a Multiple Knapsack Problem - you've got several knapsacks with different sizes.</p>

<p>This code is also a siplification of my previous post: only one "dimension" (file size) is used: _HTML_LINK(`https://yurichev.com/blog/VM_packing/',`Packing virtual machines into servers').</p>

_PRE_BEGIN
from z3 import *
import itertools

storages=[700, 30, 100, 800, 100, 800, 300, 150, 60, 500, 1000]
files=[18, 57, 291, 184, 167, 496, 45, 368, 144, 428, 15, 100, 999]

files_n=len(files)
files_t=sum(files)

print "storage total we need", files_t

def try_to_fit_into_storages(storages_to_be_used):
    t=len(storages_to_be_used)
    # for each server:
    storage_occupied=[Int('storage%d_occupied' % i) for i in range(t)]
    # which storage the file occupies?
    file_in_storage=[Int('file%d_in_storage' % i) for i in range(files_n)]

    # how much storage we have in picked storages, total?
    storage_t=0
    for i in range(t):
        storage_t=storage_t+storages[storages_to_be_used[i]]
    # skip if the sum of storage in picked storages is too small:
    if files_t > storage_t:
        return

    print "trying to fit all the files into storages:", storages_to_be_used,

    s=Solver()

    # all files must occupy some storage:
    for i in range(files_n):
        s.add(And(file_in_storage[i]>=0, file_in_storage[i]<t))

    for i in range(t):
        """
        here we generate expression like:

        If(file1_in_storage == 4, 57, 0) +
        If(file1_in_storage == 4, 291, 0) +
        If(file1_in_storage == 4, 184, 0) +
        If(file1_in_storage == 4, 167, 0) +
        If(file1_in_storage == 4, 496, 0) +
        If(file1_in_storage == 4, 45, 0) +
        If(file1_in_storage == 4, 368, 0) +
        If(file1_in_storage == 4, 144, 0) +
        If(file1_in_storage == 4, 428, 0) +
        If(file1_in_storage == 4, 15, 0)

        ... in plain English - if a file is in storage, add its size to the final sum

        """

        s.add(storage_occupied[i]==Sum([If(file_in_storage[f]==i, files[f], 0) for f in range(files_n)]))

        # ... but sum of all files in each storage must be lower than what we have in the storage:
        s.add(And(storage_occupied[i]>=0, storage_occupied[i]<=storages[storages_to_be_used[i]]))
    if s.check()==sat:
        print "sat"
        print "* solution (%d storages):" % t
        m=s.model()
        #print m
        for i in range(t):
            print "storage%d (total=%d):" % (storages_to_be_used[i], storages[storages_to_be_used[i]])
            for f in range(files_n):
                if m[file_in_storage[f]].as_long()==i:
                    print "    file%d (%d)" % (f, files[f])
            print "allocated on storage=%d" % (m[storage_occupied[i]].as_long()),
            print "free on storage=%d" % (storages[storages_to_be_used[i]] - m[storage_occupied[i]].as_long())
        print "total in all storages=%d" % storage_t
        print "allocated on all storages=%d%%" % ((float(files_t)/float(storage_t))*100)
        print ""
        return True
    else:
        print "unsat"
        return False

# how many storages we need? start with 2:
found_solution=False
for storages_to_pick in range(2, len(storages)+1):

    # we use Python itertools to find all combinations
    # in other words, pick $storages_to_pick$ storages from all storages, and enumerate all possible ways to choose from them.
    # see also: https://en.wikipedia.org/wiki/Combination
    for storages_to_be_used in itertools.combinations(range(len(storages)), r=storages_to_pick):
        # for some reasons, we may want to always use storage0
        # skip all sets, where no storage0 present:
        if 0 not in storages_to_be_used:
            continue
        if try_to_fit_into_storages(storages_to_be_used):
            found_solution=True
    # after we've got some solutions for $storages_to_pick$, stop:
    if found_solution:
        break
_PRE_END

<p>( Syntax-highlighted version: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/backup/backup.py' ) )</p>

<p>Choose any solution you like:</p>

_PRE_BEGIN
trying to fit all the files into storages: (0, 3, 5, 7, 10) sat
* solution (5 storages):
storage0 (total=700):
    file0 (18)
    file3 (184)
    file9 (428)
allocated on storage=630 free on storage=70
storage3 (total=800):
    file2 (291)
    file5 (496)
allocated on storage=787 free on storage=13
storage5 (total=800):
    file1 (57)
    file4 (167)
    file6 (45)
    file7 (368)
    file8 (144)
allocated on storage=781 free on storage=19
storage7 (total=150):
    file10 (15)
    file11 (100)
allocated on storage=115 free on storage=35
storage10 (total=1000):
    file12 (999)
allocated on storage=999 free on storage=1
total in all storages=3450
allocated on all storages=96%

trying to fit all the files into storages: (0, 3, 5, 8, 10) sat
* solution (5 storages):
storage0 (total=700):
    file3 (184)
    file5 (496)
allocated on storage=680 free on storage=20
storage3 (total=800):
    file1 (57)
    file4 (167)
    file8 (144)
    file9 (428)
allocated on storage=796 free on storage=4
storage5 (total=800):
    file0 (18)
    file2 (291)
    file7 (368)
    file11 (100)
allocated on storage=777 free on storage=23
storage8 (total=60):
    file6 (45)
    file10 (15)
allocated on storage=60 free on storage=0
storage10 (total=1000):
    file12 (999)
allocated on storage=999 free on storage=1
total in all storages=3360
allocated on all storages=98%
_PRE_END

<p>Now something practical. You may want to store each file twice. And no pair must reside on a single storage.
Not a problem, just make two arrays of variables:</p>

_PRE_BEGIN
...

     file1_in_storage=[Int('file1_%d_in_storage' % i) for i in range(files_n)]
     file2_in_storage=[Int('file2_%d_in_storage' % i) for i in range(files_n)]

...

         s.add(And(file1_in_storage[i]>=0, file1_in_storage[i]&lt;t))
         s.add(And(file2_in_storage[i]>=0, file2_in_storage[i]&lt;t))
         # no pair can reside on one storage:
         s.add(file1_in_storage[i] != file2_in_storage[i])

...

         s.add(storage_occupied[i]==
             Sum([If(file1_in_storage[f]==i, files[f], 0) for f in range(files_n)])+
             Sum([If(file2_in_storage[f]==i, files[f], 0) for f in range(files_n)]))

...

                 if m[file1_in_storage[f]].as_long()==i:
                     print "    file%d (1st copy) (%d)" % (f, files[f])
                 if m[file2_in_storage[f]].as_long()==i:
                     print "    file%d (2nd copy) (%d)" % (f, files[f])
...
_PRE_END

<p>( The full file: _HTML_LINK_AS_IS(`https://github.com/DennisYurichev/yurichev.com/blob/master/blog/backup/backup_twice.py') )</p>

<p>The result:</p>

_PRE_BEGIN
storage total we need 3570
trying to fit all the files into storages: (0, 3, 5, 6, 10) sat
* solution (5 storages):
storage0 (total=700):
    file4 (1st copy) (167)
    file7 (1st copy) (368)
    file8 (1st copy) (144)
    file9 (2nd copy) (15)
allocated on storage=694 free on storage=6
storage3 (total=800):
    file0 (2nd copy) (18)
    file3 (1st copy) (184)
    file4 (2nd copy) (167)
    file6 (2nd copy) (45)
    file7 (2nd copy) (368)
    file9 (1st copy) (15)
allocated on storage=797 free on storage=3
storage5 (total=800):
    file0 (1st copy) (18)
    file1 (2nd copy) (57)
    file3 (2nd copy) (184)
    file5 (2nd copy) (496)
    file6 (1st copy) (45)
allocated on storage=800 free on storage=0
storage6 (total=300):
    file2 (1st copy) (291)
allocated on storage=291 free on storage=9
storage10 (total=1000):
    file1 (1st copy) (57)
    file2 (2nd copy) (291)
    file5 (1st copy) (496)
    file8 (2nd copy) (144)
allocated on storage=988 free on storage=12
total in all storages=3600
allocated on all storages=99%

trying to fit all the files into storages: (0, 3, 5, 9, 10) sat
* solution (5 storages):
storage0 (total=700):
    file0 (1st copy) (18)
    file3 (2nd copy) (184)
    file5 (2nd copy) (496)
allocated on storage=698 free on storage=2
storage3 (total=800):
    file1 (2nd copy) (57)
    file2 (2nd copy) (291)
    file4 (2nd copy) (167)
    file8 (1st copy) (144)
    file9 (2nd copy) (15)
allocated on storage=674 free on storage=126
storage5 (total=800):
    file4 (1st copy) (167)
    file6 (2nd copy) (45)
    file7 (1st copy) (368)
    file8 (2nd copy) (144)
allocated on storage=724 free on storage=76
storage9 (total=500):
    file2 (1st copy) (291)
    file3 (1st copy) (184)
allocated on storage=475 free on storage=25
storage10 (total=1000):
    file0 (2nd copy) (18)
    file1 (1st copy) (57)
    file5 (1st copy) (496)
    file6 (1st copy) (45)
    file7 (2nd copy) (368)
    file9 (1st copy) (15)
allocated on storage=999 free on storage=1
total in all storages=3800
allocated on all storages=93%
_PRE_END

_BLOG_FOOTER()

