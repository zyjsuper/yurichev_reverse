(declare-fun workpieces_total () (_ BitVec 16))
(declare-fun cut_A () (_ BitVec 16))
(declare-fun cut_B () (_ BitVec 16))
(declare-fun cut_C () (_ BitVec 16))
(declare-fun cut_D () (_ BitVec 16))
(declare-fun out_A () (_ BitVec 16))
(declare-fun out_B () (_ BitVec 16))

(assert (bvuge cut_A (_ bv0 16)))
(assert (bvuge cut_B (_ bv0 16)))
(assert (bvuge cut_C (_ bv0 16)))
(assert (bvuge cut_D (_ bv0 16)))

(assert (bvuge out_A (_ bv800 16)))
(assert (bvuge out_B (_ bv400 16)))

(assert (= workpieces_total (bvadd cut_A cut_B cut_C cut_D)))

(assert (= out_A (bvadd
		(bvmul_no_overflow cut_A (_ bv3 16))
		(bvmul_no_overflow cut_B (_ bv2 16))
		cut_C
		)
	)
)

(assert (= out_B (bvadd
		cut_A
		(bvmul_no_overflow cut_B (_ bv6 16))
		(bvmul_no_overflow cut_C (_ bv9 16))
		(bvmul_no_overflow cut_D (_ bv13 16))
		)
	)
)

(minimize workpieces_total)

(check-sat)
(get-model)
