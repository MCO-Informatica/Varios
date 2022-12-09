#INCLUDE "PROTHEUS.CH"

#DEFINE NMAXPAGE	999

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT320BUT  �Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FT320BUT()
Local aRetBut := {}

AaDd(aRetBut,{"Atu. Oport.",{|| FT320LoadAD1() }})
AaDd(aRetBut,{"Td. Oport.",{|| FT320Oportun() }})

Return(aRetBut)           

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT320LoadAD1�Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FT320LoadAD1()

Local aArea		:= GetArea()
Local aOportun	:= {}						//Array que armazena todas as oportunidades do vendedor
Local lExisteADL:= .F.						// Valida se o arquivo de contas dos vendedores existe
Local aFixe		:= {}
Local nTotReg	:= 0  
Local nX    
Local cBLine	:= "{||{"
Local cSep		:= ""

#IFDEF TOP
	Local cAlias	:= "TRBAD1"  
	Local bNextReg	:= {|oOportun,aFixe|Ft320LeBd(@oOportun,aFixe,cAlias,cBLine,nTotReg,"oOportun","AD1")}
#ELSE
	Local cFiltro	:= ""
#ENDIF

AAdd(aFixe,{Nil,"AD1_NROPOR"})
AAdd(aFixe,{Nil,"AD1_DESCRI"})
If FtIsP10R13()
	AAdd(aFixe,{Nil,"AD1_CODCLI"})
	AAdd(aFixe,{Nil,"AD1_LOJCLI"})
EndIf
AAdd(aFixe,{Nil,"AD1_PROSPE"})
AAdd(aFixe,{Nil,"AD1_LOJPRO"})

//����������������������������������������������������������������Ŀ
//�Monta o bloco responsavel pela exibicao das linhas dinamicamente�
//������������������������������������������������������������������
For nX := 1 to Len(aFixe)
	cBLine	+= cSep+"oOportun:aArray[oOportun:nAt,"+AllTrim(Str(nX))+"]"
	cSep	:= ","
Next nX                

cBLine	+= "}}"

#IFDEF TOP
	
	//�������������������������Ŀ
	//�Conta registros da tabela�
	//���������������������������
	DbSelectArea(cAlias)
	DbGoTop()
	While !Eof() .AND. nTotReg <= NMAXPAGE
		nTotReg++
		DbSkip()
	End
	
	//����������������������������Ŀ
	//�Carrega dados para o ListBox�
	//������������������������������
	Ft320LeBd(@oOportun,aFixe,cAlias,cBLine,nTotReg,"oOportun","AD1")
	
	oOportun:bLine := &(cbLine)

	If Len(oOportun:aArray) <= 0
		AAdd(aOportun,{"","","","","","","",""})
		oOportun:SetArray(aOportun)
		oOportun:bLine := &(cbLine)
	EndIf 

#ELSE

	SX2->( dbSetOrder(1) )
	If SX2->( dbSeek( "ADL" ) )
		lExisteADL := .T.
		ADL->(DbClearFilter())
	Endif
	
	If !lExisteADL
		DbSelectArea("AD1")
		DbSetOrder(2)
		If DbSeek( xFilial("AD1") + SA3->A3_COD )
			While AD1->( !Eof() .AND. AD1->AD1_FILIAL + AD1->AD1_VEND == xFilial("AD1") + SA3->A3_COD )
				If AD1->AD1_STATUS $ "13"	// Aberto ou Suspenso
					If FtIsP10R13()
						aAdd( aOportun, { 	AD1->AD1_NROPOR,;
											AD1->AD1_DESCRI,;
										  	Posicione("SUS",1,xFilial("SUS")+AD1->(AD1_PROSPE+AD1_LOJPRO),"US_CODCLI"),;
										  	SUS->US_LOJACLI,;
										  	Alltrim(Posicione("SA1",1,xFilial("SA1")+SUS->(US_CODCLI+US_LOJACLI),"A1_NOME")),;
										  	AD1->AD1_PROSPE,;
										  	AD1->AD1_LOJPRO,;
										  	Alltrim(SUS->US_NOME)} )
					Else
						aAdd( aOportun, { 	AD1->AD1_NROPOR,;
											AD1->AD1_DESCRI,;
										  	AD1->AD1_PROSPE,;
										  	AD1->AD1_LOJPRO,;
										  	Alltrim(SUS->US_NOME)} )					
					EndIf
				EndIf
				AD1->( dbSkip() )
			End
		Endif
	Else     
		
		cFiltro	:= "ADL->ADL_FILIAL == '"+xFilial("ADL")+"' .AND. ADL->ADL_VEND $ '"+cVendorList+"'"
		
		DbSelectArea("ADL")
		Set Filter to &cFiltro
		DbGoTop()
		
		While ADL->( !Eof() )
			DbSelectArea("AD1")
			DbSetOrder(1)
			If DbSeek( xFilial("AD1") + ADL->ADL_CODOPO ) .AND. !Empty(ADL->ADL_CODOPO)
			
				If AD1->AD1_STATUS $ "13"	// Aberto ou Suspenso
					If FtIsP10R13()
						aAdd( aOportun, { 	AD1->AD1_NROPOR,;
											AD1->AD1_DESCRI,;
										  	Posicione("SUS",1,xFilial("SUS")+AD1->(AD1_PROSPE+AD1_LOJPRO),"US_CODCLI"),;
										  	SUS->US_LOJACLI,;
										  	Alltrim(Posicione("SA1",1,xFilial("SA1")+SUS->(US_CODCLI+US_LOJACLI),"A1_NOME")),;
										  	AD1->AD1_PROSPE,;
										  	AD1->AD1_LOJPRO,;
										  	Alltrim(SUS->US_NOME)} )
					Else
						aAdd( aOportun, { 	AD1->AD1_NROPOR,;
											AD1->AD1_DESCRI,;
										  	Alltrim(Posicione("SA1",1,xFilial("SA1")+SUS->(US_CODCLI+US_LOJACLI),"A1_NOME")),;
										  	AD1->AD1_PROSPE,;
										  	AD1->AD1_LOJPRO,;
										  	Alltrim(SUS->US_NOME)} )					
					EndIf
				EndIf
			Endif
			ADL->( dbSkip() )
		End

		ADL->(DbClearFilter())

	Endif    
	
	If Len(aOportun) <= 0
		AAdd(aOportun,{"","","","","","","",""})
	EndIf
		
	oOportun:SetArray(aOportun)
	oOportun:bLine := &(cbLine)
#ENDIF

oOportun:GoTop()
oOportun:Refresh()

#IFDEF TOP
	If (nTotReg > NMAXPAGE) 
	
		oOportun:bGoBottom 	:= {||Eval(bNextReg,oOportun,aFixe,cAlias,cBLine),oOportun:NAT := LEN(oOportun:AARRAY)}
		oOportun:bSkip		:= {|NSKIP, NOLD, nMax|nMax:=EVAL( oOportun:BLOGICLEN ),NOLD := oOportun:NAT, oOportun:NAT += NSKIP,;
													oOportun:NAT := MIN( MAX( oOportun:NAT, 1 ), nMax ),If(oOportun:nAt==nMax,Eval(bNextReg,oOportun,aFixe,cAlias,cBLine),.F.),;
											 		oOportun:NAT - NOLD}
	EndIf
#ENDIF

RestArea(aArea)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft320LeBd �Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ft320LeBd(	oLBx	, aFixe		, cAlias	, cBLine	,;
					nTotReg	, cObjName	, cRealAlias)

Local nCont		:= 0 
Local nX		:= 0 
Local nCampos	:= Len(aFixe)            
Local nLinhas	:= Len(oLBx:aArray)
Local nLastRec	:= 0

Local aArray	:= {} 
Local aLinha	:= {}   

Local bNextReg	:= Nil

Local cChave	:= "" 
Local cChaveInd	:= ""
Local cSep		:= ""

If cObjName == Nil
	cObjName	:= "oLBx"
EndIf

bNextReg	:= &("{|"+cObjName+",aFixe|Ft320LeBd(@"+cObjName+",aFixe,cAlias,cBLine,nTotReg,'"+cObjName+"',cRealAlias)}")

If nLinhas > 0
	nLastRec := aTail(oLBx:aArray[nLinhas])
EndIf

DbSelectArea(cAlias)

If nLastRec == 0
	DbGoTop()	
EndIf

(cRealAlias)->(DbSetOrder(1))

For nX := 1 to (cAlias)->(FCount())
	cChaveInd	+= cSep + (cAlias)->(FieldName(nX))
	cSep	:= "+"
Next nX
                              
If (cAlias) == "TRBAD1"
	If nLastRec > 0 .And. nTotReg <> nLastRec
		DbSelectArea(cAlias)
		DbGoTop()
	Else 
		aArray := aClone(oLBx:aArray)  
    Endif 
Else 
	aArray := aClone(oLBx:aArray)      
Endif    

While !Eof() .AND. nCont < NMAXPAGE
	
	aLinha	:= {}  
	cChave	:= (cAlias)->&(cChaveInd)
	
	(cRealAlias)->(DbSeek(xFilial(cRealAlias)+cChave))
	
	For nX := 1 to nCampos
		If (cRealAlias)->(FieldPos(aFixe[nX][2])) == 0
			DbSelectArea("SX3")
			DbSetOrder(2)
			If DbSeek( aFixe[nX][2] ) .And. AllTrim(SX3->X3_CONTEXT) == "V"
				AAdd(aLinha,CriaVar(aFixe[nX][2]))
			Else
				AAdd(aLinha,"")
			EndIf			
			DbSelectArea(cAlias)			
		Else
			AAdd(aLinha,(cRealAlias)->&(aFixe[nX][2]))
		EndIf
	Next nX  
	AAdd(aLinha,(cRealAlias)->(Recno()))
	
	AAdd(aArray,aClone(aLinha))
	nCont++
	
	DbSkip()
	
End

//���������������������������������Ŀ
//�Trata casos onde nao ha registros�
//�����������������������������������
If Len(aArray) == 0
	aLinha	:= {}
	For nX := 1 to nCampos
		AAdd(aLinha,CriaVar(aFixe[nX][2],.F.))
	Next nX
	AAdd(aLinha,0)
	AAdd(aArray,aClone(aLinha))
EndIf

oLBx:SetArray( aArray )
oLBx:bLine	:= &(cBLine)                               

If nLastRec == 0
	oLBx:GoTop()
EndIf

oLBx:Refresh()

If (nTotReg == Nil) .OR. (nTotReg > NMAXPAGE)
	
	cGoBottom	:= "{|| Eval(bNextReg,"+cObjName+",aFixe,cAlias,cBLine),"+cObjName+":NAT := Len("+cObjName+":aArray) }"
	cSkip		:= "{|NSKIP, NOLD, nMax|nMax:=Len("+cObjName+":aArray) ,NOLD := "+cObjName+":NAT, "+cObjName+":NAT += NSKIP,"+;
					cObjName+":NAT := MIN( MAX( "+cObjName+":NAT, 1 ), nMax ),If("+cObjName+":nAt==nMax,Eval(bNextReg,"+cObjName+",aFixe,cAlias,cBLine),.F.),"+;
					cObjName+":NAT - NOLD}"

	&(cObjName+":bGoBottom 	:= &(cGoBottom)")
	&(cObjName+":bSkip		:= &(cSkip)")
              
EndIf

Return Nil               

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT320Oportun�Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FT320Oportun

Ft320Brw("AD1")

Return         

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft320Brw  �Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ft320Brw(cAliasBrw)

Local aArea		:= GetArea()   
Local aAreaSX2	:= SX2->(GetArea())
Local aFixe		:= {}
Local aRot		:= {}
Local aCores	:= {}
Local cAlias	:= ""
Local cPLiberOk	:= ""
Local cPBlq		:= ""
Local cPNota	:= ""
Local cPStatus	:= ""
Local cPCodCanc	:= ""

Private aRotAuto	:= Nil
Private aMemos		:= {}

SaveInter()
                           
cCadastro	:= Capital(Posicione("SX2",1,cAliasBrw,"X2_NOME"))

Do Case 

	Case cAliasBrw == "SA1" 
		aMemos	:= {{"A1_CODMARC","A1_VM_MARC"},{"A1_OBS","A1_VM_OBS"}} 
		aRot	:= Mata030Rot()
		cAlias	:= "TRBSA1"	
		aFixe	:= Ft320AFixe(cAliasBrw)	

	Case cAliasBrw == "SUS" 
		aRot	:= TMKA260Rot()
		cAlias	:= "TRBSUS"
		aFixe	:= Ft320AFixe(cAliasBrw,{"US_STATUS"})
		cPStatus:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "US_STATUS"})))
		aCores  := {{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 1", "BR_MARROM"   },; // Classificado
   					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 2", "BR_VERMELHO" },; // Desenvolvimento
   					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 3", "BR_AZUL"     },; // Gerente
					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 4", "BR_AMARELO"  },; // Standy by
					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 5", "BR_PRETO"    },; // Cancelado
					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 6", "BR_VERDE"    },; // Cliente 
					{"Empty(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"])"   , "BR_BRANCO"   }}  // Maling (sem status)

	Case cAliasBrw == "AD1"
		aRot	:= Fata300Rot()
		cAlias	:= "TRBAD1"  
		aFixe	:= Ft320AFixe(cAliasBrw,{"AD1_STATUS"},{"AD1_DTINI","AD1_DTFIM","AD1_PROVEN"})  
		cPStatus:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "AD1_STATUS"})))
		aCores := {	{ 'oLstBx:aArray[oLstBx:nAt,'+cPStatus+']=="1"'	, 'ENABLE' 		},;	//Em Aberto
					{ 'oLstBx:aArray[oLstBx:nAt,'+cPStatus+']=="2"'	, 'BR_PRETO'	},;	//Perdido
					{ 'oLstBx:aArray[oLstBx:nAt,'+cPStatus+']=="3"'	, 'BR_AMARELO'	},;	//Suspenso
					{ 'oLstBx:aArray[oLstBx:nAt,'+cPStatus+']=="9"'	, 'DISABLE'		}}	//Encerrado

	Case cAliasBrw == "ACH"
		aRot	:= TmkA341Rot()
		cAlias	:= "TRBACH"
		aFixe	:= Ft320AFixe(cAliasBrw,{"ACH_STATUS"})   
		cPStatus:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "ACH_STATUS"})))
		aCores	:= {{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 0", "BR_BRANCO"   },;	// Mailing
					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 1", "BR_MARROM"   },; // Classificado
   					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 2", "BR_VERMELHO" },; // Desenvolvimento
   					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 3", "BR_AZUL"     },; // Gerente
					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 4", "BR_AMARELO"  },; // Standy by
					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 5", "BR_PRETO"    },; // Cancelado
					{"VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 6", "BR_VERDE"    },;	// Prospect
					{"Empty(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"])"	, "BR_BRANCO"   }} 	// Maling (sem status) 

	Case cAliasBrw == "SC5"    
	
		aRot		:= {{ "Visual"	,"A410Visual"	,0,2,0 ,NIL},;		//"Visual"
						{ "Legenda"	,"A410Legend"	,0,3,0 ,.F.}}		//"Legenda"
						
		cAlias		:= "TRBSC5"
		aFixe		:= Ft320AFixe(cAliasBrw,{"C5_LIBEROK","C5_NOTA","C5_BLQ"})
		cPLiberOk	:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "C5_LIBEROK"})))
		cPNota		:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "C5_NOTA"})))
		cPBlq		:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "C5_BLQ"})))
		
		aCores := {{"Empty(oLstBx:aArray[oLstBx:nAt,"+cPLiberOk+"]).And.Empty(oLstBx:aArray[oLstBx:nAt,"+cPNota+"]) .And. Empty(oLstBx:aArray[oLstBx:nAt,"+cPBlq+"])",'ENABLE' },;		//Pedido em Aberto
					{ "!Empty(oLstBx:aArray[oLstBx:nAt,"+cPNota+"]).Or.oLstBx:aArray[oLstBx:nAt,"+cPLiberOk+"]=='E' .And. Empty(oLstBx:aArray[oLstBx:nAt,"+cPBlq+"])" ,'DISABLE'},;		   	//Pedido Encerrado
					{ "!Empty(oLstBx:aArray[oLstBx:nAt,"+cPLiberOk+"]).And.Empty(oLstBx:aArray[oLstBx:nAt,"+cPNota+"]).And. Empty(oLstBx:aArray[oLstBx:nAt,"+cPBlq+"])",'BR_AMARELO'},;
					{ "oLstBx:aArray[oLstBx:nAt,"+cPBlq+"] == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
					{ "oLstBx:aArray[oLstBx:nAt,"+cPBlq+"] == '2'",'BR_LARANJA'}}	//Pedido Bloquedo por verba

	Case cAliasBrw == "SUC" 
	 
		aRot		:= 	{{	"Visualizar","TK271CallCenter" 	,0,2 },; 	//Visualizar
						{ 	"Legenda"  	,"TK271Legenda"	  	,0,2 }}		//"Legenda" 
		cAlias		:= "TRBSUC" 
		aFixe		:= Ft320AFixe(cAliasBrw,{"UC_CODCANC","UC_STATUS"})
		cPStatus	:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "UC_STATUS"})))
		cPCodCanc	:= AllTrim(Str(aScan(aFixe,{|x| AllTrim(x[2]) == "UC_CODCANC"})))
		aCores		:= {{"(EMPTY(oLstBx:aArray[oLstBx:nAt,"+cPCodCanc+"]) .AND. VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 2)" , "BR_VERMELHO" },;// Pendente
   						{"(EMPTY(oLstBx:aArray[oLstBx:nAt,"+cPCodCanc+"]) .AND. VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 3)" , "BR_VERDE"    },;// Encerrado
   						{"(EMPTY(oLstBx:aArray[oLstBx:nAt,"+cPCodCanc+"]) .AND. VAL(oLstBx:aArray[oLstBx:nAt,"+cPStatus+"]) == 1)" , "BR_AZUL"     },;// Planejada
   						{"(!EMPTY(oLstBx:aArray[oLstBx:nAt,"+cPCodCanc+"]))","BR_PRETO"		}} 
				
EndCase 

Ft320TelaB(	cAlias		, aFixe		, cCadastro	, aRot	,;
			cAliasBrw	, aCores	)

RestInter() 

RestArea(aAreaSX2)
RestArea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft320TelaB�Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ft320TelaB(cAlias		, aFixe		, cCadastro	, aRot	,;
					cRealAlias	, aCores	)

Local aArea		:= GetArea()
Local __aButton	:= {} 
Local aSize		:= MsAdvSize() 
Local aCampos	:= {} 
Local aPesqIdx	:= {}
Local aPesqOrd	:= {}

Local oDlg		:= Nil
Local oBtnPanel	:= Nil
Local oBmp		:= Nil 
Local oPesqPanel:= Nil
Local oPesqCbx	:= Nil
Local oPesqGet	:= Nil 

Local bExecBrow	:= Nil
Local bRefresh	:= {|oLstBx,nOpc,cRealAlias,cAlias,aFixe,cBLine|Ft320RefIt(@oLstBx,nOpc,cRealAlias,cAlias,aFixe,cBLine)}
Local bPosicione:= Nil
Local bNextReg	:= Nil

Local nX		:= 0
Local nCampos	:= Len(aFixe) 
Local nPosItem	:= 1
Local nWidth 	:= 40
Local nStart	:= 1
Local nTop,nLeft
Local nTotReg	:= 0
Local i

Local cBLine	:= "{||{"                                       
Local cSep		:= "" 
Local cPesqCampo:= Space(40)
Local cCapital	:= ""  
Local cRotina

Local lFlatMode := FlatMode()

Private aBitmaps	:= {}
Private aColors		:= {}
Private aRotina		:= aClone(aRot) 
Private oLstBx		:= Nil
Private oEnable		:= LoadBitmap( GetResources(), "ENABLE" )
Private oDisable	:= LoadBitmap( GetResources(), "DISABLE" )   

Default aCores	:= {}
                     
aColors := aClone(aCores)

If Len(aColors) > 0

	For i := 1 To Len(aColors)
		AADD(aBitmaps,LoadBitmap( GetResources(), aColors[i,2]))
	Next i  

	AAdd(aCampos," ")
	cBLine	+= "RetObjColor(aColors,oDisable,aBitMaps)"
	cSep	:= "," 
	nStart	:= 1 
	
EndIf

For nX := 1 to nCampos
	AAdd(aCampos,aFixe[nX][1])
Next nX

For nX := nStart to nCampos
	cBLine	+= cSep+"oLstBx:aArray[oLstBx:nAt,"+AllTrim(Str(nX))+"]"
	cSep	:= ","
Next nX                

cBLine	+= "}}"

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL  

nMbrWidth := oDlg:nWidth/2-43
nMbrHeight := oDlg:nHeight/2

@00,00 MSPANEL oBtnPanel PROMPT "" SIZE 50,15 OF oDlg
oBtnPanel:Align := CONTROL_ALIGN_LEFT

@ 000, 000 BITMAP oBmp RESOURCE "fw_degrade_menu.png" SIZE 000,000 OF oBtnPanel PIXEL NO BORDER
oBmp:LSTRETCH = .T.
oBmp:Align := CONTROL_ALIGN_ALLCLIENT

@ 000,000 MSPANEL oBackground PROMPT "" SIZE nMbrWidth,nMbrHeight OF oDlg
oBackground:Align := CONTROL_ALIGN_ALLCLIENT

//���������������������Ŀ
//�Pesquisa de registros�
//�����������������������
AxPesqOrd(cRealAlias,@aPesqIdx,,.F.,@aPesqOrd)
cPesqOrd := aPesqOrd[1]

@00,00 MSPANEL oPesqPanel SIZE 15,15 OF oBackground
oPesqPanel:Align := CONTROL_ALIGN_TOP      

@02,02 COMBOBOX oPesqCbx VAR cPesqOrd ITEMS aPesqOrd SIZE 100,12 PIXEL OF oPesqPanel
oPesqCbx:cReadVar := ""

@02,103 MSGET oPesqGet VAR cPesqCampo SIZE 100,09 PIXEL OF oPesqPanel
oPesqGet:cReadVar := ""
oPesqGet:cSX1Hlp := "CCAMPO"

@02,205 BUTTON "Filtrar" SIZE 40,11 PIXEL OF oPesqPanel ;	//"Filtrar"
ACTION (If(Ft320Psq(cAlias	, cRealAlias	, cPesqCampo	, cPesqOrd	,;
					aPesqOrd, aPesqIdx		),;
					(oLstBx:aArray:={},nTotReg := Ft320Conta(cAlias),(cAlias)->(DbGoTop()),;
					Ft320LeBd(@oLstBx,aFixe,cAlias,cBLine,nTotReg,"oLstBx",cRealAlias)),.f.))


@02,250 BUTTON "Limpar Filtro" SIZE 40,11 PIXEL OF oPesqPanel ;	//"Limpar Filtro"
ACTION (If(Ft320Psq(cAlias	, cRealAlias	, ""			, cPesqOrd	,;
					aPesqOrd, aPesqIdx		),;
					(oLstBx:aArray:={},nTotReg := Ft320Conta(cAlias),(cAlias)->(DbGoTop()),;
					Ft320LeBd(@oLstBx,aFixe,cAlias,cBLine,nTotReg,"oLstBx",cRealAlias),oLstBx:GoTop(),;
					oLstBx:Refresh()),.f.))

//�������Ŀ
//�Rotinas�
//���������
bExecBrow := &("{|aArray,nPos,aSvRotina,lRunPopUp| aSvRotina := Aclone(aRotina), If(aArray <> NIL,aRotina := Aclone(aArray),),SetEnch(aRotina[nPos][1]), inclui := (aRotina[nPos][4] == 3), altera := (aRotina[nPos][4] == 4), Ft320AExBr(aRotina[nPos][2],nPos,'"+cRealAlias+"'),aRotina := Aclone(aSvRotina)}")
bPosicione:= {||(cRealAlias)->(DbGoTo(aTail(oLstBx:aArray[oLstBx:nAt])))}

For i:= 1 to Len(aRotina)

	If Upper(AllTrim(aRotina[i][2])) $ "AXPESQUI#PESQBRW"
		Loop
	EndIf

	If !("&"$aRotina[i,1])
		cRotina :=""
		For nX := 1 to Len(aRotina[i,1])
			If IsUpper(Subs(aRotina[i,1],nX,1))
				cRotina += "&"+Subs(aRotina[i,1],nX)
				cCapital += Lower(Subs(aRotina[i,1],nX,1))
				Exit
			Else
				cRotina += Subs(aRotina[i,1],nX,1)
			EndIf
		Next
	Else
		cRotina := aRotina[i,1]
	EndIf

	aRotina[i,1] := ButCapital(cRotina)
	BrwBtnPos(nPosItem,@nTop,@nLeft)
	
	If ValType(aRotina[i,2]) == "C"
		bBlock := &("{|| Eval(bPosicione),Eval(bExecBrow,,"+AllTrim(Str(i))+"),Eval(bRefresh,@oLstBx,"+Str(aRotina[i,4])+",'"+cRealAlias+"','"+cAlias+"',aFixe,cBLine)}")
		AADD(__aButton,TBrowseButton():New( nTop, nLeft, (aRotina[i,1]), oBtnPanel, bBlock, nWidth, 10,,oDlg:oFont, .F., .T., .F.,, .F.,,,))
	EndIf
	__aButton[Len(__aButton)]:Align := CONTROL_ALIGN_TOP
	If lFlatMode
		__aButton[Len(__aButton)]:SetCSS("#STYLE0024")
	EndIf
	
	nPosItem ++ 
Next 

//����������Ŀ
//�Botao sair�
//������������
BrwBtnPos(nPosItem,@nTop,@nLeft)
AADD(__aButton,TBrowseButton():New( nTop, nLeft, "Sair", oBtnPanel, {||oDlg:End()}, nWidth, 10,,oDlg:oFont, .F., .T.,.F.,,.F.,,,))//"Sair"
__aButton[Len(__aButton)]:Align := CONTROL_ALIGN_TOP
If lFlatMode
	__aButton[Len(__aButton)]:SetCSS("#STYLE0024")
EndIf

oLstBx := TWBrowse():New( 15,0, nMbrWidth-10, nMbrHeight-30,,aCampos,,oBackground,,,,,,,,,,,,,,.T. )

//�������������������������Ŀ
//�Conta registros da tabela�
//���������������������������
DbSelectArea(cAlias)
DbGoTop()
While !Eof() .AND. nTotReg <= NMAXPAGE
	nTotReg++
	DbSkip()
End

//����������������������������Ŀ
//�Carrega dados para o ListBox�
//������������������������������
Ft320LeBd(@oLstBx,aFixe,cAlias,cBLine,nTotReg,"oLstBx",cRealAlias)

oLstBx:GoTop()
oLstBx:Refresh()

If (nTotReg > NMAXPAGE)
	bNextReg			:= {|oLstBx,aFixe|Ft320LeBd(@oLstBx,aFixe,cAlias,cBLine,nTotReg,'oLstBx',cRealAlias)}
	oLstBx:bGoBottom 	:= {||Eval(bNextReg,oLstBx,aFixe,cAlias,cBLine),oLstBx:NAT := LEN(oLstBx:AARRAY)}
	oLstBx:bSkip		:= {|NSKIP, NOLD, nMax|nMax:=EVAL( oLstBx:BLOGICLEN ),NOLD := oLstBx:NAT, oLstBx:NAT += NSKIP,;
							oLstBx:NAT := MIN( MAX( oLstBx:NAT, 1 ), nMax ),If(oLstBx:nAt==nMax,Eval(bNextReg,oLstBx,aFixe,cAlias,cBLine),.F.),;
							oLstBx:NAT - NOLD}
EndIf

ACTIVATE MSDIALOG oDlg CENTERED 

//�����������������������������������������������������Ŀ
//�Roda a query novamente para eliminar qualquer filtro.�
//�������������������������������������������������������
Ft320FilTb(Nil,cRealAlias)

RestArea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ButCapital�Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ButCapital(cText)
Local ni
cText := LOWER(cText)
For ni:= 1 to Len(cText)
	If Subs(cText,ni,1) != "&"
		cText := SUbs(cText,1,ni-1)+Upper(Subs(cText,ni,1))+Subs(cText,ni+1)
		Exit
	EndIf
Next
Return cText

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BrwBtnPos�Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BrwBtnPos(nBtn,nTop,nLeft)
nTop := 1+((nBtn-1)*(10))
nLeft := 1
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft320AExBr�Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ft320AExBr(cFuncao,nOpcao,cAlias)

Local cAliasBk	:= Alias()

DbSelectArea(cAlias)

&cFuncao.(cAlias,Recno(),nOpcao)

DbSelectArea(cAliasBk)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft320RefIt�Autor  �Opvs (David)        � Data �  05/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ft320RefIt(	oLstBx	, nOpc		, cRealAlias	, cAlias	,;
							aFixe	, cBLine	)

Local nRecAtu	:= 0
Local nTotReg	:= 0
Local nPos		:= 0 
Local bNextReg	:= Nil

If nOpc <> 2

	nRecAtu := aTail(oLstBx:aArray[oLstBx:nAt])
	oLstBx:aArray := {}
	
	Ft320FilTb(Nil,cRealAlias)

	//�������������������������Ŀ
	//�Conta registros da tabela�
	//���������������������������
	DbSelectArea(cAlias)
	DbGoTop()
	While !Eof() .AND. nTotReg <= NMAXPAGE
		nTotReg++
		DbSkip()
	End
	DbGoTop()
	
	//����������������������������Ŀ
	//�Carrega dados para o ListBox�
	//������������������������������
	Ft320LeBd(	@oLstBx	, aFixe		, cAlias	, cBLine	,;
				nTotReg	, "oLstBx"	, cRealAlias)
	
	//����������������������������������������������������������Ŀ
	//�Tenta posicionar no ultimo registro acessado, que pode ter�
	//�sido excluido ou estar fora da pagina atual               �
	//������������������������������������������������������������
	If (nPos := aScan(oLstBx:aArray,{|x| aTail(x) == nRecAtu })) > 0
		oLstBx:nAt := nPos
	Else
		oLstBx:GoTop()
	EndIf
	oLstBx:Refresh()
	
	If (nTotReg > NMAXPAGE)
		bNextReg			:= {|oLstBx,aFixe|Ft320LeBd(@oLstBx,aFixe,cAlias,cBLine,nTotReg,'oLstBx',cRealAlias)}
		oLstBx:bGoBottom 	:= {||Eval(bNextReg,oLstBx,aFixe,cAlias,cBLine),oLstBx:NAT := LEN(oLstBx:AARRAY)}
		oLstBx:bSkip		:= {|NSKIP, NOLD, nMax|nMax:=EVAL( oLstBx:BLOGICLEN ),NOLD := oLstBx:NAT, oLstBx:NAT += NSKIP,;
								oLstBx:NAT := MIN( MAX( oLstBx:NAT, 1 ), nMax ),If(oLstBx:nAt==nMax,Eval(bNextReg,oLstBx,aFixe,cAlias,cBLine),.F.),;
								oLstBx:NAT - NOLD}
	EndIf
	
EndIf

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft320Psq  �Autor  �Vendas CRM          � Data �  15/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de pesquisa na tabela temporaria                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1 - Alias da tabela a ser pesquisada                    ���
���          �ExpC2 - Alias da tabela real (SX2)                          ���
���          �ExpC3 - Texto da pesquisa                                   ���
���          �ExpC4 - Ordem da pesquisa selecionada                       ���
���          �ExpA5 - Lista das ordens disponiveis                        ���
���          �ExpA6 - Lista dos indices das pesquisas                     ���
�������������������������������������������������������������������������͹��
���Uso       �FATA320                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ft320Psq(	cAlias	, cRealAlias	, cPesqCampo	, cPesqOrd,;
							aPesqOrd, aPesqIdx		)

Local cPesq		:= AllTrim(cPesqCampo)
Local cQueryAnd	:= ""  
Local cChvOrig	:= ""
Local cLenPsq	:= AllTrim(Str(Len(cPesq))) 
Local cPrefX	:= PrefixoCpo(cRealAlias)
Local cConcat	:= "+"
Local lFiltra	:= .T.

Local nChave	:= 0 
Local nLenChave	:= 0

cPesq	:= StrTran(cPesq,"'")
cPesq	:= StrTran(cPesq,'"')

//��������������������������������������������������Ŀ
//�Retorna falso se nada foi solicitado para pesquisa�
//����������������������������������������������������
If Empty(cPesq)
	lFiltra := .F.
EndIf                

If lFiltra
	//������������������������������������������������������Ŀ
	//�Define o simbolo de concatenacao de acordo com o banco�
	//��������������������������������������������������������
	If Upper(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
		cConcat := "||"
	Endif 
	                     
	//�����������������������������������������Ŀ
	//�Verifica se a ordem selecionada eh valida�
	//�������������������������������������������
	If (nChave	:= aScan(aPesqOrd,{|x| AllTrim(x) == AllTrim(cPesqOrd)})) == 0
		lFiltra := .F.
	Else             
		cChave		:= Upper((cRealAlias)->(IndexKey(nChave)))
		cChave 		:= StrTran(cChave,cPrefX+"_FILIAL+","") 
		cChvOrig	:= cChave
		cChave 		:= StrTran(cChave,cPrefX+"_",cRealAlias+"."+cPrefX+"_")
		cChave 		:= StrTran(cChave,"DTOS","")
		If cConcat <> "+"
			cChave 	:= StrTran(cChave,"+",cConcat)
		EndIf
	EndIf
	                                 
	//������������������������������������������������������Ŀ
	//�Verifica se a chave de busca nao eh maior que o indice�
	//��������������������������������������������������������
	nLenChave := Ft320TamCh(cChvOrig)    
	
	If nLenChave < Val(cLenPsq)
		cLenPsq := AllTrim(Str(nLenChave))
		cPesq	:= SubStr(cPesq,1,nLenChave)
	EndIf
	
	//�������������������������������Ŀ
	//�Concatena a expressao do filtro�
	//���������������������������������
	If lFiltra
		cQueryAnd := " AND SUBSTR(" + cChave + ",1," + cLenPsq + ")= '"+cPesq+"'"
	EndIf
EndIf

Ft320FilTb(Nil,cRealAlias,cQueryAnd)

Return .T.

Static Function Ft320TamCh(cChvOrig) 

Local nTam	:= 0
Local nX	:= 0
Local aCpos	:= {}

cChvOrig := StrTran(cChvOrig,"DTOS")
cChvOrig := StrTran(cChvOrig,"(")
cChvOrig := StrTran(cChvOrig,")")

aCpos := StrToKArr(cChvOrig,"+")

For nX := 1 to Len(aCpos)
	nTam += TamSX3(aCpos[nX])[1]
Next nX

Return nTam


Static Function Ft320Conta(cAlias)

Local nTotReg := 0

DbSelectArea(cAlias)
DbGoTop()
While !Eof() .AND. nTotReg <= NMAXPAGE
	nTotReg++
	DbSkip()
End

Return nTotReg
