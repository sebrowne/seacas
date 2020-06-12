C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

C $Log: irever.f,v $
C Revision 1.1  1990/11/30 11:10:31  gdsjaar
C Initial revision
C
C
CC* FILE: [.QMESH]IREVER.FOR
CC* MODIFIED BY: TED BLACKER
CC* MODIFICATION DATE: 7/6/90
CC* MODIFICATION: COMPLETED HEADER INFORMATION
C
      SUBROUTINE IREVER (L, N)
C***********************************************************************
C
C  SUBROUTINE IREVER = REVERS THE INTEGER ARRAY L (I), I=1, N
C
C***********************************************************************
C
      DIMENSION L (N)
C
      IF (N .LE. 1) RETURN
      NUP = N + 1
      M = N / 2
      DO 100 I = 1, M
         NUP = NUP - 1
         ITEMP = L (I)
         L (I) = L (NUP)
         L (NUP) = ITEMP
  100 CONTINUE
C
      RETURN
C
      END
