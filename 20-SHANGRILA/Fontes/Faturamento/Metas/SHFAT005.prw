#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndSZ6
Static lCopia


User Function SHFAT005()
Local cVldAlt := ".T." // Validação para permitir a alteração. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validação para permitir a exclusão. Pode-se utilizar ExecBlock.

Private cString := "SZ9"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Regionais",cVldExc,cVldAlt)

Return

User Function SH003COD(cTabela,cCampo,nZero)
Local cCodigo := ''
Local oMeta   := SHMET001():New()
                        
Default nZero := 3

oMeta:cTabela := cTabela
oMeta:cCampo  := cCampo

cCodigo := oMeta:SHMETCOD(oMeta:cTabela,oMeta:cCampo,nZero)

Return cCodigo

