#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A175GRV บAutor  ณ Adriano Leonardo    บ Data ณ  23/01/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada na valida็ใo da linha do documento de     บฑฑ
ฑฑบ          ณ entrada, utilizado para validar os armaz้ns em notas de    บฑฑ
ฑฑบ          ณ devolu็ใo.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function MT100LOK()

Local _aSavArea := GetArea()
Local _cRotina	:= "MT100LOK"
Local _lRet		:= .T.
Local _nPosArm	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})
Local _nCont
Local _nQtdBlq	:= 0

If cTipo=="D" .And. Procname(5)<>"A103NFISCAL"

	For _nCont := 1 To Len(aCols)
		If !aCols[_nCont,Len(aCols[_nCont])]
			If aCols[_nCont,_nPosArm] <> SuperGetMV("MV_CQ",,"98")
				_nQtdBlq++
			EndIf
		EndIf
	Next
	
	If _nQtdBlq>1
		If MsgYesNo("Aten็ใo, para notas devolu็ใo ้ obrigat๓rio, utilizar o armaz้m " + SuperGetMV("MV_CQ",,"98") + ", deseja alterar os armaz้ns automaticamente?",_cRotina+"_001")		
			For _nCont := 1 To Len(aCols)
				If !aCols[_nCont,Len(aCols[_nCont])]
					If aCols[_nCont,_nPosArm] <> SuperGetMV("MV_CQ",,"98")
						aCols[_nCont,_nPosArm] := SuperGetMV("MV_CQ",,"98")
					EndIf
				EndIf
			Next			
		Else
			_lRet := .F.
		EndIf
	Else
		For _nCont := 1 To Len(aCols)
			If !aCols[_nCont,Len(aCols[_nCont])]
				If aCols[_nCont,_nPosArm] <> SuperGetMV("MV_CQ",,"98")
					MsgStop("Aten็ใo, para notas devolu็ใo ้ obrigat๓rio, utilizar o armaz้m " + SuperGetMV("MV_CQ",,"98") + ", favor corrigir o armaz้m desse item!",_cRotina+"_002")
					_lRet := .F.
					Exit
				EndIf
			EndIf
		Next	
	EndIf	
EndIf

RestArea(_aSavArea)

Return(_lRet)