C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details
      SUBROUTINE MXEROR (UNIT, LASTER, ERRVEC)

      IMPLICIT INTEGER (A-Z)
      INCLUDE 'params.inc'
      DIMENSION ERRVEC(NERVEC)

      WRITE (UNIT, 10010)LASTER
      WRITE (UNIT, 10000) (ERRVEC(I), I, I=1,NERVEC)
      RETURN
10000 FORMAT(/'0* * * * * E R R O R   C O D E S * * * * *'/
     *   '0OCCURANCES FLAG  MESSAGE TEXT'//
     *   5X,I6,I4,2X,'SUCCESSFUL COMPLETION'/
     *   5X,I6,I4,2X,'UNABLE TO GET REQUESTED SPACE FROM SYSTEM'/
     *   5X,I6,I4,2X,'DATA MANAGER NOT INITIALIZED'/
     *   5X,I6,I4,2X,'DATA MANAGER WAS PREVIOUSLY INITIALIZED'/
     *   5X,I6,I4,2X,'NAME NOT FOUND IN DICTIONARY'/
     *   5X,I6,I4,2X,'NAME ALREADY EXISTS IN DICTIONARY'/
     *   5X,I6,I4,2X,'ILLEGAL LENGTH REQUEST'/
     *   5X,I6,I4,2X,'UNKNOWN DATA TYPE'/
     *   5X,I6,I4,2X,'DICTIONARY IS FULL'/
     *   5X,I6,I4,2X,'VOID TABLE IS FULL'/
     *   5X,I6,I4,2X,'MEMORY BLOCK TABLE IS FULL'/
     *   5X,I6,I4,2X,'OVERLAPPING VOIDS - INTERNAL ERROR'/
     *   5X,I6,I4,2X,'OVERLAPPING MEMORY BLOCKS - INTERNAL ERROR'/
     *   5X,I6,I4,2X,'INVALID MEMORY BLOCK - EXTENSION LIBRARY ERROR'/
     *   5X,I6,I4,2X,'INVALID ERROR CODE'/
     *   5X,I6,I4,2X,'INVALID INPUT NAME'/
     *   5X,I6,I4,2X,'ILLEGAL CALL WHILE IN DEFERRED MODE'/
     *   5X,I6,I4,2X,'NAME IS OF WRONG TYPE FOR OPERATION'/)
10010 FORMAT(///'0LAST ERROR/RETURN CODE: ',I5)
      END
