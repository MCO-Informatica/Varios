#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"

User Function RFATG07()

Local _cProduto := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO" })]
Local _cLocal	:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"   })]
Local _nEstoque := 0
Local _nEstLojas:= 0
Local _cMsg		:= ""

If !Alltrim(FunName())$"RFATR05"
	
	If M->C5_TIPO$"N" .AND. !Empty(M->C5_X_ARMAZ)

		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2")+_cProduto+_cLocal,.f.)
			_nEstoque	:=	SaldoSB2()
		EndIf			
		
		If _nEstoque <= 0 .and. !M->C5_CLIENTE$"384794"
		
			If MsgYesNo("O produto "+Alltrim(_cProduto)+" Não possui estoque disponível no armazém "+_cLocal+".Deseja consultar o estoque do armazém de outra unidade/loja?","Estoque")
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial("SB2")+_cProduto,.f.)
					While Eof() == .f. .and. SB2->B2_COD == _cProduto
					
						dbSelectArea("NNR")
						dbSetOrder(1)
						dbSeek(xFilial("NNR")+SB2->B2_LOCAL,.F.)
						
						_nEstLojas	:=	SaldoSB2()
						_cMsg += "Arm.: "+SB2->B2_LOCAL+" "+NNR->NNR_DESCRI+  "Disp.: "+Transform(_nEstLojas,"@E 999,999.999999")+CHR(13)+CHR(10)
						
						dbSelectArea("SB2")
						dbSkip()
					EndDo	
				EndIf	
		
				If Len(_cMsg) < 1
					_cMsg += "Não há estoque disponível em nenhuma unidade/loja."
				EndIf
				
				MessageBox(_cMsg, "Disponibilidade",16)  
		
			EndIf			
		EndIf
	EndIf
EndIf

Return(_nEstoque)


