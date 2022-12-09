#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ U_METL900  ³ Autor ³William P. Alves       ³ Data ³07.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Reprocessamento dos Livros Fiscais (Base PIS/COFINS)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function METL900()
	
	AjustaSX1()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ mv_par01 - Data Inicial                                        ³
		//³ mv_par02 - Data Final                                          ³
		//³ mv_par03 - NF Inicial				                           ³
		//| mv_par04 - NF Final                                            | 
		//³ mv_par05 - Serie Inicial			                           ³
		//| mv_par06 - Serie Final                                         |
		//| mv_par07 - Filial de (Não usado por ter apenas uma filial)     |
		//| mv_par08 - Filial Ate (Não usado por ter apenas uma filial)    |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Pergunte("MTL900",.T.)
		Processa({||U_MProcNotas()})
	EndIf
	
Return() 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ U_MProcNotas ³ Autor ³William P. Alves     ³ Data ³07.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Reprocessamento dos Livros Fiscais (Base PIS/COFINS)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MProcNotas()

Local aOtimizacao := {}
Local cQuery      := ""
Local cAlias      := "SFT"
Local cIndex      := ""
Local lQuery      := .F.
Local lRefaz      := .F.
Local xWhile	  := ""
Local nX          := 0
Local lControle   := .T.

dbSelectArea("SM0")
SM0->(dbSeek(cEmpAnt+cFilAnt,.T.))

While ! SM0->(Eof()) .And. SM0->M0_CODIGO == cEmpAnt .And. SM0->M0_CODFIL <= cFilAnt
	
	#IFDEF TOP
		aStru       := {}
	#ENDIF
	aOtimizacao := {}
	cQuery      := ""
	cAlias      := "SFT"
	cIndex      := ""
	lQuery      := .F.
	lRefaz      := .F.
	nX          := 0
	xWhile	  	:= ""

	dbSelectArea("SFT")
	dbSetOrder(1)
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			aStru  := SFT->(dbStruct())
			lQuery := .T.
			cAlias := "MProcNotas"
			cQuery := "SELECT SFT.*,SFT.R_E_C_N_O_  SFTRECNO "
			cQuery += "FROM "+RetSqlName("SFT")+" SFT "
				
			cQuery += "WHERE SFT.FT_FILIAL='"+xFilial("SFT")+"' AND "
			
			cQuery += "SFT.FT_ENTRADA>='"+DTOS(MV_PAR01)+"' AND "
			cQuery += "SFT.FT_ENTRADA<='"+DTOS(MV_PAR02)+"' AND "
			cQuery += "SFT.FT_NFISCAL>='"+MV_PAR03+"' AND "
			cQuery += "SFT.FT_NFISCAL<='"+MV_PAR04+"' AND "
			cQuery += "SFT.FT_SERIE>='"+MV_PAR05+"' AND "
			cQuery += "SFT.FT_SERIE<='"+MV_PAR06+"' AND "
			cQuery += "SFT.FT_BASECOF > 0 AND SFT.FT_BASEPIS > 0 AND "
			cQuery += "SFT.FT_BASECOF <> SFT.FT_BASEPIS AND "
			cQuery += "SFT.D_E_L_E_T_<>'*' "
			cQuery += "ORDER BY "+SqlOrder(IndexKey())
	
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
			For nX := 1 To Len(aStru)
				If aStru[nX][2] <> "C"
					TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
				EndIf
			Next nX
		EndIf
	#ENDIF
    
    dbSelectArea("SFT")
    dbSetOrder(1)
    
	While !(cAlias)->(Eof())
		
		lControle := .F.
	    
		If (cAlias)->FT_VALCONT > 0 .And. SFT->(DbSeek(xFilial("SFT")+(cAlias)->(FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO)))
			    		
		RecLock("SFT",.F.) 
				
			SFT->FT_BASECOF 	:= (cAlias)->FT_VALCONT
			SFT->FT_BASEPIS 	:= (cAlias)->FT_VALCONT
			SFT->FT_VALPIS	 	:= ((cAlias)->FT_VALCONT * (cAlias)->FT_ALIQPIS) / 100 
			SFT->FT_VALCOF	 	:= ((cAlias)->FT_VALCONT * (cAlias)->FT_ALIQCOF) / 100
				
		SFT->(MsUnlock())
					
		EndIf
		
		(cAlias)->(dbSkip())
		
	EndDo
	
	If lControle
		MsgInfo("Não há informação a ser corrigida.")
	Else
		MsgInfo("Processo finalizado com sucesso.")
	EndIF
	
	SM0->(dbSkip())
	If lQuery
		dbSelectArea(cAlias)
		dbCloseArea()
		dbSelectArea("SFT")	
	Else
		dbSelectArea("SFT")
		RetIndex("SFT")
	EndIf
Enddo 

Return()  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³William P. ALves     º Data ³ 07/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta grupo de perguntas                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       |METL900                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()    

Local aArea := GetArea()

// mv_par01 - Data Inicial?
PutSX1("MTL900","01","Data Inicial ?","Data Inicial ?","Data Inicial ?","mv_ch1","D",8,0,0,"G"," "," "," "," ","mv_par01"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
// mv_par02 - Data Inicial?
PutSX1("MTL900","02","Data Final ?","Data Final ?","Data Final ?","mv_ch2","D",8,0,0,"G"," "," "," "," ","mv_par02"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
// mv_par03 - da Nota Fiscal ?
PutSX1("MTL900","03","da Nota Fiscal ?","da Nota Fiscal ?","da Nota Fiscal ?","mv_ch3","C",9,0,0,"G"," "," "," "," ","mv_par03"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
// mv_par04 - Ate a Nota Fiscal ?
PutSX1("MTL900","04","Ate a Nota Fiscal ?","Ate a Nota Fiscal ?","Ate a Nota Fiscal ?","mv_ch4","C",9,0,0,"G"," "," "," "," ","mv_par04"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
// mv_par05 - Serie de ?
PutSX1("MTL900","05","Serie de ?","Serie de ?","Serie de ?","mv_ch5","C",3,0,0,"G"," "," "," "," ","mv_par05"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
// mv_par06 - Serie Ate ?
PutSX1("MTL900","06","Serie Ate ?","Serie Ate ?","Serie Ate ?","mv_ch6","C",3,0,0,"G"," "," "," "," ","mv_par06"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
// mv_par07 - Da Filial?
//PutSX1("MTL900"	,"07","Da Filial","Da Filial","Da Filial","mv_ch7","C",2,0,0,"G"," "," "," "," ","mv_par07"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 
// mv_par08 - Ate Filial?
//PutSX1("MTL900"	,"08","Ate Filial","Ate Filial","Ate Filial","mv_ch8","C",2,0,0,"G"," "," "," "," ","mv_par08"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","","","") 

RestArea(aArea)
Return()
 