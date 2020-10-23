{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
module Parser
( parseCPP
) where
import Grammar
import Lexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19

happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x00\x00\xf8\x00\x00\x00\x00\x00\x00\x80\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x78\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd8\x79\x00\x00\x80\x00\x00\x00\x00\x80\x00\x40\x00\x00\x00\x00\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x80\x9d\x07\x00\x00\x08\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x30\x02\x70\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\xf0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\xf0\xff\x04\x00\x00\x00\x00\x00\xff\x4f\x00\x00\x00\x00\x00\x23\x00\x87\x07\x00\x00\x00\x00\xff\x4f\x00\x00\x00\x00\x00\xf0\x3f\x00\x00\x00\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x30\x02\x30\x78\x00\x00\x00\x00\xf0\xff\x00\x00\x00\x00\x00\x00\xff\x0f\x00\x00\x00\x00\x00\xf8\xff\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\xff\x03\x00\x00\x00\x00\x00\xf0\x00\x00\x00\x00\x00\x00\x00\x0f\x00\x00\x00\x00\x00\x00\xf0\x00\x00\x00\x00\x00\x00\x00\x0f\x00\x00\x00\x00\x00\x00\xf0\x00\x00\x00\x00\x00\x00\x00\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\xff\x4f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\xff\x0f\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x23\x00\x83\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\xff\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\xff\x04\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseCPP","program","functions","function","body","statements","statement","simple_statement","compound_statement","expr","value","vbool","vint","vdouble","vstring","ftype","vtype","WHILE","IF","ELSE","RETURN","CIN","COUT","'>>'","'<<'","INT","DOUBLE","BOOL","STRING","VOID","TRUE","FALSE","';'","','","'+'","'-'","'*'","'/'","'=='","'!='","'>='","'<='","'>'","'<'","'&&'","'||'","'!'","'('","')'","'{'","'}'","'='","NEWLINE","NAME","INT_VAL","DOUBLE_VAL","STRING_VAL","%eof"]
        bit_start = st * 60
        bit_end = (st + 1) * 60
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..59]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (28#) = happyShift action_6
action_0 (29#) = happyShift action_7
action_0 (30#) = happyShift action_8
action_0 (31#) = happyShift action_9
action_0 (32#) = happyShift action_10
action_0 (4#) = happyGoto action_11
action_0 (5#) = happyGoto action_2
action_0 (6#) = happyGoto action_3
action_0 (18#) = happyGoto action_4
action_0 (19#) = happyGoto action_5
action_0 x = happyTcHack x happyReduce_3

action_1 (28#) = happyShift action_6
action_1 (29#) = happyShift action_7
action_1 (30#) = happyShift action_8
action_1 (31#) = happyShift action_9
action_1 (32#) = happyShift action_10
action_1 (5#) = happyGoto action_2
action_1 (6#) = happyGoto action_3
action_1 (18#) = happyGoto action_4
action_1 (19#) = happyGoto action_5
action_1 x = happyTcHack x happyFail (happyExpListPerState 1)

action_2 x = happyTcHack x happyReduce_1

action_3 (28#) = happyShift action_6
action_3 (29#) = happyShift action_7
action_3 (30#) = happyShift action_8
action_3 (31#) = happyShift action_9
action_3 (32#) = happyShift action_10
action_3 (5#) = happyGoto action_13
action_3 (6#) = happyGoto action_3
action_3 (18#) = happyGoto action_4
action_3 (19#) = happyGoto action_5
action_3 x = happyTcHack x happyReduce_3

action_4 (56#) = happyShift action_12
action_4 x = happyTcHack x happyFail (happyExpListPerState 4)

action_5 x = happyTcHack x happyReduce_51

action_6 x = happyTcHack x happyReduce_53

action_7 x = happyTcHack x happyReduce_54

action_8 x = happyTcHack x happyReduce_55

action_9 x = happyTcHack x happyReduce_56

action_10 x = happyTcHack x happyReduce_52

action_11 (60#) = happyAccept
action_11 x = happyTcHack x happyFail (happyExpListPerState 11)

action_12 (50#) = happyShift action_14
action_12 x = happyTcHack x happyFail (happyExpListPerState 12)

action_13 x = happyTcHack x happyReduce_2

action_14 (28#) = happyShift action_6
action_14 (29#) = happyShift action_7
action_14 (30#) = happyShift action_8
action_14 (31#) = happyShift action_9
action_14 (51#) = happyShift action_16
action_14 (19#) = happyGoto action_15
action_14 x = happyTcHack x happyFail (happyExpListPerState 14)

action_15 (56#) = happyShift action_19
action_15 x = happyTcHack x happyFail (happyExpListPerState 15)

action_16 (52#) = happyShift action_18
action_16 (7#) = happyGoto action_17
action_16 x = happyTcHack x happyFail (happyExpListPerState 16)

action_17 x = happyTcHack x happyReduce_4

action_18 (20#) = happyShift action_27
action_18 (21#) = happyShift action_28
action_18 (23#) = happyShift action_29
action_18 (24#) = happyShift action_30
action_18 (25#) = happyShift action_31
action_18 (28#) = happyShift action_6
action_18 (29#) = happyShift action_7
action_18 (30#) = happyShift action_8
action_18 (31#) = happyShift action_9
action_18 (56#) = happyShift action_32
action_18 (8#) = happyGoto action_22
action_18 (9#) = happyGoto action_23
action_18 (10#) = happyGoto action_24
action_18 (11#) = happyGoto action_25
action_18 (19#) = happyGoto action_26
action_18 x = happyTcHack x happyReduce_9

action_19 (36#) = happyShift action_20
action_19 (51#) = happyShift action_21
action_19 x = happyTcHack x happyFail (happyExpListPerState 19)

action_20 (28#) = happyShift action_6
action_20 (29#) = happyShift action_7
action_20 (30#) = happyShift action_8
action_20 (31#) = happyShift action_9
action_20 (19#) = happyGoto action_59
action_20 x = happyTcHack x happyFail (happyExpListPerState 20)

action_21 (52#) = happyShift action_18
action_21 (7#) = happyGoto action_58
action_21 x = happyTcHack x happyFail (happyExpListPerState 21)

action_22 (53#) = happyShift action_57
action_22 x = happyTcHack x happyFail (happyExpListPerState 22)

action_23 (20#) = happyShift action_27
action_23 (21#) = happyShift action_28
action_23 (23#) = happyShift action_29
action_23 (24#) = happyShift action_30
action_23 (25#) = happyShift action_31
action_23 (28#) = happyShift action_6
action_23 (29#) = happyShift action_7
action_23 (30#) = happyShift action_8
action_23 (31#) = happyShift action_9
action_23 (56#) = happyShift action_32
action_23 (8#) = happyGoto action_56
action_23 (9#) = happyGoto action_23
action_23 (10#) = happyGoto action_24
action_23 (11#) = happyGoto action_25
action_23 (19#) = happyGoto action_26
action_23 x = happyTcHack x happyReduce_9

action_24 (35#) = happyShift action_55
action_24 x = happyTcHack x happyFail (happyExpListPerState 24)

action_25 (35#) = happyShift action_54
action_25 x = happyTcHack x happyFail (happyExpListPerState 25)

action_26 (56#) = happyShift action_53
action_26 x = happyTcHack x happyFail (happyExpListPerState 26)

action_27 (50#) = happyShift action_52
action_27 x = happyTcHack x happyFail (happyExpListPerState 27)

action_28 (50#) = happyShift action_51
action_28 x = happyTcHack x happyFail (happyExpListPerState 28)

action_29 (33#) = happyShift action_42
action_29 (34#) = happyShift action_43
action_29 (38#) = happyShift action_44
action_29 (49#) = happyShift action_45
action_29 (50#) = happyShift action_46
action_29 (56#) = happyShift action_47
action_29 (57#) = happyShift action_48
action_29 (58#) = happyShift action_49
action_29 (59#) = happyShift action_50
action_29 (12#) = happyGoto action_36
action_29 (13#) = happyGoto action_37
action_29 (14#) = happyGoto action_38
action_29 (15#) = happyGoto action_39
action_29 (16#) = happyGoto action_40
action_29 (17#) = happyGoto action_41
action_29 x = happyTcHack x happyFail (happyExpListPerState 29)

action_30 (26#) = happyShift action_35
action_30 x = happyTcHack x happyFail (happyExpListPerState 30)

action_31 (27#) = happyShift action_34
action_31 x = happyTcHack x happyFail (happyExpListPerState 31)

action_32 (50#) = happyShift action_33
action_32 x = happyTcHack x happyFail (happyExpListPerState 32)

action_33 (33#) = happyShift action_42
action_33 (34#) = happyShift action_43
action_33 (38#) = happyShift action_44
action_33 (49#) = happyShift action_45
action_33 (50#) = happyShift action_46
action_33 (51#) = happyShift action_83
action_33 (56#) = happyShift action_47
action_33 (57#) = happyShift action_48
action_33 (58#) = happyShift action_49
action_33 (59#) = happyShift action_50
action_33 (12#) = happyGoto action_82
action_33 (13#) = happyGoto action_37
action_33 (14#) = happyGoto action_38
action_33 (15#) = happyGoto action_39
action_33 (16#) = happyGoto action_40
action_33 (17#) = happyGoto action_41
action_33 x = happyTcHack x happyFail (happyExpListPerState 33)

action_34 (33#) = happyShift action_42
action_34 (34#) = happyShift action_43
action_34 (38#) = happyShift action_44
action_34 (49#) = happyShift action_45
action_34 (50#) = happyShift action_46
action_34 (56#) = happyShift action_47
action_34 (57#) = happyShift action_48
action_34 (58#) = happyShift action_49
action_34 (59#) = happyShift action_50
action_34 (12#) = happyGoto action_81
action_34 (13#) = happyGoto action_37
action_34 (14#) = happyGoto action_38
action_34 (15#) = happyGoto action_39
action_34 (16#) = happyGoto action_40
action_34 (17#) = happyGoto action_41
action_34 x = happyTcHack x happyFail (happyExpListPerState 34)

action_35 (33#) = happyShift action_42
action_35 (34#) = happyShift action_43
action_35 (38#) = happyShift action_44
action_35 (49#) = happyShift action_45
action_35 (50#) = happyShift action_46
action_35 (56#) = happyShift action_47
action_35 (57#) = happyShift action_48
action_35 (58#) = happyShift action_49
action_35 (59#) = happyShift action_50
action_35 (12#) = happyGoto action_80
action_35 (13#) = happyGoto action_37
action_35 (14#) = happyGoto action_38
action_35 (15#) = happyGoto action_39
action_35 (16#) = happyGoto action_40
action_35 (17#) = happyGoto action_41
action_35 x = happyTcHack x happyFail (happyExpListPerState 35)

action_36 (37#) = happyShift action_68
action_36 (38#) = happyShift action_69
action_36 (39#) = happyShift action_70
action_36 (40#) = happyShift action_71
action_36 (41#) = happyShift action_72
action_36 (42#) = happyShift action_73
action_36 (43#) = happyShift action_74
action_36 (44#) = happyShift action_75
action_36 (45#) = happyShift action_76
action_36 (46#) = happyShift action_77
action_36 (47#) = happyShift action_78
action_36 (48#) = happyShift action_79
action_36 x = happyTcHack x happyReduce_13

action_37 x = happyTcHack x happyReduce_41

action_38 x = happyTcHack x happyReduce_42

action_39 x = happyTcHack x happyReduce_43

action_40 x = happyTcHack x happyReduce_44

action_41 x = happyTcHack x happyReduce_45

action_42 x = happyTcHack x happyReduce_46

action_43 x = happyTcHack x happyReduce_47

action_44 (33#) = happyShift action_42
action_44 (34#) = happyShift action_43
action_44 (38#) = happyShift action_44
action_44 (49#) = happyShift action_45
action_44 (50#) = happyShift action_46
action_44 (56#) = happyShift action_47
action_44 (57#) = happyShift action_48
action_44 (58#) = happyShift action_49
action_44 (59#) = happyShift action_50
action_44 (12#) = happyGoto action_67
action_44 (13#) = happyGoto action_37
action_44 (14#) = happyGoto action_38
action_44 (15#) = happyGoto action_39
action_44 (16#) = happyGoto action_40
action_44 (17#) = happyGoto action_41
action_44 x = happyTcHack x happyFail (happyExpListPerState 44)

action_45 (33#) = happyShift action_42
action_45 (34#) = happyShift action_43
action_45 (38#) = happyShift action_44
action_45 (49#) = happyShift action_45
action_45 (50#) = happyShift action_46
action_45 (56#) = happyShift action_47
action_45 (57#) = happyShift action_48
action_45 (58#) = happyShift action_49
action_45 (59#) = happyShift action_50
action_45 (12#) = happyGoto action_66
action_45 (13#) = happyGoto action_37
action_45 (14#) = happyGoto action_38
action_45 (15#) = happyGoto action_39
action_45 (16#) = happyGoto action_40
action_45 (17#) = happyGoto action_41
action_45 x = happyTcHack x happyFail (happyExpListPerState 45)

action_46 (33#) = happyShift action_42
action_46 (34#) = happyShift action_43
action_46 (38#) = happyShift action_44
action_46 (49#) = happyShift action_45
action_46 (50#) = happyShift action_46
action_46 (56#) = happyShift action_47
action_46 (57#) = happyShift action_48
action_46 (58#) = happyShift action_49
action_46 (59#) = happyShift action_50
action_46 (12#) = happyGoto action_65
action_46 (13#) = happyGoto action_37
action_46 (14#) = happyGoto action_38
action_46 (15#) = happyGoto action_39
action_46 (16#) = happyGoto action_40
action_46 (17#) = happyGoto action_41
action_46 x = happyTcHack x happyFail (happyExpListPerState 46)

action_47 (50#) = happyShift action_64
action_47 x = happyTcHack x happyReduce_37

action_48 x = happyTcHack x happyReduce_48

action_49 x = happyTcHack x happyReduce_49

action_50 x = happyTcHack x happyReduce_50

action_51 (33#) = happyShift action_42
action_51 (34#) = happyShift action_43
action_51 (38#) = happyShift action_44
action_51 (49#) = happyShift action_45
action_51 (50#) = happyShift action_46
action_51 (56#) = happyShift action_47
action_51 (57#) = happyShift action_48
action_51 (58#) = happyShift action_49
action_51 (59#) = happyShift action_50
action_51 (12#) = happyGoto action_63
action_51 (13#) = happyGoto action_37
action_51 (14#) = happyGoto action_38
action_51 (15#) = happyGoto action_39
action_51 (16#) = happyGoto action_40
action_51 (17#) = happyGoto action_41
action_51 x = happyTcHack x happyFail (happyExpListPerState 51)

action_52 (33#) = happyShift action_42
action_52 (34#) = happyShift action_43
action_52 (38#) = happyShift action_44
action_52 (49#) = happyShift action_45
action_52 (50#) = happyShift action_46
action_52 (56#) = happyShift action_47
action_52 (57#) = happyShift action_48
action_52 (58#) = happyShift action_49
action_52 (59#) = happyShift action_50
action_52 (12#) = happyGoto action_62
action_52 (13#) = happyGoto action_37
action_52 (14#) = happyGoto action_38
action_52 (15#) = happyGoto action_39
action_52 (16#) = happyGoto action_40
action_52 (17#) = happyGoto action_41
action_52 x = happyTcHack x happyFail (happyExpListPerState 52)

action_53 (54#) = happyShift action_61
action_53 x = happyTcHack x happyFail (happyExpListPerState 53)

action_54 x = happyTcHack x happyReduce_11

action_55 x = happyTcHack x happyReduce_10

action_56 x = happyTcHack x happyReduce_8

action_57 x = happyTcHack x happyReduce_7

action_58 x = happyTcHack x happyReduce_5

action_59 (56#) = happyShift action_60
action_59 x = happyTcHack x happyFail (happyExpListPerState 59)

action_60 (51#) = happyShift action_104
action_60 x = happyTcHack x happyFail (happyExpListPerState 60)

action_61 (33#) = happyShift action_42
action_61 (34#) = happyShift action_43
action_61 (38#) = happyShift action_44
action_61 (49#) = happyShift action_45
action_61 (50#) = happyShift action_46
action_61 (56#) = happyShift action_47
action_61 (57#) = happyShift action_48
action_61 (58#) = happyShift action_49
action_61 (59#) = happyShift action_50
action_61 (12#) = happyGoto action_103
action_61 (13#) = happyGoto action_37
action_61 (14#) = happyGoto action_38
action_61 (15#) = happyGoto action_39
action_61 (16#) = happyGoto action_40
action_61 (17#) = happyGoto action_41
action_61 x = happyTcHack x happyFail (happyExpListPerState 61)

action_62 (37#) = happyShift action_68
action_62 (38#) = happyShift action_69
action_62 (39#) = happyShift action_70
action_62 (40#) = happyShift action_71
action_62 (41#) = happyShift action_72
action_62 (42#) = happyShift action_73
action_62 (43#) = happyShift action_74
action_62 (44#) = happyShift action_75
action_62 (45#) = happyShift action_76
action_62 (46#) = happyShift action_77
action_62 (47#) = happyShift action_78
action_62 (48#) = happyShift action_79
action_62 (51#) = happyShift action_102
action_62 x = happyTcHack x happyFail (happyExpListPerState 62)

action_63 (37#) = happyShift action_68
action_63 (38#) = happyShift action_69
action_63 (39#) = happyShift action_70
action_63 (40#) = happyShift action_71
action_63 (41#) = happyShift action_72
action_63 (42#) = happyShift action_73
action_63 (43#) = happyShift action_74
action_63 (44#) = happyShift action_75
action_63 (45#) = happyShift action_76
action_63 (46#) = happyShift action_77
action_63 (47#) = happyShift action_78
action_63 (48#) = happyShift action_79
action_63 (51#) = happyShift action_101
action_63 x = happyTcHack x happyFail (happyExpListPerState 63)

action_64 (33#) = happyShift action_42
action_64 (34#) = happyShift action_43
action_64 (38#) = happyShift action_44
action_64 (49#) = happyShift action_45
action_64 (50#) = happyShift action_46
action_64 (51#) = happyShift action_100
action_64 (56#) = happyShift action_47
action_64 (57#) = happyShift action_48
action_64 (58#) = happyShift action_49
action_64 (59#) = happyShift action_50
action_64 (12#) = happyGoto action_99
action_64 (13#) = happyGoto action_37
action_64 (14#) = happyGoto action_38
action_64 (15#) = happyGoto action_39
action_64 (16#) = happyGoto action_40
action_64 (17#) = happyGoto action_41
action_64 x = happyTcHack x happyFail (happyExpListPerState 64)

action_65 (37#) = happyShift action_68
action_65 (38#) = happyShift action_69
action_65 (39#) = happyShift action_70
action_65 (40#) = happyShift action_71
action_65 (41#) = happyShift action_72
action_65 (42#) = happyShift action_73
action_65 (43#) = happyShift action_74
action_65 (44#) = happyShift action_75
action_65 (45#) = happyShift action_76
action_65 (46#) = happyShift action_77
action_65 (47#) = happyShift action_78
action_65 (48#) = happyShift action_79
action_65 (51#) = happyShift action_98
action_65 x = happyTcHack x happyFail (happyExpListPerState 65)

action_66 (37#) = happyShift action_68
action_66 (38#) = happyShift action_69
action_66 (39#) = happyShift action_70
action_66 (40#) = happyShift action_71
action_66 (41#) = happyShift action_72
action_66 (42#) = happyShift action_73
action_66 (43#) = happyShift action_74
action_66 (44#) = happyShift action_75
action_66 (45#) = happyShift action_76
action_66 (46#) = happyShift action_77
action_66 x = happyTcHack x happyReduce_35

action_67 (39#) = happyShift action_70
action_67 (40#) = happyShift action_71
action_67 x = happyTcHack x happyReduce_32

action_68 (33#) = happyShift action_42
action_68 (34#) = happyShift action_43
action_68 (38#) = happyShift action_44
action_68 (49#) = happyShift action_45
action_68 (50#) = happyShift action_46
action_68 (56#) = happyShift action_47
action_68 (57#) = happyShift action_48
action_68 (58#) = happyShift action_49
action_68 (59#) = happyShift action_50
action_68 (12#) = happyGoto action_97
action_68 (13#) = happyGoto action_37
action_68 (14#) = happyGoto action_38
action_68 (15#) = happyGoto action_39
action_68 (16#) = happyGoto action_40
action_68 (17#) = happyGoto action_41
action_68 x = happyTcHack x happyFail (happyExpListPerState 68)

action_69 (33#) = happyShift action_42
action_69 (34#) = happyShift action_43
action_69 (38#) = happyShift action_44
action_69 (49#) = happyShift action_45
action_69 (50#) = happyShift action_46
action_69 (56#) = happyShift action_47
action_69 (57#) = happyShift action_48
action_69 (58#) = happyShift action_49
action_69 (59#) = happyShift action_50
action_69 (12#) = happyGoto action_96
action_69 (13#) = happyGoto action_37
action_69 (14#) = happyGoto action_38
action_69 (15#) = happyGoto action_39
action_69 (16#) = happyGoto action_40
action_69 (17#) = happyGoto action_41
action_69 x = happyTcHack x happyFail (happyExpListPerState 69)

action_70 (33#) = happyShift action_42
action_70 (34#) = happyShift action_43
action_70 (38#) = happyShift action_44
action_70 (49#) = happyShift action_45
action_70 (50#) = happyShift action_46
action_70 (56#) = happyShift action_47
action_70 (57#) = happyShift action_48
action_70 (58#) = happyShift action_49
action_70 (59#) = happyShift action_50
action_70 (12#) = happyGoto action_95
action_70 (13#) = happyGoto action_37
action_70 (14#) = happyGoto action_38
action_70 (15#) = happyGoto action_39
action_70 (16#) = happyGoto action_40
action_70 (17#) = happyGoto action_41
action_70 x = happyTcHack x happyFail (happyExpListPerState 70)

action_71 (33#) = happyShift action_42
action_71 (34#) = happyShift action_43
action_71 (38#) = happyShift action_44
action_71 (49#) = happyShift action_45
action_71 (50#) = happyShift action_46
action_71 (56#) = happyShift action_47
action_71 (57#) = happyShift action_48
action_71 (58#) = happyShift action_49
action_71 (59#) = happyShift action_50
action_71 (12#) = happyGoto action_94
action_71 (13#) = happyGoto action_37
action_71 (14#) = happyGoto action_38
action_71 (15#) = happyGoto action_39
action_71 (16#) = happyGoto action_40
action_71 (17#) = happyGoto action_41
action_71 x = happyTcHack x happyFail (happyExpListPerState 71)

action_72 (33#) = happyShift action_42
action_72 (34#) = happyShift action_43
action_72 (38#) = happyShift action_44
action_72 (49#) = happyShift action_45
action_72 (50#) = happyShift action_46
action_72 (56#) = happyShift action_47
action_72 (57#) = happyShift action_48
action_72 (58#) = happyShift action_49
action_72 (59#) = happyShift action_50
action_72 (12#) = happyGoto action_93
action_72 (13#) = happyGoto action_37
action_72 (14#) = happyGoto action_38
action_72 (15#) = happyGoto action_39
action_72 (16#) = happyGoto action_40
action_72 (17#) = happyGoto action_41
action_72 x = happyTcHack x happyFail (happyExpListPerState 72)

action_73 (33#) = happyShift action_42
action_73 (34#) = happyShift action_43
action_73 (38#) = happyShift action_44
action_73 (49#) = happyShift action_45
action_73 (50#) = happyShift action_46
action_73 (56#) = happyShift action_47
action_73 (57#) = happyShift action_48
action_73 (58#) = happyShift action_49
action_73 (59#) = happyShift action_50
action_73 (12#) = happyGoto action_92
action_73 (13#) = happyGoto action_37
action_73 (14#) = happyGoto action_38
action_73 (15#) = happyGoto action_39
action_73 (16#) = happyGoto action_40
action_73 (17#) = happyGoto action_41
action_73 x = happyTcHack x happyFail (happyExpListPerState 73)

action_74 (33#) = happyShift action_42
action_74 (34#) = happyShift action_43
action_74 (38#) = happyShift action_44
action_74 (49#) = happyShift action_45
action_74 (50#) = happyShift action_46
action_74 (56#) = happyShift action_47
action_74 (57#) = happyShift action_48
action_74 (58#) = happyShift action_49
action_74 (59#) = happyShift action_50
action_74 (12#) = happyGoto action_91
action_74 (13#) = happyGoto action_37
action_74 (14#) = happyGoto action_38
action_74 (15#) = happyGoto action_39
action_74 (16#) = happyGoto action_40
action_74 (17#) = happyGoto action_41
action_74 x = happyTcHack x happyFail (happyExpListPerState 74)

action_75 (33#) = happyShift action_42
action_75 (34#) = happyShift action_43
action_75 (38#) = happyShift action_44
action_75 (49#) = happyShift action_45
action_75 (50#) = happyShift action_46
action_75 (56#) = happyShift action_47
action_75 (57#) = happyShift action_48
action_75 (58#) = happyShift action_49
action_75 (59#) = happyShift action_50
action_75 (12#) = happyGoto action_90
action_75 (13#) = happyGoto action_37
action_75 (14#) = happyGoto action_38
action_75 (15#) = happyGoto action_39
action_75 (16#) = happyGoto action_40
action_75 (17#) = happyGoto action_41
action_75 x = happyTcHack x happyFail (happyExpListPerState 75)

action_76 (33#) = happyShift action_42
action_76 (34#) = happyShift action_43
action_76 (38#) = happyShift action_44
action_76 (49#) = happyShift action_45
action_76 (50#) = happyShift action_46
action_76 (56#) = happyShift action_47
action_76 (57#) = happyShift action_48
action_76 (58#) = happyShift action_49
action_76 (59#) = happyShift action_50
action_76 (12#) = happyGoto action_89
action_76 (13#) = happyGoto action_37
action_76 (14#) = happyGoto action_38
action_76 (15#) = happyGoto action_39
action_76 (16#) = happyGoto action_40
action_76 (17#) = happyGoto action_41
action_76 x = happyTcHack x happyFail (happyExpListPerState 76)

action_77 (33#) = happyShift action_42
action_77 (34#) = happyShift action_43
action_77 (38#) = happyShift action_44
action_77 (49#) = happyShift action_45
action_77 (50#) = happyShift action_46
action_77 (56#) = happyShift action_47
action_77 (57#) = happyShift action_48
action_77 (58#) = happyShift action_49
action_77 (59#) = happyShift action_50
action_77 (12#) = happyGoto action_88
action_77 (13#) = happyGoto action_37
action_77 (14#) = happyGoto action_38
action_77 (15#) = happyGoto action_39
action_77 (16#) = happyGoto action_40
action_77 (17#) = happyGoto action_41
action_77 x = happyTcHack x happyFail (happyExpListPerState 77)

action_78 (33#) = happyShift action_42
action_78 (34#) = happyShift action_43
action_78 (38#) = happyShift action_44
action_78 (49#) = happyShift action_45
action_78 (50#) = happyShift action_46
action_78 (56#) = happyShift action_47
action_78 (57#) = happyShift action_48
action_78 (58#) = happyShift action_49
action_78 (59#) = happyShift action_50
action_78 (12#) = happyGoto action_87
action_78 (13#) = happyGoto action_37
action_78 (14#) = happyGoto action_38
action_78 (15#) = happyGoto action_39
action_78 (16#) = happyGoto action_40
action_78 (17#) = happyGoto action_41
action_78 x = happyTcHack x happyFail (happyExpListPerState 78)

action_79 (33#) = happyShift action_42
action_79 (34#) = happyShift action_43
action_79 (38#) = happyShift action_44
action_79 (49#) = happyShift action_45
action_79 (50#) = happyShift action_46
action_79 (56#) = happyShift action_47
action_79 (57#) = happyShift action_48
action_79 (58#) = happyShift action_49
action_79 (59#) = happyShift action_50
action_79 (12#) = happyGoto action_86
action_79 (13#) = happyGoto action_37
action_79 (14#) = happyGoto action_38
action_79 (15#) = happyGoto action_39
action_79 (16#) = happyGoto action_40
action_79 (17#) = happyGoto action_41
action_79 x = happyTcHack x happyFail (happyExpListPerState 79)

action_80 (37#) = happyShift action_68
action_80 (38#) = happyShift action_69
action_80 (39#) = happyShift action_70
action_80 (40#) = happyShift action_71
action_80 (41#) = happyShift action_72
action_80 (42#) = happyShift action_73
action_80 (43#) = happyShift action_74
action_80 (44#) = happyShift action_75
action_80 (45#) = happyShift action_76
action_80 (46#) = happyShift action_77
action_80 (47#) = happyShift action_78
action_80 (48#) = happyShift action_79
action_80 x = happyTcHack x happyReduce_17

action_81 (37#) = happyShift action_68
action_81 (38#) = happyShift action_69
action_81 (39#) = happyShift action_70
action_81 (40#) = happyShift action_71
action_81 (41#) = happyShift action_72
action_81 (42#) = happyShift action_73
action_81 (43#) = happyShift action_74
action_81 (44#) = happyShift action_75
action_81 (45#) = happyShift action_76
action_81 (46#) = happyShift action_77
action_81 (47#) = happyShift action_78
action_81 (48#) = happyShift action_79
action_81 x = happyTcHack x happyReduce_18

action_82 (36#) = happyShift action_84
action_82 (37#) = happyShift action_68
action_82 (38#) = happyShift action_69
action_82 (39#) = happyShift action_70
action_82 (40#) = happyShift action_71
action_82 (41#) = happyShift action_72
action_82 (42#) = happyShift action_73
action_82 (43#) = happyShift action_74
action_82 (44#) = happyShift action_75
action_82 (45#) = happyShift action_76
action_82 (46#) = happyShift action_77
action_82 (47#) = happyShift action_78
action_82 (48#) = happyShift action_79
action_82 (51#) = happyShift action_85
action_82 x = happyTcHack x happyFail (happyExpListPerState 82)

action_83 x = happyTcHack x happyReduce_14

action_84 (33#) = happyShift action_42
action_84 (34#) = happyShift action_43
action_84 (38#) = happyShift action_44
action_84 (49#) = happyShift action_45
action_84 (50#) = happyShift action_46
action_84 (56#) = happyShift action_47
action_84 (57#) = happyShift action_48
action_84 (58#) = happyShift action_49
action_84 (59#) = happyShift action_50
action_84 (12#) = happyGoto action_110
action_84 (13#) = happyGoto action_37
action_84 (14#) = happyGoto action_38
action_84 (15#) = happyGoto action_39
action_84 (16#) = happyGoto action_40
action_84 (17#) = happyGoto action_41
action_84 x = happyTcHack x happyFail (happyExpListPerState 84)

action_85 x = happyTcHack x happyReduce_15

action_86 (37#) = happyShift action_68
action_86 (38#) = happyShift action_69
action_86 (39#) = happyShift action_70
action_86 (40#) = happyShift action_71
action_86 (41#) = happyShift action_72
action_86 (42#) = happyShift action_73
action_86 (43#) = happyShift action_74
action_86 (44#) = happyShift action_75
action_86 (45#) = happyShift action_76
action_86 (46#) = happyShift action_77
action_86 (47#) = happyShift action_78
action_86 x = happyTcHack x happyReduce_34

action_87 (37#) = happyShift action_68
action_87 (38#) = happyShift action_69
action_87 (39#) = happyShift action_70
action_87 (40#) = happyShift action_71
action_87 (41#) = happyShift action_72
action_87 (42#) = happyShift action_73
action_87 (43#) = happyShift action_74
action_87 (44#) = happyShift action_75
action_87 (45#) = happyShift action_76
action_87 (46#) = happyShift action_77
action_87 x = happyTcHack x happyReduce_33

action_88 (37#) = happyShift action_68
action_88 (38#) = happyShift action_69
action_88 (39#) = happyShift action_70
action_88 (40#) = happyShift action_71
action_88 (41#) = happyFail []
action_88 (42#) = happyFail []
action_88 (43#) = happyFail []
action_88 (44#) = happyFail []
action_88 (45#) = happyFail []
action_88 (46#) = happyFail []
action_88 x = happyTcHack x happyReduce_31

action_89 (37#) = happyShift action_68
action_89 (38#) = happyShift action_69
action_89 (39#) = happyShift action_70
action_89 (40#) = happyShift action_71
action_89 (41#) = happyFail []
action_89 (42#) = happyFail []
action_89 (43#) = happyFail []
action_89 (44#) = happyFail []
action_89 (45#) = happyFail []
action_89 (46#) = happyFail []
action_89 x = happyTcHack x happyReduce_30

action_90 (37#) = happyShift action_68
action_90 (38#) = happyShift action_69
action_90 (39#) = happyShift action_70
action_90 (40#) = happyShift action_71
action_90 (41#) = happyFail []
action_90 (42#) = happyFail []
action_90 (43#) = happyFail []
action_90 (44#) = happyFail []
action_90 (45#) = happyFail []
action_90 (46#) = happyFail []
action_90 x = happyTcHack x happyReduce_29

action_91 (37#) = happyShift action_68
action_91 (38#) = happyShift action_69
action_91 (39#) = happyShift action_70
action_91 (40#) = happyShift action_71
action_91 (41#) = happyFail []
action_91 (42#) = happyFail []
action_91 (43#) = happyFail []
action_91 (44#) = happyFail []
action_91 (45#) = happyFail []
action_91 (46#) = happyFail []
action_91 x = happyTcHack x happyReduce_28

action_92 (37#) = happyShift action_68
action_92 (38#) = happyShift action_69
action_92 (39#) = happyShift action_70
action_92 (40#) = happyShift action_71
action_92 (41#) = happyFail []
action_92 (42#) = happyFail []
action_92 (43#) = happyFail []
action_92 (44#) = happyFail []
action_92 (45#) = happyFail []
action_92 (46#) = happyFail []
action_92 x = happyTcHack x happyReduce_27

action_93 (37#) = happyShift action_68
action_93 (38#) = happyShift action_69
action_93 (39#) = happyShift action_70
action_93 (40#) = happyShift action_71
action_93 (41#) = happyFail []
action_93 (42#) = happyFail []
action_93 (43#) = happyFail []
action_93 (44#) = happyFail []
action_93 (45#) = happyFail []
action_93 (46#) = happyFail []
action_93 x = happyTcHack x happyReduce_26

action_94 x = happyTcHack x happyReduce_25

action_95 x = happyTcHack x happyReduce_24

action_96 (39#) = happyShift action_70
action_96 (40#) = happyShift action_71
action_96 x = happyTcHack x happyReduce_23

action_97 (39#) = happyShift action_70
action_97 (40#) = happyShift action_71
action_97 x = happyTcHack x happyReduce_22

action_98 x = happyTcHack x happyReduce_36

action_99 (36#) = happyShift action_108
action_99 (37#) = happyShift action_68
action_99 (38#) = happyShift action_69
action_99 (39#) = happyShift action_70
action_99 (40#) = happyShift action_71
action_99 (41#) = happyShift action_72
action_99 (42#) = happyShift action_73
action_99 (43#) = happyShift action_74
action_99 (44#) = happyShift action_75
action_99 (45#) = happyShift action_76
action_99 (46#) = happyShift action_77
action_99 (47#) = happyShift action_78
action_99 (48#) = happyShift action_79
action_99 (51#) = happyShift action_109
action_99 x = happyTcHack x happyFail (happyExpListPerState 99)

action_100 x = happyTcHack x happyReduce_38

action_101 (52#) = happyShift action_18
action_101 (7#) = happyGoto action_107
action_101 x = happyTcHack x happyFail (happyExpListPerState 101)

action_102 (52#) = happyShift action_18
action_102 (7#) = happyGoto action_106
action_102 x = happyTcHack x happyFail (happyExpListPerState 102)

action_103 (37#) = happyShift action_68
action_103 (38#) = happyShift action_69
action_103 (39#) = happyShift action_70
action_103 (40#) = happyShift action_71
action_103 (41#) = happyShift action_72
action_103 (42#) = happyShift action_73
action_103 (43#) = happyShift action_74
action_103 (44#) = happyShift action_75
action_103 (45#) = happyShift action_76
action_103 (46#) = happyShift action_77
action_103 (47#) = happyShift action_78
action_103 (48#) = happyShift action_79
action_103 x = happyTcHack x happyReduce_12

action_104 (52#) = happyShift action_18
action_104 (7#) = happyGoto action_105
action_104 x = happyTcHack x happyFail (happyExpListPerState 104)

action_105 x = happyTcHack x happyReduce_6

action_106 x = happyTcHack x happyReduce_19

action_107 (22#) = happyShift action_113
action_107 x = happyTcHack x happyReduce_20

action_108 (33#) = happyShift action_42
action_108 (34#) = happyShift action_43
action_108 (38#) = happyShift action_44
action_108 (49#) = happyShift action_45
action_108 (50#) = happyShift action_46
action_108 (56#) = happyShift action_47
action_108 (57#) = happyShift action_48
action_108 (58#) = happyShift action_49
action_108 (59#) = happyShift action_50
action_108 (12#) = happyGoto action_112
action_108 (13#) = happyGoto action_37
action_108 (14#) = happyGoto action_38
action_108 (15#) = happyGoto action_39
action_108 (16#) = happyGoto action_40
action_108 (17#) = happyGoto action_41
action_108 x = happyTcHack x happyFail (happyExpListPerState 108)

action_109 x = happyTcHack x happyReduce_39

action_110 (37#) = happyShift action_68
action_110 (38#) = happyShift action_69
action_110 (39#) = happyShift action_70
action_110 (40#) = happyShift action_71
action_110 (41#) = happyShift action_72
action_110 (42#) = happyShift action_73
action_110 (43#) = happyShift action_74
action_110 (44#) = happyShift action_75
action_110 (45#) = happyShift action_76
action_110 (46#) = happyShift action_77
action_110 (47#) = happyShift action_78
action_110 (48#) = happyShift action_79
action_110 (51#) = happyShift action_111
action_110 x = happyTcHack x happyFail (happyExpListPerState 110)

action_111 x = happyTcHack x happyReduce_16

action_112 (37#) = happyShift action_68
action_112 (38#) = happyShift action_69
action_112 (39#) = happyShift action_70
action_112 (40#) = happyShift action_71
action_112 (41#) = happyShift action_72
action_112 (42#) = happyShift action_73
action_112 (43#) = happyShift action_74
action_112 (44#) = happyShift action_75
action_112 (45#) = happyShift action_76
action_112 (46#) = happyShift action_77
action_112 (47#) = happyShift action_78
action_112 (48#) = happyShift action_79
action_112 (51#) = happyShift action_115
action_112 x = happyTcHack x happyFail (happyExpListPerState 112)

action_113 (52#) = happyShift action_18
action_113 (7#) = happyGoto action_114
action_113 x = happyTcHack x happyFail (happyExpListPerState 113)

action_114 x = happyTcHack x happyReduce_21

action_115 x = happyTcHack x happyReduce_40

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_1 = happySpecReduce_1  4# happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Program happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_2 = happySpecReduce_2  5# happyReduction_2
happyReduction_2 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 : happy_var_2
	)
happyReduction_2 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_3 = happySpecReduce_0  5# happyReduction_3
happyReduction_3  =  HappyAbsSyn5
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_4 = happyReduce 5# 6# happyReduction_4
happyReduction_4 ((HappyAbsSyn7  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	(HappyAbsSyn18  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Fun0 happy_var_1 happy_var_2 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_5 = happyReduce 7# 6# happyReduction_5
happyReduction_5 ((HappyAbsSyn7  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_5)) `HappyStk`
	(HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	(HappyAbsSyn18  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Fun1 happy_var_1 happy_var_2 happy_var_4 happy_var_5 happy_var_7
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_6 = happyReduce 10# 6# happyReduction_6
happyReduction_6 ((HappyAbsSyn7  happy_var_10) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_8)) `HappyStk`
	(HappyAbsSyn19  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_5)) `HappyStk`
	(HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	(HappyAbsSyn18  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Fun2 happy_var_1 happy_var_2 happy_var_4 happy_var_5 happy_var_7 happy_var_8 happy_var_10
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_7 = happySpecReduce_3  7# happyReduction_7
happyReduction_7 _
	(HappyAbsSyn8  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (happy_var_2
	)
happyReduction_7 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_8 = happySpecReduce_2  8# happyReduction_8
happyReduction_8 (HappyAbsSyn8  happy_var_2)
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 : happy_var_2
	)
happyReduction_8 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_9 = happySpecReduce_0  8# happyReduction_9
happyReduction_9  =  HappyAbsSyn8
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_10 = happySpecReduce_2  9# happyReduction_10
happyReduction_10 _
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_10 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_11 = happySpecReduce_2  9# happyReduction_11
happyReduction_11 _
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_11 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_12 = happyReduce 4# 10# happyReduction_12
happyReduction_12 ((HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	(HappyAbsSyn19  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (AssignStmt happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_13 = happySpecReduce_2  10# happyReduction_13
happyReduction_13 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (ReturnStmt happy_var_2
	)
happyReduction_13 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_14 = happySpecReduce_3  10# happyReduction_14
happyReduction_14 _
	_
	(HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn10
		 (Fun0Stmt happy_var_1
	)
happyReduction_14 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_15 = happyReduce 4# 10# happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Fun1Stmt happy_var_1 happy_var_3
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_16 = happyReduce 6# 10# happyReduction_16
happyReduction_16 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Fun2Stmt happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_17 = happySpecReduce_3  10# happyReduction_17
happyReduction_17 (HappyAbsSyn12  happy_var_3)
	_
	_
	 =  HappyAbsSyn10
		 (ReadStmt happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_18 = happySpecReduce_3  10# happyReduction_18
happyReduction_18 (HappyAbsSyn12  happy_var_3)
	_
	_
	 =  HappyAbsSyn10
		 (WriteStmt happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_19 = happyReduce 5# 11# happyReduction_19
happyReduction_19 ((HappyAbsSyn7  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (WhileStmt happy_var_3 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_20 = happyReduce 5# 11# happyReduction_20
happyReduction_20 ((HappyAbsSyn7  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (IfStmt happy_var_3 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_21 = happyReduce 7# 11# happyReduction_21
happyReduction_21 ((HappyAbsSyn7  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (IfElseStmt happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_22 = happySpecReduce_3  12# happyReduction_22
happyReduction_22 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprPlus happy_var_1 happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_23 = happySpecReduce_3  12# happyReduction_23
happyReduction_23 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprMinus happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_24 = happySpecReduce_3  12# happyReduction_24
happyReduction_24 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprMul happy_var_1 happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_25 = happySpecReduce_3  12# happyReduction_25
happyReduction_25 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprDiv happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_26 = happySpecReduce_3  12# happyReduction_26
happyReduction_26 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprEq happy_var_1 happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_27 = happySpecReduce_3  12# happyReduction_27
happyReduction_27 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprNeq happy_var_1 happy_var_3
	)
happyReduction_27 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_28 = happySpecReduce_3  12# happyReduction_28
happyReduction_28 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprGE happy_var_1 happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_29 = happySpecReduce_3  12# happyReduction_29
happyReduction_29 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprLE happy_var_1 happy_var_3
	)
happyReduction_29 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_30 = happySpecReduce_3  12# happyReduction_30
happyReduction_30 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprGT happy_var_1 happy_var_3
	)
happyReduction_30 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_31 = happySpecReduce_3  12# happyReduction_31
happyReduction_31 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprLT happy_var_1 happy_var_3
	)
happyReduction_31 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_32 = happySpecReduce_2  12# happyReduction_32
happyReduction_32 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (ExprNeg happy_var_2
	)
happyReduction_32 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_33 = happySpecReduce_3  12# happyReduction_33
happyReduction_33 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprAnd happy_var_1 happy_var_3
	)
happyReduction_33 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_34 = happySpecReduce_3  12# happyReduction_34
happyReduction_34 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprOr happy_var_1 happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_35 = happySpecReduce_2  12# happyReduction_35
happyReduction_35 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (ExprNot happy_var_2
	)
happyReduction_35 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_36 = happySpecReduce_3  12# happyReduction_36
happyReduction_36 _
	(HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (ExprBracketed happy_var_2
	)
happyReduction_36 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_37 = happySpecReduce_1  12# happyReduction_37
happyReduction_37 (HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn12
		 (ExprVar happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_38 = happySpecReduce_3  12# happyReduction_38
happyReduction_38 _
	_
	(HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn12
		 (ExprFun0 happy_var_1
	)
happyReduction_38 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_39 = happyReduce 4# 12# happyReduction_39
happyReduction_39 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (ExprFun1 happy_var_1 happy_var_3
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_40 = happyReduce 6# 12# happyReduction_40
happyReduction_40 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (ExprFun2 happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_41 = happySpecReduce_1  12# happyReduction_41
happyReduction_41 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprVal happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_42 = happySpecReduce_1  13# happyReduction_42
happyReduction_42 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_43 = happySpecReduce_1  13# happyReduction_43
happyReduction_43 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_44 = happySpecReduce_1  13# happyReduction_44
happyReduction_44 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_45 = happySpecReduce_1  13# happyReduction_45
happyReduction_45 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_45 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_46 = happySpecReduce_1  14# happyReduction_46
happyReduction_46 _
	 =  HappyAbsSyn14
		 (BoolValue True
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_47 = happySpecReduce_1  14# happyReduction_47
happyReduction_47 _
	 =  HappyAbsSyn14
		 (BoolValue False
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_48 = happySpecReduce_1  15# happyReduction_48
happyReduction_48 (HappyTerminal (TInt happy_var_1))
	 =  HappyAbsSyn15
		 (IntValue happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_49 = happySpecReduce_1  16# happyReduction_49
happyReduction_49 (HappyTerminal (TDouble happy_var_1))
	 =  HappyAbsSyn16
		 (DoubleValue happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_50 = happySpecReduce_1  17# happyReduction_50
happyReduction_50 (HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn17
		 (StringValue happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_51 = happySpecReduce_1  18# happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn18
		 (ValType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_52 = happySpecReduce_1  18# happyReduction_52
happyReduction_52 _
	 =  HappyAbsSyn18
		 (VoidType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_53 = happySpecReduce_1  19# happyReduction_53
happyReduction_53 _
	 =  HappyAbsSyn19
		 (IntType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_54 = happySpecReduce_1  19# happyReduction_54
happyReduction_54 _
	 =  HappyAbsSyn19
		 (DoubleType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_55 = happySpecReduce_1  19# happyReduction_55
happyReduction_55 _
	 =  HappyAbsSyn19
		 (BoolType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_56 = happySpecReduce_1  19# happyReduction_56
happyReduction_56 _
	 =  HappyAbsSyn19
		 (StringType
	)

happyNewToken action sts stk [] =
	action 60# 60# notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TWhile -> cont 20#;
	TIf -> cont 21#;
	TElse -> cont 22#;
	TReturn -> cont 23#;
	TCin -> cont 24#;
	TCout -> cont 25#;
	TRShift -> cont 26#;
	TLShift -> cont 27#;
	TIntType -> cont 28#;
	TDoubleType -> cont 29#;
	TBoolType -> cont 30#;
	TStringType -> cont 31#;
	TVoidType -> cont 32#;
	TTrue -> cont 33#;
	TFalse -> cont 34#;
	TSemi -> cont 35#;
	TComma -> cont 36#;
	TPlus -> cont 37#;
	TMinus -> cont 38#;
	TMul -> cont 39#;
	TDiv -> cont 40#;
	TEq -> cont 41#;
	TNEq -> cont 42#;
	TGE -> cont 43#;
	TLE -> cont 44#;
	TG -> cont 45#;
	TL -> cont 46#;
	TAnd -> cont 47#;
	TOr -> cont 48#;
	TNot -> cont 49#;
	TLPar -> cont 50#;
	TRPar -> cont 51#;
	TLBr -> cont 52#;
	TRBr -> cont 53#;
	TAssign -> cont 54#;
	TNewline -> cont 55#;
	TName happy_dollar_dollar -> cont 56#;
	TInt happy_dollar_dollar -> cont 57#;
	TDouble happy_dollar_dollar -> cont 58#;
	TString happy_dollar_dollar -> cont 59#;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 60# tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [String]) -> HappyIdentity a
happyError' = HappyIdentity . (\(tokens, _) -> parseError tokens)
parseCPP tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError arg = error $ "Parse error" <> show arg
{-# LINE 1 "templates/GenericTemplate.hs" #-}

















































































































































































































-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 













-- Do not remove this comment. Required to fix CPP parsing when using GCC and a clang-compiled alex.
#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif


data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList




















infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is 1#, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 1# tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
        (happyTcHack j ) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action




indexShortOffAddr (HappyA# arr) off =
        Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#




{-# INLINE happyLt #-}
happyLt x y = LT(x,y)


readArrayBit arr bit =
    Bits.testBit (Happy_GHC_Exts.I# (indexShortOffAddr arr ((unbox_int bit) `Happy_GHC_Exts.iShiftRA#` 4#))) (bit `mod` 16)
  where unbox_int (Happy_GHC_Exts.I# x) = x






data HappyAddr = HappyA# Happy_GHC_Exts.Addr#


-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Happy_GHC_Exts.Int# ->                    -- token number
         Happy_GHC_Exts.Int# ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 1# tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Happy_GHC_Exts.Int#
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n ((_):(t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (1# is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist 1# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  1# tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action 1# 1# tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action 1# 1# tk (HappyState (action)) sts ( (HappyErrorToken (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions


happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}


-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.

