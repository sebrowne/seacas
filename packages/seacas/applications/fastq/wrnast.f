C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

      SUBROUTINE WRNAST (MS, MR, NPNODE, NPELEM, MXNFLG, MXSFLG, NPREGN,
     &   NPNBC, NPSBC, IUNIT, NNN, KKK, NNXK, NODES, NELEMS, NNFLG,
     &   NNPTR, NNLEN, NSFLG, NSPTR, NSLEN, NVPTR, NVLEN, NSIDEN,
     &   MAPDXG, XN, YN, NXK, MAT, MAPGXD, MATMAP, NBCNOD, NNLIST,
     &   NBCSID, NSLIST, NVLIST, NUMMAT, LINKM, TITLE, ERR, EIGHT,
     &   NINE, LONG)
C************************************************************************

C  SUBROUTINE WRNAST = WRITES NASTRAN DATABASE MESH OUTPUT FILE

C***********************************************************************

      DIMENSION XN(NPNODE), YN(NPNODE), NXK(NNXK, NPELEM), MAT(NPELEM)
      DIMENSION NODES(NPNBC), NELEMS(NPSBC), NSIDEN(NPSBC)
      DIMENSION NNFLG(MXNFLG), NNLEN(MXNFLG), NNPTR(MXNFLG)
      DIMENSION NSFLG(MXSFLG), NSLEN(MXSFLG), NSPTR(MXSFLG)
      DIMENSION NVLEN(MXSFLG), NVPTR(MXSFLG), LINKM(2, (MS+MR))
      DIMENSION MAPDXG(NPNODE), MAPGXD(NPNODE), MATMAP(3, NPREGN)

      CHARACTER*72 TITLE, DUMMY, DUMMY2

      LOGICAL ERR, EIGHT, NINE, DEFTYP, LONG

      ERR = .TRUE.

C  WRITE OUT HEADER TITLE AND INFORMATION

      WRITE(IUNIT, 10000, ERR = 180)TITLE
      WRITE(IUNIT, 10010, ERR = 180)NNN, KKK, NBCNOD

C  WRITE OUT NODE BLOCK

      WRITE(IUNIT, 10020, ERR = 180)
      Z = 0.
      DO 100 I = 1, NNN
         CALL GETDUM(I, DUMMY, LEN)
         IF (LONG) THEN
            WRITE(IUNIT, 10030, ERR = 180)I, XN(I), YN(I), DUMMY(1:6),
     &         DUMMY(1:6), Z
         ELSE
            WRITE(IUNIT, 10040, ERR = 180)I, XN(I), YN(I), Z
         ENDIF
  100 CONTINUE

C  QUERY THE USER FOR LOCAL CONTROL OF ELEMENT TYPE

      CALL INQTRU('USE DEFAULT ELEMENT TYPES FOR ELEMENT BLOCKS',
     &   DEFTYP)

C  WRITE OUT ELEMENT BLOCKS

      DO 150 I = 1, NUMMAT
         CALL GETDUM(MATMAP(1, I), DUMMY, LEN)
         IF(NXK(3, MATMAP(2, I)).EQ.0)THEN
            WRITE(IUNIT, 10050, ERR = 180)DUMMY(1:LEN)
            INODE = 2
            IF(DEFTYP)THEN
               DUMMY2 = 'CBAR'
               LEN2 = 4
            ELSE
               WRITE(*, 10060)MATMAP(1, I)
               CALL INQSTR('2 NODE ELEMENT TYPE:  ', DUMMY2)
               CALL STRLNG(DUMMY2, LEN2)
            ENDIF
         ELSEIF (NXK(4, MATMAP(2, I)) .EQ. 0)THEN
            CALL MESAGE('THREE NODE BAR ELEMENTS NOT SUPPORTED')
            CALL MESAGE('THE CENTER NODE WILL BE IGNORED')
            WRITE(IUNIT, 10050, ERR = 180)DUMMY(1:LEN)
            IF (DEFTYP)THEN
               DUMMY2 = 'CBAR'
               LEN2 = 4
            ELSE
               WRITE(*, 10060) MATMAP(1, I)
               CALL INQSTR ('2 NODE ELEMENT TYPE:  ', DUMMY2)
               CALL STRLNG (DUMMY2, LEN2)
            ENDIF
            INODE = 3
         ELSEIF(EIGHT.OR.NINE)THEN
            WRITE(IUNIT, 10070, ERR = 180) DUMMY(1:LEN)
            IF (NINE) THEN
               CALL MESAGE('NINE NODE QUAD ELEMENTS NOT SUPPORTED')
               CALL MESAGE('THE CENTER NODE WILL BE IGNORED')
            ENDIF
            IF(DEFTYP)THEN
               DUMMY2 = 'CQUAD8'
               LEN2 = 6
            ELSE
               WRITE(*, 10060)MATMAP(1, I)
               CALL INQSTR('8 NODE ELEMENT TYPE:  ', DUMMY2)
               CALL STRLNG(DUMMY2, LEN2)
            ENDIF
            INODE = 8
         ELSE
            WRITE(IUNIT, 10080, ERR = 180)DUMMY(1:LEN)
            IF(DEFTYP)THEN
               DUMMY2 = 'CQUAD4'
               LEN2 = 6
            ELSE
               WRITE(*, 10060)MATMAP(1, I)
               CALL INQSTR('4 NODE ELEMENT TYPE:  ', DUMMY2)
               CALL STRLNG(DUMMY2, LEN2)
            ENDIF
            INODE = 4
         ENDIF
         CALL STRIPB(DUMMY2, ILEFT, IRIGHT)
         IRIGHT = ILEFT+7
         IF(NXK(3, MATMAP(2, I)).EQ.0)THEN
            DO 110 K = MATMAP(2, I), MATMAP(3, I)
               WRITE(IUNIT, 10090, ERR = 180)DUMMY2(ILEFT:IRIGHT), K,
     &            MATMAP(1, I), (NXK(J, K), J = 1, INODE)
  110       CONTINUE
         ELSEIF(NXK(4, MATMAP(2, I)).EQ.0)THEN
            DO 120 K = MATMAP(2, I), MATMAP(3, I)
               WRITE(IUNIT, 10090, ERR = 180)DUMMY2(ILEFT:IRIGHT), K,
     &            MATMAP(1, I), (NXK(J, K), J = 1, INODE, 2)
  120       CONTINUE
         ELSEIF(EIGHT.OR.NINE)THEN
            DO 130 K = MATMAP(2, I), MATMAP(3, I)
               WRITE(IUNIT, 10100, ERR = 180)DUMMY2(ILEFT:IRIGHT), K,
     &            MATMAP(1, I), NXK(1, K), NXK(3, K), NXK(5, K),
     &            NXK(7, K), NXK(2, K), NXK(4, K), NXK(6, K), NXK(8, K)
  130       CONTINUE
         ELSE
            DO 140 K = MATMAP(2, I), MATMAP(3, I)
               WRITE(IUNIT, 10110, ERR = 180)DUMMY2(ILEFT:IRIGHT), K,
     &            MATMAP(1, I), (NXK(J, K), J = 1, INODE)
  140       CONTINUE
         ENDIF
  150 CONTINUE

C  WRITE OUT THE NODAL BOUNDARY CONDITIONS

      IF(NBCNOD.GT.0)THEN
         DO 170 I = 1, NBCNOD
            J1 = NNPTR(I)
            J2 = NNPTR(I) + NNLEN(I)-1
            CALL GETDUM (NNFLG(I), DUMMY, LEN)
            WRITE (IUNIT, 10120) DUMMY(1:LEN)
            WRITE (*, 10130)NNFLG(I)
            CALL INQSTR ('DEGREES OF FREEDOM  RESTRAINED (NO BLANKS): ',
     &         DUMMY)
            DO 160 J = J1, J2
               WRITE(IUNIT, 10140, ERR = 180)NNFLG(I), NODES(J),
     &            DUMMY(1:6)
  160       CONTINUE
  170    CONTINUE
      ENDIF

C  NOTIFY USER THAT SIDE BOUNDARY FLAGS ARE NOT SUPPORTED

      IF (NBCSID .GT. 0) THEN
         CALL MESAGE('NO SIDE BOUNDARY FLAGS SUPPORTED BY NASTRAN')
      ENDIF

C  END THE DATA

      WRITE(IUNIT, 10150)
      CALL MESAGE ('NASTRAN OUTPUT FILE SUCCESSFULLY WRITTEN')
      ERR = .FALSE.
      RETURN

C  ERR DURING WRITE PROBLEMS

  180 CONTINUE
      CALL MESAGE ('ERR DURING WRITE TO ABAQUS OUTPUT FILE')
      CALL MESAGE ('         - NO FILE SAVED -            ')
      RETURN

10000 FORMAT('$TITLE: ', /, A72)
10010 FORMAT('$', /,
     &   '$     MESH GENERATED USING FASTQ        ', /,
     &   '$  NUMBER OF NODES:                     ', I5, /,
     &   '$  NUMBER OF ELEMENTS:                  ', I5, /,
     &   '$  NUMBER OF NODAL BOUNDARY CONDITIONS: ', I5, /,
     &   '$', /,
     &   'BEGIN BULK')
10020 FORMAT('$ NODE (GRID) DATA FOLLOWS:')
10030 FORMAT('GRID*   ', I16, 16X, 2E16.9, '*N', A6, /, '*N', A6,
     &   E16.9, '345')
10040 FORMAT('GRID    ', I8, 8X, 3F8.4, '345')
10050 FORMAT('$ 2 NODE BAR ELEMENTS FOR BLOCK ID ', A, ' FOLLOW:')
10060 FORMAT(' FOR BLOCK ID:', I7, '  ENTER NEW')
10070 FORMAT('$ 8 NODE QUAD ELEMENTS FOR BLOCK ID ', A, ' FOLLOW:')
10080 FORMAT('$ 4 NODE QUAD ELEMENTS FOR BLOCK ID ', A, ' FOLLOW:')
10090 FORMAT(A8, 4I8)
10100 FORMAT(A8, 9I8, /, 8X, I8)
10110 FORMAT(A8, 6I8)
10120 FORMAT('$ NODAL CONSTRAINTS FOR BOUNDARY FLAG ', A, ' FOLLOW:')
10130 FORMAT(' INPUT THE CONSTRAINTS FOR NODAL BOUNDARY FLAG: ', I5)
10140 FORMAT('SPC     ', 2I8, A8)
10150 FORMAT('ENDDATA')

      END
