#include "protheus.ch"

User Function TstCopy()

Local cOrigem	:= "E:\TEMP\ORIGEM\ARQ1.TXT"
Local cDestino	:= "E:\TEMP\DESTINO\ARQ2.TXT"

__CopyFIle(cOrigem,cDestino)

Return(.T.)
