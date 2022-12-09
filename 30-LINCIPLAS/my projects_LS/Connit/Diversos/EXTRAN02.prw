#INCLUDE "rwmake.ch"
#Include "COLORS.CH"

//=========================================================================================//
// Programa : EXTRAN02        Autor: Eduardo Felipe da Silva            Data: 08/10/03     //
//=========================================================================================//
// Descrição: Rotina para Classificar a pré-nota referente a entrada de mercadoria         //
// 			  por transferência.                                                           //
//=========================================================================================//
// Uso      : Especifico para                                                              //
//=========================================================================================//

User Function EXTRAN02()

//=========================================================================================//
// Declaracao de Variaveis                                                                 //
//=========================================================================================//

SetPrvt("_cNumSeq")
SetPrvt("oFnt","oCod","oMens","cMens","oTimer","oBtn","oButton","oDesc","oFnt1","oFnt2","oFnt3")
SetPrvt("oTexto","oGet","oPreco","cCod","cDesc","cPreco","cTexto","cMens","nCont","lMultimidia")
Private lMsErroAuto := .F.

_cCODBAR:= space(10)
_dULMES := GetMv("MV_ULMES")
_dDATA	:= dDataBase

oFonte := TFont():New("Arial",10,18,,.T.,,,,,)

@ 200,300 To 310,800 Dialog mkwdlg Title OemToAnsi("Entrada de Nota Fiscal de Transferência")

mkwdlg:SetFont(oFonte)    
@ 015,020 Say OemToAnsi ("               Leitura de Código de Barras") Size 300,50 COLOR CLR_HRED
@ 030,020 Say OemToAnsi ("Passe o Leitor no Código de Barras da Nota") Size 300,50 COLOR CLR_HRED 
@ 025,300 Get _cCODBAR Size 000,000
@ 055,300 BmpButton Type 1 Action Verificar() 

Activate Dialog mkwdlg CENTERED                                  
oFonte:End()                        


//=========================================================================================//
//  VERIFICAR A SITUAÇÃO DA NOTA FISCAL E CLASSIFICA                                       //
//=========================================================================================//
Static Function Verificar()

Procregua(500.000)

cDiretor := "\\bigan02-proth01\protheus_data\ftpsites\LocalUser\Lojas\"+SM0->M0_CODFIL+"\"
cArquivo := SM0->M0_CODFIL+Alltrim(_cCODBAR)+".TXT"
If _dULMES > _dDATA
	MsgAlert("Não pode ser lançado movimento com data anterior a última data de fechamento!!!","A T E N Ç Ã O !!!")
Else
	DBSelectArea("SF1")
	DBOrderNickName("F1USER_2")  // Alterado em 23/08/05 
   //	DBSetOrder(8)   
	If DBseek(xFilial("SF1") + _cCODBAR + "UN ")
		IncProc('Classificando Nota Fiscal de Entrada => ' + " " + SF1->F1_DOC)
		
		If SF1->F1_STATUS = "A"
  			Aviso("EXTRAN02","A Nota Fiscal "+SF1->F1_DOC+" "+SF1->F1_SERIE+" já foi lançada!!!",{"OK"},1,"A T E N Ç Ã O !!!")  	
		Else
			If RecLock("SF1",.F.)
				SF1->F1_DTDIGIT  := _dDATA
				SF1->F1_RECBMTO  := _dDATA
	   			SF1->F1_STATUS	:= "A"
	   			MsUnlock()
   			EndIf
			DBSelectArea("SD1")
			DBSetOrder(1)  
			DBseek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
				Do While !Eof() .AND. SD1->D1_DOC = SF1->F1_DOC .AND. SD1->D1_SERIE = SF1->F1_SERIE .AND. SD1->D1_FORNECE = SF1->F1_FORNECE .AND. SD1->D1_LOJA = SF1->F1_LOJA
			        _cNumSeq := GETSXENUM ("SD1","D1_NUMSEQ")
					RecLock("SD1",.F.)  
					D1_DTDIGIT   := _dDATA
					D1_NUMSEQ	:= _cNumSeq  
			        CONFIRMSX8()
   					MsUnlock()
   					DBSelectArea("SB2")
					DBSetOrder(1) 
					cLog := "NF: "+SD1->D1_DOC+"/"+SD1->D1_SERIE+" Produto: " + SD1->D1_COD + " "
   					If DBseek(xFilial("SB2") + SD1->D1_COD + SD1->D1_LOCAL)
						cLog += "Saldo Atual alterado de "+Alltrim(Str(SB2->B2_QATU))+" para "
			        	RecLock("SB2",.F.)  
						B2_QATU := SB2->B2_QATU + SD1->D1_QUANT
						B2_VATU1:= SB2->B2_QATU * SB2->B2_CM1
   						MsUnlock()
						cLog += Alltrim(Str(SB2->B2_QATU))
   					Else
   						RecLock("SB2",.T.)  
						B2_FILIAL:= SD1->D1_FILIAL
						B2_COD   := SD1->D1_COD
						B2_LOCAL := SD1->D1_LOCAL
						B2_CM1   := ROUND(SD1->D1_CUSTO / SD1->D1_QUANT,4)
						B2_QATU  := SB2->B2_QATU + SD1->D1_QUANT
						B2_VATU1 := SB2->B2_QATU * SB2->B2_CM1
						MsUnlock()
						cLog += "Saldo Atual criado com "+Alltrim(Str(SB2->B2_QATU))
   					EndIf
   					U_LSLogSB2(cLog)
					DBSelectArea("SD1")
   					dbSkip()
   				EndDo
			Aviso("EXTRAN02","A Nota Fiscal foi lançado com sucesso!",{"OK"},1,"A T E N Ç Ã O !!!")  	
		EndIF	
	ElseIf File(cDiretor+cArquivo)
		Processa( {|| Adicionar(cDiretor,cArquivo,_cCodbar) },'Lançando Nota Fiscal de Entrada => ' + Substr(_cCodBar,5,6))
	Else
		Aviso("EXTRAN02","Esta nota fiscal deve ser classificada pela Área Fiscal!!!",{"OK"},1,"A T E N Ç Ã O !!!")  	
	EndIf
EndIf

Close(mkwdlg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ Adicionar ³ Autor ³ Eduardo Felipe da Silva³ Data³ 09/06/06 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Inclui Nota Fiscal de entrada com base em arquivo texto.	º±±
±±ºÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±ºModulos   ³ Estoque/Custos                                              º±±
±±ºÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±ºUso       ³                        	                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Adicionar(cDiretor,cArquivo,cCodBar)

//nArq    := fOpen(cPathArq,0)
//nStr	:= 96
//cLinArq := fReadStr(nArq, nStr)
cPathArq  := cDiretor+cArquivo
lAtualiza := .T.
cNota 	  := Space(9)
cSerie	  := Space(3)

FT_FUSE(cPathArq)

ProcRegua(Reccount())

FT_FGotop()		
Do While ( !FT_FEof() )
	cLinArq  := FT_FREADLN()
			
	IncProc('Incluindo a Nota Fiscal => '+" "+Alltrim(Substr(cLinArq,1,9)))

//	MsgAlert(Substr(cCodBar,1,4),"Aten‡„o!")


	If cNota <> Substr(cLinArq,1,9)
		cNota  := Substr(cLinArq,1,9)
		cSerie := Alltrim(Substr(cLinArq,11,3))
		dEmissao := Ctod(Substr(cLinArq,21,2)+"/"+Substr(cLinArq,19,2)+"/"+Substr(cLinArq,15,4))
		dbSelectArea("SA2")
		dbSetOrder(3)

		If dbSeek(xFilial("SA2")+Substr(cLinArq,24,13))
			aCabec := {}
			aItens := {}
			aadd(aCabec,{"F1_TIPO"   ,"N"})
			aadd(aCabec,{"F1_FORMUL" ,"N"})
//			aadd(aCabec,{"F1_SENHA"  ,Substr(cCodBar,1,4)})
			aadd(aCabec,{"F1_DOC"    ,cNota})
			aadd(aCabec,{"F1_SERIE"  ,cSerie})
			aadd(aCabec,{"F1_EMISSAO",dEmissao})
			aadd(aCabec,{"F1_FORNECE",SA2->A2_COD})
			aadd(aCabec,{"F1_LOJA"   ,SA2->A2_LOJA})
			aadd(aCabec,{"F1_ESPECIE","NFE"})
			If Substr(cLinArq,24,8) = Substr(SM0->M0_CGC,1,8)
				aadd(aCabec,{"F1_COND","003"})
     		Else
				aadd(aCabec,{"F1_COND","001"})
			EndIf
		EndIf
	EndIf

	nQde    := Round(Val(Subs(cLinArq,55,14))/1000,2)
	nPrUnit := Val(Subs(cLinArq,70,14))/100
  /*        
	dbSelectArea("SB1")
	dbSetOrder(1)
	If ! dbSeek(xFilial("SB1")+Alltrim(Substr(cLinArq,36,15)))
		dbSelectArea("SB1")
		DbOrderNickName("CODNEW")
		If !dbSeek(xFilial("SB1")+Alltrim(Substr(cLinArq,36,15)))
			lAtualiza := .F.	    
			Aviso("EXTRAN02","O produto "+Alltrim(Substr(cLinArq,36,15))+" não existe no cadastro.",{"OK"},1,"A T E N Ç Ã O !!!")
	    EndIf
	EndIf   */
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+Alltrim(Substr(cLinArq,39,15)))
	   cProd := Alltrim(SB1->B1_COD)
	Else 
		dbSelectArea("SB1")
		DbOrderNickName("CODNEW")
		If dbSeek(xFilial("SB1")+Alltrim(Substr(cLinArq,39,15)))
			cProd := Alltrim(SB1->B1_COD)
		Else
			Aviso("EXTRAN02","O produto "+Alltrim(Substr(cLinArq,39,15))+" não existe no cadastro.",{"OK"},1,"A T E N Ç Ã O !!!")
			lAtualiza := .F.  
			cProd	  := Space(15)
		EndIf
	EndIf 

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProd)
		
	If lAtualiza
		aLinha := {}
//		aadd(aLinha,{"D1_COD"    ,Alltrim(Substr(cLinArq,36,15)),Nil})
		aadd(aLinha,{"D1_COD"    ,cProd,Nil})
//		aadd(aLinha,{"D1_LOCAL"  ,"12",Nil})  
		aadd(aLinha,{"D1_CC"  ,GETMV("MV_CCPAD"),Nil})
		aadd(aLinha,{"D1_QUANT"  ,nQde,Nil})
		aadd(aLinha,{"D1_VUNIT"  ,nPrUnit,Nil})		
		aadd(aLinha,{"D1_TOTAL"  ,nPrUnit * nQde,Nil})
	   //	If Substr(cLinArq,24,8) = Substr(SM0->M0_CGC,1,8)
//			aadd(aLinha,{"D1_TES"  ,"044",Nil})
		If cNumemp = "D2F2"
			aadd(aLinha,{"D1_OPER"  ,"F",Nil})
		EndIf
		//EndIf
		aadd(aItens,aLinha) 
	EndIf
	FT_FSkip()
Enddo

FT_FUse()

fClose(cPathArq) 

If lAtualiza
	If cNumemp = "D2F2"
		MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3) //Executa Sigaauto pré-nota
	Else
		MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3) //Executa Sigaauto
	EndIf
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+Alltrim(Substr(cCodBar,5,9)))
		RecLock("SF1",.F.)  
		SF1->F1_SENHA := Substr(cCodBar,1,4)	
		MsUnlock()
	EndIf
	If lMsErroAuto 
		MostraErro()
	Else
		Aviso("EXTRAN02","A Nota Fiscal foi lançado com sucesso!",{"OK"},1,"A T E N Ç Ã O !!!") 
		__CopyFile(cPathArq,cDiretor+"\backup\"+cArquivo)
		Ferase(cPathArq)
	EndIf
EndIf

Return