create or replace package body dbms_transaction wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
95a425ff
1
4
0 
4f
7 PACKAGE:
4 BODY:
10 DBMS_TRANSACTION:
b EXECUTE_SQL:
d COORD_SESS_OK:
e BINARY_INTEGER:
8 FORMS_OK:
a TRIGGER_OK:
c PROCEDURE_OK:
4 STMT:
8 VARCHAR2:
a ERROR_HINT:
6 PRAGMA:
9 INTERFACE:
1 C:
8 FUNCTION:
8 LTID_ICD:
a CREATE_TXN:
6 RETURN:
8 STEP_ICD:
6 NUMBER:
c COMMIT_FORCE:
3 XID:
3 SCN:
7 IS NULL:
1 0:
1 1:
e commit force ':
2 ||:
1 ':
6 COMMIT:
3 ' ':
e ROLLBACK_FORCE:
10 rollback force ':
8 ROLLBACK:
d ADVISE_COMMIT:
1b alter session advise commit:
d ADVISE COMMIT:
f ADVISE_ROLLBACK:
1d alter session advise rollback:
f ADVISE ROLLBACK:
e ADVISE_NOTHING:
1c alter session advise nothing:
e ADVISE NOTHING:
e COMMIT_COMMENT:
4 CMNT:
f commit comment :
9 READ_ONLY:
19 set transaction read only:
f SET TRANSACTION:
a READ_WRITE:
1a set transaction read write:
14 USE_ROLLBACK_SEGMENT:
7 RB_NAME:
25 set transaction use rollback segment :
b PURGE_MIXED:
15 TRANSACTION_NOT_FOUND:
6 SYSTEM:
3 SYS:
e PENDING_TRANS$:
6 STATUS:
1 =:
1 D:
d LOCAL_TRAN_ID:
8 ROWCOUNT:
11 PENDING_SESSIONS$:
15 PENDING_SUB_SESSIONS$:
5 RAISE:
13 PURGE_LOST_DB_ENTRY:
5 STATE:
a collecting:
9 committed:
d forced commit:
f forced rollback:
14 LOCAL_TRANSACTION_ID:
12 CREATE_TRANSACTION:
7 BOOLEAN:
5 FALSE:
7 STEP_ID:
0

0
0
22d
2
0 a0 1d a0 97 9a 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d 8f a0 b0 3d b4 55
6a :4 a0 b4 5d a0 8d 8f a0
b0 3d b4 :2 a0 2c 6a :4 a0 b4
5d a0 8d a0 b4 a0 2c 6a
:4 a0 b4 5d 9a 8f a0 b0 3d
8f a0 4d b0 3d b4 55 6a
a0 7e b4 2e a0 :4 51 6e 7e
a0 b4 2e 7e 6e b4 2e 6e
a5 57 b7 a0 :4 51 6e 7e a0
b4 2e 7e 6e b4 2e 7e a0
b4 2e 7e 6e b4 2e 6e a5
57 b7 :2 19 3c b7 a4 b1 11
68 4f 9a 8f a0 b0 3d b4
55 6a a0 :4 51 6e 7e a0 b4
2e 7e 6e b4 2e 6e a5 57
b7 a4 b1 11 68 4f 9a b4
55 6a a0 :4 51 :2 6e a5 57 b7
a4 b1 11 68 4f 9a b4 55
6a a0 :4 51 :2 6e a5 57 b7 a4
b1 11 68 4f 9a b4 55 6a
a0 :4 51 :2 6e a5 57 b7 a4 b1
11 68 4f 9a 8f a0 b0 3d
b4 55 6a a0 :4 51 6e 7e 6e
b4 2e 7e a0 b4 2e 7e 6e
b4 2e 6e a5 57 b7 a4 b1
11 68 4f 9a b4 55 6a a0
:4 51 :2 6e a5 57 b7 a4 b1 11
68 4f 9a b4 55 6a a0 :4 51
:2 6e a5 57 b7 a4 b1 11 68
4f 9a 8f a0 b0 3d b4 55
6a a0 :4 51 6e 7e a0 b4 2e
6e a5 57 b7 a4 b1 11 68
4f 9a 8f a0 b0 3d b4 8b
55 6a b0 2a a0 6e a5 57
:2 a0 6b a0 7e 6e b4 2e :2 a0
7e b4 2e a 10 cd e9 a0
f 7e 51 b4 2e :2 a0 6b :2 a0
7e b4 2e cd e9 :2 a0 6b :2 a0
7e b4 2e cd e9 b7 :2 a0 62
b7 :2 19 3c b7 a4 b1 11 68
4f 9a 8f a0 b0 3d b4 8b
55 6a b0 2a a0 6e a5 57
:2 a0 6b a0 7e 6e b4 2e a0
7e 6e b4 2e 52 10 a0 7e
6e b4 2e 52 10 a0 7e 6e
b4 2e 52 10 5a :2 a0 7e b4
2e a 10 cd e9 a0 f 7e
51 b4 2e :2 a0 6b :2 a0 7e b4
2e cd e9 :2 a0 6b :2 a0 7e b4
2e cd e9 b7 :2 a0 62 b7 :2 19
3c b7 a4 b1 11 68 4f a0
8d 8f :2 a0 b0 3d b4 :2 a0 2c
6a :3 a0 51 a5 b 5a 65 b7
:2 a0 51 a5 b 5a 65 b7 :2 19
3c b7 a4 b1 11 68 4f a0
8d a0 b4 a0 2c 6a :2 a0 5a
65 b7 a4 b1 11 68 4f b1
b7 a4 11 b1 56 4f 17 b5 
22d
2
0 3 7 8 c 14 29 25
24 30 3d 39 23 44 4d 49
38 54 61 5d 37 68 71 6d
5c 78 85 81 5b 8c 80 91
95 99 9d a1 a5 7f a9 ac
b0 c5 c1 c0 cc bf d1 d5
d9 dd e1 e5 e9 ed f1 f2
f5 f9 106 10a 10b 10f 113 117
11b 11f 123 127 128 12b 140 13c
13b 147 154 150 1 13a 15b 14f
160 164 168 14c 16c 16d 172 176
179 17c 17f 182 186 189 18d 18e
193 196 19a 19b 1a0 1a4 1a5 138
1aa 1ae 1b1 1b4 1b7 1ba 1be 1c1
1c5 1c6 1cb 1ce 1d2 1d3 1d8 1db
1df 1e0 1e5 1e8 1ec 1ed 1f2 1f6
1f7 bd 1fc 200 204 7d 207 59
20b 216 35 21a 22f 22b 22a 236
229 23b 23f 243 247 24a 24d 250
253 257 25a 25e 25f 264 267 26b
26c 271 275 276 227 27b 21 27f
28a 28e 290 29d 29e 2a2 2a6 2aa
2ad 2b0 2b3 2b6 2ba 2be 2bf 2c4
2c6 2ca 2cc 2d7 2db 2dd 2ea 2eb
2ef 2f3 2f7 2fa 2fd 300 303 307
30b 30c 311 313 317 319 324 328
32a 337 338 33c 340 344 347 34a
34d 350 354 358 359 35e 360 364
366 371 375 377 38c 388 387 393
386 398 39c 3a0 3a4 3a7 3aa 3ad
3b0 3b4 3b7 3bb 3bc 3c1 3c4 3c8
3c9 3ce 3d1 3d5 3d6 3db 3df 3e0
384 3e5 3e9 3eb 3f6 3fa 3fc 409
40a 40e 412 416 419 41c 41f 422
426 42a 42b 430 432 436 438 443
447 449 456 457 45b 45f 463 466
469 46c 46f 473 477 478 47d 47f
483 485 490 494 496 4ab 4a7 4a6
4b2 4a5 4b7 4bb 4bf 4c3 4c6 4c9
4cc 4cf 4d3 4d6 4da 4db 4e0 4e4
4e5 4a3 4ea 4ee 4f0 4fb 4ff 501
516 512 511 51d 510 52e 526 52a
525 522 534 538 53c 53d 542 546
54a 54d 551 554 558 559 55e 562
566 569 56a 1 56f 574 578 57d
581 585 588 58b 58c 591 595 599
59c 5a0 5a4 5a7 5a8 5ad 5b1 5b6
5ba 5be 5c1 5c5 5c9 5cc 5cd 5d2
5d6 50e 5db 5df 5e3 5e6 5e8 5ec
5f0 5f3 5f5 5f9 5fb 606 60a 60c
621 61d 61c 628 61b 639 631 635
630 62d 63f 643 647 648 64d 651
655 658 65c 65f 663 664 669 66d
670 674 675 1 67a 67f 683 686
68a 68b 1 690 695 699 69c 6a0
6a1 1 6a6 6ab 6ae 6b2 6b6 6b9
6ba 1 6bf 6c4 6c8 6cd 6d1 6d5
6d8 6db 6dc 6e1 6e5 6e9 6ec 6f0
6f4 6f7 6f8 6fd 701 706 70a 70e
711 715 719 71c 71d 722 726 619
72b 72f 733 736 738 73c 740 743
745 749 74b 756 75a 75c 760 779
771 775 770 780 76f 785 789 78d
791 795 799 79d 7a1 7a4 76d 7a5
7a8 7ac 7ae 7b2 7b6 7b9 7ba 7bc
7bf 7c3 7c5 7c9 7cd 7d0 7d2 7d6
7d8 7e3 7e7 7e9 7ed 7fa 7fe 7ff
803 807 80b 80f 813 816 81a 81c
820 822 82d 831 833 835 837 83b
846 848 84b 84d 854 
22d
2
0 :2 1 9 e d 19 27 :2 19
37 40 :2 37 7 12 :2 7 22 2f
:2 22 3f 44 :2 3f 7 12 :2 7 18
:2 3 5 c 17 1a :2 5 3 c
15 20 :2 15 14 30 37 :2 3 5
c 17 1a :2 5 3 c 15 0
1c :2 3 5 c 17 1a :2 5 d
1a 1e :2 1a 28 2c 3d :2 28 19
:2 3 :4 8 7 13 16 19 1c 1f
31 34 :2 1f 38 3b :2 1f 41 :2 7
14 7 13 16 19 1c 1f 31
34 :2 1f 38 3b :2 1f 43 9 :2 1f
d 10 :2 1f 16 :2 7 :4 5 :6 3 d
1c 20 :2 1c 1b :2 3 5 11 14
17 1a 1d 31 34 :2 1d 38 3b
:2 1d 41 :2 5 :6 3 d 0 :2 3 5
11 14 17 1a 1d 3c :2 5 :6 3
d 0 :2 3 5 11 14 17 1a
1d 12 :2 5 :6 3 d 0 :2 3 5
11 14 17 1a 1d 3c :2 5 :6 3
d 1c 21 :2 1c 1b :2 3 5 11
14 17 1a 1d 2f 32 :2 1d 37
3a :2 1d 3f 42 :2 1d 11 :2 5 :6 3
d 0 :2 3 5 11 14 17 1a
1d 3a :2 5 :6 3 d 0 :2 3 5
11 14 17 1a 1d 3b :2 5 :6 3
d 22 2a :2 22 21 :2 3 5 11
14 17 1a 1d 45 48 :2 1d 8
:2 5 :6 3 d 19 1d :2 19 18 5
:2 3 :3 5 1a :2 5 11 15 11 2a
31 33 :2 31 3b 4b :3 49 :2 2a :2 5
c 8 15 17 :2 15 13 17 13
2f 3f :3 3d :2 7 13 17 13 33
43 :3 41 :2 7 19 7 d 7 :4 5
:6 3 d 21 25 :2 21 20 5 :2 3
:3 5 1a :2 5 11 15 11 e 14
16 :2 14 26 2c 2e :2 2c :2 e 7
d f :2 d :2 e 22 28 2a :2 28
:2 e d b 1b :3 19 :2 d :2 5 c
8 15 17 :2 15 13 17 13 2f
3f :3 3d :2 7 13 17 13 33 43
:3 41 :2 7 19 7 d 7 :4 5 :7 3
c 21 34 3f :2 21 20 5 c
:2 3 8 7 e 17 :2 e d 7
1b 7 e 17 :2 e d 7 :4 5
:7 3 c 14 0 1b :2 3 4 b
a 4 :a 3 :5 1 
22d
2
0 :4 1 :9 3 :c 4 :4 5 :3 3 :6 6 :b 9
:6 a :3 d 0 :3 d :6 e :d 10 :4 12 :11 13
12 :f 15 16 :2 15 :2 16 :2 15 16 :2 15
:2 14 :2 12 :2 11 :4 10 :8 1a :11 1c :2 1b :4 1a
1f 0 :2 1f :9 21 :2 20 :4 1f 24 0
:2 24 :6 26 27 :2 26 :2 25 :4 24 2a 0
:2 2a :9 2c :2 2b :4 2a :8 2f :12 31 32 :2 31
:2 30 :4 2f 35 0 :2 35 :9 37 :2 36 :4 35
3a 0 :2 3a :9 3c :2 3b :4 3a :8 3f :a 41
42 :2 41 :2 40 :4 3f :6 45 46 :2 45 :2 46
:4 48 :11 49 :6 4a :a 4b :a 4c 4a :3 4e :2 4d
:2 4a :2 47 :4 45 :6 52 53 :2 52 :2 53 :4 55
:3 56 :c 57 :5 58 :2 57 :5 58 :3 57 :5 59 :2 57
:2 56 :6 5a :a 5b :a 5c 5a :3 5e :2 5d :2 5a
:2 54 :4 52 :8 62 :2 63 :2 62 65 :7 66 65
:7 68 :2 67 :2 65 :2 64 :4 62 :3 6c 0 :3 6c
:4 6e :2 6d :4 6c :4 10 :5 1 
856
2
:3 0 1 :4 0 2 :3 0 3 :6 0 1
4 :a 0 20 2 0 a7 5 3
6 :3 0 5 :6 0 8 7 :5 0 9
7 6 :3 0 7 :6 0 c b :3 0
6 :3 0 8 :6 0 10 f :4 0 88
d b 6 :3 0 9 :6 0 14 13
:3 0 b :3 0 a :6 0 18 17 :3 0
53 88 16 f b :3 0 c :6 0
1c 1b :3 0 1e :2 0 20 5 1f
0 228 d :3 0 e :3 0 f :3 0
4 5 :2 0 22 25 228 10 :3 0
11 :a 0 31 3 4e 82 1b 19
6 :3 0 12 :6 0 2b 2a :3 0 13
:3 0 b :3 0 2d 2f 0 31 28
30 0 228 d :3 0 e :3 0 f
:3 0 11 28 :2 0 1d 33 36 228
10 :3 0 14 :a 0 3e 4 13 :4 0
15 :3 0 3b 3c 0 3e 39 3d
0 228 d :3 0 e :3 0 f :3 0
14 39 :2 0 20 40 43 228 16
:a 0 89 5 39 83 25 23 b
:3 0 17 :6 0 48 47 :3 0 19 :2 0
27 b :3 0 18 :6 0 4d 4b 4c
:2 0 4f :2 0 89 45 50 :2 0 18
:3 0 2a 53 54 :3 0 4 :3 0 1a
:2 0 1a :2 0 1a :2 0 1b :2 0 1c
:3 0 1d :2 0 17 :3 0 2c 5c 5e
:3 0 1d :2 0 1e :3 0 2f 60 62
:3 0 1f :3 0 32 56 65 :2 0 67
4 :3 0 1a :2 0 1a :2 0 1a :2 0
1b :2 0 1c :3 0 1d :2 0 17 :3 0
3b 6e 70 :3 0 1d :2 0 20 :3 0
3e 72 74 :3 0 1d :2 0 18 :3 0
41 76 78 :3 0 1d :2 0 1e :3 0
44 7a 7c :3 0 1f :3 0 47 68
7f :2 0 81 0 81 0 84 55
67 0 84 50 0 85 :3 0 88
87 85 86 :6 0 89 1 45 50
88 228 21 :a 0 a8 6 66 a7
57 55 b :3 0 17 :6 0 8e 8d
:3 0 90 :2 0 a8 8b 91 :2 0 4
:3 0 1a :2 0 1a :2 0 1a :2 0 1b
:2 0 22 :3 0 1d :2 0 17 :3 0 59
99 9b :3 0 1d :2 0 1e :3 0 5c
9d 9f :3 0 23 :3 0 5f 93 a2
:2 0 a4 :3 0 a7 a6 a4 a5 :6 0
a8 1 8b 91 a7 228 :2 0 24
:a 0 bb 7 0 ab :2 0 bb aa
ac :2 0 4 :3 0 1b :2 0 1b :2 0
1b :2 0 1b :2 0 25 :3 0 26 :3 0
68 ae b5 :2 0 b7 6f ba :3 0
ba 0 ba b9 b7 b8 :6 0 bb
1 aa ac ba 228 :2 0 27 :a 0
ce 8 0 be :2 0 ce bd bf
:2 0 4 :3 0 1b :2 0 1b :2 0 1b
:2 0 1b :2 0 28 :3 0 29 :3 0 71
c1 c8 :2 0 ca 78 cd :3 0 cd
0 cd cc ca cb :6 0 ce 1
bd bf cd 228 :2 0 2a :a 0 e1
9 0 d1 :2 0 e1 d0 d2 :2 0
4 :3 0 1b :2 0 1b :2 0 1b :2 0
1b :2 0 2b :3 0 2c :3 0 7a d4
db :2 0 dd 81 e0 :3 0 e0 0
e0 df dd de :6 0 e1 1 d0
d2 e0 228 :2 0 2d :a 0 104 a
97 103 85 83 b :3 0 2e :6 0
e6 e5 :3 0 e8 :2 0 104 e3 e9
:2 0 4 :3 0 1a :2 0 1a :2 0 1a
:2 0 1b :2 0 2f :3 0 1d :2 0 1e
:3 0 87 f1 f3 :3 0 1d :2 0 2e
:3 0 8a f5 f7 :3 0 1d :2 0 1e
:3 0 8d f9 fb :3 0 1f :3 0 90
eb fe :2 0 100 :3 0 103 0 103
102 100 101 :6 0 104 1 e3 e9
103 228 :2 0 30 :a 0 117 b 0
107 :2 0 117 106 108 :2 0 4 :3 0
1a :2 0 1b :2 0 1a :2 0 1b :2 0
31 :3 0 32 :3 0 99 10a 111 :2 0
113 a0 116 :3 0 116 0 116 115
113 114 :6 0 117 1 106 108 116
228 :2 0 33 :a 0 12a c 0 11a
:2 0 12a 119 11b :2 0 4 :3 0 1a
:2 0 1b :2 0 1a :2 0 1b :2 0 34
:3 0 32 :3 0 a2 11d 124 :2 0 126
a9 129 :3 0 129 0 129 128 126
127 :6 0 12a 1 119 11b 129 228
:2 0 35 :a 0 145 d b9 144 ad
ab b :3 0 36 :6 0 12f 12e :3 0
131 :2 0 145 12c 132 :2 0 4 :3 0
1a :2 0 1b :2 0 1a :2 0 1b :2 0
37 :3 0 1d :2 0 36 :3 0 af 13a
13c :3 0 32 :3 0 b2 134 13f :2 0
141 :3 0 144 0 144 143 141 142
:6 0 145 1 12c 132 144 228 :2 0
38 :a 0 18d e d4 187 bd bb
b :3 0 17 :6 0 14a 149 :3 0 150
0 18b bf 14c :2 0 18d 147 14e
:2 0 39 :5 0 35 :3 0 3a :3 0 c1
152 154 :2 0 189 3b :3 0 3c :3 0
156 157 0 3d :3 0 3e :2 0 3f
:3 0 c5 15a 15c :3 0 40 :3 0 17
:3 0 3e :2 0 c8 160 161 :3 0 15d
163 162 :2 0 158 164 0 166 0
165 :2 0 189 41 :4 0 167 :2 0 3e
:2 0 1b :2 0 cb 169 16b :3 0 3b
:3 0 42 :3 0 16d 16e 0 40 :3 0
17 :3 0 3e :2 0 ce 172 173 :3 0
16f 174 0 176 0 175 :2 0 181
3b :3 0 43 :3 0 177 178 0 40
:3 0 17 :3 0 3e :2 0 d1 17c 17d
:3 0 179 17e 0 180 0 17f :2 0
181 44 :3 0 39 :3 0 183 0 185
c3 186 0 185 0 188 16c 181
0 188 d7 0 189 da 18c :3 0
18c de 18c 18b 189 18a :6 0 18d
1 147 14e 18c 228 :2 0 45 :a 0
1eb f 102 1e5 e2 e0 b :3 0
17 :6 0 192 191 :3 0 198 0 1e9
e4 194 :2 0 1eb 18f 196 :2 0 39
:5 0 35 :3 0 3a :3 0 e6 19a 19c
:2 0 1e7 3b :3 0 3c :3 0 19e 19f
0 46 :3 0 3e :2 0 47 :3 0 ea
1a2 1a4 :3 0 46 :3 0 3e :2 0 48
:3 0 ed 1a7 1a9 :3 0 1a5 1ab 1aa
:2 0 46 :3 0 3e :2 0 49 :3 0 f0
1ae 1b0 :3 0 1ac 1b2 1b1 :2 0 46
:3 0 3e :2 0 4a :3 0 f3 1b5 1b7
:3 0 1b3 1b9 1b8 :2 0 1ba :2 0 40
:3 0 17 :3 0 3e :2 0 f6 1be 1bf
:3 0 1bb 1c1 1c0 :2 0 1a0 1c2 0
1c4 0 1c3 :2 0 1e7 41 :4 0 1c5
:2 0 3e :2 0 1b :2 0 f9 1c7 1c9
:3 0 3b :3 0 42 :3 0 1cb 1cc 0
40 :3 0 17 :3 0 3e :2 0 fc 1d0
1d1 :3 0 1cd 1d2 0 1d4 0 1d3
:2 0 1df 3b :3 0 43 :3 0 1d5 1d6
0 40 :3 0 17 :3 0 3e :2 0 ff
1da 1db :3 0 1d7 1dc 0 1de 0
1dd :2 0 1df 44 :3 0 39 :3 0 1e1
0 1e3 e8 1e4 0 1e3 0 1e6
1ca 1df 0 1e6 105 0 1e7 108
1ea :3 0 1ea 10c 1ea 1e9 1e7 1e8
:6 0 1eb 1 18f 196 1ea 228 :2 0
10 :3 0 4b :a 0 211 10 1fb 1fd
110 10e 4d :3 0 4e :3 0 4c :6 0
1f2 1f0 1f1 :2 0 13 :3 0 b :3 0
1f4 1f6 0 211 1ee 1f7 :2 0 4c
:3 0 13 :3 0 11 :3 0 1b :2 0 112
1fe :2 0 1ff :2 0 201 114 20b 13
:3 0 11 :3 0 1a :2 0 116 203 205
206 :2 0 207 :2 0 209 118 20a 0
209 0 20c 1f9 201 0 20c 11a
0 20d 11d 210 :3 0 210 0 210
20f 20d 20e :6 0 211 1 1ee 1f7
210 228 :2 0 10 :3 0 4f :a 0 222
11 13 :4 0 15 :3 0 216 217 0
222 214 218 :2 0 13 :3 0 14 :3 0
21b :2 0 21c :2 0 21e 11f 221 :3 0
221 0 221 220 21e 21f :6 0 222
1 214 218 221 228 :3 0 227 0
227 :3 0 227 228 225 226 :6 0 229
0 121 0 4 227 22b :2 0 2
229 22c :6 0 
135
2
:3 0 1 6 1 a 1 e 1
12 1 16 1 1a 6 9 d
11 15 19 1d 2 23 24 1
29 1 2c 2 34 35 2 41
42 1 46 1 4a 2 49 4e
1 52 2 5b 5d 2 5f 61
6 57 58 59 5a 63 64 1
66 2 6d 6f 2 71 73 2
75 77 2 79 7b 6 69 6a
6b 6c 7d 7e 1 80 2 83
82 1 84 1 8c 1 8f 2
98 9a 2 9c 9e 6 94 95
96 97 a0 a1 1 a3 6 af
b0 b1 b2 b3 b4 1 b6 6
c2 c3 c4 c5 c6 c7 1 c9
6 d5 d6 d7 d8 d9 da 1
dc 1 e4 1 e7 2 f0 f2
2 f4 f6 2 f8 fa 6 ec
ed ee ef fc fd 1 ff 6
10b 10c 10d 10e 10f 110 1 112
6 11e 11f 120 121 122 123 1
125 1 12d 1 130 2 139 13b
6 135 136 137 138 13d 13e 1
140 1 148 1 14b 1 14d 1
153 1 184 2 159 15b 2 15e
15f 2 168 16a 2 170 171 2
17a 17b 2 176 180 2 187 186
3 155 166 188 1 151 1 190
1 193 1 195 1 19b 1 1e2
2 1a1 1a3 2 1a6 1a8 2 1ad
1af 2 1b4 1b6 2 1bc 1bd 2
1c6 1c8 2 1ce 1cf 2 1d8 1d9
2 1d4 1de 2 1e5 1e4 3 19d
1c4 1e6 1 199 1 1ef 1 1f3
1 1fc 1 200 1 204 1 208
2 20b 20a 1 20c 1 21d 13
20 26 31 37 3e 44 89 a8
bb ce e1 104 117 12a 145 18d
1eb 211 222 
1
4
0 
22b
0
1
14
11
22
0 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1
1 0 0 0 
12c 1 d
e3 1 a
bd 1 8
5 1 2
1a 2 0
1ef 10 0
29 3 0
8b 1 6
e 2 0
119 1 c
16 2 0
214 1 11
39 1 4
4a 5 0
a 2 0
18f 1 f
147 1 e
195 f 0
14d e 0
106 1 b
190 f 0
148 e 0
8c 6 0
46 5 0
aa 1 7
d0 1 9
4 0 1
1ee 1 10
28 1 3
e4 a 0
12d d 0
12 2 0
45 1 5
6 2 0
0

/
create or replace package body dbms_session wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
95a425ff
1
4
0 
52
7 PACKAGE:
4 BODY:
c DBMS_SESSION:
b EXECUTE_SQL:
d COORD_SESS_OK:
e BINARY_INTEGER:
8 FORMS_OK:
a TRIGGER_OK:
c PROCEDURE_OK:
4 STMT:
8 VARCHAR2:
a ERROR_HINT:
6 PRAGMA:
9 INTERFACE:
1 C:
6 PSDDIN:
8 FUNCTION:
6 PSDUIS:
6 RETURN:
6 PSDIRE:
8 ROLENAME:
6 PSDFMR:
6 HEAPNO:
7 RECURSE:
8 SET_ROLE:
8 ROLE_CMD:
1 1:
1 0:
9 set role :
2 ||:
8 SET ROLE:
d SET_SQL_TRACE:
9 SQL_TRACE:
7 BOOLEAN:
20 alter session set sql_trace true:
d SET SQL_TRACE:
21 alter session set sql_trace false:
7 SET_NLS:
5 PARAM:
5 VALUE:
9 DDL_ERROR:
6 SUBSTR:
5 UPPER:
1 4:
2 !=:
4 NLS_:
6 LENGTH:
1 >:
2 20:
5 RAISE:
12 alter session set :
3  = :
7 SET NLS:
13 CLOSE_DATABASE_LINK:
6 DBLINK:
22 alter session close database link :
13 CLOSE DATABASE LINK:
9 SET_LABEL:
3 LBL:
1 =:
6 DBHIGH:
5 DBLOW:
1a alter session set label = :
9 SET LABEL:
1b alter session set label = ':
1 ':
14 SET_MLS_LABEL_FORMAT:
3 FMT:
26 alter session set mls_label_format = ':
14 SET MLS LABEL FORMAT:
d RESET_PACKAGE:
11 UNIQUE_SESSION_ID:
f IS_ROLE_ENABLED:
4 TRUE:
5 FALSE:
1d SET_CLOSE_CACHED_OPEN_CURSORS:
d CLOSE_CURSORS:
32 alter session set close_cached_open_cursors = true:
1d SET CLOSE_CACHED_OPEN_CURSORS:
33 alter session set close_cached_open_cursors = false:
17 FREE_UNUSED_USER_MEMORY:
6 RECVAL:
0

0
0
20d
2
0 a0 1d a0 97 9a 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d 8f a0 b0 3d b4 55
6a :4 a0 b4 5d 9a b4 55 6a
:4 a0 b4 5d a0 8d a0 b4 a0
2c 6a :4 a0 b4 5d a0 8d 8f
a0 b0 3d b4 :2 a0 2c 6a :4 a0
b4 5d 9a 8f a0 b0 3d 8f
a0 b0 3d b4 55 6a :4 a0 b4
5d 9a 8f a0 b0 3d b4 55
6a a0 :4 51 6e 7e a0 b4 2e
6e a5 57 b7 a4 b1 11 68
4f 9a 8f a0 b0 3d b4 55
6a :2 a0 :4 51 :2 6e a5 57 b7 a0
:4 51 :2 6e a5 57 b7 :2 19 3c b7
a4 b1 11 68 4f 9a 8f a0
b0 3d 8f a0 b0 3d b4 8b
55 6a b0 2a :3 a0 a5 b :2 51
a5 b 7e 6e b4 2e :2 a0 a5
b 7e 51 b4 2e 52 10 :2 a0
62 b7 19 3c a0 :4 51 6e 7e
a0 b4 2e 7e 6e b4 2e 7e
a0 b4 2e 6e a5 57 b7 a4
b1 11 68 4f 9a 8f a0 b0
3d b4 55 6a a0 :4 51 6e 7e
a0 b4 2e 6e a5 57 b7 a4
b1 11 68 4f 9a 8f a0 b0
3d b4 55 6a :2 a0 a5 b 7e
6e b4 2e :2 a0 a5 b 7e 6e
b4 2e 52 10 a0 :4 51 6e 7e
a0 b4 2e 6e a5 57 b7 a0
:4 51 6e 7e a0 b4 2e 7e 6e
b4 2e 6e a5 57 b7 :2 19 3c
b7 a4 b1 11 68 4f 9a 8f
a0 b0 3d b4 55 6a a0 :4 51
6e 7e a0 b4 2e 7e 6e b4
2e 6e a5 57 b7 a4 b1 11
68 4f 9a b4 55 6a a0 57
b3 b7 a4 b1 11 68 4f a0
8d a0 b4 a0 2c 6a :2 a0 65
b7 a4 b1 11 68 4f a0 8d
8f a0 b0 3d b4 :2 a0 2c 6a
:2 a0 a5 b 7e 51 b4 2e :2 a0
65 b7 :2 a0 65 b7 :2 19 3c b7
a4 b1 11 68 4f 9a 8f a0
b0 3d b4 55 6a :2 a0 :4 51 :2 6e
a5 57 b7 a0 :4 51 :2 6e a5 57
b7 :2 19 3c b7 a4 b1 11 68
4f 9a 8f a0 b0 3d 8f a0
b0 3d b4 a3 55 6a a0 1c
81 b0 :2 a0 51 d b7 a0 51
d b7 :2 19 3c :3 a0 a5 57 b7
a4 b1 11 68 4f 9a b4 55
6a a0 51 a0 a5 57 b7 a4
b1 11 68 4f b1 b7 a4 11
b1 56 4f 17 b5 
20d
2
0 3 7 8 c 14 29 25
24 30 3d 39 23 44 4d 49
38 54 61 5d 37 68 71 6d
5c 78 85 81 5b 8c 80 91
95 99 9d a1 a5 7f a9 ac
b9 ba be c2 c6 ca ce d2
d3 d6 da e7 eb ec f0 f4
f8 fc 100 104 108 109 10c 110
125 121 120 12c 11f 131 135 139
13d 141 145 149 14d 151 152 155
16a 166 165 171 17e 17a 164 185
179 18a 18e 192 196 19a 19e 178
1a2 1a5 1ba 1b6 1b5 1c1 1b4 1c6
1ca 1ce 1d2 1d5 1d8 1db 1de 1e2
1e5 1e9 1ea 1ef 1f3 1f4 1b2 1f9
176 1fd 208 162 20c 221 21d 21c
228 21b 22d 231 235 239 23d 240
243 246 249 24d 251 252 219 257
25b 25e 261 264 267 26b 26f 270
11d 275 279 27d 7d 280 59 284
28f 35 293 2a8 2a4 2a3 2af 2bc
2b8 2a2 2c3 2b7 2d4 2cc 2d0 2b6
2da 2c8 2dd 2e1 2e5 2b4 2e6 2e9
2ec 2a0 2ed 2f0 2f4 2f5 2fa 2fe
302 21 303 306 309 30a 1 30f
314 318 31c 31f 321 325 328 32c
32f 332 335 338 33c 33f 343 344
349 34c 350 351 356 359 35d 35e
363 367 368 36d 36f 373 375 380
384 386 39b 397 396 3a2 395 3a7
3ab 3af 3b3 3b6 3b9 3bc 3bf 3c3
3c6 3ca 3cb 3d0 3d4 3d5 393 3da
3de 3e0 3eb 3ef 3f1 406 402 401
40d 400 412 416 41a 41e 422 3fe
423 426 42a 42b 430 434 438 439
43b 43e 442 443 1 448 44d 451
454 457 45a 45d 461 464 468 469
46e 472 473 478 47a 47e 481 484
487 48a 48e 491 495 496 49b 49e
4a2 4a3 4a8 4ac 4ad 4b2 4b4 4b8
4bc 4bf 4c1 4c5 4c7 4d2 4d6 4d8
4ed 4e9 4e8 4f4 4e7 4f9 4fd 501
505 508 50b 50e 511 515 518 51c
51d 522 525 529 52a 52f 533 534
4e5 539 53d 53f 54a 54e 550 55d
55e 562 566 56a 56f 570 572 576
578 583 587 589 58d 59a 59e 59f
5a3 5a7 5ab 5af 5b3 5b7 5b9 5bd
5bf 5ca 5ce 5d0 5d4 5e9 5e5 5e4
5f0 5e3 5f5 5f9 5fd 601 605 609
60d 5e1 60e 611 614 615 61a 61e
622 626 628 62c 630 634 636 63a
63e 641 643 647 649 654 658 65a
66f 66b 66a 676 669 67b 67f 683
687 68b 68e 691 694 697 69b 69f
6a0 667 6a5 6a9 6ac 6af 6b2 6b5
6b9 6bd 6be 6c3 6c5 6c9 6cd 6d0
6d2 6d6 6d8 6e3 6e7 6e9 6fe 6fa
6f9 705 712 70e 6f8 719 70d 739
722 726 72a 72e 735 70c 71e 740
744 747 70a 74b 74f 752 6f6 756
75a 75e 761 765 769 76d 76e 773
775 779 77b 786 78a 78c 799 79a
79e 7a2 7a6 7a9 7ad 7ae 7b3 7b5
7b9 7bb 7c6 7ca 7cc 7ce 7d0 7d4
7df 7e1 7e4 7e6 7ed 
20d
2
0 :2 1 9 e d 19 27 :2 19
37 40 :2 37 7 12 :2 7 22 2f
:2 22 3f 44 :2 3f 7 12 :2 7 18
:2 3 5 c 17 1a :2 5 d 0
:2 3 5 c 17 1a :2 5 3 c
13 0 1a :2 3 5 c 17 1a
:2 5 3 c 13 1c :2 13 12 26
2d :2 3 5 c 17 1a :2 5 d
14 1b :2 14 2b 33 :2 2b 13 :2 3
5 c 17 1a :2 5 d 16 1f
:2 16 15 :2 3 5 11 14 17 1a
1d 29 2c :2 1d 36 :2 5 :6 3 d
1b 25 :2 1b 1a :2 3 8 7 13
16 19 1c 1f 9 :2 7 12 7
13 16 19 1c 1f 9 :2 7 :4 5
:6 3 d 15 1b :2 15 25 2b :2 25
14 5 :2 3 :2 5 8 f 15 :2 f
1c 1e :2 8 21 24 :2 21 c 13
:2 c 1a 1c :2 1a :2 8 7 d 7
1f :3 5 11 14 17 1a 1d 32
35 :2 1d 3b 3e :2 1d 44 47 :2 1d
8 :2 5 :6 3 d 21 28 :2 21 20
:2 3 5 11 14 17 1a 1d 42
45 :2 1d 7 :2 5 :6 3 d 17 1b
:2 17 16 :2 3 8 e :2 8 13 15
:2 13 21 27 :2 21 2c 2e :2 2c :2 8
7 13 16 19 1c 1f 3c 3f
:2 1f 44 :2 7 36 7 13 16 19
1c 1f 3e 41 :2 1f 45 48 :2 1f
9 :2 7 :4 5 :6 3 d 22 26 :2 22
21 :2 3 5 11 14 17 1a 7
31 34 :2 7 38 3b :3 7 :2 5 :6 3
d 0 :2 3 :3 5 :7 3 c 1e 0
25 :2 3 5 c 5 :7 3 c 1c
25 :2 1c 1b 2f 36 :2 3 8 f
:2 8 19 1b :2 19 7 e 7 1d
7 e 7 :4 5 :6 3 d 2b 39
:2 2b 2a :2 3 8 7 13 16 19
1c 2 9 :2 7 16 7 13 16
19 1c 2 9 :2 7 :2 4 :2 5 :6 3
d 25 2c :2 25 3c 44 :2 3c 24
5 :2 3 :3 c 5 8 7 11 7
10 7 11 7 :5 5 c 13 :2 5
:6 3 d 0 :2 3 5 1d 20 :2 5
:a 3 :5 1 
20d
2
0 :4 1 :9 3 :c 4 :4 5 :3 3 :6 6 9
0 :2 9 :6 a :3 d 0 :3 d :6 e :b 11
:6 12 :c 15 :6 16 :8 18 :d 1a :2 19 :4 18 :8 1d
1f :6 20 21 :2 20 1f :6 23 24 :2 23
:2 22 :2 1f :2 1e :4 1d :a 28 29 :2 28 :2 29
:d 2c :8 2d :2 2c :3 2e 2d :2 2c :12 30 31
:2 30 :2 2a :4 28 :8 34 :a 36 37 :2 36 :2 35
:4 34 :8 3a :12 3c :d 3d 3c :e 3f 40 :2 3f
:2 3e :2 3c :2 3b :4 3a :8 44 :5 46 :9 47 48
:2 46 :2 45 :4 44 4b 0 :2 4b :3 4d :2 4c
:4 4b :3 50 0 :3 50 :3 52 :2 51 :4 50 :b 55
:8 57 :3 58 57 :3 5a :2 59 :2 57 :2 56 :4 55
:8 5e 60 :5 61 62 63 :2 61 60 :5 65
66 67 :2 65 :2 64 :2 60 :2 5f :4 5e :a 6b
6c :2 6b :4 6c 6e :3 6f 6e :3 71 :2 70
:2 6e :5 74 :2 6d :4 6b 77 0 :2 77 :5 79
:2 78 :4 77 :4 18 :5 1 
7ef
2
:3 0 1 :4 0 2 :3 0 3 :6 0 1
4 :a 0 20 2 be c0 5 3
6 :3 0 5 :6 0 8 7 :5 0 9
7 6 :3 0 7 :6 0 c b :3 0
6 :3 0 8 :6 0 10 f :4 0 9f
d b 6 :3 0 9 :6 0 14 13
:3 0 b :3 0 a :6 0 18 17 :3 0
59 9f 16 f b :3 0 c :6 0
1c 1b :3 0 1e :2 0 20 5 1f
0 208 d :3 0 e :3 0 f :3 0
4 5 :2 0 22 25 208 10 :a 0
2a 3 0 28 :2 0 2a 27 29
0 208 d :3 0 e :3 0 f :3 0
10 27 :2 0 19 2c 2f 208 11
:3 0 12 :a 0 37 4 13 :4 0 b
:3 0 34 35 0 37 32 36 0
208 d :3 0 e :3 0 f :3 0 12
32 :2 0 1c 39 3c 208 11 :3 0
14 :a 0 48 5 54 99 21 1f
b :3 0 15 :6 0 42 41 :3 0 13
:3 0 6 :3 0 44 46 0 48 3f
47 0 208 d :3 0 e :3 0 f
:3 0 14 3f :2 0 23 4a 4d 208
16 :a 0 5a 6 :2 0 28 26 6
:3 0 17 :6 0 52 51 :4 0 79 2d
2a 6 :3 0 18 :6 0 56 55 :3 0
58 :2 0 5a 4f 59 0 208 d
:3 0 e :3 0 f :3 0 16 4f :2 0
5c 5f 208 19 :a 0 7a 7 3e
79 32 30 b :3 0 1a :6 0 64
63 :3 0 66 :2 0 7a 61 67 :2 0
4 :3 0 1b :2 0 1b :2 0 1c :2 0
1c :2 0 1d :3 0 1e :2 0 1a :3 0
34 6f 71 :3 0 1f :3 0 37 69
74 :2 0 76 :3 0 79 78 76 77
:6 0 7a 1 61 67 79 208 20
:a 0 a0 8 4b 9a 42 40 22
:3 0 21 :6 0 7f 7e :3 0 81 :2 0
a0 7c 82 :2 0 21 :3 0 4 :3 0
1b :2 0 1b :2 0 1b :2 0 1b :2 0
23 :3 0 24 :3 0 44 85 8c :2 0
8e 4 :3 0 1b :2 0 1b :2 0 1b
:2 0 1b :2 0 25 :3 0 24 :3 0 4d
8f 96 :2 0 98 0 98 0 9b
84 8e 0 9b 56 0 9c :3 0
9f 9e 9c 9d :6 0 a0 1 7c
82 9f 208 26 :a 0 e7 9 b1
b8 5d 5b b :3 0 27 :6 0 a5
a4 :3 0 b2 b4 62 5f b :3 0
28 :6 0 a9 a8 :3 0 2a :3 0 ab
:2 0 e7 a2 ad :2 0 29 :5 0 af
0 e5 2b :3 0 27 :3 0 64 1b
:2 0 2c :2 0 66 2d :2 0 2e :3 0
6c ba bc :3 0 2f :3 0 28 :3 0
6a 30 :2 0 31 :2 0 71 c2 c4
:3 0 bd c6 c5 :2 0 32 :3 0 29
:3 0 c9 0 cb 6f cc c7 cb
0 cd 74 0 e3 4 :3 0 1c
:2 0 1b :2 0 1c :2 0 1b :2 0 33
:3 0 1e :2 0 27 :3 0 76 d4 d6
:3 0 1e :2 0 34 :3 0 79 d8 da
:3 0 1e :2 0 28 :3 0 7c dc de
:3 0 35 :3 0 7f ce e1 :2 0 e3
86 e6 :3 0 e6 89 e6 e5 e3
e4 :6 0 e7 1 a2 ad e6 208
:2 0 36 :a 0 102 a 99 101 8d
8b b :3 0 37 :6 0 ec eb :3 0
ee :2 0 102 e9 ef :2 0 4 :3 0
1b :2 0 1b :2 0 1b :2 0 1b :2 0
38 :3 0 1e :2 0 37 :3 0 8f f7
f9 :3 0 39 :3 0 92 f1 fc :2 0
fe :3 0 101 0 101 100 fe ff
:6 0 102 1 e9 ef 101 208 :2 0
3a :a 0 145 b 10c 10e 9d 9b
b :3 0 3b :6 0 107 106 :3 0 109
:2 0 145 104 10a :2 0 2b :3 0 3b
:3 0 9f 3c :2 0 3d :3 0 a3 110
112 :3 0 2b :3 0 3b :3 0 a1 114
116 3c :2 0 3e :3 0 a8 118 11a
:3 0 113 11c 11b :2 0 4 :3 0 1c
:2 0 1b :2 0 1b :2 0 1b :2 0 3f
:3 0 1e :2 0 3b :3 0 ab 124 126
:3 0 40 :3 0 ae 11e 129 :2 0 12b
a6 13f 4 :3 0 1c :2 0 1b :2 0
1b :2 0 1b :2 0 41 :3 0 1e :2 0
3b :3 0 b5 132 134 :3 0 1e :2 0
42 :3 0 b8 136 138 :3 0 40 :3 0
bb 12c 13b :2 0 13d c2 13e 0
13d 0 140 11d 12b 0 140 c4
0 141 c7 144 :3 0 144 0 144
143 141 142 :6 0 145 1 104 10a
144 208 :2 0 43 :a 0 164 c da
163 cb c9 b :3 0 44 :6 0 14a
149 :3 0 14c :2 0 164 147 14d :2 0
4 :3 0 1c :2 0 1b :2 0 1b :2 0
1b :2 0 45 :3 0 1e :2 0 44 :3 0
cd 155 157 :3 0 1e :2 0 42 :3 0
d0 159 15b :3 0 46 :3 0 d3 14f
15e :2 0 160 :3 0 163 0 163 162
160 161 :6 0 164 1 147 14d 163
208 :2 0 47 :a 0 171 d 0 167
:2 0 171 166 168 :2 0 10 :3 0 16a
16c :2 0 16d 0 dc 170 :3 0 170
0 170 16f 16d 16e :6 0 171 1
166 168 170 208 :2 0 11 :3 0 48
:a 0 181 e 13 :4 0 b :3 0 176
177 0 181 174 178 :2 0 13 :3 0
12 :3 0 17b :2 0 17d de 180 :3 0
180 0 180 17f 17d 17e :6 0 181
1 174 178 180 208 :2 0 11 :3 0
49 :a 0 1a5 f 18e 190 e2 e0
b :3 0 15 :6 0 187 186 :3 0 13
:3 0 22 :3 0 189 18b 0 1a5 184
18c :2 0 14 :3 0 15 :3 0 e4 3c
:2 0 1b :2 0 e8 192 194 :3 0 13
:3 0 4a :3 0 197 :2 0 199 e6 19f
13 :3 0 4b :3 0 19b :2 0 19d eb
19e 0 19d 0 1a0 195 199 0
1a0 ed 0 1a1 f0 1a4 :3 0 1a4
0 1a4 1a3 1a1 1a2 :6 0 1a5 1
184 18c 1a4 208 :2 0 4c :a 0 1cb
10 fd 1c5 f4 f2 22 :3 0 4d
:6 0 1aa 1a9 :3 0 1ac :2 0 1cb 1a7
1ad :2 0 4d :3 0 4 :3 0 1b :2 0
1b :2 0 1b :2 0 1b :2 0 4e :3 0
4f :3 0 f6 1b0 1b7 :2 0 1b9 4
:3 0 1b :2 0 1b :2 0 1b :2 0 1b
:2 0 50 :3 0 4f :3 0 ff 1ba 1c1
:2 0 1c3 106 1c4 0 1c3 0 1c6
1af 1b9 0 1c6 108 0 1c7 10b
1ca :3 0 1ca 0 1ca 1c9 1c7 1c8
:6 0 1cb 1 1a7 1ad 1ca 208 :2 0
51 :a 0 1f3 11 118 1e7 10f 10d
6 :3 0 17 :6 0 1d0 1cf :3 0 116
1e8 114 111 22 :3 0 18 :6 0 1d4
1d3 :3 0 18 :3 0 1d6 :2 0 1f3 1cd
1d8 :2 0 6 :3 0 1da :6 0 1dd 1db
0 1f1 52 :6 0 52 :3 0 1b :2 0
1df 1e0 0 1e2 52 :3 0 1c :2 0
1e3 1e4 0 1e6 0 1e6 0 1e9
1de 1e2 0 1e9 11a 0 1ef 16
:3 0 17 :3 0 52 :3 0 11d 1ea 1ed
:2 0 1ef 120 1f2 :3 0 1f2 123 1f2
1f1 1ef 1f0 :6 0 1f3 1 1cd 1d8
1f2 208 :2 0 51 :a 0 202 12 0
1f6 :2 0 202 1f5 1f7 :2 0 51 :3 0
1c :2 0 4a :3 0 125 1f9 1fc :2 0
1fe 128 201 :3 0 201 0 201 200
1fe 1ff :6 0 202 1 1f5 1f7 201
208 :3 0 207 0 207 :3 0 207 208
205 206 :6 0 209 0 12a 0 4
207 20b :2 0 2 209 20c :6 0 
141
2
:3 0 1 6 1 a 1 e 1
12 1 16 1 1a 6 9 d
11 15 19 1d 2 23 24 2
2d 2e 2 3a 3b 1 40 1
43 2 4b 4c 1 50 1 54
2 53 57 2 5d 5e 1 62
1 65 2 6e 70 6 6a 6b
6c 6d 72 73 1 75 1 7d
1 80 6 86 87 88 89 8a
8b 1 8d 6 90 91 92 93
94 95 1 97 2 9a 99 1
9b 1 a3 1 a7 2 a6 aa
1 ac 1 b3 3 b5 b6 b7
1 bf 2 b9 bb 1 ca 2
c1 c3 1 cc 2 d3 d5 2
d7 d9 2 db dd 6 cf d0
d1 d2 df e0 2 cd e2 1
b0 1 ea 1 ed 2 f6 f8
6 f2 f3 f4 f5 fa fb 1
fd 1 105 1 108 1 10d 1
115 2 10f 111 1 12a 2 117
119 2 123 125 6 11f 120 121
122 127 128 2 131 133 2 135
137 6 12d 12e 12f 130 139 13a
1 13c 2 13f 13e 1 140 1
148 1 14b 2 154 156 2 158
15a 6 150 151 152 153 15c 15d
1 15f 1 16b 1 17c 1 185
1 188 1 18f 1 198 2 191
193 1 19c 2 19f 19e 1 1a0
1 1a8 1 1ab 6 1b1 1b2 1b3
1b4 1b5 1b6 1 1b8 6 1bb 1bc
1bd 1be 1bf 1c0 1 1c2 2 1c5
1c4 1 1c6 1 1ce 1 1d2 2
1d1 1d5 1 1d7 1 1e1 1 1e5
2 1e8 1e7 2 1eb 1ec 2 1e9
1ee 1 1dc 2 1fa 1fb 1 1fd
16 20 26 2a 30 37 3d 48
4e 5a 60 7a a0 e7 102 145
164 171 181 1a5 1cb 1f3 202 
1
4
0 
20b
1
1
14
12
28
0 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1
1 1 0 0 
32 1 4
104 1 b
166 1 d
105 b 0
1d7 11 0
174 1 e
5 1 2
148 c 0
7c 1 8
4 0 1
1a 2 0
27 1 3
e 2 0
a3 9 0
1a7 1 10
62 7 0
16 2 0
147 1 c
a7 9 0
61 1 7
1a8 10 0
ac 9 0
184 1 f
4f 1 6
a 2 0
3f 1 5
ea a 0
1d2 11 0
54 6 0
a2 1 9
e9 1 a
1ce 11 0
7d 8 0
50 6 0
1f5 1 12
1cd 1 11
12 2 0
185 f 0
40 5 0
6 2 0
0

/
create or replace package body dbms_ddl wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
95a425ff
1
4
0 
6d
7 PACKAGE:
4 BODY:
8 DBMS_DDL:
a NOT_EXIST0:
6 PRAGMA:
e EXCEPTION_INIT:
1 -:
3 942:
a NOT_EXIST1:
4 4042:
a NOT_EXIST2:
4 4043:
a NOT_EXIST3:
4 6564:
a NOT_EXIST4:
3 943:
a NOT_EXIST5:
4 1418:
7 NO_PRIV:
4 1031:
b EXECUTE_SQL:
d COORD_SESS_OK:
e BINARY_INTEGER:
8 FORMS_OK:
a TRIGGER_OK:
c PROCEDURE_OK:
4 STMT:
8 VARCHAR2:
a ERROR_HINT:
9 INTERFACE:
1 C:
d ALTER_COMPILE:
4 TYPE:
6 SCHEMA:
4 NAME:
5 PTYPE:
2 30:
7 PSCHEMA:
5 PNAME:
2 65:
5 OWNER:
5 PART1:
5 PART2:
6 DBLINK:
a PART1_TYPE:
6 NUMBER:
5 OBJNO:
b IS NOT NULL:
2 ||:
3 ".":
1 ":
c DBMS_UTILITY:
c NAME_RESOLVE:
1 1:
17 RAISE_APPLICATION_ERROR:
5 20000:
12 Unable to compile :
1  :
2b , insufficient privileges or does not exist:
7 IS NULL:
5 20001:
16 cannot compile remote :
1 =:
3 SYS:
d DBMS_STANDARD:
8 STANDARD:
6 RETURN:
5 UPPER:
6 COMMIT:
c PACKAGE BODY:
1 0:
e alter package :
d  compile body:
15 ALTER PACKAGE COMPILE:
5 ELSIF:
15 PACKAGE SPECIFICATION:
16  compile specification:
8  compile:
9 PROCEDURE:
8 FUNCTION:
6 alter :
17 ALTER PROCEDURE COMPILE:
1b bad value for object type:: :
e ANALYZE_OBJECT:
6 METHOD:
d ESTIMATE_ROWS:
10 ESTIMATE_PERCENT:
a METHOD_OPT:
5 ONAME:
6 SAMPLE:
0 4 UET$:
4 FET$:
8 ESTIMATE:
2 !=:
7 sample :
5  rows:
8  percent:
7 CLUSTER:
10 analyze cluster :
c  statistics :
f ANALYZE CLUSTER:
5 TABLE:
e analyze table :
d ANALYZE TABLE:
5 INDEX:
e analyze index :
d ANALYZE INDEX:
12 Unable to analyze :
0

0
0
371
2
0 a0 1d a0 97 8b b0 2a
:3 a0 7e 51 b4 2e b4 5d 8b
b0 2a :3 a0 7e 51 b4 2e b4
5d 8b b0 2a :3 a0 7e 51 b4
2e b4 5d 8b b0 2a :3 a0 7e
51 b4 2e b4 5d 8b b0 2a
:3 a0 7e 51 b4 2e b4 5d 8b
b0 2a :3 a0 7e 51 b4 2e b4
5d 8b b0 2a :3 a0 7e 51 b4
2e b4 5d 9a 8f a0 b0 3d
8f a0 b0 3d 8f a0 b0 3d
8f a0 b0 3d 8f a0 b0 3d
8f a0 b0 3d b4 55 6a :4 a0
b4 5d 9a 8f a0 b0 3d 8f
a0 b0 3d 8f a0 b0 3d b4
a3 55 6a a0 51 a5 1c 81
b0 a3 a0 51 a5 1c 81 b0
a3 a0 51 a5 1c 81 b0 a3
a0 51 a5 1c 81 b0 a3 a0
51 a5 1c 81 b0 a3 a0 51
a5 1c 81 b0 a3 a0 51 a5
1c 81 b0 a3 a0 1c 81 b0
a3 a0 1c 81 b0 :2 a0 d :2 a0
d a0 7e b4 2e :2 a0 7e 6e
b4 2e 7e a0 b4 2e d b7
19 3c a0 6e 7e a0 b4 2e
7e 6e b4 2e d :2 a0 6b a0
51 :6 a0 a5 57 b7 :3 a0 7e 51
b4 2e 6e 7e a0 b4 2e 7e
6e b4 2e 7e a0 b4 2e 7e
6e b4 2e a5 57 b7 a6 9
a4 b1 11 4f a0 7e b4 2e
a0 7e b4 2e 52 10 5a a0
7e 51 b4 2e 6e 7e a0 b4
2e 7e 6e b4 2e 7e a0 b4
2e a5 57 b7 19 3c a0 7e
6e b4 2e a0 3e :3 6e 5 48
a 10 a0 65 b7 19 3c :3 a0
a5 b d a0 57 a0 b4 e9
a0 7e 6e b4 2e a0 :4 51 6e
7e a0 b4 2e 7e 6e b4 2e
6e a5 57 a0 b7 a0 7e 6e
b4 2e a0 :4 51 6e 7e a0 b4
2e 7e 6e b4 2e 6e a5 57
a0 b7 19 a0 7e 6e b4 2e
a0 :4 51 6e 7e a0 b4 2e 7e
6e b4 2e 6e a5 57 a0 b7
19 a0 7e 6e b4 2e a0 7e
6e b4 2e 52 10 a0 :4 51 6e
7e a0 b4 2e 7e 6e b4 2e
7e a0 b4 2e 7e 6e b4 2e
6e a5 57 b7 19 a0 7e 51
b4 2e 6e 7e a0 b4 2e a5
57 b7 :2 19 3c b7 :4 a0 7e 51
b4 2e 6e 7e a0 b4 2e 7e
6e b4 2e 7e a0 b4 2e 7e
6e b4 2e a5 57 b7 a6 9
a4 b1 11 4f a0 57 a0 b4
e9 b7 a4 b1 11 68 4f 9a
8f a0 b0 3d 8f a0 b0 3d
8f a0 b0 3d 8f a0 b0 3d
8f a0 4d b0 3d 8f a0 4d
b0 3d 8f a0 4d b0 3d b4
a3 55 6a a0 51 a5 1c 81
b0 a3 a0 51 a5 1c 6e 81
b0 :2 a0 d a0 7e b4 2e :2 a0
7e 6e b4 2e 7e a0 b4 2e
d b7 19 3c a0 6e 7e a0
b4 2e 7e 6e b4 2e d a0
57 a0 b4 e9 a0 7e 6e b4
2e a0 3e :2 6e 5 48 a 10
a0 65 b7 19 3c :2 a0 a5 b
7e 6e b4 2e a0 7e 51 b4
2e a0 6e 7e a0 b4 2e 7e
6e b4 2e d a0 b7 a0 7e
51 b4 2e a0 6e 7e a0 b4
2e 7e 6e b4 2e d b7 :2 19
3c b7 19 3c :2 a0 a5 b 7e
6e b4 2e a0 :4 51 6e 7e a0
b4 2e 7e 6e b4 2e 7e a0
b4 2e 7e 6e b4 2e 7e a0
b4 2e 7e 6e b4 2e 7e a0
b4 2e 6e a5 57 a0 b7 :2 a0
a5 b 7e 6e b4 2e a0 :4 51
6e 7e a0 b4 2e 7e 6e b4
2e 7e a0 b4 2e 7e 6e b4
2e 7e a0 b4 2e 7e 6e b4
2e 7e a0 b4 2e 6e a5 57
a0 b7 19 :2 a0 a5 b 7e 6e
b4 2e a0 :4 51 6e 7e a0 b4
2e 7e 6e b4 2e 7e a0 b4
2e 7e 6e b4 2e 7e a0 b4
2e 6e a5 57 b7 19 a0 7e
51 b4 2e 6e 7e a0 b4 2e
a5 57 b7 :2 19 3c b7 :7 a0 7e
51 b4 2e 6e 7e a0 b4 2e
7e 6e b4 2e 7e a0 b4 2e
7e 6e b4 2e a5 57 b7 a6
9 a4 b1 11 4f a0 57 a0
b4 e9 b7 a4 b1 11 68 4f
b1 b7 a4 11 b1 56 4f 17
b5 
371
2
0 3 7 8 14 1c 13 10
c 22 26 2a 2d 30 31 36
37 3a 40 41 44 48 4c 50
53 56 57 5c 5d 60 66 67
6a 6e 72 76 79 7c 7d 82
83 86 8c 8d 90 94 98 9c
9f a2 a3 a8 a9 ac b2 b3
b6 ba be c2 c5 c8 c9 ce
cf d2 d8 d9 dc e0 e4 e8
eb ee ef f4 f5 f8 fe ff
102 106 10a 10e 111 114 115 11a
11b 11e 133 12f 12e 13a 147 143
12d 14e 157 153 142 15e 16b 167
141 172 17b 177 166 182 18f 18b
165 196 18a 19b 19f 1a3 1a7 1ab
1af 189 1b3 1b6 1cb 1c7 1c6 1d2
1df 1db 1c5 1e6 1ef 1eb 1da 1f6
1d9 21a 1ff 203 207 20b 20e 20f
216 1fe 235 225 1fb 229 22a 231
224 250 240 221 244 245 24c 23f
26b 25b 23c 25f 260 267 25a 286
276 257 27a 27b 282 275 2a1 291
272 295 296 29d 290 2bc 2ac 28d
2b0 2b1 2b8 2ab 2d6 2c7 2cb 2d2
2aa 2ec 2dd 2e1 2e8 2c6 2f3 2f7
2fb 2ff 303 307 30b 2c3 30f 310
315 319 31d 320 324 325 32a 32d
331 332 337 2a8 33b 33f 342 346
34a 34d 351 352 357 35a 35e 35f
364 368 36c 370 373 377 37a 37e
382 386 38a 38e 392 393 1d7 398
39c 3a0 3a4 3a7 3aa 3ab 3b0 3b4
3b7 3bb 3bc 3c1 3c4 3c8 3c9 3ce
3d1 3d5 3d6 3db 3de 3e2 3e3 3e8
3e9 1c3 3ee 3ef 3f4 187 3f8 163
403 407 40a 40b 410 414 417 418
1 41d 422 425 429 42c 42f 430
435 439 43c 440 441 446 449 44d
44e 453 456 45a 45b 460 461 13f
466 46a 46d 471 474 478 479 47e
1 482 486 48a 48e 492 1 495
49a 49e 12b 4a2 4a6 4a9 4ad 4b1
4b5 4b6 4b8 4bc 4c0 4c5 4c9 4ca
4cf 4d3 4d6 4da 4db 4e0 4e4 4e7
4ea 4ed 4f0 4f4 4f7 4fb 4fc 501
504 508 509 50e 512 513 518 51c
51e 522 525 529 52a 52f 533 536
539 53c 53f 543 546 54a 54b 550
553 557 558 55d 561 562 567 56b
56d 571 575 578 57c 57d 582 586
589 58c 58f 592 596 599 59d 59e
5a3 5a6 5aa 5ab 5b0 5b4 5b5 5ba
5be 5c0 5c4 5c8 5cb 5cf 5d0 5d5
5d9 5dc 5e0 5e1 1 5e6 5eb 5ef
5f2 5f5 5f8 5fb 5ff 602 606 607
60c 60f 613 614 619 61c 620 621
626 629 62d 62e 633 637 638 63d
63f 643 647 64a 64d 64e 653 657
65a 65e 65f 664 665 66a 66c 670
674 677 679 67d 681 685 689 68c
68f 690 695 699 69c 6a0 6a1 6a6
6a9 6ad 6ae 6b3 6b6 6ba 6bb 6c0
6c3 6c7 6c8 6cd 6ce 6d3 6d5 6d6
6db 6df 6e1 6ec 6ee 6f2 6f7 6fb
6fc 701 703 707 709 714 718 71a
72f 72b 72a 736 743 73f 729 74a
753 74f 73e 75a 767 763 73d 76e
777 773 1 762 77e 78b 787 1
761 792 79b 797 1 786 7a2 785
7c6 7ab 7af 7b3 7b7 7ba 7bb 7c2
7aa 7e5 7d1 7a7 7d5 7d6 7dd 7e1
7d0 7ec 7f0 7f4 7f8 7cd 7fc 7fd
802 806 80a 80d 811 812 817 81a
81e 81f 824 783 828 82c 82f 833
837 83a 83e 83f 844 847 84b 84c
851 855 859 85e 862 863 868 86c
86f 873 874 879 1 87d 881 885
889 1 88c 891 895 75f 899 89d
8a0 8a4 8a8 73b 8a9 8ac 8b0 8b1
8b6 8ba 8bd 8c0 8c1 8c6 8ca 8ce
8d1 8d5 8d6 8db 8de 8e2 8e3 8e8
8ec 727 8f0 8f4 8f7 8fa 8fb 900
904 908 90b 90f 910 915 918 91c
91d 922 926 928 92c 930 933 935
939 93c 940 944 945 947 94a 94e
94f 954 958 95b 95e 961 964 968
96b 96f 970 975 978 97c 97d 982
985 989 98a 98f 992 996 997 99c
99f 9a3 9a4 9a9 9ac 9b0 9b1 9b6
9b9 9bd 9be 9c3 9c7 9c8 9cd 9d1
9d3 9d7 9db 9dc 9de 9e1 9e5 9e6
9eb 9ef 9f2 9f5 9f8 9fb 9ff a02
a06 a07 a0c a0f a13 a14 a19 a1c
a20 a21 a26 a29 a2d a2e a33 a36
a3a a3b a40 a43 a47 a48 a4d a50
a54 a55 a5a a5e a5f a64 a68 a6a
a6e a72 a76 a77 a79 a7c a80 a81
a86 a8a a8d a90 a93 a96 a9a a9d
aa1 aa2 aa7 aaa aae aaf ab4 ab7
abb abc ac1 ac4 ac8 ac9 ace ad1
ad5 ad6 adb adf ae0 ae5 ae7 aeb
aef af2 af5 af6 afb aff b02 b06
b07 b0c b0d b12 b14 b18 b1c b1f
b21 b25 b29 b2d b31 b35 b39 b3d
b40 b43 b44 b49 b4d b50 b54 b55
b5a b5d b61 b62 b67 b6a b6e b6f
b74 b77 b7b b7c b81 b82 b87 b89
b8a b8f b93 b95 ba0 ba2 ba6 bab
baf bb0 bb5 bb7 bbb bbd bc8 bcc
bce bd0 bd2 bd6 be1 be3 be6 be8
bef 
371
2
0 :2 1 9 e :4 3 a 19 :4 25
:6 3 a 19 :4 25 :6 3 a 19 :4 25
:6 3 a 19 :4 25 :6 3 a 19 :4 25
:6 3 a 19 :4 25 :6 3 a 19 :4 22
:2 3 d 19 27 :2 19 37 40 :2 37
7 12 :2 7 22 2f :2 22 3f 44
:2 3f 7 12 :2 7 18 :2 3 5 c
17 1a :2 5 d 1b 20 :2 1b 2a
31 :2 2a 3b 40 :2 3b 1a 5 :2 3
10 19 18 :2 10 :2 5 10 19 18
:2 10 :2 5 10 19 18 :2 10 :2 5 10
19 18 :2 10 :2 5 10 19 18 :2 10
:2 5 10 19 18 :2 10 :2 5 10 19
18 :2 10 :2 5 :3 10 :2 5 :3 10 :2 5 10
:2 5 e 5 :4 8 7 10 18 1b
:2 10 21 24 :2 10 7 1c :3 5 e
12 15 :2 e 1b 1e :2 e 5 7
:2 14 21 28 2b 32 39 40 21
2d :2 7 5 14 22 7 1f 20
:2 1f 27 3c 3f :2 27 44 47 :2 27
9 c :2 27 12 15 :2 27 :2 7 2a
:2 f 5 :3 3 :4 9 :4 1a :2 9 8 7
1f 20 :2 1f 27 40 43 :2 27 48
9 :2 27 d 10 :2 27 :2 7 2e :2 5
8 e 10 :4 e 18 29 35 :2 e
:2 8 :2 7 41 :3 5 e 14 :2 e :6 5
a 10 12 :2 10 9 15 18 1b
1e 21 32 35 :2 21 3b 3e :2 21
b :2 9 7 21 d 13 15 :2 13
b 17 1a 1d 20 23 34 37
:2 23 3d 7 :2 23 21 :2 b 7 2d
21 d 13 15 :2 13 9 15 18
1b 1e 21 32 35 :2 21 3b 3e
:2 21 b :2 9 7 1f 21 d 13
15 :2 13 24 2a 2c :2 2a :2 d 9
15 18 1b 1e 21 2a 2d :2 21
33 36 :2 21 3a 3d :2 21 43 46
:2 21 b :2 9 37 21 9 21 22
:2 21 29 46 48 :2 29 :2 9 :4 7 5
14 22 30 7 1f 20 :2 1f 27
3c 3f :2 27 44 47 :2 27 9 c
:2 27 12 15 :2 27 :2 7 38 :2 f 5
:3 3 :5 5 :6 3 d 6 b :2 6 15
1c :2 15 26 2b :2 26 35 3c :2 35
6 14 23 :3 6 17 26 :2 6 2c
37 48 :2 2c :2 5 :2 3 c 15 14
:2 c :2 5 c 15 14 c 1c c
:2 5 e 5 :4 8 7 10 17 1a
:2 10 20 23 :2 10 7 1b :3 5 e
12 15 :2 e 1b 1e :2 e :6 5 8
f 11 :2 f :2 1b 24 2c :2 1b :2 8
:2 39 34 :2 5 8 e :2 8 16 18
:2 16 a 18 1b :2 18 9 13 1c
1e :2 13 2b 2d :2 13 9 7 1d
d 1e 21 :2 1e 9 13 1c 1e
:2 13 2e 30 :2 13 9 23 1d :2 7
23 :2 5 a 10 :2 a 16 18 :2 16
9 15 18 1b 1e b 1d 1f
:2 b 24 26 :2 b 29 2b :2 b 31
33 :2 b 41 43 :3 b e :2 b 12
14 :3 b :2 9 7 22 d 13 :2 d
19 1b :2 19 9 15 18 1b 1e
b 1b 1d :2 b 22 24 :2 b 27
29 :2 b 2f 31 :2 b 3f 41 :3 b
e :2 b 12 14 :3 b :2 9 7 23
22 d 13 :2 d 19 1b :2 19 9
15 18 1b 1e b 1b 1d :2 b
22 24 :2 b 27 29 :2 b 2f 31
:2 b 3f 41 :3 b :2 9 23 22 9
21 22 :2 21 29 47 4a :2 29 :2 9
:4 7 5 14 22 30 3e a 18
7 1f 20 :2 1f 27 3c 3f :2 27
44 47 :2 27 9 c :2 27 12 15
:2 27 :2 7 20 :2 f 5 :3 3 :5 5 :a 3
:5 1 
371
2
0 :4 1 :3 2 :9 3 :3 4 :9 5 :3 6 :9 7
:3 8 :9 9 :3 a :9 b :3 c :9 d :3 e :9 f
:9 12 :c 13 :4 14 :3 12 :6 15 :e 17 18 :2 17
:6 18 :7 19 :7 1a :7 1b :7 1c :7 1d :7 1e :5 1f
:5 20 :3 22 :3 23 :4 24 :b 25 :3 24 :b 27 :9 2c
:2 2d :2 2c 29 :2 2e :e 2f :2 30 :2 2f :2 30
:4 2f :4 2e :3 21 :b 33 :b 34 35 :2 34 :2 35
:4 34 :3 33 :5 37 :7 38 :2 37 :2 39 38 :2 37
:6 3c :5 3d :5 41 :e 42 43 :2 42 44 41
:5 44 :b 45 46 :2 45 46 :2 45 47 44
41 :5 47 :e 48 49 :2 48 4a 47 41
:c 4a :16 4b 4c :2 4b 4a 41 :c 4e :2 4d
:2 41 40 :3 50 :e 51 :2 52 :2 51 :2 52 :4 51
:4 50 :3 21 :5 54 :2 21 :4 17 57 :10 58 :5 59
:a 5a 58 5b :2 57 :6 5b :8 5c :3 5e :4 5f
:b 60 :3 5f :b 62 :5 64 :12 67 :8 69 :5 6a :b 6b
6c 6a :5 6c :b 6d 6c :3 6a :3 69 :8 72
:5 73 :15 74 :2 75 :2 74 :2 75 :2 74 76 :2 73
77 72 :8 77 :5 78 :15 79 :2 7a :2 79 :2 7a
:2 79 7b :2 78 7c 77 72 :8 7c :5 7d
:15 7e 7f :2 7d 7c 72 :c 81 :2 80 :2 72
71 :4 83 :2 84 :e 85 :2 86 :2 85 :2 86 :4 85
84 :3 83 :3 5d :5 88 :2 5d :4 57 :4 17 :5 1

bf1
2
:3 0 1 :4 0 2 :3 0 5 :3 0 6
0 36c :2 3 :6 0 1 4 :5 0 6
:3 0 4 5 :2 0 7 :2 0 8 :2 0
5 b d :3 0 7 9 f 36c
9 :5 0 a 12 0 36c 5 :3 0
6 :3 0 9 11 :2 0 7 :2 0 a
:2 0 c 17 19 :3 0 e 15 1b
36c b :5 0 11 1e 0 36c 5
:3 0 6 :3 0 b 1d :2 0 7 :2 0
c :2 0 13 23 25 :3 0 15 21
27 36c d :5 0 18 2a 0 36c
5 :3 0 6 :3 0 d 29 :2 0 7
:2 0 e :2 0 1a 2f 31 :3 0 1c
2d 33 36c f :5 0 1f 36 0
36c 5 :3 0 6 :3 0 f 35 :2 0
7 :2 0 10 :2 0 21 3b 3d :3 0
23 39 3f 36c 11 :5 0 26 42
0 36c 5 :3 0 6 :3 0 11 41
:2 0 7 :2 0 12 :2 0 28 47 49
:3 0 2a 45 4b 36c 13 :5 0 2d
4e 0 36c 5 :3 0 6 :3 0 13
4d :2 0 7 :2 0 14 :2 0 2f 53
55 :3 0 31 51 57 36c 15 :a 0
74 2 bf 14b 36 34 17 :3 0
16 :6 0 5c 5b :3 0 bb 138 3a
38 17 :3 0 18 :6 0 60 5f :3 0
17 :3 0 19 :6 0 64 63 :5 0 3e
3c 17 :3 0 1a :6 0 68 67 :3 0
1c :3 0 1b :6 0 6c 6b :4 0 116
47 40 1c :3 0 1d :6 0 70 6f
:3 0 72 :2 0 74 59 73 0 36c
5 :3 0 1e :3 0 1f :3 0 15 59
:2 0 76 79 36c 20 :a 0 205 3
a2 113 4c 4a 1c :3 0 21 :6 0
7e 7d :3 0 8f 116 50 4e 1c
:3 0 22 :6 0 82 81 :3 0 1c :3 0
23 :6 0 86 85 :3 0 25 :2 0 56
88 :2 0 205 7b 8a :2 0 1c :3 0
25 :2 0 54 8c 8e :5 0 91 8f
0 203 24 :6 0 28 :2 0 5a 1c
:3 0 58 93 95 :5 0 98 96 0
203 26 :6 0 25 :2 0 5e 1c :3 0
5c 9a 9c :5 0 9f 9d 0 203
27 :6 0 25 :2 0 62 1c :3 0 60
a1 a3 :5 0 a6 a4 0 203 29
:6 0 25 :2 0 66 1c :3 0 64 a8
aa :5 0 ad ab 0 203 2a :6 0
25 :2 0 6a 1c :3 0 68 af b1
:5 0 b4 b2 0 203 2b :6 0 7c
dc 70 6e 1c :3 0 6c b6 b8
:5 0 bb b9 0 203 2c :6 0 30
:2 0 72 2e :3 0 bd :6 0 c0 be
0 203 2d :6 0 2e :3 0 c2 :6 0
c5 c3 0 203 2f :6 0 26 :3 0
22 :3 0 c6 c7 0 201 27 :3 0
23 :3 0 c9 ca 0 201 26 :3 0
74 cd ce :3 0 27 :3 0 26 :3 0
31 :2 0 32 :3 0 76 d2 d4 :3 0
31 :2 0 27 :3 0 79 d6 d8 :3 0
d0 d9 0 db cf db 0 dd
7e 0 201 27 :3 0 33 :3 0 31
:2 0 27 :3 0 80 e0 e2 :3 0 31
:2 0 33 :3 0 83 e4 e6 :3 0 de
e7 0 201 34 :3 0 35 :3 0 e9
ea 0 27 :3 0 36 :2 0 29 :3 0
2a :3 0 2b :3 0 2c :3 0 2d :3 0
2f :3 0 86 eb f4 :2 0 f6 d
:3 0 13 :3 0 37 :3 0 7 :2 0 38
:2 0 91 fa fc :3 0 39 :3 0 31
:2 0 21 :3 0 93 ff 101 :3 0 31
:2 0 3a :3 0 96 103 105 :3 0 31
:2 0 27 :3 0 99 107 109 :3 0 31
:2 0 3b :3 0 9c 10b 10d :3 0 9f
f9 10f :2 0 111 a4 112 111 :2 0
114 a7 :2 0 116 115 f6 114 :6 0
201 3 2f :3 0 3c :2 0 a9 119
11a :3 0 2c :3 0 30 :2 0 ab 11d
11e :3 0 11b 120 11f :2 0 121 :2 0
37 :3 0 7 :2 0 3d :2 0 ad 124
126 :3 0 3e :3 0 31 :2 0 21 :3 0
af 129 12b :3 0 31 :2 0 3a :3 0
b2 12d 12f :3 0 31 :2 0 27 :3 0
b5 131 133 :3 0 b8 123 135 :2 0
137 122 137 0 139 bd 0 201
29 :3 0 3f :2 0 40 :3 0 c1 13b
13d :3 0 2a :3 0 41 :3 0 42 :3 0
3 :3 0 c4 :3 0 13f 140 144 13e
146 145 :2 0 43 :6 0 14a 147 14a
0 14c c8 0 201 24 :3 0 44
:3 0 21 :3 0 ca 14e 150 14d 151
0 201 45 :3 0 155 156 :2 0 157
45 :5 0 154 :2 0 201 24 :3 0 3f
:2 0 46 :3 0 ce 159 15b :3 0 15
:3 0 47 :2 0 47 :2 0 47 :2 0 36
:2 0 48 :3 0 31 :2 0 27 :3 0 d1
163 165 :3 0 31 :2 0 49 :3 0 d4
167 169 :3 0 4a :3 0 d7 15d 16c
:2 0 16f 4b :3 0 cc 1d7 24 :3 0
3f :2 0 4c :3 0 e0 171 173 :3 0
15 :3 0 47 :2 0 47 :2 0 47 :2 0
36 :2 0 48 :3 0 31 :2 0 27 :3 0
e3 17b 17d :3 0 31 :2 0 4d :3 0
e6 17f 181 :3 0 4a :3 0 e9 175
184 :2 0 187 4b :3 0 de 188 174
187 0 1d8 24 :3 0 3f :2 0 1
:3 0 f2 18a 18c :3 0 15 :3 0 47
:2 0 47 :2 0 47 :2 0 36 :2 0 48
:3 0 31 :2 0 27 :3 0 f5 194 196
:3 0 31 :2 0 4e :3 0 f8 198 19a
:3 0 4a :3 0 fb 18e 19d :2 0 1a0
4b :3 0 f0 1a1 18d 1a0 0 1d8
24 :3 0 3f :2 0 4f :3 0 104 1a3
1a5 :3 0 24 :3 0 3f :2 0 50 :3 0
107 1a8 1aa :3 0 1a6 1ac 1ab :2 0
15 :3 0 47 :2 0 47 :2 0 47 :2 0
36 :2 0 51 :3 0 31 :2 0 24 :3 0
10a 1b4 1b6 :3 0 31 :2 0 3a :3 0
10d 1b8 1ba :3 0 31 :2 0 27 :3 0
110 1bc 1be :3 0 31 :2 0 4e :3 0
113 1c0 1c2 :3 0 52 :3 0 116 1ae
1c5 :2 0 1c7 102 1c8 1ad 1c7 0
1d8 37 :3 0 7 :2 0 3d :2 0 11d
1ca 1cc :3 0 53 :3 0 31 :2 0 24
:3 0 11f 1cf 1d1 :3 0 122 1c9 1d3
:2 0 1d5 125 1d6 0 1d5 0 1d8
15c 16f 0 1d8 127 0 1d9 12d
1fa 9 :3 0 b :3 0 13 :3 0 37
:3 0 7 :2 0 38 :2 0 12f 1de 1e0
:3 0 39 :3 0 31 :2 0 21 :3 0 131
1e3 1e5 :3 0 31 :2 0 3a :3 0 134
1e7 1e9 :3 0 31 :2 0 27 :3 0 137
1eb 1ed :3 0 31 :2 0 3b :3 0 13a
1ef 1f1 :3 0 13d 1dd 1f3 :2 0 1f5
140 1f7 142 1f6 1f5 :2 0 1f8 146
:2 0 1fa 0 1fa 1f9 1d9 1f8 :6 0
201 3 :2 0 45 :3 0 1fe 1ff :2 0
200 45 :5 0 1fd :2 0 201 148 204
:3 0 204 154 204 203 201 202 :6 0
205 1 7b 8a 204 36c :2 0 54
:a 0 366 6 19a 29c 160 15e 1c
:3 0 21 :6 0 20a 209 :3 0 270 272
164 162 1c :3 0 22 :6 0 20e 20d
:3 0 1c :3 0 23 :6 0 212 211 :3 0
18e 26e 168 166 1c :3 0 55 :6 0
216 215 :3 0 2e :3 0 56 :6 0 21b
219 21a :2 0 184 24c 16c 16a 2e
:3 0 57 :6 0 220 21e 21f :2 0 1c
:3 0 58 :6 0 225 223 224 :2 0 25
:2 0 176 227 :2 0 366 207 229 :2 0
1c :3 0 28 :2 0 174 22b 22d :5 0
230 22e 0 364 59 :6 0 30 :2 0
17a 1c :3 0 178 232 234 :5 0 5b
:3 0 238 235 236 364 5a :6 0 59
:3 0 23 :3 0 239 23a 0 362 22
:3 0 17c 23d 23e :3 0 59 :3 0 22
:3 0 31 :2 0 32 :3 0 17e 242 244
:3 0 31 :2 0 23 :3 0 181 246 248
:3 0 240 249 0 24b 23f 24b 0
24d 186 0 362 59 :3 0 33 :3 0
31 :2 0 59 :3 0 188 250 252 :3 0
31 :2 0 33 :3 0 18b 254 256 :3 0
24e 257 0 362 45 :3 0 25b 25c
:2 0 25d 45 :5 0 25a :2 0 362 22
:3 0 3f :2 0 40 :3 0 190 25f 261
:3 0 23 :3 0 5c :3 0 5d :3 0 193
:3 0 263 264 267 262 269 268 :2 0
43 :6 0 26d 26a 26d 0 26f 196
0 362 44 :3 0 55 :3 0 198 3f
:2 0 5e :3 0 19c 274 276 :3 0 56
:3 0 5f :2 0 47 :2 0 19f 279 27b
:3 0 5a :3 0 60 :3 0 31 :2 0 56
:3 0 1a2 27f 281 :3 0 31 :2 0 61
:3 0 1a5 283 285 :3 0 27d 286 0
289 4b :3 0 57 :3 0 5f :2 0 47
:2 0 1aa 28b 28d :3 0 5a :3 0 60
:3 0 31 :2 0 57 :3 0 1ad 291 293
:3 0 31 :2 0 62 :3 0 1b0 295 297
:3 0 28f 298 0 29a 1a8 29b 28e
29a 0 29d 27c 289 0 29d 1b3
0 29e 1b6 29f 277 29e 0 2a0
1b8 0 362 44 :3 0 21 :3 0 1ba
2a1 2a3 3f :2 0 63 :3 0 1be 2a5
2a7 :3 0 15 :3 0 47 :2 0 47 :2 0
47 :2 0 36 :2 0 64 :3 0 31 :2 0
59 :3 0 1c1 2af 2b1 :3 0 31 :2 0
3a :3 0 1c4 2b3 2b5 :3 0 31 :2 0
55 :3 0 1c7 2b7 2b9 :3 0 31 :2 0
65 :3 0 1ca 2bb 2bd :3 0 31 :2 0
5a :3 0 1cd 2bf 2c1 :3 0 31 :2 0
3a :3 0 1d0 2c3 2c5 :3 0 31 :2 0
58 :3 0 1d3 2c7 2c9 :3 0 66 :3 0
1d6 2a9 2cc :2 0 2cf 4b :3 0 1bc
335 44 :3 0 21 :3 0 1dd 2d0 2d2
3f :2 0 67 :3 0 1e1 2d4 2d6 :3 0
15 :3 0 47 :2 0 47 :2 0 47 :2 0
36 :2 0 68 :3 0 31 :2 0 59 :3 0
1e4 2de 2e0 :3 0 31 :2 0 3a :3 0
1e7 2e2 2e4 :3 0 31 :2 0 55 :3 0
1ea 2e6 2e8 :3 0 31 :2 0 65 :3 0
1ed 2ea 2ec :3 0 31 :2 0 5a :3 0
1f0 2ee 2f0 :3 0 31 :2 0 3a :3 0
1f3 2f2 2f4 :3 0 31 :2 0 58 :3 0
1f6 2f6 2f8 :3 0 69 :3 0 1f9 2d8
2fb :2 0 2fe 4b :3 0 1df 2ff 2d7
2fe 0 336 44 :3 0 21 :3 0 200
300 302 3f :2 0 6a :3 0 204 304
306 :3 0 15 :3 0 47 :2 0 47 :2 0
47 :2 0 36 :2 0 6b :3 0 31 :2 0
59 :3 0 207 30e 310 :3 0 31 :2 0
3a :3 0 20a 312 314 :3 0 31 :2 0
55 :3 0 20d 316 318 :3 0 31 :2 0
65 :3 0 210 31a 31c :3 0 31 :2 0
5a :3 0 213 31e 320 :3 0 6c :3 0
216 308 323 :2 0 325 202 326 307
325 0 336 37 :3 0 7 :2 0 3d
:2 0 21d 328 32a :3 0 53 :3 0 31
:2 0 21 :3 0 21f 32d 32f :3 0 222
327 331 :2 0 333 225 334 0 333
0 336 2a8 2cf 0 336 227 0
337 22c 35b 4 :3 0 9 :3 0 b
:3 0 f :3 0 11 :3 0 13 :3 0 37
:3 0 7 :2 0 38 :2 0 22e 33f 341
:3 0 6d :3 0 31 :2 0 21 :3 0 230
344 346 :3 0 31 :2 0 3a :3 0 233
348 34a :3 0 31 :2 0 59 :3 0 236
34c 34e :3 0 31 :2 0 3b :3 0 239
350 352 :3 0 23c 33e 354 :2 0 356
23f 358 241 357 356 :2 0 359 248
:2 0 35b 0 35b 35a 337 359 :6 0
362 6 :2 0 45 :3 0 35f 360 :2 0
361 45 :5 0 35e :2 0 362 24a 365
:3 0 365 253 365 364 362 363 :6 0
366 1 207 229 365 36c :3 0 36b
0 36b :3 0 36b 36c 369 36a :6 0
36d 0 256 0 4 36b 36f :2 0
2 36d 370 :6 0 
269
2
:3 0 1 5 1 c 2 a e
1 11 1 18 2 16 1a 1
1d 1 24 2 22 26 1 29
1 30 2 2e 32 1 35 1
3c 2 3a 3e 1 41 1 48
2 46 4a 1 4d 1 54 2
52 56 1 5a 1 5e 1 62
1 66 1 6a 1 6e 6 5d
61 65 69 6d 71 2 77 78
1 7c 1 80 1 84 3 7f
83 87 1 8d 1 89 1 94
1 92 1 9b 1 99 1 a2
1 a0 1 a9 1 a7 1 b0
1 ae 1 b7 1 b5 1 bc
1 c1 1 cc 2 d1 d3 2
d5 d7 1 da 1 dc 2 df
e1 2 e3 e5 8 ec ed ee
ef f0 f1 f2 f3 1 f5 1
fb 2 fe 100 2 102 104 2
106 108 2 10a 10c 2 fd 10e
1 110 2 f7 f8 1 113 1
118 1 11c 1 125 2 128 12a
2 12c 12e 2 130 132 2 127
134 1 136 1 138 1 149 2
13a 13c 3 141 142 143 1 14b
1 14f 1 16d 2 158 15a 2
162 164 2 166 168 6 15e 15f
160 161 16a 16b 1 185 2 170
172 2 17a 17c 2 17e 180 6
176 177 178 179 182 183 1 19e
2 189 18b 2 193 195 2 197
199 6 18f 190 191 192 19b 19c
1 1c6 2 1a2 1a4 2 1a7 1a9
2 1b3 1b5 2 1b7 1b9 2 1bb
1bd 2 1bf 1c1 6 1af 1b0 1b1
1b2 1c3 1c4 1 1cb 2 1ce 1d0
2 1cd 1d2 1 1d4 5 1d7 188
1a1 1c8 1d6 1 1d8 1 1df 2
1e2 1e4 2 1e6 1e8 2 1ea 1ec
2 1ee 1f0 2 1e1 1f2 1 1f4
3 1da 1db 1dc 1 1f7 b c8
cb dd e8 116 139 14c 152 157
1fa 200 9 90 97 9e a5 ac
b3 ba bf c4 1 208 1 20c
1 210 1 214 1 218 1 21d
1 222 7 20b 20f 213 217 21c
221 226 1 22c 1 228 1 233
1 231 1 23c 2 241 243 2
245 247 1 24a 1 24c 2 24f
251 2 253 255 1 26c 2 25e
260 2 265 266 1 26e 1 271
1 287 2 273 275 2 278 27a
2 27e 280 2 282 284 1 299
2 28a 28c 2 290 292 2 294
296 2 29c 29b 1 29d 1 29f
1 2a2 1 2cd 2 2a4 2a6 2
2ae 2b0 2 2b2 2b4 2 2b6 2b8
2 2ba 2bc 2 2be 2c0 2 2c2
2c4 2 2c6 2c8 6 2aa 2ab 2ac
2ad 2ca 2cb 1 2d1 1 2fc 2
2d3 2d5 2 2dd 2df 2 2e1 2e3
2 2e5 2e7 2 2e9 2eb 2 2ed
2ef 2 2f1 2f3 2 2f5 2f7 6
2d9 2da 2db 2dc 2f9 2fa 1 301
1 324 2 303 305 2 30d 30f
2 311 313 2 315 317 2 319
31b 2 31d 31f 6 309 30a 30b
30c 321 322 1 329 2 32c 32e
2 32b 330 1 332 4 335 2ff
326 334 1 336 1 340 2 343
345 2 347 349 2 34b 34d 2
34f 351 2 342 353 1 355 6
338 339 33a 33b 33c 33d 1 358
8 23b 24d 258 25d 26f 2a0 35b
361 2 22f 237 12 7 10 13
1c 1f 28 2b 34 37 40 43
4c 4f 58 74 7a 205 366 
1
4
0 
36f
1
1
14
7
26
0 1 1 3 3 1 6 0
0 0 0 0 0 0 0 0
0 0 0 0 
207 1 6
210 6 0
84 3 0
59 1 2
bc 3 0
92 3 0
c1 3 0
6e 2 0
62 2 0
89 3 0
6a 2 0
4d 1 0
5 1 0
11 1 0
1d 1 0
29 1 0
35 1 0
a7 3 0
41 1 0
ae 3 0
5e 2 0
231 6 0
214 6 0
208 6 0
7c 3 0
b5 3 0
4 0 1
218 6 0
228 6 0
21d 6 0
222 6 0
7b 1 3
99 3 0
66 2 0
a0 3 0
5a 2 0
20c 6 0
80 3 0
0

/
create or replace view order_object_by_dependency (dlevel, object_id) as
       select max(level), object_id from public_dependency
       connect by object_id = prior referenced_object_id
       group by object_id
/
create or replace view dba_analyze_objects (owner, object_name, object_type) as
       select u.name, o.name, decode(o.type, 2, 'TABLE', 3, 'CLUSTER')
       from sys.user$ u, sys.obj$ o, sys.tab$ t
       where o.owner# = u.user#
       and   o.obj# = t.obj# (+)
       and   t.clu# is null
       and   o.type in (2,3)
/
create or replace package body dbms_utility wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
95a425ff
1
4
0 
81
7 PACKAGE:
4 BODY:
c DBMS_UTILITY:
8 FUNCTION:
b IS_PARALLEL:
6 RETURN:
e BINARY_INTEGER:
6 PRAGMA:
9 INTERFACE:
1 C:
c ICD_GET_TIME:
c ICD_NAME_RES:
4 NAME:
8 VARCHAR2:
7 CONTEXT:
6 SCHEMA:
3 OUT:
5 PART1:
5 PART2:
6 DBLINK:
a PART1_TYPE:
d OBJECT_NUMBER:
11 ICD_NAME_TOKENIZE:
1 A:
1 B:
7 NEXTPOS:
6 PSDPOR:
7 ICD_DBA:
4 FILE:
5 BLOCK:
c ICD_DBA_FILE:
3 DBA:
d ICD_DBA_BLOCK:
8 ICD_HASH:
4 BASE:
9 HASH_SIZE:
c NAME_RESOLVE:
6 NUMBER:
2 !=:
1 1:
1 3:
17 RAISE_APPLICATION_ERROR:
1 -:
5 20005:
2a ORU-10034:: context argument must be 1 or 3:
d NAME_TOKENIZE:
e COMMA_TO_TABLE:
4 LIST:
6 TABLEN:
3 TAB:
a UNCL_ARRAY:
6 OLDPOS:
4 DONE:
7 BOOLEAN:
1 I:
3 LEN:
5 DUMMY:
3 128:
5 FALSE:
3 NVL:
7 LENGTHB:
1 0:
5 WHILE:
4 LOOP:
3 NOT:
7 SUBSTRB:
1 +:
1 >:
4 TRUE:
5 ELSIF:
1 =:
1 ,:
5 20001:
22 comma-separated list invalid near :
2 ||:
1 2:
1 5:
e TABLE_TO_COMMA:
4 TEMP:
4 6500:
0 b IS NOT NULL:
d NO_DATA_FOUND:
8 GET_TIME:
12 IS_PARALLEL_SERVER:
e COMPILE_SCHEMA:
14 NOT_EXIST_OR_NO_PRIV:
e EXCEPTION_INIT:
5 20000:
6 CURSOR:
2 C1:
b OBJECT_TYPE:
b OBJECT_NAME:
6 STATUS:
3 SYS:
1a ORDER_OBJECT_BY_DEPENDENCY:
1 P:
b DBA_OBJECTS:
9 OBJECT_ID:
5 OWNER:
9 PROCEDURE:
c PACKAGE BODY:
6 DLEVEL:
3 REC:
c DBMS_SESSION:
10 DBMS_TRANSACTION:
8 DBMS_DDL:
d ALTER_COMPILE:
15 PACKAGE SPECIFICATION:
3e You have insufficient privileges for an object in this schema.:
d RESET_PACKAGE:
e ANALYZE_SCHEMA:
6 METHOD:
d ESTIMATE_ROWS:
10 ESTIMATE_PERCENT:
a METHOD_OPT:
13 DBA_ANALYZE_OBJECTS:
1 x:
5 USER$:
6 user ':
10 ' does not exist:
e ANALYZE_OBJECT:
10 ANALYZE_DATABASE:
40 You have insufficient privileges for an object in this database.:
b PORT_STRING:
17 MAKE_DATA_BLOCK_ADDRESS:
17 DATA_BLOCK_ADDRESS_FILE:
18 DATA_BLOCK_ADDRESS_BLOCK:
e GET_HASH_VALUE:
0

0
0
577
2
0 a0 1d a0 97 a0 8d a0
b4 a0 2c 6a :4 a0 b4 5d a0
8d a0 b4 a0 2c 6a :4 a0 b4
5d 9a 8f a0 b0 3d 8f a0
b0 3d 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 b4 55 6a :4 a0 b4 5d
9a 8f a0 b0 3d 96 :2 a0 b0
54 96 :2 a0 b0 54 96 :2 a0 b0
54 96 :2 a0 b0 54 96 :2 a0 b0
54 b4 55 6a :4 a0 b4 5d a0
8d a0 b4 a0 2c 6a :4 a0 b4
5d a0 8d 8f a0 b0 3d 8f
a0 b0 3d b4 :2 a0 2c 6a :4 a0
b4 5d a0 8d 8f a0 b0 3d
b4 :2 a0 2c 6a :4 a0 b4 5d a0
8d 8f a0 b0 3d b4 :2 a0 2c
6a :4 a0 b4 5d a0 8d 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d b4 :2 a0 2c 6a :4 a0 b4
5d 9a 8f a0 b0 3d 8f a0
b0 3d 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 b4 55 6a a0 7e 51
b4 2e a0 7e 51 b4 2e a
10 a0 7e 51 b4 2e 6e a5
57 b7 19 3c :9 a0 a5 57 b7
a4 b1 11 68 4f 9a 8f a0
b0 3d 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 b4 55
6a :7 a0 a5 57 b7 a4 b1 11
68 4f 9a 8f a0 b0 3d 96
:2 a0 b0 54 96 :2 a0 b0 54 b4
a3 55 6a a0 1c 81 b0 a3
a0 1c 81 b0 a3 a0 1c 81
b0 a3 a0 1c 81 b0 a3 a0
1c 81 b0 a3 a0 51 a5 1c
81 b0 a0 51 d :2 a0 d a0
51 d :4 a0 a5 b 51 a5 b
d :3 a0 7e b4 2e 82 :2 a0 d
:2 a0 6b :3 a0 a5 b :5 a0 a5 57
:2 a0 a5 b :4 a0 a5 b d :2 a0
7e a0 b4 2e d :2 a0 7e b4
2e :2 a0 d a0 b7 :3 a0 51 a5
b 7e 6e b4 2e :2 a0 7e 51
b4 2e d b7 19 a0 7e 51
b4 2e 6e 7e :3 a0 7e 51 b4
2e 51 a5 b b4 2e a5 57
b7 :2 19 3c :2 a0 7e 51 b4 2e
d b7 a0 47 :2 a0 a5 b 4d
d :2 a0 7e 51 b4 2e d b7
a4 b1 11 68 4f 9a 8f a0
b0 3d 96 :2 a0 b0 54 96 :2 a0
b0 54 b4 a3 55 6a a0 51
a5 1c 6e 81 b0 a3 a0 1c
51 81 b0 :2 a0 a5 b 7e b4
2e :3 a0 a5 b d :2 a0 7e 51
b4 2e d :3 a0 a5 b 7e b4
2e a0 82 :2 a0 7e 6e b4 2e
7e :2 a0 a5 b b4 2e d :2 a0
7e 51 b4 2e d b7 a0 47
b7 19 3c :2 a0 7e 51 b4 2e
d :2 a0 d b7 :3 a0 7e 51 b4
2e d :2 a0 d b7 a6 9 a4
b1 11 68 4f a0 8d a0 b4
a0 2c 6a :2 a0 65 b7 a4 b1
11 68 4f a0 8d a0 b4 a0
2c 6a a0 7e 51 b4 2e :2 a0
65 b7 :2 a0 65 b7 :2 19 3c b7
a4 b1 11 68 4f 9a 8f a0
b0 3d b4 8b 55 6a b0 2a
:3 a0 7e 51 b4 2e b4 5d a0
f4 8f a0 b0 3d b4 bf c8
:2 a0 6b :2 a0 6b :2 a0 6b ac :2 a0
6b a0 b9 :2 a0 6b a0 b9 b2
ee :2 a0 6b a0 7e a0 6b b4
2e :2 a0 6b a0 7e a0 6b b4
2e a 10 :2 a0 6b 7e 6e b4
2e :2 a0 6b 7e 6e b4 2e 52
10 :2 a0 6b 7e 6e b4 2e 52
10 :2 a0 6b 7e 6e b4 2e 52
10 5a a 10 ac d0 a0 de
ac e5 e9 bd b7 11 a4 b1
91 :2 a0 a5 b a0 37 a0 7e
6e b4 2e :2 a0 6b 4c :3 6e 5
48 52 10 5a :2 a0 6b 7e 6e
b4 2e 5a :2 a0 6b 6e :3 a0 6b
a5 57 b7 :2 a0 7e 51 b4 2e
6e a5 57 b7 a6 9 a4 b1
11 4f a0 b7 :2 a0 6b 7e 6e
b4 2e 5a :2 a0 6b 6e :3 a0 6b
a5 57 b7 :2 a0 7e 51 b4 2e
6e a5 57 b7 a6 9 a4 b1
11 4f b7 19 :2 a0 6b :2 a0 6b
:3 a0 6b a5 57 b7 :2 a0 7e 51
b4 2e 6e a5 57 b7 a6 9
a4 b1 11 4f b7 :2 19 3c b7
a4 b1 11 4f b7 19 3c b7
a0 47 :2 a0 6b 57 b3 b7 a4
b1 11 68 4f 9a 8f a0 b0
3d 8f a0 b0 3d 8f a0 4d
b0 3d 8f a0 4d b0 3d 8f
a0 4d b0 3d b4 8b 55 6a
b0 2a :3 a0 7e 51 b4 2e b4
5d a0 f4 8f a0 b0 3d b4
bf c8 :2 a0 ac :2 a0 6b b2 ee
:2 a0 7e a0 6b b4 2e ac d0
a0 de a0 de ac e5 e9 bd
b7 11 a4 b1 a3 a0 51 a5
1c 81 b0 6e ac :3 a0 6b b2
ee :2 a0 7e b4 2e ac e5 d0
b2 e9 b7 :2 a0 7e 51 b4 2e
6e 7e a0 b4 2e 7e 6e b4
2e a5 57 b7 a6 9 a4 b1
11 4f 91 :2 a0 a5 b a0 37
:2 a0 6b :2 a0 6b :3 a0 6b :4 a0 a5
57 b7 :2 a0 7e 51 b4 2e 6e
a5 57 b7 a6 9 a4 b1 11
4f b7 a0 47 b7 a4 b1 11
68 4f 9a 8f a0 b0 3d 8f
a0 4d b0 3d 8f a0 4d b0
3d 8f a0 4d b0 3d b4 8b
55 6a b0 2a :3 a0 7e 51 b4
2e b4 5d a0 f4 b4 bf c8
:3 a0 ac :2 a0 6b b2 ee ac d0
a0 de a0 de ac e5 e9 bd
b7 11 a4 b1 91 :2 a0 37 :2 a0
6b :2 a0 6b :2 a0 6b :2 a0 6b :4 a0
a5 57 b7 :2 a0 7e 51 b4 2e
6e a5 57 b7 a6 9 a4 b1
11 4f b7 a0 47 b7 a4 b1
11 68 4f a0 8d a0 b4 a0
2c 6a :2 a0 5a 65 b7 a4 a0
b1 11 68 4f a0 8d 8f a0
b0 3d 8f a0 b0 3d b4 :2 a0
2c 6a :4 a0 a5 b 5a 65 b7
a4 b1 11 68 4f a0 8d 8f
a0 b0 3d b4 :2 a0 2c 6a :3 a0
a5 b 5a 65 b7 a4 b1 11
68 4f a0 8d 8f a0 b0 3d
b4 :2 a0 2c 6a :3 a0 a5 b 5a
65 b7 a4 b1 11 68 4f a0
8d 8f a0 b0 3d 8f a0 b0
3d 8f a0 b0 3d b4 :2 a0 2c
6a :5 a0 a5 b 5a 65 b7 a4
b1 11 68 4f b1 b7 a4 11
a0 b1 56 4f 17 b5 
577
2
0 3 7 8 14 10 1c c
29 2a 2e 32 36 3a 3e 42
46 47 4a 4e 5b 5f 60 64
68 6c 70 74 78 7c 7d 80
95 91 90 9c a9 a5 8f b0
bd b5 b9 a4 c3 d4 cc d0
a3 da e7 df e3 cb ed fe
f6 fa ca 104 111 109 10d f5
117 128 120 124 f4 12e 11f 133
137 13b 13f 143 147 11e 14b 14e
163 15f 15e 16a 17b 173 177 15d
181 18e 186 18a 172 194 1a5 19d
1a1 171 1ab 1b8 1b0 1b4 19c 1be
1cf 1c7 1cb 19b 1d5 1c6 1da 1de
1e2 1e6 1ea 1ee 1c5 1f2 1f5 1f9
206 20a 20b 20f 213 217 21b 21f
223 227 228 22b 22f 244 240 23f
24b 258 254 23e 25f 253 264 268
26c 270 274 278 27c 280 252 284
287 28b 2a0 29c 29b 2a7 29a 2ac
2b0 2b4 2b8 2bc 2c0 2c4 2c8 2cc
2cd 2d0 2d4 2e9 2e5 2e4 2f0 2e3
2f5 2f9 2fd 301 305 309 30d 311
315 316 319 31d 332 32e 32d 339
346 342 32c 34d 356 352 341 35d
340 362 366 36a 36e 372 376 37a
37e 382 383 386 39b 397 396 3a2
3af 3ab 395 3b6 3c3 3bb 3bf 3aa
3c9 3da 3d2 3d6 3a9 3e0 3ed 3e5
3e9 3d1 3f3 404 3fc 400 3d0 40a
417 40f 413 3fb 41d 42e 426 42a
3fa 434 425 439 43d 441 422 445
448 449 44e 452 455 458 459 1
45e 463 467 46a 46d 46e 473 477
478 3f8 47d 481 484 488 48c 490
494 498 49c 4a0 4a4 4a8 4a9 3ce
4ae 3a7 4b2 4bd 393 4c1 4d6 4d2
4d1 4dd 4ee 4e6 4ea 4d0 4f4 501
4f9 4fd 4e5 507 518 510 514 4e4
51e 52b 523 527 50f 531 542 53a
53e 50e 548 539 54d 551 555 559
55d 561 565 569 56d 538 571 536
576 50c 57a 585 4e2 589 59e 59a
599 5a5 5b6 5ae 5b2 598 5bc 5c9
5c1 5c5 5ad 5cf 5ac 5ef 5d8 5dc
5e0 5e4 5eb 5d7 609 5fa 5fe 605
5d6 61f 610 614 61b 5f9 639 62a
62e 635 5f8 64f 640 644 64b 629
66a 65a 626 65e 65f 666 659 671
656 675 679 67d 681 685 689 68c
690 694 698 69c 6a0 5f6 6a1 6a4
5d4 6a5 6a9 6ad 6b1 6b5 6b8 6b9
5aa 6be 6c2 6c6 6ca 6ce 6d2 6d5
6d9 6dd 6e1 596 6e2 6e6 6ea 6ee
6f2 6f6 6f7 6fc 700 704 4ce 705
709 70d 711 715 33e 716 71a 71e
722 725 729 72a 72f 733 737 73b
73e 73f 744 748 74c 750 32a 754
758 75c 760 763 2e1 764 767 76b
76c 771 775 779 77c 77f 780 785
298 789 78d 791 794 797 798 79d
7a1 7a4 7a8 7ac 7b0 7b3 7b6 7b7
7bc 7bf 250 7c0 7c1 7c6 7c7 23c
7cc 7d0 7d4 7d7 7db 7df 7e2 7e5
7e6 7eb 1c3 7ef 7f3 7fa 7fe 802
199 1 803 807 80b 80f 812 815
816 81b 16f 81f 15b 823 82e 11c
832 847 843 842 84e 85f 857 85b
841 865 872 86a 86e 856 878 855
8a0 881 885 889 88d 890 891 898
89c 880 8ba 8ab 8af 87d 8b6 8aa
8c1 8c5 8a9 8a7 8c9 8cc 8cd 8d2
8d6 8da 8de 853 8df 8e3 8e7 8eb
8ee 8f1 8f2 8f7 8fb 8ff 903 907
83f 908 90b 90c 911 f2 915 919
91d 920 924 925 92a 92d 931 935
c8 936 937 93c 940 944 948 94b
94e 94f 954 a1 958 95c 8d 963
967 96a 96e 972 975 978 979 97e
982 986 98a 98e 990 994 998 99c
99f 9a2 9a3 9a8 9ac 9b0 9b4 9b8
9ba 9bb 9c0 9c4 9c6 9d1 9d5 9d7
9db 9e8 9ec 9ed 9f1 9f5 9f9 9fd
a01 a05 a07 a0b a0d a18 a1c a1e
a22 a2f a33 a34 a38 a3c a40 a44
a47 a4a a4b a50 a54 a58 a5c a5e
a62 a66 a6a a6c a70 a74 a77 a79
a7d a7f a8a a8e a90 aa5 aa1 aa0
aac a9f abd ab5 ab9 ab4 ab1 ac3
ac7 acb acf ad2 ad5 ad6 adb adc
adf ae3 af8 af4 af3 aff af2 b04
b07 b0b b0f b13 b16 b1a b1e b21
b25 b29 b2c b2d b31 b35 b38 af0
b3c b40 b44 b47 a9d b4b b4c b53
b57 b5b b5e b62 b65 b69 b6c b6d
b72 b76 b7a b7d b81 b84 b88 b8b
b8c 1 b91 b96 b9a b9e ba1 ba4
ba8 ba9 bae bb2 bb6 bb9 bbc bc0
bc1 1 bc6 bcb bcf bd3 bd6 bd9
bdd bde 1 be3 be8 bec bf0 bf3
bf6 bfa bfb 1 c00 c05 1 c08
c0d c0e c12 c16 c18 c19 c1e c23
c28 c2a c35 c39 c3b c3f c43 c47
c48 c4a c4e c50 c54 c57 c5b c5c
c61 c65 c69 1 c6c c70 c74 c78
c7c 1 c7f c84 c87 c8b c8f c92
c95 c99 c9a c9f ca2 ca6 caa cad
cb1 cb5 cb9 cbd cc0 cc1 cc6 cc8
ccc cd0 cd3 cd6 cd7 cdc ce0 ce1
ce6 ce8 ce9 cee cf2 cf4 cff d01
d05 d07 d0b d0f d12 d15 d19 d1a
d1f d22 d26 d2a d2d d31 d35 d39
d3d d40 d41 d46 d48 d4c d50 d53
d56 d57 d5c d60 d61 d66 d68 d69
d6e d72 d74 d7f d81 d83 d87 d8b
d8f d92 d96 d9a d9d da1 da5 da9
dac dad db2 db4 db8 dbc dbf dc2
dc3 dc8 dcc dcd dd2 dd4 dd5 dda
dde de0 deb ded def df3 df7 dfa
dfc e00 e02 e0d e0f e11 e15 e18
e1a e1e e25 e29 e2d e30 e35 e36
e38 e3c e3e e49 e4d e4f e64 e60
e5f e6b e78 e74 e5e e7f e88 e84
1 e73 e8f e9c e98 1 e72 ea3
eac ea8 1 e97 eb3 e96 ec4 ebc
ec0 ebb eb8 eca ece ed2 ed6 ed9
edc edd ee2 ee3 ee6 eea eff efb
efa f06 ef9 f0b f0e f12 f16 f1a
f1b f1f f23 f26 f27 f2e f32 f36
f39 f3d f40 f41 f46 f47 f4b ef7
f4f e94 f53 f54 f59 f5e e70 f63
f6e e5c f89 f76 f7a f7d f7e f85
f75 f90 f74 f94 f98 f9c fa0 fa3
fa4 fab faf fb3 fb6 fb7 fbc fbd
fc2 fc6 fc7 f72 fcc fd0 fd4 fd7
fda fdb fe0 fe4 fe7 feb fec ff1
ff4 ff8 ff9 ffe fff 1004 1006 1007
100c 1010 1012 101d 101f 1023 1027 102b
102c 102e 1032 1034 1038 103c 103f 1043
1047 104a 104e 1052 1056 1059 105d 1061
1065 1069 106a 106f 1071 1075 1079 107c
107f 1080 1085 1089 108a 108f 1091 1092
1097 109b 109d 10a8 10aa 10ac 10b0 10b7
10b9 10bd 10bf 10ca 10ce 10d0 10e5 10e1
10e0 10ec 10f9 10f5 1 10df 1100 1109
1105 1 10f4 1110 111d 1119 1 10f3
1124 1118 1135 112d 1131 1117 113b 1129
113e 1142 1146 1149 114c 114d 1152 1153
1156 115a 1167 1168 116b 116f 1173 1177
117b 117c 1180 1184 1187 1188 118f 1190
1194 1115 1198 10f1 119c 119d 11a2 11a7
10dd 11ac 11b7 11bb 11bd 11c1 11c5 11c9
11cb 11cf 11d3 11d6 11da 11de 11e1 11e5
11e9 11ec 11f0 11f4 11f7 11fb 11ff 1203
1207 1208 120d 120f 1213 1217 121a 121d
121e 1223 1227 1228 122d 122f 1230 1235
1239 123b 1246 1248 124a 124e 1255 1257
125b 125d 1268 126c 126e 1272 127f 1283
1284 1288 128c 1290 1294 1298 129b 129f
12a1 12a5 12a9 12ab 12b6 12ba 12bc 12c0
12d5 12d1 12d0 12dc 12e9 12e5 12cf 12f0
12e4 12f5 12f9 12fd 1301 1305 1309 130d
1311 12e3 12e1 1315 1318 12cd 131c 1320
1322 132d 1331 1333 1337 134c 1348 1347
1353 1346 1358 135c 1360 1364 1368 136c
1370 1374 1344 1375 1378 137c 137e 1382
1384 138f 1393 1395 1399 13ae 13aa 13a9
13b5 13a8 13ba 13be 13c2 13c6 13ca 13ce
13d2 13d6 13a6 13d7 13da 13de 13e0 13e4
13e6 13f1 13f5 13f7 13fb 1410 140c 140b
1417 1424 1420 140a 142b 1434 1430 141f
143b 141e 1440 1444 1448 144c 1450 1454
1458 145c 1460 1464 141c 1465 1468 1408
146c 1470 1472 147d 1481 1483 1485 1487
148b 1496 149a 149c 149f 14a1 14a8 
577
2
0 :2 1 9 e 3 c 18 0
1f :2 3 5 c 17 1a :2 5 3
c 19 0 20 :2 3 5 c 17
1a :2 5 d 1a 22 :2 1a 2c 37
:2 2c 7 e 12 :2 7 1c 22 26
:2 1c 30 36 3a :2 30 7 e 12
:2 7 1c 27 2b :2 1c 7 15 19
:2 7 19 :2 3 5 c 17 1a :2 5
d 20 2c :2 20 12 1a 1e :3 12
1a 1e :2 12 19 21 25 :2 19 20
28 2c :3 20 28 2c :2 20 1e :2 3
5 c 17 1a :2 5 3 c 13
0 1a :2 3 5 c 17 1a :2 5
3 c 14 19 :2 14 29 2f :2 29
13 8 f :2 3 5 c 17 1a
:2 5 3 c 19 1d :2 19 18 2d
34 :2 3 5 c 17 1a :2 5 3
c 1a 1e :2 1a 19 2e 35 :2 3
5 c 17 1a :2 5 3 c 15
1a :2 15 24 29 :2 24 15 1f :2 15
14 8 f :2 3 5 c 17 1a
:2 5 d 1a 22 :2 1a 2c 37 :2 2c
5 c 10 :2 5 1a 20 24 :2 1a
2e 34 38 :2 2e 5 c 10 :2 5
1a 25 29 :2 1a 31 3f 43 :2 31
19 :2 3 8 10 13 :2 10 19 21
24 :2 21 :2 8 3 1b 1c :2 1b 23
:2 3 26 :3 5 12 18 21 29 30
37 3f 7 :2 5 :6 3 d 1c 28
:2 1c e 16 1a :2 e 18 20 24
:2 18 15 1d 21 :2 15 e 16 1a
:3 e 16 1a :2 e 1a :2 3 5 18
1e 21 24 27 2f :2 5 :6 3 d
1d 28 :3 1d 24 28 :3 1d 24 28
:2 1d 1b 5 :2 3 :3 10 :2 5 :3 10 :2 5
:3 10 :2 5 :3 10 :2 5 :3 10 :2 5 10 19
18 :2 10 :2 5 11 :2 5 11 :2 5 11
:2 5 11 15 1d :2 15 23 :2 11 :2 5
f 14 :3 b 5 7 11 :2 7 :2 14
23 2b 30 :2 23 1c 23 2a 31
38 :3 7 b :2 7 11 1a 20 28
:2 11 :2 7 12 19 1b :2 12 7 a
14 :3 12 9 11 9 7 18 d
15 1a 22 :2 d 25 27 :2 25 9
14 1c 1e :2 14 9 2b 18 9
22 23 :2 22 b 30 33 3b 40
47 48 :2 40 4a :2 33 :2 b :2 9 :5 7
c e 10 :2 c 7 14 9 :2 5
9 :2 5 f :2 5 f 10 11 :2 f
5 :6 3 d 1d 28 :3 1d 24 28
:3 1d 24 28 :2 1d 1b 5 :2 3 b
14 13 b 1d b :2 5 :2 b 1e
b 5 8 c :5 8 7 f 13
:2 f :2 7 f 11 13 :2 f :2 7 d
11 :5 d 20 7 9 11 16 19
:2 11 1d 20 24 :2 20 :2 11 :2 9 e
10 12 :2 e 9 20 b 7 1b
:3 5 f 10 11 :2 f :2 5 f 5
3 a 7 11 12 13 :2 11 :2 7
11 7 18 :2 5 :6 3 c 15 0
1c :2 3 5 c 5 :7 3 c 1f
0 26 :2 3 8 14 16 :2 14 7
e 7 18 7 e 7 :4 5 :6 3
d 1d 24 :2 1d 1c 5 :2 3 :3 5
c 1b :4 31 :3 5 c f 16 :2 f
e :2 5 e :2 10 1d :2 1f 2c :2 2e
e c 10 c 2b c 2e 32
2e 3e 2e 7 c d :2 f 1b
19 :2 1d :2 19 d :2 f 17 15 :2 1a
:2 15 :2 d c :2 e 1a 1c :2 1a 2a
:2 2c 38 3a :2 38 :3 c :2 e 1a 1c
:2 1a :2 c 29 :2 2b 37 39 :2 37 :2 c
b :2 d :2 7 :2 10 :3 7 :5 5 9 10
13 :2 10 1b 5 b 12 15 :2 12
1e :2 22 2e 36 b 1b :2 1e :2 b
a f :2 13 1f 21 :2 1f e 11
:2 1a 28 41 28 :2 2c :2 11 e 20
1a 32 33 :2 32 f :2 1a 35 :2 1b
11 :3 2c b 2c 12 :2 16 22 24
:2 22 :2 11 :2 1a 28 38 26 :2 2a :2 11
e 20 1a 32 33 :2 32 e :2 1a
35 :2 1b 11 :4 34 2c 11 :2 1a 28
:2 2c 39 28 :2 2c :2 11 e 20 1a
32 33 :2 32 10 :2 1a 35 :2 1b 11
:7 b :2 a :4 30 :2 7 1b 9 5 3
:2 10 :8 3 d 1c 23 :2 1c 2d 34
:2 2d 1c 2a 39 :3 1c 2d 3c :3 1c
27 38 :2 1c 1b 5 :2 3 :3 5 c
1b :4 31 :3 5 c f 16 :2 f e
:2 5 e 1b e c 10 c 7
c d 15 13 :2 18 :2 13 :2 7 :2 10
:2 1d :3 7 :6 5 b 14 13 :2 b 5
:2 e 17 22 26 22 1d 22 32
39 :3 37 1d :4 7 5 14 7 1f
20 :2 1f 26 2f 31 :2 26 37 39
:2 26 :2 7 22 :2 f 5 :3 3 9 10
13 :2 10 1b 5 b :2 14 23 :2 27
34 3c :2 40 23 2b 3a 23 :2 b
9 18 b 23 24 :2 23 d :2 b
2d :2 13 9 :4 1b 9 5 :6 3 d
1e 25 :3 1e 2c 3b :3 1e 2f 3e
:3 1e 29 3a :2 1e 1d 5 :2 3 :3 5
c 1b :4 31 :3 5 c 0 :2 5 e
15 22 e c 10 c 7 c
:2 7 :2 10 :2 1d :3 7 :5 5 9 10 13
5 b :2 14 23 :2 27 34 :2 38 3f
:2 43 23 2b 3a 23 :2 b 9 18
b 23 24 :2 23 c :2 b 2d :2 13
9 :4 13 9 5 :7 3 c 18 0
1f :2 3 5 c b 5 :2 3 7
:5 3 c 24 29 :2 24 31 37 :2 31
23 3f 46 :2 3 5 d 15 1a
:2 d c 5 :7 3 c 24 28 :2 24
23 30 37 :2 3 5 d 1a :2 d
c 5 :7 3 c 25 29 :2 25 24
31 38 :2 3 5 d 1b :2 d c
5 :7 3 c 1b 20 :2 1b 2a 2f
:2 2a 37 41 :2 37 1a 5 c :2 3
5 d 16 1c 22 :2 d c 5
:a 3 5 :5 1 
577
2
0 :4 1 :3 2 0 :3 2 :6 3 :3 4 0
:3 4 :6 5 :9 6 :f 7 :a 8 :5 9 :3 6 :6 a
:5 b :5 c :5 d :5 e :5 f :5 10 :3 b :6 11
:3 12 0 :3 12 :6 13 :b 15 :2 16 :2 15 :6 17
:b 19 :6 1a :b 1c :6 1d :a 1f :4 20 1f :2 21
:2 1f :6 22 :9 24 :f 25 :f 26 :3 24 :c 28 :8 29
:3 28 :8 2b 2c :2 2b :2 27 :4 24 :5 2f :5 30
:5 31 :5 32 :5 33 :5 34 :3 2f :9 36 :2 35 :4 2f
:5 41 :5 42 :5 43 41 44 :2 41 :4 44 :5 45
:5 46 :5 47 :5 48 :7 49 :3 4c :3 4d :3 4e :a 4f
:7 51 :3 52 :8 53 :5 54 :2 53 :b 55 :7 56 :5 57
:3 58 59 57 :a 59 :7 5a 59 57 :5 5c
:e 5d :2 5c :2 5b :2 57 :7 5f 51 60 51
:6 63 :7 64 :2 4a :4 41 :5 6d :5 6e :5 6f 6d
70 :2 6d :7 70 :6 71 :7 73 :6 74 :7 75 :a 76
:e 77 :7 78 76 79 76 :3 73 :7 7b :3 7c
72 7e :7 7f :3 80 :3 7e 7d :4 6d :3 83
0 :3 83 :3 85 :2 84 :4 83 :3 88 0 :3 88
:5 8a :3 8b 8a :3 8d :2 8c :2 8a :2 89 :4 88
:6 91 92 :2 91 :2 92 :9 93 :9 95 :a 96 :c 97
:9 98 :9 99 :2 98 :10 a5 :7 a6 :2 a5 :7 a6 :3 a5
:2 98 97 96 :3 a7 :2 96 :5 95 :7 a9 :a aa
:2 ab :5 aa :8 ad :5 af :3 b0 :2 af ae b1
:5 b2 b3 :2 b2 :4 b1 :3 ad b5 ad :8 b5
:5 b7 :3 b8 :2 b7 b6 b9 :5 ba bb :2 ba
:4 b9 :4 b5 ad :7 bf :3 c0 :2 bf be c1
:5 c2 c3 :2 c2 :4 c1 :5 bd :2 ad :2 ac :4 ab
:2 aa a9 c8 a9 :5 ca :2 a8 :4 91 :9 cd
:5 ce :5 cf :5 d0 cd d1 :2 cd :2 d1 :9 d2
:9 d4 :3 d5 :5 d6 :7 d7 d6 d5 :5 d8 :2 d5
:5 d4 :7 d9 :12 dd dc de :10 df :4 de :3 da
:7 e2 :a e4 :3 e5 e6 :2 e4 e3 e7 :5 e8
e9 :2 e8 :4 e7 :4 e2 eb e2 :2 da :4 cd
:5 ee :5 ef :5 f0 :5 f1 ee f2 :2 ee :2 f2
:9 f3 :2 f5 0 :2 f5 :4 f6 :6 f7 f6 :5 f8
:2 f6 :5 f5 :4 fb :c fd :3 fe ff :2 fd fc
100 :5 101 102 :2 101 :4 100 :4 fb 104 fb
:2 f9 :4 ee :3 107 0 :3 107 :4 109 :2 108 10a
:4 107 :f 10c :8 10e :2 10d :4 10c :b 111 :7 113 :2 112
:4 111 :b 116 :7 118 :2 117 :4 116 :f 11b :2 11c :2 11b
:9 11e :2 11d :4 11b :4 24 121 :5 1 
14aa
2
:3 0 1 :4 0 2 :3 0 6 :3 0 4
:3 0 3 :6 0 1 5 :a 0 b 2
0 7 :3 0 8 9 0 b 6
a 0 572 8 :3 0 9 :3 0 a
:3 0 5 6 :2 0 3 d 10 572
4 :3 0 b :a 0 18 3 6 :4 0
7 :3 0 15 16 0 18 13 17
0 572 8 :3 0 9 :3 0 a :3 0
b 13 :2 0 6 1a 1d 572 c
:a 0 48 4 154 26f b 9 e
:3 0 d :6 0 22 21 :3 0 151 26d
f d 7 :3 0 f :6 0 26 25
:3 0 11 :3 0 e :3 0 10 :5 0 2b
2a :3 0 25d 25f 13 :2 11 :3 0 e
:3 0 12 :5 0 30 2f :3 0 11 :3 0
e :3 0 13 :5 0 35 34 :3 0 253
26d 17 15 11 :3 0 e :3 0 14
:5 0 3a 39 :3 0 11 :3 0 7 :3 0
15 :5 0 3f 3e :5 0 22 19 11
:3 0 7 :3 0 16 :5 0 44 43 :3 0
46 :2 0 48 1f 47 0 572 8
:3 0 9 :3 0 a :3 0 c 1f :2 0
4a 4d 572 17 :a 0 6f 5 122
215 27 25 e :3 0 d :6 0 52
51 :3 0 11a 215 2b 29 11 :3 0
e :3 0 18 :5 0 57 56 :3 0 11
:3 0 e :3 0 19 :5 0 5c 5b :3 0
205 207 2f 2d 11 :3 0 e :3 0
a :5 0 61 60 :3 0 11 :3 0 e
:3 0 14 :5 0 66 65 :3 0 10e 204
38 31 11 :3 0 7 :3 0 1a :5 0
6b 6a :3 0 6d :2 0 6f 4f 6e
0 572 8 :3 0 9 :3 0 a :3 0
17 4f :2 0 71 74 572 4 :3 0
1b :a 0 7c :2 6 :4 0 e :3 0 79
7a 0 7c 77 7b 0 572 8
:3 0 9 :3 0 a :3 0 1b 77 :2 0
3b 7e 81 572 4 :3 0 1c :a 0
91 7 105 1f8 40 3e 7 :3 0
1d :6 0 87 86 :3 0 1e9 1f1 45
42 7 :3 0 1e :6 0 8b 8a :3 0
6 :3 0 7 :3 0 8d 8f 0 91
84 90 0 572 8 :3 0 9 :3 0
a :3 0 1c 84 :2 0 93 96 572
4 :3 0 1f :a 0 a2 8 ee 1e1
4a 48 7 :3 0 20 :6 0 9c 9b
:3 0 6 :3 0 7 :3 0 9e a0 0
a2 99 a1 0 572 8 :3 0 9
:3 0 a :3 0 1f 99 :2 0 4c a4
a7 572 4 :3 0 21 :a 0 b3 9
1cf 1d3 51 4f 7 :3 0 20 :6 0
ad ac :3 0 6 :3 0 7 :3 0 af
b1 0 b3 aa b2 0 572 8
:3 0 9 :3 0 a :3 0 21 aa :2 0
53 b5 b8 572 4 :3 0 22 :a 0
cc a e5 1f9 58 56 e :3 0
d :6 0 be bd :3 0 1b7 1bb 5c
5a 7 :3 0 23 :6 0 c2 c1 :3 0
7 :3 0 24 :6 0 c6 c5 :3 0 6
:3 0 7 :3 0 c8 ca 0 cc bb
cb 0 572 8 :3 0 9 :3 0 a
:3 0 22 bb :2 0 60 ce d1 572
25 :a 0 123 b :2 0 65 63 e
:3 0 d :6 0 d6 d5 :4 0 122 69
67 26 :3 0 f :6 0 da d9 :3 0
11 :3 0 e :3 0 10 :5 0 df de
:3 0 94 122 6d 6b 11 :3 0 e
:3 0 12 :5 0 e4 e3 :3 0 11 :3 0
e :3 0 13 :5 0 e9 e8 :3 0 87
112 71 6f 11 :3 0 e :3 0 14
:5 0 ee ed :3 0 11 :3 0 26 :3 0
15 :5 0 f3 f2 :3 0 27 :2 0 73
11 :3 0 26 :3 0 16 :5 0 f8 f7
:3 0 fa :2 0 123 d3 fb :2 0 f
:3 0 28 :2 0 7e fe 100 :3 0 f
:3 0 27 :2 0 29 :2 0 81 103 105
:3 0 101 107 106 :2 0 2a :3 0 2b
:2 0 2c :2 0 7c 10a 10c :3 0 2d
:3 0 84 109 10f :2 0 111 108 111
0 113 89 0 11f c :3 0 d
:3 0 f :3 0 10 :3 0 12 :3 0 13
:3 0 14 :3 0 15 :3 0 16 :3 0 8b
114 11d :2 0 11f :3 0 122 121 11f
120 :6 0 123 1 d3 fb 122 572
2e :a 0 153 c 1b3 1b5 99 97
e :3 0 d :6 0 128 127 :5 0 9d
9b 11 :3 0 e :3 0 18 :5 0 12d
12c :3 0 11 :3 0 e :3 0 19 :5 0
132 131 :4 0 152 a1 9f 11 :3 0
e :3 0 a :5 0 137 136 :3 0 11
:3 0 e :3 0 14 :5 0 13c 13b :3 0
b1 152 aa a3 11 :3 0 7 :3 0
1a :5 0 141 140 :3 0 143 :2 0 153
125 144 :2 0 17 :3 0 d :3 0 18
:3 0 19 :3 0 a :3 0 14 :3 0 1a
:3 0 146 14d :2 0 14f :3 0 152 151
14f 150 :6 0 153 1 125 144 152
572 2f :a 0 216 d 1a7 1aa b5
b3 e :3 0 30 :6 0 158 157 :3 0
19f 204 b9 b7 11 :3 0 7 :3 0
31 :5 0 15d 15c :3 0 11 :3 0 33
:3 0 32 :5 0 162 161 :3 0 191 197
bf bd 164 :2 0 216 155 166 :2 0
7 :3 0 168 :6 0 16b 169 0 214
1a :6 0 192 194 c3 c1 7 :3 0
16d :6 0 170 16e 0 214 34 :6 0
36 :3 0 172 :6 0 175 173 0 214
35 :6 0 3a :2 0 c5 7 :3 0 177
:6 0 17a 178 0 214 37 :6 0 7
:3 0 17c :6 0 17f 17d 0 214 38
:6 0 28 :2 0 c9 e :3 0 c7 181
183 :5 0 186 184 0 214 39 :6 0
1a :3 0 187 188 0 212 35 :3 0
3b :3 0 18a 18b 0 212 37 :3 0
28 :2 0 18d 18e 0 212 38 :3 0
3c :3 0 3d :3 0 30 :3 0 cb 3e
:2 0 cd 190 198 0 212 3f :3 0
35 :3 0 40 :3 0 41 :2 0 d0 19d
19e :3 0 34 :3 0 1a :3 0 1a1 1a2
0 202 3 :3 0 2e :3 0 1a4 1a5
0 42 :3 0 30 :3 0 34 :3 0 d2
39 :3 0 39 :3 0 39 :3 0 39 :3 0
1a :3 0 d5 1a6 1b1 :2 0 202 32
:3 0 37 :3 0 dc 42 :3 0 30 :3 0
34 :3 0 1a :3 0 de 1b6 1bc 0
202 1a :3 0 34 :3 0 43 :2 0 1a
:3 0 e2 1c0 1c2 :3 0 1be 1c3 0
202 1a :3 0 38 :3 0 44 :2 0 e7
1c7 1c8 :3 0 35 :3 0 45 :3 0 1ca
1cb 0 1ce 46 :3 0 42 :3 0 30
:3 0 1a :3 0 28 :2 0 ea 47 :2 0
48 :3 0 f0 1d5 1d7 :3 0 1a :3 0
1a :3 0 43 :2 0 28 :2 0 f3 1db
1dd :3 0 1d9 1de 0 1e0 1d8 1e0
0 1fa 2a :3 0 2b :2 0 49 :2 0
f6 1e3 1e5 :3 0 4a :3 0 4b :2 0
42 :3 0 30 :3 0 1a :3 0 2b :2 0
4c :2 0 f8 1ec 1ee :3 0 4d :2 0
fb ff 1e8 1f3 :3 0 102 1e2 1f5
:2 0 1f7 0 1f7 0 1fa 1c9 1ce
0 1fa 107 0 202 37 :3 0 37
:3 0 43 :2 0 28 :2 0 10b 1fd 1ff
:3 0 1fb 200 0 202 40 :3 0 1a0
202 :4 0 212 32 :3 0 37 :3 0 115
208 209 0 212 31 :3 0 37 :3 0
2b :2 0 28 :2 0 117 20d 20f :3 0
20b 210 0 212 :3 0 215 214 212
213 :6 0 216 1 155 166 215 572
4e :a 0 28d f 24d 24f 12b 129
33 :3 0 32 :6 0 21b 21a :3 0 240
242 12f 12d 11 :3 0 7 :3 0 31
:5 0 220 21f :3 0 11 :3 0 e :3 0
30 :5 0 225 224 :3 0 28 :2 0 135
227 :2 0 28d 218 229 :2 0 e :3 0
50 :2 0 133 22b 22d :5 0 51 :3 0
231 22e 22f 28b 4f :6 0 238 23a
139 137 7 :3 0 233 :6 0 237 234
235 28b 37 :6 0 32 :3 0 37 :3 0
52 :2 0 13b 23c 23d :3 0 4f :3 0
32 :3 0 37 :3 0 13d 23f 243 0
26e 37 :3 0 37 :3 0 43 :2 0 28
:2 0 13f 247 249 :3 0 245 24a 0
26e 3f :3 0 32 :3 0 37 :3 0 142
52 :2 0 144 251 252 :3 0 40 :3 0
4f :3 0 4f :3 0 4b :2 0 48 :3 0
146 258 25a :3 0 4b :2 0 32 :3 0
37 :3 0 149 14b 25c 261 :3 0 256
262 0 26b 37 :3 0 37 :3 0 43
:2 0 28 :2 0 14e 266 268 :3 0 264
269 0 26b 40 :3 0 255 26b :4 0
26e 23e 26e 0 270 158 0 27b
31 :3 0 37 :3 0 2b :2 0 28 :2 0
15a 273 275 :3 0 271 276 0 27b
30 :3 0 4f :3 0 278 279 0 27b
15d 28c 53 :3 0 31 :3 0 37 :3 0
2b :2 0 28 :2 0 161 27f 281 :3 0
27d 282 0 287 30 :3 0 4f :3 0
284 285 0 287 164 289 167 288
287 :2 0 28a 169 :2 0 28c 16b 28c
28b 27b 28a :6 0 28d 1 218 229
28c 572 :2 0 4 :3 0 54 :a 0 29d
11 6 :4 0 26 :3 0 292 293 0
29d 290 294 :2 0 6 :3 0 b :3 0
297 :2 0 299 16e 29c :3 0 29c 0
29c 29b 299 29a :6 0 29d 1 290
294 29c 572 :2 0 4 :3 0 55 :a 0
2ba 12 6 :4 0 36 :3 0 2a2 2a3
0 2ba 2a0 2a4 :2 0 5 :3 0 47
:2 0 28 :2 0 172 2a7 2a9 :3 0 6
:3 0 45 :3 0 2ac :2 0 2ae 170 2b4
6 :3 0 3b :3 0 2b0 :2 0 2b2 175
2b3 0 2b2 0 2b5 2aa 2ae 0
2b5 177 0 2b6 17a 2b9 :3 0 2b9
0 2b9 2b8 2b6 2b7 :6 0 2ba 1
2a0 2a4 2b9 572 :2 0 56 :a 0 3cb
13 2ea 2eb 17e 17c e :3 0 10
:6 0 2bf 2be :3 0 2c5 0 3c9 180
2c1 :2 0 3cb 2bc 2c3 :2 0 57 :5 0
8 :3 0 58 :3 0 57 2c2 :2 0 2b
:2 0 59 :2 0 182 2ca 2cc :3 0 184
2c8 2ce 3c9 5a :3 0 5b :a 0 14
0 2e5 2e6 189 187 e :3 0 10
:6 0 2d4 2d3 :3 0 2d1 2d8 0 2d6
:3 0 18 :3 0 5c :3 0 2d9 2da 0
18 :3 0 5d :3 0 2dc 2dd 0 18
:3 0 5e :3 0 2df 2e0 0 18b 5f
:3 0 60 :3 0 2e3 2e4 0 61 :3 0
5f :3 0 62 :3 0 2e8 2e9 0 18
:3 0 18f 2ed 327 0 328 :3 0 61
:3 0 63 :3 0 2ef 2f0 0 18 :3 0
47 :2 0 63 :3 0 2f2 2f4 0 194
2f3 2f6 :3 0 18 :3 0 64 :3 0 2f8
2f9 0 5b :3 0 47 :2 0 10 :3 0
2fb 2fd 0 197 2fc 2ff :3 0 2f7
301 300 :2 0 18 :3 0 5c :3 0 303
304 0 47 :2 0 4 :3 0 19a 306
308 :3 0 18 :3 0 5c :3 0 30a 30b
0 47 :2 0 65 :3 0 19d 30d 30f
:3 0 309 311 310 :2 0 18 :3 0 5c
:3 0 313 314 0 47 :2 0 1 :3 0
1a0 316 318 :3 0 312 31a 319 :2 0
18 :3 0 5c :3 0 31c 31d 0 47
:2 0 66 :3 0 1a3 31f 321 :3 0 31b
323 322 :2 0 324 :2 0 302 326 325
:4 0 2e2 2ee 0 67 :3 0 2 32a
192 329 0 32c :3 0 32d :2 0 330
2d1 2d8 331 0 3c9 1a6 331 333
330 332 :6 0 32f 1 :5 0 331 68
:3 0 5b :3 0 10 :3 0 1a8 335 337
40 :3 0 334 338 10 :3 0 27 :2 0
5f :3 0 1ac 33c 33e :3 0 68 :3 0
5d :3 0 340 341 0 3 :3 0 69
:3 0 6a :3 0 1af :3 0 342 343 347
33f 349 348 :2 0 34a :2 0 68 :3 0
5c :3 0 34c 34d 0 47 :2 0 1
:3 0 1b3 34f 351 :3 0 352 :2 0 6b
:3 0 6c :3 0 354 355 0 6d :3 0
10 :3 0 68 :3 0 5d :3 0 359 35a
0 1b6 356 35c :2 0 35e 1aa 36d
57 :3 0 2a :3 0 2b :2 0 59 :2 0
1ba 361 363 :3 0 6e :3 0 1bc 360
366 :2 0 368 1bf 36a 1c1 369 368
:2 0 36b 1c3 :2 0 36d 0 36d 36c
35e 36b :6 0 370 16 :2 0 46 :3 0
1c5 3b5 68 :3 0 5c :3 0 371 372
0 47 :2 0 66 :3 0 1c9 374 376
:3 0 377 :2 0 6b :3 0 6c :3 0 379
37a 0 66 :3 0 10 :3 0 68 :3 0
5d :3 0 37e 37f 0 1cc 37b 381
:2 0 383 1c7 392 57 :3 0 2a :3 0
2b :2 0 59 :2 0 1d0 386 388 :3 0
6e :3 0 1d2 385 38b :2 0 38d 1d5
38f 1d7 38e 38d :2 0 390 1d9 :2 0
392 0 392 391 383 390 :6 0 394
16 :2 0 1db 395 378 394 0 3b6
6b :3 0 6c :3 0 396 397 0 68
:3 0 5c :3 0 399 39a 0 10 :3 0
68 :3 0 5d :3 0 39d 39e 0 1dd
398 3a0 :2 0 3a2 1e1 3b1 57 :3 0
2a :3 0 2b :2 0 59 :2 0 1e3 3a5
3a7 :3 0 6e :3 0 1e5 3a4 3aa :2 0
3ac 1e8 3ae 1ea 3ad 3ac :2 0 3af
1ec :2 0 3b1 0 3b1 3b0 3a2 3af
:6 0 3b3 16 :2 0 1ee 3b4 0 3b3
0 3b6 353 370 0 3b6 1f0 0
3b7 1f4 3ba :3 0 3ba 0 3ba 3b9
3b7 3b8 :6 0 3bc 15 :2 0 1f6 3bd
34b 3bc 0 3be 1f8 0 3bf 1fa
3c1 40 :3 0 33a 3bf :4 0 3c7 69
:3 0 6f :3 0 3c2 3c3 0 3c4 3c6
:2 0 3c7 0 1fc 3ca :3 0 3ca 1ff
3ca 3c9 3c7 3c8 :6 0 3cb 1 2bc
2c3 3ca 572 :2 0 70 :a 0 47b 1a
0 417 205 203 e :3 0 10 :6 0
3d0 3cf :3 0 223 417 209 207 e
:3 0 71 :6 0 3d4 3d3 :3 0 26 :3 0
72 :6 0 3d9 3d7 3d8 :2 0 1 410
20d 20b 26 :3 0 73 :6 0 3de 3dc
3dd :2 0 e :3 0 74 :6 0 3e3 3e1
3e2 :2 0 3e9 0 479 213 3e5 :2 0
47b 3cd 3e7 :2 0 57 :5 0 8 :3 0
58 :3 0 57 3e6 :2 0 2b :2 0 59
:2 0 215 3ee 3f0 :3 0 217 3ec 3f2
479 5a :3 0 5b :a 0 1b 0 1
40e 21c 21a e :3 0 10 :6 0 3f8
3f7 :3 0 3f5 3fc 0 3fa :3 0 5d
:3 0 5c :3 0 21e 5f :3 0 75 :3 0
400 401 0 221 403 40b 0 40c
:3 0 64 :3 0 5b :3 0 47 :2 0 10
:3 0 406 408 0 225 407 40a :5 0
3ff 404 0 5c :3 0 5d :3 0 228
40d 0 412 :3 0 413 :2 0 416 3f5
3fc 417 0 479 419 416 418 :6 0
415 1 :4 0 238 44a 22f 22d e
:3 0 28 :2 0 22b 41b 41d :5 0 420
41e 0 479 39 :6 0 76 :3 0 39
:3 0 5f :3 0 77 :3 0 424 425 0
231 427 42d 0 42e :3 0 d :3 0
10 :3 0 47 :2 0 235 42b 42c :4 0
430 431 :4 0 422 428 0 233 0
42f :2 0 433 53 :3 0 2a :3 0 2b
:2 0 59 :2 0 23a 436 438 :3 0 78
:3 0 4b :2 0 10 :3 0 23c 43b 43d
:3 0 4b :2 0 79 :3 0 23f 43f 441
:3 0 242 435 443 :2 0 445 245 447
247 446 445 :2 0 448 249 :2 0 44a
0 44a 449 433 448 :6 0 477 1a
:2 0 68 :3 0 5b :3 0 10 :3 0 24b
44d 44f 40 :3 0 44c 450 6b :3 0
7a :3 0 453 454 0 68 :3 0 5c
:3 0 456 457 0 10 :3 0 68 :3 0
5d :3 0 45a 45b 0 71 :3 0 72
:3 0 73 :3 0 74 :3 0 24d 455 461
:2 0 463 255 472 57 :3 0 2a :3 0
2b :2 0 59 :2 0 257 466 468 :3 0
6e :3 0 259 465 46b :2 0 46d 25c
46f 25e 46e 46d :2 0 470 260 :2 0
472 0 472 471 463 470 :6 0 474
1d :2 0 262 476 40 :3 0 452 474
:4 0 477 264 47a :3 0 47a 267 47a
479 477 478 :6 0 47b 1 3cd 3e7
47a 572 :2 0 7b :a 0 4ea 1f 289
4b9 26e 26c e :3 0 71 :6 0 480
47f :3 0 1 4b2 272 270 26 :3 0
72 :6 0 485 483 484 :2 0 26 :3 0
73 :6 0 48a 488 489 :2 0 1 4b0
279 274 e :3 0 74 :6 0 48f 48d
48e :2 0 8 :3 0 491 :2 0 4ea 47d
493 :2 0 57 :5 0 495 0 4e8 58
:3 0 57 492 :2 0 2b :2 0 59 :2 0
27b 49a 49c :3 0 27d 498 49e 4e8
5a :3 0 5b :a 0 20 :2 0 4a1 4a4
0 4a2 :3 0 64 :3 0 5d :3 0 5c
:3 0 280 5f :3 0 75 :3 0 4a9 4aa
0 284 4ac :2 0 4ae :5 0 4a8 4ad
0 5c :3 0 5d :3 0 286 4af 0
4b4 :3 0 4b5 :2 0 4b8 4a1 4a4 4b9
0 4e8 4bb 4b8 4ba :6 0 4b7 1
:5 0 4b9 68 :3 0 5b :3 0 40 :3 0
4bc 4bd 6b :3 0 7a :3 0 4c0 4c1
0 68 :3 0 5c :3 0 4c3 4c4 0
68 :3 0 64 :3 0 4c6 4c7 0 68
:3 0 5d :3 0 4c9 4ca 0 71 :3 0
72 :3 0 73 :3 0 74 :3 0 28b 4c2
4d0 :2 0 4d2 293 4e1 57 :3 0 2a
:3 0 2b :2 0 59 :2 0 295 4d5 4d7
:3 0 7c :3 0 297 4d4 4da :2 0 4dc
29a 4de 29c 4dd 4dc :2 0 4df 29e
:2 0 4e1 0 4e1 4e0 4d2 4df :6 0
4e3 21 :2 0 2a0 4e5 40 :3 0 4bf
4e3 :4 0 4e6 2a2 4e9 :3 0 4e9 2a4
4e9 4e8 4e6 4e7 :6 0 4ea 1 47d
493 4e9 572 :2 0 4 :3 0 7d :a 0
4fc 23 6 :4 0 e :3 0 4ef 4f0
0 4fc 4ed 4f1 :2 0 6 :3 0 1b
:3 0 4f4 :2 0 4f5 :2 0 4f7 2a8 4fb
:3 0 4fb 7d :4 0 4fb 4fa 4f7 4f8
:6 0 4fc 1 4ed 4f1 4fb 572 :2 0
4 :3 0 7e :a 0 519 24 2b4 518
2ac 2aa 26 :3 0 1d :6 0 502 501
:3 0 50e 511 2b1 2ae 26 :3 0 1e
:6 0 506 505 :3 0 6 :3 0 26 :3 0
508 50a 0 519 4ff 50b :2 0 6
:3 0 1c :3 0 1d :3 0 1e :3 0 512
:2 0 513 :2 0 515 :3 0 518 0 518
517 515 516 :6 0 519 1 4ff 50b
518 572 :2 0 4 :3 0 7f :a 0 531
25 527 529 2b8 2b6 26 :3 0 20
:6 0 51f 51e :3 0 6 :3 0 26 :3 0
521 523 0 531 51c 524 :2 0 6
:3 0 1f :3 0 20 :3 0 2ba 52a :2 0
52b :2 0 52d 2bc 530 :3 0 530 0
530 52f 52d 52e :6 0 531 1 51c
524 530 572 :2 0 4 :3 0 80 :a 0
549 26 53f 541 2c0 2be 26 :3 0
20 :6 0 537 536 :3 0 6 :3 0 26
:3 0 539 53b 0 549 534 53c :2 0
6 :3 0 21 :3 0 20 :3 0 2c2 542
:2 0 543 :2 0 545 2c4 548 :3 0 548
0 548 547 545 546 :6 0 549 1
534 53c 548 572 :2 0 4 :3 0 81
:a 0 56b 27 2d4 56a 2c8 2c6 e
:3 0 d :6 0 54f 54e :3 0 55f 563
2cc 2ca 26 :3 0 23 :6 0 553 552
:3 0 26 :3 0 24 :6 0 557 556 :3 0
6 :3 0 26 :3 0 559 55b 0 56b
54c 55c :2 0 6 :3 0 22 :3 0 d
:3 0 23 :3 0 24 :3 0 2d0 564 :2 0
565 :2 0 567 :3 0 56a 0 56a 569
567 568 :6 0 56b 1 54c 55c 56a
572 :3 0 570 0 570 :3 0 570 572
56e 56f :6 0 573 0 3 :3 0 2d6
0 4 570 575 :2 0 2 573 576
:6 0 
2f7
2
:3 0 2 e f 2 1b 1c 1
20 1 24 1 28 1 2d 1
32 1 37 1 3c 1 41 8
23 27 2c 31 36 3b 40 45
2 4b 4c 1 50 1 54 1
59 1 5e 1 63 1 68 6
53 58 5d 62 67 6c 2 72
73 2 7f 80 1 85 1 89
2 88 8c 2 94 95 1 9a
1 9d 2 a5 a6 1 ab 1
ae 2 b6 b7 1 bc 1 c0
1 c4 3 bf c3 c7 2 cf
d0 1 d4 1 d8 1 dc 1
e1 1 e6 1 eb 1 f0 1
f5 8 d7 db e0 e5 ea ef
f4 f9 1 10b 2 fd ff 2
102 104 2 10d 10e 1 110 1
112 8 115 116 117 118 119 11a
11b 11c 2 113 11e 1 126 1
12a 1 12f 1 134 1 139 1
13e 6 129 12e 133 138 13d 142
6 147 148 149 14a 14b 14c 1
14e 1 156 1 15a 1 15f 3
159 15e 163 1 165 1 16c 1
171 1 176 1 17b 1 182 1
180 1 193 2 195 196 1 19b
2 1a8 1a9 6 1ab 1ac 1ad 1ae
1af 1b0 1 1b4 3 1b8 1b9 1ba
2 1bf 1c1 1 1cc 2 1c5 1c6
3 1d0 1d1 1d2 1 1df 2 1d4
1d6 2 1da 1dc 1 1e4 2 1eb
1ed 3 1ea 1ef 1f0 2 1e7 1f2
2 1e6 1f4 1 1f6 3 1f9 1e1
1f8 2 1fc 1fe 6 1a3 1b2 1bd
1c4 1fa 201 1 206 2 20c 20e
7 189 18c 18f 199 204 20a 211
6 16a 16f 174 179 17e 185 1
219 1 21d 1 222 3 21c 221
226 1 22c 1 228 1 232 1
239 1 23b 1 241 2 246 248
1 24e 1 250 2 257 259 1
25e 2 25b 260 2 265 267 2
263 26a 3 244 24b 26d 1 26f
2 272 274 3 270 277 27a 2
27e 280 2 283 286 1 27c 1
289 2 230 236 1 298 1 2ad
2 2a6 2a8 1 2b1 2 2b4 2b3
1 2b5 1 2bd 1 2c0 1 2c2
1 2cb 2 2c9 2cd 1 2d2 1
2d5 3 2db 2de 2e1 2 2e7 2ec
1 32b 2 2f1 2f5 2 2fa 2fe
2 305 307 2 30c 30e 2 315
317 2 31e 320 1 32e 1 336
1 35d 2 33b 33d 3 344 345
346 2 34e 350 3 357 358 35b
1 362 2 364 365 1 367 1
35f 1 36a 1 36d 1 382 2
373 375 3 37c 37d 380 1 387
2 389 38a 1 38c 1 384 1
38f 1 392 3 39b 39c 39f 1
3a1 1 3a6 2 3a8 3a9 1 3ab
1 3a3 1 3ae 1 3b1 3 3b5
395 3b4 1 3b6 1 3ba 1 3bd
1 3be 2 3c1 3c5 3 2c6 2cf
32f 1 3ce 1 3d2 1 3d6 1
3db 1 3e0 5 3d1 3d5 3da 3df
3e4 1 3e6 1 3ef 2 3ed 3f1
1 3f6 1 3f9 2 3fd 3fe 1
402 1 414 2 405 409 2 40f
411 1 41c 1 41a 1 421 1
426 1 423 2 429 42a 1 432
1 437 2 43a 43c 2 43e 440
2 439 442 1 444 1 434 1
447 1 44e 7 458 459 45c 45d
45e 45f 460 1 462 1 467 2
469 46a 1 46c 1 464 1 46f
1 472 2 44a 476 4 3ea 3f3
415 41f 1 47e 1 482 1 487
1 48c 4 481 486 48b 490 1
492 1 49b 2 499 49d 3 4a5
4a6 4a7 1 4ab 2 4b1 4b3 1
4b6 7 4c5 4c8 4cb 4cc 4cd 4ce
4cf 1 4d1 1 4d6 2 4d8 4d9
1 4db 1 4d3 1 4de 1 4e1
1 4e5 3 496 49f 4b7 1 4f6
1 500 1 504 2 503 507 2
50f 510 1 514 1 51d 1 520
1 528 1 52c 1 535 1 538
1 540 1 544 1 54d 1 551
1 555 3 550 554 558 3 560
561 562 1 566 20 b 11 18
1e 48 4e 6f 75 7c 82 91
97 a2 a8 b3 b9 cc d2 123
153 216 28d 29d 2ba 3cb 47b 4ea
4fc 519 531 549 56b 
1
4
0 
575
1
1
28
27
66
0 1 1 1 1 1 1 1
1 1 1 1 1 d 1 f
1 1 1 13 13 15 16 16
16 1 1a 1a 1a 1d 1 1f
1f 21 1 1 1 1 1 0

bb 1 a
54d 27 0
126 c 0
d4 b 0
bc a 0
50 5 0
20 4 0
2bc 1 13
d3 1 b
f0 b 0
3c 4 0
4f 1 5
41a 1a 0
180 d 0
17b d 0
551 27 0
c0 a 0
492 1f 0
3e6 1a 0
2c2 13 0
3cd 1 1a
219 f 0
15f d 0
4bc 21 0
44c 1d 0
334 15 0
84 1 7
4 0 1
534 1 26
4ff 1 24
165 d 0
13e c 0
68 5 0
aa 1 9
47d 1 1f
e1 b 0
2d 4 0
e6 b 0
32 4 0
13 1 3
16c d 0
99 1 8
222 f 0
156 d 0
47e 1f 0
3d2 1a 0
6 1 2
139 c 0
eb b 0
63 5 0
37 4 0
482 1f 0
3d6 1a 0
12a c 0
54 5 0
12f c 0
59 5 0
134 c 0
5e 5 0
4ed 1 23
535 26 0
51d 25 0
ab 9 0
9a 8 0
1f 1 4
d8 b 0
24 4 0
500 24 0
232 f 0
176 d 0
85 7 0
21d f 0
15a d 0
487 1f 0
3db 1a 0
125 1 c
228 f 0
4a1 1f 20
3f5 1a 1b
2d1 13 14
54c 1 27
48c 1f 0
3e0 1a 0
2a0 1 12
171 d 0
218 1 f
504 24 0
89 7 0
155 1 d
77 1 6
555 27 0
c4 a 0
f5 b 0
41 4 0
51c 1 25
3f6 1b 0
3ce 1a 0
2d2 14 0
2bd 13 0
dc b 0
28 4 0
290 1 11
0

/
create or replace package body dbms_system wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
95a425ff
1
4
0 
24
7 PACKAGE:
4 BODY:
b DBMS_SYSTEM:
a SET_EV_ICD:
3 SID:
e BINARY_INTEGER:
3 SER:
2 EV:
3 LEV:
4 NAME:
8 VARCHAR2:
6 PRAGMA:
9 INTERFACE:
1 C:
b READ_EV_ICD:
3 IEV:
3 OEV:
3 OUT:
11 DIST_TXN_SYNC_ICD:
8 INST_NUM:
6 NUMBER:
18 SET_SQL_TRACE_IN_SESSION:
7 SERIAL#:
9 SQL_TRACE:
7 BOOLEAN:
6 SET_EV:
5 10046:
1 1:
0 1 0:
2 SI:
2 SE:
2 LE:
2 NM:
7 READ_EV:
d DIST_TXN_SYNC:
0

0
0
ca
2
0 a0 1d a0 97 9a 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d b4 55 6a :4 a0 b4 5d
9a 8f a0 b0 3d 96 :2 a0 b0
54 b4 55 6a :4 a0 b4 5d 9a
8f a0 b0 3d b4 55 6a :4 a0
b4 5d 9a 8f a0 b0 3d 8f
a0 b0 3d 8f a0 b0 3d b4
55 6a :4 a0 :2 51 6e a5 57 b7
:3 a0 :2 51 6e a5 57 b7 :2 19 3c
b7 a4 b1 11 68 4f 9a 8f
a0 b0 3d 8f a0 b0 3d 8f
a0 b0 3d 8f a0 b0 3d 8f
a0 b0 3d b4 55 6a :6 a0 a5
57 b7 a4 b1 11 68 4f 9a
8f a0 b0 3d 96 :2 a0 b0 54
b4 55 6a :3 a0 a5 57 b7 a4
b1 11 68 4f 9a 8f a0 b0
3d b4 55 6a :2 a0 a5 57 b7
a4 b1 11 68 4f b1 b7 a4
11 a0 b1 56 4f 17 b5 
ca
2
0 3 7 8 c 14 29 25
24 30 3d 39 23 44 4d 49
38 54 61 5d 37 68 71 6d
5c 78 5b 7d 81 85 89 8d
91 95 96 99 ae aa a9 b5
c6 be c2 a8 cc bd d1 d5
d9 dd e1 e5 bc e9 ec 101
fd fc 108 fb 10d 111 115 119
11d 121 125 126 129 13e 13a 139
145 152 14e 138 159 162 15e 14d
169 14c 16e 172 176 17a 17e 182
186 189 18c 190 191 14a 196 19a
19e 1a2 1a5 1a8 1ac 1ad 136 1b2
1b6 1ba f9 1bd ba 1c1 1cc a6
1d0 1e5 1e1 1e0 1ec 1f9 1f5 1df
200 209 205 1f4 210 21d 219 1f3
224 22d 229 218 234 217 239 23d
241 245 249 24d 251 255 259 25a
215 25f 1f1 263 26e 1dd 272 287
283 282 28e 29f 297 29b 281 2a5
296 2aa 2ae 2b2 2b6 2ba 295 2be
293 2c3 27f 2c7 2d2 59 2d6 2eb
2e7 2e6 2f2 2e5 2f7 2fb 2ff 303
307 308 2e3 30d 35 311 31c 21
320 322 324 328 333 337 339 33c
33e 345 
ca
2
0 :2 1 9 e d 18 1c :2 18
2c 30 :2 2c d 10 :2 d 20 24
:2 20 34 39 :2 34 17 :2 3 5 c
17 1a :2 5 d 19 1d :2 19 2d
31 35 :2 2d 18 :2 3 5 c 17
1a :2 5 d 1f 28 :2 1f 1e :2 3
5 c 17 1a :2 5 d 26 2a
:2 26 32 3a :2 32 1f 29 :2 1f 25
:2 3 8 a 11 16 1f 26 29
:2 a 5 a 11 16 1f 26 29
:2 a :4 5 :6 3 d 14 17 :2 14 27
2a :2 27 d 10 :2 d 20 23 :2 20
33 36 :2 33 13 :2 3 b 16 19
1c 1f 22 :2 b :2 5 :4 3 d 15
19 :2 15 29 2d 31 :2 29 14 :2 3
b 17 1c :2 b :2 5 :4 3 d 1b
24 :2 1b 1a :2 3 b 1d :2 b :2 5
:8 3 5 :5 1 
ca
2
0 :4 1 :9 3 :c 4 :3 3 :6 5 :d 8 :6 9
:8 c :6 d :9 10 :4 11 :3 10 13 :9 14 :a 15
:2 13 :2 12 :4 10 :9 1a :c 1b :3 1a :a 1c :4 1a
:d 1f :7 20 :4 1f :8 24 :6 25 :4 24 :4 10 27
:5 1 
347
2
:3 0 1 :4 0 2 :3 0 3 :6 0 1
4 :a 0 1c 2 :2 0 5 3 6
:3 0 5 :6 0 8 7 :4 0 bd 9
7 6 :3 0 7 :6 0 c b :3 0
6 :3 0 8 :6 0 10 f :5 0 d
b 6 :3 0 9 :6 0 14 13 :3 0
b :3 0 a :6 0 18 17 :3 0 1a
:2 0 1c 5 1b 0 c5 c :3 0
d :3 0 e :3 0 4 5 :2 0 13
1e 21 c5 f :a 0 2f 3 :2 0
18 16 6 :3 0 10 :6 0 26 25
:4 0 6d 1d 1a 12 :3 0 6 :3 0
11 :5 0 2b 2a :3 0 2d :2 0 2f
23 2e 0 c5 c :3 0 d :3 0
e :3 0 f 23 :2 0 31 34 c5
13 :a 0 3d 4 44 6d 22 20
15 :3 0 14 :6 0 39 38 :3 0 3b
:2 0 3d 36 3c 0 c5 c :3 0
d :3 0 e :3 0 13 36 :2 0 24
3f 42 c5 16 :a 0 6e 5 3f
67 29 27 15 :3 0 5 :6 0 47
46 :3 0 37 68 2d 2b 15 :3 0
17 :6 0 4b 4a :3 0 19 :3 0 18
:6 0 4f 4e :3 0 51 :2 0 6e 44
52 :2 0 18 :3 0 1a :3 0 5 :3 0
17 :3 0 1b :2 0 1c :2 0 1d :3 0
31 55 5b :2 0 5d 1a :3 0 5
:3 0 17 :3 0 1b :2 0 1e :2 0 1d
:3 0 39 5e 64 :2 0 66 0 66
0 69 54 5d 0 69 41 0
6a :3 0 6d 6c 6a 6b :6 0 6e
1 44 52 6d c5 1a :a 0 94
6 :2 0 48 46 6 :3 0 1f :6 0
73 72 :4 0 93 4c 4a 6 :3 0
20 :6 0 77 76 :3 0 6 :3 0 8
:6 0 7b 7a :3 0 5c 93 50 4e
6 :3 0 21 :6 0 7f 7e :3 0 b
:3 0 22 :6 0 83 82 :3 0 85 :2 0
94 70 86 :2 0 4 :3 0 1f :3 0
20 :3 0 8 :3 0 21 :3 0 22 :3 0
56 88 8e :2 0 90 :3 0 93 92
90 91 :6 0 94 1 70 86 93
c5 23 :a 0 ac 7 0 ab 60
5e 6 :3 0 10 :6 0 99 98 :3 0
68 ab 65 62 12 :3 0 6 :3 0
11 :5 0 9e 9d :3 0 a0 :2 0 ac
96 a1 :2 0 f :3 0 10 :3 0 11
:3 0 a3 a6 :2 0 a8 :3 0 ab aa
a8 a9 :6 0 ac 1 96 a1 ab
c5 24 :a 0 be 8 70 bd 6c
6a 15 :3 0 14 :6 0 b1 b0 :3 0
b3 :2 0 be ae b4 :2 0 13 :3 0
14 :3 0 6e b6 b8 :2 0 ba :3 0
bd bc ba bb :6 0 be 1 ae
b4 bd c5 0 c3 0 c3 :3 0
c3 c5 c1 c2 :6 0 c6 0 3
:3 0 72 0 4 c3 c8 :2 0 2
c6 c9 :6 0 
7d
2
:3 0 1 6 1 a 1 e 1
12 1 16 5 9 d 11 15
19 2 1f 20 1 24 1 28
2 27 2c 2 32 33 1 37
1 3a 2 40 41 1 45 1
49 1 4d 3 48 4c 50 5
56 57 58 59 5a 1 5c 5
5f 60 61 62 63 1 65 2
68 67 1 69 1 71 1 75
1 79 1 7d 1 81 5 74
78 7c 80 84 5 89 8a 8b
8c 8d 1 8f 1 97 1 9b
2 9a 9f 2 a4 a5 1 a7
1 af 1 b2 1 b7 1 b9
a 1c 22 2f 35 3d 43 6e
94 ac be 
1
4
0 
c8
1
1
14
8
1b
0 1 1 1 1 1 1 1
0 0 0 0 0 0 0 0
0 0 0 0 
16 2 0
97 7 0
24 3 0
7d 6 0
79 6 0
e 2 0
12 2 0
5 1 2
81 6 0
75 6 0
4 0 1
70 1 6
44 1 5
71 6 0
9b 7 0
28 3 0
96 1 7
45 5 0
6 2 0
a 2 0
af 8 0
37 4 0
23 1 3
49 5 0
36 1 4
4d 5 0
ae 1 8
0

/
create or replace package body dbms_application_info wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
95a425ff
1
4
0 
16
7 PACKAGE:
4 BODY:
15 DBMS_APPLICATION_INFO:
e ICD_SET_MODULE:
b MODULE_NAME:
8 VARCHAR2:
b ACTION_NAME:
6 PRAGMA:
9 INTERFACE:
1 C:
e ICD_SET_ACTION:
f ICD_READ_MODULE:
3 OUT:
f ICD_READ_ACTION:
13 ICD_SET_CLIENT_INFO:
b CLIENT_INFO:
d ICD_READ_INFO:
a SET_MODULE:
a SET_ACTION:
b READ_MODULE:
f SET_CLIENT_INFO:
10 READ_CLIENT_INFO:
0

0
0
d3
2
0 a0 1d a0 97 9a 8f a0
b0 3d 8f a0 b0 3d b4 55
6a :4 a0 b4 5d 9a 8f a0 b0
3d b4 55 6a :4 a0 b4 5d 9a
96 :2 a0 b0 54 b4 55 6a :4 a0
b4 5d 9a 96 :2 a0 b0 54 b4
55 6a :4 a0 b4 5d 9a 8f a0
b0 3d b4 55 6a :4 a0 b4 5d
9a 96 :2 a0 b0 54 b4 55 6a
:4 a0 b4 5d 9a 8f a0 b0 3d
8f a0 b0 3d b4 55 6a :3 a0
a5 57 b7 a4 b1 11 68 4f
9a 8f a0 b0 3d b4 55 6a
:2 a0 a5 57 b7 a4 b1 11 68
4f 9a 96 :2 a0 b0 54 96 :2 a0
b0 54 b4 55 6a :2 a0 a5 57
:2 a0 a5 57 b7 a4 b1 11 68
4f 9a 8f a0 b0 3d b4 55
6a :2 a0 a5 57 b7 a4 b1 11
68 4f 9a 96 :2 a0 b0 54 b4
55 6a :2 a0 a5 57 b7 a4 b1
11 68 4f b1 b7 a4 11 b1
56 4f 17 b5 
d3
2
0 3 7 8 c 14 29 25
24 30 3d 39 23 44 38 49
4d 51 55 59 5d 37 61 64
79 75 74 80 73 85 89 8d
91 95 99 9d 9e a1 ba b2
b6 b1 c0 b0 c5 c9 cd d1
d5 d9 dd de e1 fa f2 f6
f1 100 f0 105 109 10d 111 115
119 11d 11e 121 136 132 131 13d
130 142 146 14a 14e 152 156 15a
15b 15e 177 16f 173 16e 17d 16d
182 186 18a 18e 192 196 19a 19b
19e 1b3 1af 1ae 1ba 1c7 1c3 1ad
1ce 1c2 1d3 1d7 1db 1df 1e3 1c1
1e7 1bf 1ec 1ab 1f0 1fb 16b 1ff
214 210 20f 21b 20e 220 224 228
22c 230 231 20c 236 12e 23a 245
ee 249 262 25a 25e 259 268 279
271 275 258 27f 270 284 288 28c
290 26f 294 299 29d 2a1 2a2 26d
2a7 256 2ab 2b6 ae 2ba 2cf 2cb
2ca 2d6 2c9 2db 2df 2e3 2e7 2eb
2ec 2c7 2f1 71 2f5 300 35 304
31d 315 319 314 323 313 328 32c
330 334 338 339 311 33e 21 342
34d 351 353 355 357 35b 366 368
36b 36d 374 
d3
2
0 :2 1 9 e d 1c 28 :2 1c
32 3e :2 32 1b :2 3 5 c 17
1a :2 5 d 1c 28 :2 1c 1b :2 3
5 c 17 1a :2 5 d 1d 29
2d :2 1d 1c :2 3 5 c 17 1a
:2 5 d 1d 29 2d :2 1d 1c :2 3
5 c 17 1a :2 5 d 21 2d
:2 21 20 :2 3 5 c 17 1a :2 5
d 1b 27 2b :2 1b 1a :2 3 5
c 17 1a :2 5 d 18 24 :2 18
2e 3a :2 2e 17 :2 3 b 1a 27
:2 b :2 5 :4 3 d 18 24 :2 18 17
:2 3 b 1a :2 b :2 5 :4 3 d 19
25 29 :2 19 33 3f 43 :2 33 18
:2 3 5 15 :3 5 15 :2 5 :6 3 d
1d 29 :2 1d 1c :2 3 b 1f :2 b
:2 5 :4 3 d 1e 2a 2e :2 1e 1d
:2 3 b 19 :2 b :2 5 :8 3 :5 1 
d3
2
0 :4 1 :c 2 :6 3 :8 5 :6 6 :9 8 :6 9
:9 b :6 c :8 e :6 f :9 11 :6 12 :c 15 :7 16
:4 15 :8 18 :6 19 :4 18 :e 1e :4 20 :4 21 :2 1f
:4 1e :8 24 :6 25 :4 24 :9 27 :6 28 :4 27 :4 15
:5 1 
376
2
:3 0 1 :4 0 2 :3 0 3 :6 0 1
4 :a 0 10 2 0 c7 5 3
6 :3 0 5 :6 0 8 7 :5 0 a
7 6 :3 0 7 :6 0 c b :3 0
e :2 0 10 5 f 0 ce 8
:3 0 9 :3 0 a :3 0 4 5 :2 0
12 15 ce b :a 0 1e 3 0
b4 f d 6 :3 0 7 :6 0 1a
19 :3 0 1c :2 0 1e 17 1d 0
ce 8 :3 0 9 :3 0 a :3 0 b
17 :2 0 11 20 23 ce c :a 0
2d 4 :2 0 16 14 d :3 0 6
:3 0 5 :5 0 29 28 :3 0 2b :2 0
2d 25 2c 0 ce 8 :3 0 9
:3 0 a :3 0 c 25 :2 0 18 2f
32 ce e :a 0 3c 5 :2 0 1d
1b d :3 0 6 :3 0 7 :5 0 38
37 :3 0 3a :2 0 3c 34 3b 0
ce 8 :3 0 9 :3 0 a :3 0 e
34 :2 0 1f 3e 41 ce f :a 0
4a 6 0 86 24 22 6 :3 0
10 :6 0 46 45 :3 0 48 :2 0 4a
43 49 0 ce 8 :3 0 9 :3 0
a :3 0 f 43 :2 0 26 4c 4f
ce 11 :a 0 59 7 :2 0 2b 29
d :3 0 6 :3 0 10 :5 0 55 54
:3 0 57 :2 0 59 51 58 0 ce
8 :3 0 9 :3 0 a :3 0 11 51
:2 0 2d 5b 5e ce 12 :a 0 75
8 0 74 32 30 6 :3 0 5
:6 0 63 62 :3 0 3a 74 37 34
6 :3 0 7 :6 0 67 66 :3 0 69
:2 0 75 60 6a :2 0 4 :3 0 5
:3 0 7 :3 0 6c 6f :2 0 71 :3 0
74 73 71 72 :6 0 75 1 60
6a 74 ce 13 :a 0 87 9 42
86 3e 3c 6 :3 0 7 :6 0 7a
79 :3 0 7c :2 0 87 77 7d :2 0
b :3 0 7 :3 0 40 7f 81 :2 0
83 :3 0 86 85 83 84 :6 0 87
1 77 7d 86 ce 14 :a 0 a3
a 0 a2 46 44 d :3 0 6
:3 0 5 :5 0 8d 8c :3 0 4f a2
4b 48 d :3 0 6 :3 0 7 :5 0
92 91 :3 0 94 :2 0 a3 89 95
:2 0 c :3 0 5 :3 0 97 99 :2 0
9f e :3 0 7 :3 0 4d 9b 9d
:2 0 9f :3 0 a2 a1 9f a0 :6 0
a3 1 89 95 a2 ce 15 :a 0
b5 b 58 b4 54 52 6 :3 0
10 :6 0 a8 a7 :3 0 aa :2 0 b5
a5 ab :2 0 f :3 0 10 :3 0 56
ad af :2 0 b1 :3 0 b4 b3 b1
b2 :6 0 b5 1 a5 ab b4 ce
16 :a 0 c8 c 60 c7 5c 5a
d :3 0 6 :3 0 10 :5 0 bb ba
:3 0 bd :2 0 c8 b7 be :2 0 11
:3 0 10 :3 0 5e c0 c2 :2 0 c4
:3 0 c7 c6 c4 c5 :6 0 c8 1
b7 be c7 ce :3 0 cd 0 cd
:3 0 cd ce cb cc :6 0 cf 0
62 0 4 cd d1 :2 0 2 cf
d2 :6 0 
74
2
:3 0 1 6 1 a 2 9 d
2 13 14 1 18 1 1b 2
21 22 1 26 1 2a 2 30
31 1 35 1 39 2 3f 40
1 44 1 47 2 4d 4e 1
52 1 56 2 5c 5d 1 61
1 65 2 64 68 2 6d 6e
1 70 1 78 1 7b 1 80
1 82 1 8a 1 8f 2 8e
93 1 98 1 9c 2 9a 9e
1 a6 1 a9 1 ae 1 b0
1 b8 1 bc 1 c1 1 c3
11 10 16 1e 24 2d 33 3c
42 4a 50 59 5f 75 87 a3
b5 c8 
1
4
0 
d1
1
1
14
c
1a
0 1 1 1 1 1 1 1
1 1 1 1 0 0 0 0
0 0 0 0 
5 1 2
60 1 8
17 1 3
25 1 4
43 1 6
77 1 9
89 1 a
b8 c 0
a6 b 0
52 7 0
44 6 0
34 1 5
8a a 0
61 8 0
26 4 0
6 2 0
4 0 1
8f a 0
78 9 0
65 8 0
35 5 0
18 3 0
a 2 0
51 1 7
b7 1 c
a5 1 b
0

/
create or replace package body dbms_space wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
95a425ff
1
4
0 
1a
7 PACKAGE:
4 BODY:
a DBMS_SPACE:
7 KTSBUSP:
d SEGMENT_OWNER:
8 VARCHAR2:
c SEGMENT_NAME:
c SEGMENT_TYPE:
c TOTAL_BLOCKS:
3 OUT:
6 NUMBER:
b TOTAL_BYTES:
d UNUSED_BLOCKS:
c UNUSED_BYTES:
18 LAST_USED_EXTENT_FILE_ID:
19 LAST_USED_EXTENT_BLOCK_ID:
f LAST_USED_BLOCK:
6 PRAGMA:
9 INTERFACE:
1 C:
7 KTSBFBL:
11 FREELIST_GROUP_ID:
9 FREE_BLKS:
a SCAN_LIMIT:
c UNUSED_SPACE:
b FREE_BLOCKS:
0

0
0
e0
2
0 a0 1d a0 97 9a 8f a0
b0 3d 8f a0 b0 3d 8f a0
b0 3d 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 b4 55
6a :4 a0 b4 5d 9a 8f a0 b0
3d 8f a0 b0 3d 8f a0 b0
3d 8f a0 b0 3d 96 :2 a0 b0
54 8f a0 4d b0 3d b4 55
6a :4 a0 b4 5d 9a 8f a0 b0
3d 8f a0 b0 3d 8f a0 b0
3d 96 :2 a0 b0 54 96 :2 a0 b0
54 96 :2 a0 b0 54 96 :2 a0 b0
54 96 :2 a0 b0 54 96 :2 a0 b0
54 96 :2 a0 b0 54 b4 55 6a
:b a0 a5 57 b7 a4 a0 b1 11
68 4f 9a 8f a0 b0 3d 8f
a0 b0 3d 8f a0 b0 3d 8f
a0 b0 3d 96 :2 a0 b0 54 8f
a0 4d b0 3d b4 55 6a :7 a0
a5 57 b7 a4 a0 b1 11 68
4f b1 b7 a4 11 b1 56 4f
17 b5 
e0
2
0 3 7 8 c 14 29 25
24 30 3d 39 23 44 4d 49
38 54 65 5d 61 37 6b 78
70 74 5c 7e 8f 87 8b 5b
95 a2 9a 9e 86 a8 b9 b1
b5 85 bf cc c4 c8 b0 d2
e3 db df af e9 da ee f2
f6 fa fe 102 d9 106 109 11e
11a 119 125 132 12e 118 139 142
13e 12d 149 156 152 12c 15d 16a
162 166 151 170 17d 179 1 150
184 178 189 18d 191 195 199 19d
177 1a1 1a4 1b9 1b5 1b4 1c0 1cd
1c9 1b3 1d4 1dd 1d9 1c8 1e4 1f5
1ed 1f1 1c7 1fb 208 200 204 1ec
20e 21f 217 21b 1eb 225 232 22a
22e 216 238 249 241 245 215 24f
25c 254 258 240 262 273 26b 26f
23f 279 26a 27e 282 286 28a 28e
292 296 29a 29e 2a2 2a6 2aa 2ae
269 2b2 267 2b7 2bb 23d 2bf 2ca
213 2ce 2e3 2df 2de 2ea 2f7 2f3
2dd 2fe 307 303 2f2 30e 31b 317
2f1 322 32f 327 32b 316 335 342
33e 1 315 349 33d 34e 352 356
35a 35e 362 366 36a 36e 33c 372
33a 377 37b 313 37f 38a 2ef 2db
1e9 38e 392 1c5 39d 1b1 3a0 175 
e0
2
0 :2 1 9 e d 1a 2b :3 1a
2a :3 1a 2a :3 1a 27 2b :3 1a 26
2a :3 1a 28 2c :3 1a 27 2b :3 1a
33 37 :3 1a 34 38 :3 1a 2a 2e
:2 1a 19 :3 3 a 14 17 :2 3 d
1a 2b :3 1a 2a :3 1a 2a :3 1a 2f
:3 1a 24 28 :3 1a 28 37 :2 1a 19
:3 3 a 14 17 :2 3 d 1a 2b
:3 1a 2a :3 1a 2a :3 1a 27 2b :3 1a
26 2a :3 1a 28 2c :3 1a 27 2b
:3 1a 33 37 :3 1a 34 38 :3 1a 2a
2e :2 1a 19 :2 3 5 d 1c 2a
38 6 13 22 30 6 21 :2 5
:2 3 7 :4 3 d 1a 2b :3 1a 2a
:3 1a 2a :3 1a 2f :3 1a 24 28 :3 1a
28 37 :2 1a 19 :2 3 5 d 1c
2a 38 6 11 :2 5 :2 3 7 :8 3
:5 1 
e0
2
0 :4 1 :5 3 :4 4 :4 5 :5 6 :5 7 :5 8
:5 9 :5 a :5 b :5 c :3 3 :6 e :5 10 :4 11
:4 12 :4 13 :5 14 :5 15 :3 10 :6 17 :5 19 :4 1a
:4 1b :5 1c :5 1d :5 1e :5 1f :5 20 :5 21 :5 22
:3 19 :5 25 :4 26 :2 27 :2 25 :2 24 28 :4 19
:5 2a :4 2b :4 2c :4 2d :5 2e :5 2f :3 2a :5 32
:2 33 :2 32 :2 31 34 :4 2a :4 19 :5 1 
3a7
2
:2 0 14e 1 :4 0 2 :3 0 3 :6 0
1 4 :a 0 37 2 200 0 5
3 6 :3 0 5 :6 0 8 7 :3 0
200 21 9 7 6 :3 0 7 :6 0
c b :3 0 6 :3 0 8 :6 0 10
f :3 0 200 35 d b a :3 0
b :3 0 9 :5 0 15 14 :3 0 a
:3 0 b :3 0 c :5 0 1a 19 :3 0
200 59 11 f a :3 0 b :3 0
d :5 0 1f 1e :3 0 a :3 0 b
:3 0 e :5 0 24 23 :3 0 200 83
15 13 a :3 0 b :3 0 f :5 0
29 28 :3 0 a :3 0 b :3 0 10
:5 0 2e 2d :3 0 200 ad 22 17
a :3 0 b :3 0 11 :5 0 33 32
:3 0 35 :2 0 37 5 36 0 db
12 :3 0 13 :3 0 14 :3 0 4 5
:2 0 39 3c db 15 :a 0 5b 3
200 d7 27 25 6 :3 0 5 :6 0
41 40 :3 0 200 116 2b 29 6
:3 0 7 :6 0 45 44 :3 0 6 :3 0
8 :6 0 49 48 :3 0 200 12a 2f
2d b :3 0 16 :6 0 4d 4c :3 0
a :3 0 b :3 0 17 :5 0 52 51
:5 0 38 31 b :3 0 18 :6 0 57
55 56 :2 0 59 :2 0 5b 3e 5a
0 db 12 :3 0 13 :3 0 14 :3 0
15 3e :2 0 5d 60 db 19 :a 0
a7 4 :2 0 3d 3b 6 :3 0 5
:6 0 65 64 :3 0 83 0 41 3f
6 :3 0 7 :6 0 69 68 :3 0 6
:3 0 8 :6 0 6d 6c :4 0 da 45
43 a :3 0 b :3 0 9 :5 0 72
71 :3 0 a :3 0 b :3 0 c :5 0
77 76 :5 0 49 47 a :3 0 b
:3 0 d :5 0 7c 7b :3 0 a :3 0
b :3 0 e :5 0 81 80 :4 0 a6
4d 4b a :3 0 b :3 0 f :5 0
86 85 :3 0 a :3 0 b :3 0 10
:5 0 8b 8a :3 0 65 a6 5a 4f
a :3 0 b :3 0 11 :5 0 90 8f
:3 0 92 :2 0 a7 62 93 :2 0 4
:3 0 5 :3 0 7 :3 0 8 :3 0 9
:3 0 c :3 0 d :3 0 e :3 0 f
:3 0 10 :3 0 11 :3 0 95 a0 :2 0
a2 :3 0 a6 19 :3 0 a5 a2 a3
:6 0 a7 1 62 93 a6 db 1a
:a 0 d5 5 0 da 69 67 6
:3 0 5 :6 0 ac ab :5 0 6d 6b
6 :3 0 7 :6 0 b0 af :3 0 6
:3 0 8 :6 0 b4 b3 :4 0 d4 71
6f b :3 0 16 :6 0 b8 b7 :3 0
a :3 0 b :3 0 17 :5 0 bd bc
:3 0 81 d4 7a 73 b :3 0 18
:6 0 c2 c0 c1 :2 0 c4 :2 0 d5
a9 c5 :2 0 15 :3 0 5 :3 0 7
:3 0 8 :3 0 16 :3 0 17 :3 0 18
:3 0 c7 ce :2 0 d0 :3 0 d4 1a
:3 0 d3 d0 d1 :6 0 d5 1 a9
c5 d4 db :3 0 da db d8 d9
:6 0 dc 0 4 da de 2 dc
df :4 0 
8a
2
:3 0 1 6 1 a 1 e 1
12 1 17 1 1c 1 21 1
26 1 2b 1 30 a 9 d
11 16 1b 20 25 2a 2f 34
2 3a 3b 1 3f 1 43 1
47 1 4b 1 4f 1 54 6
42 46 4a 4e 53 58 2 5e
5f 1 63 1 67 1 6b 1
6f 1 74 1 79 1 7e 1
83 1 88 1 8d a 66 6a
6e 73 78 7d 82 87 8c 91
a 96 97 98 99 9a 9b 9c
9d 9e 9f 1 a1 1 aa 1
ae 1 b2 1 b6 1 ba 1
bf 6 ad b1 b5 b9 be c3
6 c8 c9 ca cb cc cd 1
cf 6 37 3d 5b 61 a7 d5 
1
4
0 
de
1
1
14
5
25
0 1 1 1 1 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 
a9 1 5
74 4 0
17 2 0
b6 5 0
4b 3 0
ba 5 0
8d 4 0
4f 3 0
30 2 0
5 1 2
3e 1 3
bf 5 0
88 4 0
54 3 0
2b 2 0
ae 5 0
67 4 0
43 3 0
a 2 0
6f 4 0
12 2 0
79 4 0
1c 2 0
4 0 1
aa 5 0
63 4 0
3f 3 0
6 2 0
7e 4 0
21 2 0
62 1 4
b2 5 0
6b 4 0
47 3 0
e 2 0
83 4 0
26 2 0
0

/
