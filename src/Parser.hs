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

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20
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
	| HappyAbsSyn20 t20

happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x00\x00\xf0\x01\x00\x00\x00\x00\x00\x00\x3e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x01\x00\x20\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\xe1\x01\x00\x00\x02\x00\x00\x00\x00\x08\x00\x04\x00\x00\x00\x80\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\xc0\xc2\x03\x00\x00\x04\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\xc0\x10\x80\xe1\x01\x00\x00\x00\x20\x00\x00\x02\x00\x00\x80\x01\x00\x00\x80\x00\x00\x00\x00\x60\x08\xc0\xf0\x00\x00\x00\x00\x80\xff\x07\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x21\x00\xc3\x03\x00\x00\x00\x30\x04\x60\x78\x00\x00\x00\x00\x86\x00\x0c\x0f\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x01\x18\x1e\x00\x00\x00\x80\x21\x00\xc3\x03\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x86\x00\x1c\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\xff\x9f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x10\x80\xe1\x01\x00\x00\x00\x00\xff\x4f\x00\x00\x00\x00\x00\xe0\xff\x09\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x80\xff\x27\x00\x00\x00\x00\x00\xf0\x3f\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x86\x00\x1c\x0f\x00\x00\x00\xc0\x10\x80\xe1\x01\x00\x00\x00\x18\x02\x30\x3c\x00\x00\x00\x00\x43\x00\x86\x07\x00\x00\x00\x60\x08\xc0\xf0\x00\x00\x00\x00\x0c\x01\x18\x1e\x00\x00\x00\x80\x21\x00\xc3\x03\x00\x00\x00\x30\x04\x60\x78\x00\x00\x00\x00\x86\x00\x0c\x0f\x00\x00\x00\xc0\x10\x80\xe1\x01\x00\x00\x00\x18\x02\x30\x3c\x00\x00\x00\x00\x43\x00\x86\x07\x00\x00\x00\x60\x08\xc0\xf0\x00\x00\x00\x00\x80\xff\x07\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x10\x80\xe1\x01\x00\x00\x00\x18\x02\x30\x3c\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\xfc\x0f\x00\x00\x00\x00\x00\x80\x07\x00\x00\x00\x00\x00\x00\xf0\x00\x00\x00\x00\x00\x00\x00\x1e\x00\x00\x00\x00\x00\x00\xc0\x03\x00\x00\x00\x00\x00\x00\x78\x00\x00\x00\x00\x00\x00\x00\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\xc0\x00\x00\x00\x00\x00\x00\x00\xff\x9f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\xfc\x3f\x00\x00\x00\x00\x00\x0c\x01\x18\x1e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\x7f\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x60\x08\xc0\xf0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\xff\x00\x00\x00\x00\x00\x00\xfe\x1f\x00\x00\x00\x00\x00\xc0\xff\x13\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseCPP","program","functions","function","body","statements","statement","simple_statement","compound_statement","expr","fname","value","vbool","vint","vdouble","vstring","ftype","vtype","WHILE","IF","ELSE","RETURN","CIN","COUT","'>>'","'<<'","INT","DOUBLE","BOOL","STRING","VOID","TRUE","FALSE","'::'","';'","','","'+'","'-'","'*'","'/'","'=='","'!='","'>='","'<='","'>'","'<'","'&&'","'||'","'!'","'('","')'","'{'","'}'","'='","NAME","INT_VAL","DOUBLE_VAL","STRING_VAL","%eof"]
        bit_start = st * 61
        bit_end = (st + 1) * 61
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..60]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (29#) = happyShift action_5
action_0 (30#) = happyShift action_6
action_0 (31#) = happyShift action_7
action_0 (32#) = happyShift action_8
action_0 (33#) = happyShift action_9
action_0 (4#) = happyGoto action_10
action_0 (5#) = happyGoto action_2
action_0 (6#) = happyGoto action_3
action_0 (19#) = happyGoto action_4
action_0 x = happyTcHack x happyReduce_3

action_1 (29#) = happyShift action_5
action_1 (30#) = happyShift action_6
action_1 (31#) = happyShift action_7
action_1 (32#) = happyShift action_8
action_1 (33#) = happyShift action_9
action_1 (5#) = happyGoto action_2
action_1 (6#) = happyGoto action_3
action_1 (19#) = happyGoto action_4
action_1 x = happyTcHack x happyFail (happyExpListPerState 1)

action_2 x = happyTcHack x happyReduce_1

action_3 (29#) = happyShift action_5
action_3 (30#) = happyShift action_6
action_3 (31#) = happyShift action_7
action_3 (32#) = happyShift action_8
action_3 (33#) = happyShift action_9
action_3 (5#) = happyGoto action_12
action_3 (6#) = happyGoto action_3
action_3 (19#) = happyGoto action_4
action_3 x = happyTcHack x happyReduce_3

action_4 (57#) = happyShift action_11
action_4 x = happyTcHack x happyFail (happyExpListPerState 4)

action_5 x = happyTcHack x happyReduce_54

action_6 x = happyTcHack x happyReduce_55

action_7 x = happyTcHack x happyReduce_56

action_8 x = happyTcHack x happyReduce_57

action_9 x = happyTcHack x happyReduce_58

action_10 (61#) = happyAccept
action_10 x = happyTcHack x happyFail (happyExpListPerState 10)

action_11 (52#) = happyShift action_13
action_11 x = happyTcHack x happyFail (happyExpListPerState 11)

action_12 x = happyTcHack x happyReduce_2

action_13 (29#) = happyShift action_15
action_13 (30#) = happyShift action_16
action_13 (31#) = happyShift action_17
action_13 (32#) = happyShift action_18
action_13 (53#) = happyShift action_19
action_13 (20#) = happyGoto action_14
action_13 x = happyTcHack x happyFail (happyExpListPerState 13)

action_14 (57#) = happyShift action_22
action_14 x = happyTcHack x happyFail (happyExpListPerState 14)

action_15 x = happyTcHack x happyReduce_59

action_16 x = happyTcHack x happyReduce_60

action_17 x = happyTcHack x happyReduce_61

action_18 x = happyTcHack x happyReduce_62

action_19 (54#) = happyShift action_21
action_19 (7#) = happyGoto action_20
action_19 x = happyTcHack x happyFail (happyExpListPerState 19)

action_20 x = happyTcHack x happyReduce_4

action_21 (21#) = happyShift action_31
action_21 (22#) = happyShift action_32
action_21 (24#) = happyShift action_33
action_21 (29#) = happyShift action_15
action_21 (30#) = happyShift action_16
action_21 (31#) = happyShift action_17
action_21 (32#) = happyShift action_18
action_21 (57#) = happyShift action_34
action_21 (8#) = happyGoto action_25
action_21 (9#) = happyGoto action_26
action_21 (10#) = happyGoto action_27
action_21 (11#) = happyGoto action_28
action_21 (13#) = happyGoto action_29
action_21 (20#) = happyGoto action_30
action_21 x = happyTcHack x happyReduce_9

action_22 (38#) = happyShift action_23
action_22 (53#) = happyShift action_24
action_22 x = happyTcHack x happyFail (happyExpListPerState 22)

action_23 (29#) = happyShift action_15
action_23 (30#) = happyShift action_16
action_23 (31#) = happyShift action_17
action_23 (32#) = happyShift action_18
action_23 (20#) = happyGoto action_61
action_23 x = happyTcHack x happyFail (happyExpListPerState 23)

action_24 (54#) = happyShift action_21
action_24 (7#) = happyGoto action_60
action_24 x = happyTcHack x happyFail (happyExpListPerState 24)

action_25 (55#) = happyShift action_59
action_25 x = happyTcHack x happyFail (happyExpListPerState 25)

action_26 (21#) = happyShift action_31
action_26 (22#) = happyShift action_32
action_26 (24#) = happyShift action_33
action_26 (29#) = happyShift action_15
action_26 (30#) = happyShift action_16
action_26 (31#) = happyShift action_17
action_26 (32#) = happyShift action_18
action_26 (57#) = happyShift action_34
action_26 (8#) = happyGoto action_58
action_26 (9#) = happyGoto action_26
action_26 (10#) = happyGoto action_27
action_26 (11#) = happyGoto action_28
action_26 (13#) = happyGoto action_29
action_26 (20#) = happyGoto action_30
action_26 x = happyTcHack x happyReduce_9

action_27 (37#) = happyShift action_57
action_27 x = happyTcHack x happyFail (happyExpListPerState 27)

action_28 x = happyTcHack x happyReduce_11

action_29 (52#) = happyShift action_56
action_29 x = happyTcHack x happyFail (happyExpListPerState 29)

action_30 (57#) = happyShift action_55
action_30 x = happyTcHack x happyFail (happyExpListPerState 30)

action_31 (52#) = happyShift action_54
action_31 x = happyTcHack x happyFail (happyExpListPerState 31)

action_32 (52#) = happyShift action_53
action_32 x = happyTcHack x happyFail (happyExpListPerState 32)

action_33 (34#) = happyShift action_44
action_33 (35#) = happyShift action_45
action_33 (40#) = happyShift action_46
action_33 (51#) = happyShift action_47
action_33 (52#) = happyShift action_48
action_33 (57#) = happyShift action_49
action_33 (58#) = happyShift action_50
action_33 (59#) = happyShift action_51
action_33 (60#) = happyShift action_52
action_33 (12#) = happyGoto action_37
action_33 (13#) = happyGoto action_38
action_33 (14#) = happyGoto action_39
action_33 (15#) = happyGoto action_40
action_33 (16#) = happyGoto action_41
action_33 (17#) = happyGoto action_42
action_33 (18#) = happyGoto action_43
action_33 x = happyTcHack x happyFail (happyExpListPerState 33)

action_34 (36#) = happyShift action_35
action_34 (56#) = happyShift action_36
action_34 x = happyTcHack x happyReduce_43

action_35 (25#) = happyShift action_86
action_35 (26#) = happyShift action_87
action_35 (57#) = happyShift action_88
action_35 x = happyTcHack x happyFail (happyExpListPerState 35)

action_36 (34#) = happyShift action_44
action_36 (35#) = happyShift action_45
action_36 (40#) = happyShift action_46
action_36 (51#) = happyShift action_47
action_36 (52#) = happyShift action_48
action_36 (57#) = happyShift action_49
action_36 (58#) = happyShift action_50
action_36 (59#) = happyShift action_51
action_36 (60#) = happyShift action_52
action_36 (12#) = happyGoto action_85
action_36 (13#) = happyGoto action_38
action_36 (14#) = happyGoto action_39
action_36 (15#) = happyGoto action_40
action_36 (16#) = happyGoto action_41
action_36 (17#) = happyGoto action_42
action_36 (18#) = happyGoto action_43
action_36 x = happyTcHack x happyFail (happyExpListPerState 36)

action_37 (39#) = happyShift action_73
action_37 (40#) = happyShift action_74
action_37 (41#) = happyShift action_75
action_37 (42#) = happyShift action_76
action_37 (43#) = happyShift action_77
action_37 (44#) = happyShift action_78
action_37 (45#) = happyShift action_79
action_37 (46#) = happyShift action_80
action_37 (47#) = happyShift action_81
action_37 (48#) = happyShift action_82
action_37 (49#) = happyShift action_83
action_37 (50#) = happyShift action_84
action_37 x = happyTcHack x happyReduce_14

action_38 (52#) = happyShift action_72
action_38 x = happyTcHack x happyFail (happyExpListPerState 38)

action_39 x = happyTcHack x happyReduce_42

action_40 x = happyTcHack x happyReduce_45

action_41 x = happyTcHack x happyReduce_46

action_42 x = happyTcHack x happyReduce_47

action_43 x = happyTcHack x happyReduce_48

action_44 x = happyTcHack x happyReduce_49

action_45 x = happyTcHack x happyReduce_50

action_46 (34#) = happyShift action_44
action_46 (35#) = happyShift action_45
action_46 (40#) = happyShift action_46
action_46 (51#) = happyShift action_47
action_46 (52#) = happyShift action_48
action_46 (57#) = happyShift action_49
action_46 (58#) = happyShift action_50
action_46 (59#) = happyShift action_51
action_46 (60#) = happyShift action_52
action_46 (12#) = happyGoto action_71
action_46 (13#) = happyGoto action_38
action_46 (14#) = happyGoto action_39
action_46 (15#) = happyGoto action_40
action_46 (16#) = happyGoto action_41
action_46 (17#) = happyGoto action_42
action_46 (18#) = happyGoto action_43
action_46 x = happyTcHack x happyFail (happyExpListPerState 46)

action_47 (34#) = happyShift action_44
action_47 (35#) = happyShift action_45
action_47 (40#) = happyShift action_46
action_47 (51#) = happyShift action_47
action_47 (52#) = happyShift action_48
action_47 (57#) = happyShift action_49
action_47 (58#) = happyShift action_50
action_47 (59#) = happyShift action_51
action_47 (60#) = happyShift action_52
action_47 (12#) = happyGoto action_70
action_47 (13#) = happyGoto action_38
action_47 (14#) = happyGoto action_39
action_47 (15#) = happyGoto action_40
action_47 (16#) = happyGoto action_41
action_47 (17#) = happyGoto action_42
action_47 (18#) = happyGoto action_43
action_47 x = happyTcHack x happyFail (happyExpListPerState 47)

action_48 (34#) = happyShift action_44
action_48 (35#) = happyShift action_45
action_48 (40#) = happyShift action_46
action_48 (51#) = happyShift action_47
action_48 (52#) = happyShift action_48
action_48 (57#) = happyShift action_49
action_48 (58#) = happyShift action_50
action_48 (59#) = happyShift action_51
action_48 (60#) = happyShift action_52
action_48 (12#) = happyGoto action_69
action_48 (13#) = happyGoto action_38
action_48 (14#) = happyGoto action_39
action_48 (15#) = happyGoto action_40
action_48 (16#) = happyGoto action_41
action_48 (17#) = happyGoto action_42
action_48 (18#) = happyGoto action_43
action_48 x = happyTcHack x happyFail (happyExpListPerState 48)

action_49 (36#) = happyShift action_68
action_49 (52#) = happyReduce_43
action_49 x = happyTcHack x happyReduce_38

action_50 x = happyTcHack x happyReduce_51

action_51 x = happyTcHack x happyReduce_52

action_52 x = happyTcHack x happyReduce_53

action_53 (34#) = happyShift action_44
action_53 (35#) = happyShift action_45
action_53 (40#) = happyShift action_46
action_53 (51#) = happyShift action_47
action_53 (52#) = happyShift action_48
action_53 (57#) = happyShift action_49
action_53 (58#) = happyShift action_50
action_53 (59#) = happyShift action_51
action_53 (60#) = happyShift action_52
action_53 (12#) = happyGoto action_67
action_53 (13#) = happyGoto action_38
action_53 (14#) = happyGoto action_39
action_53 (15#) = happyGoto action_40
action_53 (16#) = happyGoto action_41
action_53 (17#) = happyGoto action_42
action_53 (18#) = happyGoto action_43
action_53 x = happyTcHack x happyFail (happyExpListPerState 53)

action_54 (34#) = happyShift action_44
action_54 (35#) = happyShift action_45
action_54 (40#) = happyShift action_46
action_54 (51#) = happyShift action_47
action_54 (52#) = happyShift action_48
action_54 (57#) = happyShift action_49
action_54 (58#) = happyShift action_50
action_54 (59#) = happyShift action_51
action_54 (60#) = happyShift action_52
action_54 (12#) = happyGoto action_66
action_54 (13#) = happyGoto action_38
action_54 (14#) = happyGoto action_39
action_54 (15#) = happyGoto action_40
action_54 (16#) = happyGoto action_41
action_54 (17#) = happyGoto action_42
action_54 (18#) = happyGoto action_43
action_54 x = happyTcHack x happyFail (happyExpListPerState 54)

action_55 (56#) = happyShift action_65
action_55 x = happyTcHack x happyFail (happyExpListPerState 55)

action_56 (34#) = happyShift action_44
action_56 (35#) = happyShift action_45
action_56 (40#) = happyShift action_46
action_56 (51#) = happyShift action_47
action_56 (52#) = happyShift action_48
action_56 (53#) = happyShift action_64
action_56 (57#) = happyShift action_49
action_56 (58#) = happyShift action_50
action_56 (59#) = happyShift action_51
action_56 (60#) = happyShift action_52
action_56 (12#) = happyGoto action_63
action_56 (13#) = happyGoto action_38
action_56 (14#) = happyGoto action_39
action_56 (15#) = happyGoto action_40
action_56 (16#) = happyGoto action_41
action_56 (17#) = happyGoto action_42
action_56 (18#) = happyGoto action_43
action_56 x = happyTcHack x happyFail (happyExpListPerState 56)

action_57 x = happyTcHack x happyReduce_10

action_58 x = happyTcHack x happyReduce_8

action_59 x = happyTcHack x happyReduce_7

action_60 x = happyTcHack x happyReduce_5

action_61 (57#) = happyShift action_62
action_61 x = happyTcHack x happyFail (happyExpListPerState 61)

action_62 (53#) = happyShift action_111
action_62 x = happyTcHack x happyFail (happyExpListPerState 62)

action_63 (38#) = happyShift action_109
action_63 (39#) = happyShift action_73
action_63 (40#) = happyShift action_74
action_63 (41#) = happyShift action_75
action_63 (42#) = happyShift action_76
action_63 (43#) = happyShift action_77
action_63 (44#) = happyShift action_78
action_63 (45#) = happyShift action_79
action_63 (46#) = happyShift action_80
action_63 (47#) = happyShift action_81
action_63 (48#) = happyShift action_82
action_63 (49#) = happyShift action_83
action_63 (50#) = happyShift action_84
action_63 (53#) = happyShift action_110
action_63 x = happyTcHack x happyFail (happyExpListPerState 63)

action_64 x = happyTcHack x happyReduce_15

action_65 (34#) = happyShift action_44
action_65 (35#) = happyShift action_45
action_65 (40#) = happyShift action_46
action_65 (51#) = happyShift action_47
action_65 (52#) = happyShift action_48
action_65 (57#) = happyShift action_49
action_65 (58#) = happyShift action_50
action_65 (59#) = happyShift action_51
action_65 (60#) = happyShift action_52
action_65 (12#) = happyGoto action_108
action_65 (13#) = happyGoto action_38
action_65 (14#) = happyGoto action_39
action_65 (15#) = happyGoto action_40
action_65 (16#) = happyGoto action_41
action_65 (17#) = happyGoto action_42
action_65 (18#) = happyGoto action_43
action_65 x = happyTcHack x happyFail (happyExpListPerState 65)

action_66 (39#) = happyShift action_73
action_66 (40#) = happyShift action_74
action_66 (41#) = happyShift action_75
action_66 (42#) = happyShift action_76
action_66 (43#) = happyShift action_77
action_66 (44#) = happyShift action_78
action_66 (45#) = happyShift action_79
action_66 (46#) = happyShift action_80
action_66 (47#) = happyShift action_81
action_66 (48#) = happyShift action_82
action_66 (49#) = happyShift action_83
action_66 (50#) = happyShift action_84
action_66 (53#) = happyShift action_107
action_66 x = happyTcHack x happyFail (happyExpListPerState 66)

action_67 (39#) = happyShift action_73
action_67 (40#) = happyShift action_74
action_67 (41#) = happyShift action_75
action_67 (42#) = happyShift action_76
action_67 (43#) = happyShift action_77
action_67 (44#) = happyShift action_78
action_67 (45#) = happyShift action_79
action_67 (46#) = happyShift action_80
action_67 (47#) = happyShift action_81
action_67 (48#) = happyShift action_82
action_67 (49#) = happyShift action_83
action_67 (50#) = happyShift action_84
action_67 (53#) = happyShift action_106
action_67 x = happyTcHack x happyFail (happyExpListPerState 67)

action_68 (57#) = happyShift action_88
action_68 x = happyTcHack x happyFail (happyExpListPerState 68)

action_69 (39#) = happyShift action_73
action_69 (40#) = happyShift action_74
action_69 (41#) = happyShift action_75
action_69 (42#) = happyShift action_76
action_69 (43#) = happyShift action_77
action_69 (44#) = happyShift action_78
action_69 (45#) = happyShift action_79
action_69 (46#) = happyShift action_80
action_69 (47#) = happyShift action_81
action_69 (48#) = happyShift action_82
action_69 (49#) = happyShift action_83
action_69 (50#) = happyShift action_84
action_69 (53#) = happyShift action_105
action_69 x = happyTcHack x happyFail (happyExpListPerState 69)

action_70 (39#) = happyShift action_73
action_70 (40#) = happyShift action_74
action_70 (41#) = happyShift action_75
action_70 (42#) = happyShift action_76
action_70 (43#) = happyShift action_77
action_70 (44#) = happyShift action_78
action_70 (45#) = happyShift action_79
action_70 (46#) = happyShift action_80
action_70 (47#) = happyShift action_81
action_70 (48#) = happyShift action_82
action_70 x = happyTcHack x happyReduce_36

action_71 (41#) = happyShift action_75
action_71 (42#) = happyShift action_76
action_71 x = happyTcHack x happyReduce_33

action_72 (34#) = happyShift action_44
action_72 (35#) = happyShift action_45
action_72 (40#) = happyShift action_46
action_72 (51#) = happyShift action_47
action_72 (52#) = happyShift action_48
action_72 (53#) = happyShift action_104
action_72 (57#) = happyShift action_49
action_72 (58#) = happyShift action_50
action_72 (59#) = happyShift action_51
action_72 (60#) = happyShift action_52
action_72 (12#) = happyGoto action_103
action_72 (13#) = happyGoto action_38
action_72 (14#) = happyGoto action_39
action_72 (15#) = happyGoto action_40
action_72 (16#) = happyGoto action_41
action_72 (17#) = happyGoto action_42
action_72 (18#) = happyGoto action_43
action_72 x = happyTcHack x happyFail (happyExpListPerState 72)

action_73 (34#) = happyShift action_44
action_73 (35#) = happyShift action_45
action_73 (40#) = happyShift action_46
action_73 (51#) = happyShift action_47
action_73 (52#) = happyShift action_48
action_73 (57#) = happyShift action_49
action_73 (58#) = happyShift action_50
action_73 (59#) = happyShift action_51
action_73 (60#) = happyShift action_52
action_73 (12#) = happyGoto action_102
action_73 (13#) = happyGoto action_38
action_73 (14#) = happyGoto action_39
action_73 (15#) = happyGoto action_40
action_73 (16#) = happyGoto action_41
action_73 (17#) = happyGoto action_42
action_73 (18#) = happyGoto action_43
action_73 x = happyTcHack x happyFail (happyExpListPerState 73)

action_74 (34#) = happyShift action_44
action_74 (35#) = happyShift action_45
action_74 (40#) = happyShift action_46
action_74 (51#) = happyShift action_47
action_74 (52#) = happyShift action_48
action_74 (57#) = happyShift action_49
action_74 (58#) = happyShift action_50
action_74 (59#) = happyShift action_51
action_74 (60#) = happyShift action_52
action_74 (12#) = happyGoto action_101
action_74 (13#) = happyGoto action_38
action_74 (14#) = happyGoto action_39
action_74 (15#) = happyGoto action_40
action_74 (16#) = happyGoto action_41
action_74 (17#) = happyGoto action_42
action_74 (18#) = happyGoto action_43
action_74 x = happyTcHack x happyFail (happyExpListPerState 74)

action_75 (34#) = happyShift action_44
action_75 (35#) = happyShift action_45
action_75 (40#) = happyShift action_46
action_75 (51#) = happyShift action_47
action_75 (52#) = happyShift action_48
action_75 (57#) = happyShift action_49
action_75 (58#) = happyShift action_50
action_75 (59#) = happyShift action_51
action_75 (60#) = happyShift action_52
action_75 (12#) = happyGoto action_100
action_75 (13#) = happyGoto action_38
action_75 (14#) = happyGoto action_39
action_75 (15#) = happyGoto action_40
action_75 (16#) = happyGoto action_41
action_75 (17#) = happyGoto action_42
action_75 (18#) = happyGoto action_43
action_75 x = happyTcHack x happyFail (happyExpListPerState 75)

action_76 (34#) = happyShift action_44
action_76 (35#) = happyShift action_45
action_76 (40#) = happyShift action_46
action_76 (51#) = happyShift action_47
action_76 (52#) = happyShift action_48
action_76 (57#) = happyShift action_49
action_76 (58#) = happyShift action_50
action_76 (59#) = happyShift action_51
action_76 (60#) = happyShift action_52
action_76 (12#) = happyGoto action_99
action_76 (13#) = happyGoto action_38
action_76 (14#) = happyGoto action_39
action_76 (15#) = happyGoto action_40
action_76 (16#) = happyGoto action_41
action_76 (17#) = happyGoto action_42
action_76 (18#) = happyGoto action_43
action_76 x = happyTcHack x happyFail (happyExpListPerState 76)

action_77 (34#) = happyShift action_44
action_77 (35#) = happyShift action_45
action_77 (40#) = happyShift action_46
action_77 (51#) = happyShift action_47
action_77 (52#) = happyShift action_48
action_77 (57#) = happyShift action_49
action_77 (58#) = happyShift action_50
action_77 (59#) = happyShift action_51
action_77 (60#) = happyShift action_52
action_77 (12#) = happyGoto action_98
action_77 (13#) = happyGoto action_38
action_77 (14#) = happyGoto action_39
action_77 (15#) = happyGoto action_40
action_77 (16#) = happyGoto action_41
action_77 (17#) = happyGoto action_42
action_77 (18#) = happyGoto action_43
action_77 x = happyTcHack x happyFail (happyExpListPerState 77)

action_78 (34#) = happyShift action_44
action_78 (35#) = happyShift action_45
action_78 (40#) = happyShift action_46
action_78 (51#) = happyShift action_47
action_78 (52#) = happyShift action_48
action_78 (57#) = happyShift action_49
action_78 (58#) = happyShift action_50
action_78 (59#) = happyShift action_51
action_78 (60#) = happyShift action_52
action_78 (12#) = happyGoto action_97
action_78 (13#) = happyGoto action_38
action_78 (14#) = happyGoto action_39
action_78 (15#) = happyGoto action_40
action_78 (16#) = happyGoto action_41
action_78 (17#) = happyGoto action_42
action_78 (18#) = happyGoto action_43
action_78 x = happyTcHack x happyFail (happyExpListPerState 78)

action_79 (34#) = happyShift action_44
action_79 (35#) = happyShift action_45
action_79 (40#) = happyShift action_46
action_79 (51#) = happyShift action_47
action_79 (52#) = happyShift action_48
action_79 (57#) = happyShift action_49
action_79 (58#) = happyShift action_50
action_79 (59#) = happyShift action_51
action_79 (60#) = happyShift action_52
action_79 (12#) = happyGoto action_96
action_79 (13#) = happyGoto action_38
action_79 (14#) = happyGoto action_39
action_79 (15#) = happyGoto action_40
action_79 (16#) = happyGoto action_41
action_79 (17#) = happyGoto action_42
action_79 (18#) = happyGoto action_43
action_79 x = happyTcHack x happyFail (happyExpListPerState 79)

action_80 (34#) = happyShift action_44
action_80 (35#) = happyShift action_45
action_80 (40#) = happyShift action_46
action_80 (51#) = happyShift action_47
action_80 (52#) = happyShift action_48
action_80 (57#) = happyShift action_49
action_80 (58#) = happyShift action_50
action_80 (59#) = happyShift action_51
action_80 (60#) = happyShift action_52
action_80 (12#) = happyGoto action_95
action_80 (13#) = happyGoto action_38
action_80 (14#) = happyGoto action_39
action_80 (15#) = happyGoto action_40
action_80 (16#) = happyGoto action_41
action_80 (17#) = happyGoto action_42
action_80 (18#) = happyGoto action_43
action_80 x = happyTcHack x happyFail (happyExpListPerState 80)

action_81 (34#) = happyShift action_44
action_81 (35#) = happyShift action_45
action_81 (40#) = happyShift action_46
action_81 (51#) = happyShift action_47
action_81 (52#) = happyShift action_48
action_81 (57#) = happyShift action_49
action_81 (58#) = happyShift action_50
action_81 (59#) = happyShift action_51
action_81 (60#) = happyShift action_52
action_81 (12#) = happyGoto action_94
action_81 (13#) = happyGoto action_38
action_81 (14#) = happyGoto action_39
action_81 (15#) = happyGoto action_40
action_81 (16#) = happyGoto action_41
action_81 (17#) = happyGoto action_42
action_81 (18#) = happyGoto action_43
action_81 x = happyTcHack x happyFail (happyExpListPerState 81)

action_82 (34#) = happyShift action_44
action_82 (35#) = happyShift action_45
action_82 (40#) = happyShift action_46
action_82 (51#) = happyShift action_47
action_82 (52#) = happyShift action_48
action_82 (57#) = happyShift action_49
action_82 (58#) = happyShift action_50
action_82 (59#) = happyShift action_51
action_82 (60#) = happyShift action_52
action_82 (12#) = happyGoto action_93
action_82 (13#) = happyGoto action_38
action_82 (14#) = happyGoto action_39
action_82 (15#) = happyGoto action_40
action_82 (16#) = happyGoto action_41
action_82 (17#) = happyGoto action_42
action_82 (18#) = happyGoto action_43
action_82 x = happyTcHack x happyFail (happyExpListPerState 82)

action_83 (34#) = happyShift action_44
action_83 (35#) = happyShift action_45
action_83 (40#) = happyShift action_46
action_83 (51#) = happyShift action_47
action_83 (52#) = happyShift action_48
action_83 (57#) = happyShift action_49
action_83 (58#) = happyShift action_50
action_83 (59#) = happyShift action_51
action_83 (60#) = happyShift action_52
action_83 (12#) = happyGoto action_92
action_83 (13#) = happyGoto action_38
action_83 (14#) = happyGoto action_39
action_83 (15#) = happyGoto action_40
action_83 (16#) = happyGoto action_41
action_83 (17#) = happyGoto action_42
action_83 (18#) = happyGoto action_43
action_83 x = happyTcHack x happyFail (happyExpListPerState 83)

action_84 (34#) = happyShift action_44
action_84 (35#) = happyShift action_45
action_84 (40#) = happyShift action_46
action_84 (51#) = happyShift action_47
action_84 (52#) = happyShift action_48
action_84 (57#) = happyShift action_49
action_84 (58#) = happyShift action_50
action_84 (59#) = happyShift action_51
action_84 (60#) = happyShift action_52
action_84 (12#) = happyGoto action_91
action_84 (13#) = happyGoto action_38
action_84 (14#) = happyGoto action_39
action_84 (15#) = happyGoto action_40
action_84 (16#) = happyGoto action_41
action_84 (17#) = happyGoto action_42
action_84 (18#) = happyGoto action_43
action_84 x = happyTcHack x happyFail (happyExpListPerState 84)

action_85 (39#) = happyShift action_73
action_85 (40#) = happyShift action_74
action_85 (41#) = happyShift action_75
action_85 (42#) = happyShift action_76
action_85 (43#) = happyShift action_77
action_85 (44#) = happyShift action_78
action_85 (45#) = happyShift action_79
action_85 (46#) = happyShift action_80
action_85 (47#) = happyShift action_81
action_85 (48#) = happyShift action_82
action_85 (49#) = happyShift action_83
action_85 (50#) = happyShift action_84
action_85 x = happyTcHack x happyReduce_13

action_86 (27#) = happyShift action_90
action_86 x = happyTcHack x happyFail (happyExpListPerState 86)

action_87 (28#) = happyShift action_89
action_87 x = happyTcHack x happyFail (happyExpListPerState 87)

action_88 x = happyTcHack x happyReduce_44

action_89 (34#) = happyShift action_44
action_89 (35#) = happyShift action_45
action_89 (40#) = happyShift action_46
action_89 (51#) = happyShift action_47
action_89 (52#) = happyShift action_48
action_89 (57#) = happyShift action_49
action_89 (58#) = happyShift action_50
action_89 (59#) = happyShift action_51
action_89 (60#) = happyShift action_52
action_89 (12#) = happyGoto action_119
action_89 (13#) = happyGoto action_38
action_89 (14#) = happyGoto action_39
action_89 (15#) = happyGoto action_40
action_89 (16#) = happyGoto action_41
action_89 (17#) = happyGoto action_42
action_89 (18#) = happyGoto action_43
action_89 x = happyTcHack x happyFail (happyExpListPerState 89)

action_90 (34#) = happyShift action_44
action_90 (35#) = happyShift action_45
action_90 (40#) = happyShift action_46
action_90 (51#) = happyShift action_47
action_90 (52#) = happyShift action_48
action_90 (57#) = happyShift action_49
action_90 (58#) = happyShift action_50
action_90 (59#) = happyShift action_51
action_90 (60#) = happyShift action_52
action_90 (12#) = happyGoto action_118
action_90 (13#) = happyGoto action_38
action_90 (14#) = happyGoto action_39
action_90 (15#) = happyGoto action_40
action_90 (16#) = happyGoto action_41
action_90 (17#) = happyGoto action_42
action_90 (18#) = happyGoto action_43
action_90 x = happyTcHack x happyFail (happyExpListPerState 90)

action_91 (39#) = happyShift action_73
action_91 (40#) = happyShift action_74
action_91 (41#) = happyShift action_75
action_91 (42#) = happyShift action_76
action_91 (43#) = happyShift action_77
action_91 (44#) = happyShift action_78
action_91 (45#) = happyShift action_79
action_91 (46#) = happyShift action_80
action_91 (47#) = happyShift action_81
action_91 (48#) = happyShift action_82
action_91 (49#) = happyShift action_83
action_91 x = happyTcHack x happyReduce_35

action_92 (39#) = happyShift action_73
action_92 (40#) = happyShift action_74
action_92 (41#) = happyShift action_75
action_92 (42#) = happyShift action_76
action_92 (43#) = happyShift action_77
action_92 (44#) = happyShift action_78
action_92 (45#) = happyShift action_79
action_92 (46#) = happyShift action_80
action_92 (47#) = happyShift action_81
action_92 (48#) = happyShift action_82
action_92 x = happyTcHack x happyReduce_34

action_93 (39#) = happyShift action_73
action_93 (40#) = happyShift action_74
action_93 (41#) = happyShift action_75
action_93 (42#) = happyShift action_76
action_93 (43#) = happyFail []
action_93 (44#) = happyFail []
action_93 (45#) = happyFail []
action_93 (46#) = happyFail []
action_93 (47#) = happyFail []
action_93 (48#) = happyFail []
action_93 x = happyTcHack x happyReduce_32

action_94 (39#) = happyShift action_73
action_94 (40#) = happyShift action_74
action_94 (41#) = happyShift action_75
action_94 (42#) = happyShift action_76
action_94 (43#) = happyFail []
action_94 (44#) = happyFail []
action_94 (45#) = happyFail []
action_94 (46#) = happyFail []
action_94 (47#) = happyFail []
action_94 (48#) = happyFail []
action_94 x = happyTcHack x happyReduce_31

action_95 (39#) = happyShift action_73
action_95 (40#) = happyShift action_74
action_95 (41#) = happyShift action_75
action_95 (42#) = happyShift action_76
action_95 (43#) = happyFail []
action_95 (44#) = happyFail []
action_95 (45#) = happyFail []
action_95 (46#) = happyFail []
action_95 (47#) = happyFail []
action_95 (48#) = happyFail []
action_95 x = happyTcHack x happyReduce_30

action_96 (39#) = happyShift action_73
action_96 (40#) = happyShift action_74
action_96 (41#) = happyShift action_75
action_96 (42#) = happyShift action_76
action_96 (43#) = happyFail []
action_96 (44#) = happyFail []
action_96 (45#) = happyFail []
action_96 (46#) = happyFail []
action_96 (47#) = happyFail []
action_96 (48#) = happyFail []
action_96 x = happyTcHack x happyReduce_29

action_97 (39#) = happyShift action_73
action_97 (40#) = happyShift action_74
action_97 (41#) = happyShift action_75
action_97 (42#) = happyShift action_76
action_97 (43#) = happyFail []
action_97 (44#) = happyFail []
action_97 (45#) = happyFail []
action_97 (46#) = happyFail []
action_97 (47#) = happyFail []
action_97 (48#) = happyFail []
action_97 x = happyTcHack x happyReduce_28

action_98 (39#) = happyShift action_73
action_98 (40#) = happyShift action_74
action_98 (41#) = happyShift action_75
action_98 (42#) = happyShift action_76
action_98 (43#) = happyFail []
action_98 (44#) = happyFail []
action_98 (45#) = happyFail []
action_98 (46#) = happyFail []
action_98 (47#) = happyFail []
action_98 (48#) = happyFail []
action_98 x = happyTcHack x happyReduce_27

action_99 x = happyTcHack x happyReduce_26

action_100 x = happyTcHack x happyReduce_25

action_101 (41#) = happyShift action_75
action_101 (42#) = happyShift action_76
action_101 x = happyTcHack x happyReduce_24

action_102 (41#) = happyShift action_75
action_102 (42#) = happyShift action_76
action_102 x = happyTcHack x happyReduce_23

action_103 (38#) = happyShift action_116
action_103 (39#) = happyShift action_73
action_103 (40#) = happyShift action_74
action_103 (41#) = happyShift action_75
action_103 (42#) = happyShift action_76
action_103 (43#) = happyShift action_77
action_103 (44#) = happyShift action_78
action_103 (45#) = happyShift action_79
action_103 (46#) = happyShift action_80
action_103 (47#) = happyShift action_81
action_103 (48#) = happyShift action_82
action_103 (49#) = happyShift action_83
action_103 (50#) = happyShift action_84
action_103 (53#) = happyShift action_117
action_103 x = happyTcHack x happyFail (happyExpListPerState 103)

action_104 x = happyTcHack x happyReduce_39

action_105 x = happyTcHack x happyReduce_37

action_106 (54#) = happyShift action_21
action_106 (7#) = happyGoto action_115
action_106 x = happyTcHack x happyFail (happyExpListPerState 106)

action_107 (54#) = happyShift action_21
action_107 (7#) = happyGoto action_114
action_107 x = happyTcHack x happyFail (happyExpListPerState 107)

action_108 (39#) = happyShift action_73
action_108 (40#) = happyShift action_74
action_108 (41#) = happyShift action_75
action_108 (42#) = happyShift action_76
action_108 (43#) = happyShift action_77
action_108 (44#) = happyShift action_78
action_108 (45#) = happyShift action_79
action_108 (46#) = happyShift action_80
action_108 (47#) = happyShift action_81
action_108 (48#) = happyShift action_82
action_108 (49#) = happyShift action_83
action_108 (50#) = happyShift action_84
action_108 x = happyTcHack x happyReduce_12

action_109 (34#) = happyShift action_44
action_109 (35#) = happyShift action_45
action_109 (40#) = happyShift action_46
action_109 (51#) = happyShift action_47
action_109 (52#) = happyShift action_48
action_109 (57#) = happyShift action_49
action_109 (58#) = happyShift action_50
action_109 (59#) = happyShift action_51
action_109 (60#) = happyShift action_52
action_109 (12#) = happyGoto action_113
action_109 (13#) = happyGoto action_38
action_109 (14#) = happyGoto action_39
action_109 (15#) = happyGoto action_40
action_109 (16#) = happyGoto action_41
action_109 (17#) = happyGoto action_42
action_109 (18#) = happyGoto action_43
action_109 x = happyTcHack x happyFail (happyExpListPerState 109)

action_110 x = happyTcHack x happyReduce_16

action_111 (54#) = happyShift action_21
action_111 (7#) = happyGoto action_112
action_111 x = happyTcHack x happyFail (happyExpListPerState 111)

action_112 x = happyTcHack x happyReduce_6

action_113 (39#) = happyShift action_73
action_113 (40#) = happyShift action_74
action_113 (41#) = happyShift action_75
action_113 (42#) = happyShift action_76
action_113 (43#) = happyShift action_77
action_113 (44#) = happyShift action_78
action_113 (45#) = happyShift action_79
action_113 (46#) = happyShift action_80
action_113 (47#) = happyShift action_81
action_113 (48#) = happyShift action_82
action_113 (49#) = happyShift action_83
action_113 (50#) = happyShift action_84
action_113 (53#) = happyShift action_122
action_113 x = happyTcHack x happyFail (happyExpListPerState 113)

action_114 x = happyTcHack x happyReduce_20

action_115 (23#) = happyShift action_121
action_115 x = happyTcHack x happyReduce_21

action_116 (34#) = happyShift action_44
action_116 (35#) = happyShift action_45
action_116 (40#) = happyShift action_46
action_116 (51#) = happyShift action_47
action_116 (52#) = happyShift action_48
action_116 (57#) = happyShift action_49
action_116 (58#) = happyShift action_50
action_116 (59#) = happyShift action_51
action_116 (60#) = happyShift action_52
action_116 (12#) = happyGoto action_120
action_116 (13#) = happyGoto action_38
action_116 (14#) = happyGoto action_39
action_116 (15#) = happyGoto action_40
action_116 (16#) = happyGoto action_41
action_116 (17#) = happyGoto action_42
action_116 (18#) = happyGoto action_43
action_116 x = happyTcHack x happyFail (happyExpListPerState 116)

action_117 x = happyTcHack x happyReduce_40

action_118 (39#) = happyShift action_73
action_118 (40#) = happyShift action_74
action_118 (41#) = happyShift action_75
action_118 (42#) = happyShift action_76
action_118 (43#) = happyShift action_77
action_118 (44#) = happyShift action_78
action_118 (45#) = happyShift action_79
action_118 (46#) = happyShift action_80
action_118 (47#) = happyShift action_81
action_118 (48#) = happyShift action_82
action_118 (49#) = happyShift action_83
action_118 (50#) = happyShift action_84
action_118 x = happyTcHack x happyReduce_18

action_119 (39#) = happyShift action_73
action_119 (40#) = happyShift action_74
action_119 (41#) = happyShift action_75
action_119 (42#) = happyShift action_76
action_119 (43#) = happyShift action_77
action_119 (44#) = happyShift action_78
action_119 (45#) = happyShift action_79
action_119 (46#) = happyShift action_80
action_119 (47#) = happyShift action_81
action_119 (48#) = happyShift action_82
action_119 (49#) = happyShift action_83
action_119 (50#) = happyShift action_84
action_119 x = happyTcHack x happyReduce_19

action_120 (39#) = happyShift action_73
action_120 (40#) = happyShift action_74
action_120 (41#) = happyShift action_75
action_120 (42#) = happyShift action_76
action_120 (43#) = happyShift action_77
action_120 (44#) = happyShift action_78
action_120 (45#) = happyShift action_79
action_120 (46#) = happyShift action_80
action_120 (47#) = happyShift action_81
action_120 (48#) = happyShift action_82
action_120 (49#) = happyShift action_83
action_120 (50#) = happyShift action_84
action_120 (53#) = happyShift action_124
action_120 x = happyTcHack x happyFail (happyExpListPerState 120)

action_121 (54#) = happyShift action_21
action_121 (7#) = happyGoto action_123
action_121 x = happyTcHack x happyFail (happyExpListPerState 121)

action_122 x = happyTcHack x happyReduce_17

action_123 x = happyTcHack x happyReduce_22

action_124 x = happyTcHack x happyReduce_41

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
	(HappyAbsSyn19  happy_var_1) `HappyStk`
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
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	(HappyAbsSyn19  happy_var_1) `HappyStk`
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
	(HappyAbsSyn20  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_5)) `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	(HappyAbsSyn19  happy_var_1) `HappyStk`
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
happyReduce_11 = happySpecReduce_1  9# happyReduction_11
happyReduction_11 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_12 = happyReduce 4# 10# happyReduction_12
happyReduction_12 ((HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName happy_var_2)) `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (AssignStmt happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_13 = happySpecReduce_3  10# happyReduction_13
happyReduction_13 (HappyAbsSyn12  happy_var_3)
	_
	(HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn10
		 (AssignStmtWithoutType happy_var_1 happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_14 = happySpecReduce_2  10# happyReduction_14
happyReduction_14 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (ReturnStmt happy_var_2
	)
happyReduction_14 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_15 = happySpecReduce_3  10# happyReduction_15
happyReduction_15 _
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn10
		 (Fun0Stmt happy_var_1
	)
happyReduction_15 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_16 = happyReduce 4# 10# happyReduction_16
happyReduction_16 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Fun1Stmt happy_var_1 happy_var_3
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_17 = happyReduce 6# 10# happyReduction_17
happyReduction_17 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Fun2Stmt happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_18 = happyReduce 5# 10# happyReduction_18
happyReduction_18 ((HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (ReadStmt happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_19 = happyReduce 5# 10# happyReduction_19
happyReduction_19 ((HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (WriteStmt happy_var_5
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
		 (WhileStmt happy_var_3 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_21 = happyReduce 5# 11# happyReduction_21
happyReduction_21 ((HappyAbsSyn7  happy_var_5) `HappyStk`
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
happyReduce_22 = happyReduce 7# 11# happyReduction_22
happyReduction_22 ((HappyAbsSyn7  happy_var_7) `HappyStk`
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
happyReduce_23 = happySpecReduce_3  12# happyReduction_23
happyReduction_23 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprPlus happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_24 = happySpecReduce_3  12# happyReduction_24
happyReduction_24 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprMinus happy_var_1 happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_25 = happySpecReduce_3  12# happyReduction_25
happyReduction_25 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprMul happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_26 = happySpecReduce_3  12# happyReduction_26
happyReduction_26 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprDiv happy_var_1 happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_27 = happySpecReduce_3  12# happyReduction_27
happyReduction_27 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprEq happy_var_1 happy_var_3
	)
happyReduction_27 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_28 = happySpecReduce_3  12# happyReduction_28
happyReduction_28 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprNeq happy_var_1 happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_29 = happySpecReduce_3  12# happyReduction_29
happyReduction_29 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprGE happy_var_1 happy_var_3
	)
happyReduction_29 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_30 = happySpecReduce_3  12# happyReduction_30
happyReduction_30 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprLE happy_var_1 happy_var_3
	)
happyReduction_30 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_31 = happySpecReduce_3  12# happyReduction_31
happyReduction_31 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprGT happy_var_1 happy_var_3
	)
happyReduction_31 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_32 = happySpecReduce_3  12# happyReduction_32
happyReduction_32 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprLT happy_var_1 happy_var_3
	)
happyReduction_32 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_33 = happySpecReduce_2  12# happyReduction_33
happyReduction_33 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (ExprNeg happy_var_2
	)
happyReduction_33 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_34 = happySpecReduce_3  12# happyReduction_34
happyReduction_34 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprAnd happy_var_1 happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_35 = happySpecReduce_3  12# happyReduction_35
happyReduction_35 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprOr happy_var_1 happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_36 = happySpecReduce_2  12# happyReduction_36
happyReduction_36 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (ExprNot happy_var_2
	)
happyReduction_36 _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_37 = happySpecReduce_3  12# happyReduction_37
happyReduction_37 _
	(HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (ExprBracketed happy_var_2
	)
happyReduction_37 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_38 = happySpecReduce_1  12# happyReduction_38
happyReduction_38 (HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn12
		 (ExprVar happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_39 = happySpecReduce_3  12# happyReduction_39
happyReduction_39 _
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprFun0 happy_var_1
	)
happyReduction_39 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_40 = happyReduce 4# 12# happyReduction_40
happyReduction_40 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (ExprFun1 happy_var_1 happy_var_3
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_41 = happyReduce 6# 12# happyReduction_41
happyReduction_41 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (ExprFun2 happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_42 = happySpecReduce_1  12# happyReduction_42
happyReduction_42 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (ExprVal happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_43 = happySpecReduce_1  13# happyReduction_43
happyReduction_43 (HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn13
		 (("", happy_var_1)
	)
happyReduction_43 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_44 = happySpecReduce_3  13# happyReduction_44
happyReduction_44 (HappyTerminal (TName happy_var_3))
	_
	(HappyTerminal (TName happy_var_1))
	 =  HappyAbsSyn13
		 ((happy_var_1, happy_var_3)
	)
happyReduction_44 _ _ _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_45 = happySpecReduce_1  14# happyReduction_45
happyReduction_45 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_45 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_46 = happySpecReduce_1  14# happyReduction_46
happyReduction_46 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_47 = happySpecReduce_1  14# happyReduction_47
happyReduction_47 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_48 = happySpecReduce_1  14# happyReduction_48
happyReduction_48 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_49 = happySpecReduce_1  15# happyReduction_49
happyReduction_49 _
	 =  HappyAbsSyn15
		 (BoolValue True
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_50 = happySpecReduce_1  15# happyReduction_50
happyReduction_50 _
	 =  HappyAbsSyn15
		 (BoolValue False
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_51 = happySpecReduce_1  16# happyReduction_51
happyReduction_51 (HappyTerminal (TInt happy_var_1))
	 =  HappyAbsSyn16
		 (IntValue happy_var_1
	)
happyReduction_51 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_52 = happySpecReduce_1  17# happyReduction_52
happyReduction_52 (HappyTerminal (TDouble happy_var_1))
	 =  HappyAbsSyn17
		 (DoubleValue happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_53 = happySpecReduce_1  18# happyReduction_53
happyReduction_53 (HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn18
		 (StringValue happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_54 = happySpecReduce_1  19# happyReduction_54
happyReduction_54 _
	 =  HappyAbsSyn19
		 (FIntType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_55 = happySpecReduce_1  19# happyReduction_55
happyReduction_55 _
	 =  HappyAbsSyn19
		 (FDoubleType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_56 = happySpecReduce_1  19# happyReduction_56
happyReduction_56 _
	 =  HappyAbsSyn19
		 (FBoolType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_57 = happySpecReduce_1  19# happyReduction_57
happyReduction_57 _
	 =  HappyAbsSyn19
		 (FStringType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_58 = happySpecReduce_1  19# happyReduction_58
happyReduction_58 _
	 =  HappyAbsSyn19
		 (VoidType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_59 = happySpecReduce_1  20# happyReduction_59
happyReduction_59 _
	 =  HappyAbsSyn20
		 (IntType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_60 = happySpecReduce_1  20# happyReduction_60
happyReduction_60 _
	 =  HappyAbsSyn20
		 (DoubleType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_61 = happySpecReduce_1  20# happyReduction_61
happyReduction_61 _
	 =  HappyAbsSyn20
		 (BoolType
	)

#if __GLASGOW_HASKELL__ >= 710
#endif
happyReduce_62 = happySpecReduce_1  20# happyReduction_62
happyReduction_62 _
	 =  HappyAbsSyn20
		 (StringType
	)

happyNewToken action sts stk [] =
	action 61# 61# notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TWhile -> cont 21#;
	TIf -> cont 22#;
	TElse -> cont 23#;
	TReturn -> cont 24#;
	TCin -> cont 25#;
	TCout -> cont 26#;
	TRShift -> cont 27#;
	TLShift -> cont 28#;
	TIntType -> cont 29#;
	TDoubleType -> cont 30#;
	TBoolType -> cont 31#;
	TStringType -> cont 32#;
	TVoidType -> cont 33#;
	TTrue -> cont 34#;
	TFalse -> cont 35#;
	TDColon -> cont 36#;
	TSemi -> cont 37#;
	TComma -> cont 38#;
	TPlus -> cont 39#;
	TMinus -> cont 40#;
	TMul -> cont 41#;
	TDiv -> cont 42#;
	TEq -> cont 43#;
	TNEq -> cont 44#;
	TGE -> cont 45#;
	TLE -> cont 46#;
	TG -> cont 47#;
	TL -> cont 48#;
	TAnd -> cont 49#;
	TOr -> cont 50#;
	TNot -> cont 51#;
	TLPar -> cont 52#;
	TRPar -> cont 53#;
	TLBr -> cont 54#;
	TRBr -> cont 55#;
	TAssign -> cont 56#;
	TName happy_dollar_dollar -> cont 57#;
	TInt happy_dollar_dollar -> cont 58#;
	TDouble happy_dollar_dollar -> cont 59#;
	TString happy_dollar_dollar -> cont 60#;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 61# tk tks = happyError' (tks, explist)
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

