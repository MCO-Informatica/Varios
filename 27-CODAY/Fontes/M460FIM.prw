#include "rwmake.ch"
#include "Topconn.ch"

User Function M460FIM()

RecLock("SF2", .F. )
SF2->F2_VOLUME1	:= SC5->C5_VOLUME1
SF2->F2_ESPECI1	:= SC5->C5_ESPECI1
SF2->F2_PBRUTO	:= SC5->C5_PBRUTO
SF2->F2_PLIQUI	:= SC5->C5_PESOL
MsUnLock()

Return
