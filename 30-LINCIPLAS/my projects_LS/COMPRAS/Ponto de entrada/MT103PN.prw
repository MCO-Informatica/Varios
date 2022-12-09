#Include "Protheus.ch"

// Vanilson *Documentar*


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT103PN   บAutor  ณMicrosiga           บ Data ณ  05/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฟ
//ณEste ponto de entrada pertence เ rotina de manuten็ใo de documentos de entrada, ณ
//ณMATA103. ษ executada em A103NFISCAL, na inclusใo de um documento de entrada.    ณ
//ณEla permite ao usuแrio decidir se a inclusใo serแ executada ou nใo.             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ู
*/

User Function __MT103PN()

Local lValid   := .T.
U_LS_F1VLCOND(4,dDemissao,cCondicao,cEspecie)

/*
Local nPosCod  := ""
Local nPosTes  := ""
Local cTipoEmp := ""
Local nPosCf   := ""
Local _nI      

If cEmpAnt <> '01'
	Return(.t.)
EndIf
          

nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
nPosCf	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"}) 

If SF1->F1_TIPO <> 'DB'
	cFornec := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
	cEstado := SA2->A2_EST
Else
	cFornec := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_CGC")
	cEstado := SA1->A1_EST
EndIf

If AllTrim(SM0->M0_CODFIL) $ "01/55"
	cTipoEmp := "M"
ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ")
	cTipoEmp := "F"
Else
	cTipoEmp := "C"
EndIf

For _nI := 1 To Len(aCols)
	
	If Substr(cFornec,1,8) $ GetMv("MV_LSVCNPJ")
		
		cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TE")
		cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
		
	ElseIf Substr(cFornec,1,8) $ GetMv("MV_CNPJLSV") .AND. cTipoEmp = "M"
		
		cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TEC")
		cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
		
	Else
		
		cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TE_FORN")
		cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
		
	EndIf
	
	If SM0->M0_ESTENT <> cEstado .AND. !Empty(cTes)
		
		cCf := "2"+Substr(cCf,2,3)
		
	EndIf
	
	aCols[_nI,nPosTes] := cTes
	aCols[_nI,nPosCf]  := cCf   
Next
*/
Return(lValid)
