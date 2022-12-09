#include "rwmake.ch"
#include "protheus.ch"

User Function ImpBol()

Private cPerg := "CSFT07"
ValidPerg()

If Pergunte(cPerg,.T.)
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSeek(xFilial("SE1")+mv_par03+mv_par01)
	//	While !Eof() .and. SE1->E1_NUM >= cTitIni .and. SE1->E1_NUM <= cTitFim .and. SE1->E1_PREFIXO == cSerie
	
	IF E1_PORTAD2 == "237" //"BRADESCO"
		// IMPRIME BOLETO DO BRADESCO
		U_CISFT072(MV_PAR01,MV_PAR02,MV_PAR03)
	ELSEIF E1_PORTAD2 == "341" //"ITAU"
		// IMPRIME BOLETO DO ITAU
		U_CISFT073(MV_PAR01,MV_PAR02,MV_PAR03)
	ENDIF
	
	//	ENDDO
ENDIF

RETURN

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  22/02/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Nota            ?","","","mv_ch1","C",9,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Nota         ?","","","mv_ch2","C",9,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","SEA","",""})
aAdd(aRegs,{cPerg,"03","Serie              ?","","","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","SEA","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return
