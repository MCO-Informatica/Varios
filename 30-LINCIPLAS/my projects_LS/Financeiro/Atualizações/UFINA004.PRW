#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINA004   บAutor  ณ Antonio Carlos     บ Data ณ  16/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina responsavel pela importa็ใo dos valores de vendas   fฑฑ
ฑฑบ          ณ ref. fechamento de Lojas e inclusao no Contas a Receber.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UFINA004(aParam)

Local nHdlLock	:= 0
//Local aParam	:= {}
Local cArqLock 	:= "FINA004.lck"

Private _lJob	:= (aParam <> Nil .Or. ValType(aParam) == "A")

If _lJob
	
	Conout("Parametros recebidos => Empresa "+aParam[1]+" Filial "+aParam[2])

	//====================================================//
	//Efetua o Lock de gravacao da Rotina - Monousuario   //    
	//====================================================//
	FErase(cArqLock)
	nHdlLock := MsFCreate(cArqLock)
	If nHdlLock < 0
		Conout("Rotina "+FunName()+" ja em execu็ใo.")
		Return(.T.)
	EndIf

	If FindFunction('WFPREPENV')
 		Conout("Preparando Environment")
		WfPrepENV(aParam[1], aParam[2])
	Else
		Prepare Environment Empresa aParam[1]Filial aParam[2] 
	EndIf	
	
	IntegraFin()
	
	Reset Environment
	
	//==========================================//
	// Cancela o Lock de gravacao da rotina     //
	//==========================================//
	FClose(nHdlLock)
	FErase(cArqLock)

Else
	
	AtuDados()      

EndIf	

Return    

Static Function AtuDados()

Local aArea		:= GetArea()
Local aAreaSM0	:= SM0->( GetArea() )

Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")

Private oData1
Private oData2
Private oDlg

Private lInvFil		:= .F.
Private lInvGrp		:= .F.
Private aFilial		:= {}

Private _dDatad		:= CTOD("  /  /  ")
Private _dDataa		:= CTOD("  /  /  ")
Private cStrFilia	:= ""
Private cStrFil		:= ""
Private cCadastro	:= "Integra Resumo de Vendas - Protheus"

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 430,400 OF oMainWnd PIXEL

@ 10,10 SAY "Data de: " OF oDlg PIXEL
@ 20,10 MSGET oData1 VAR _dDatad SIZE 50,10 OF oDlg PIXEL

@ 10,80 SAY "Data ate: " OF oDlg PIXEL
@ 20,80 MSGET oData2 VAR _dDataa SIZE 50,10 OF oDlg PIXEL

//Group Box de Filiais
@ 50,10  TO 190,197 LABEL "Filiais" OF oDlg PIXEL

//Grid de Filiais
DbSelectArea("SM0")
SM0->( DbGoTop() )
While SM0->( !Eof() )
	If SM0->M0_CODIGO == "01"
		Aadd( aFilial, {.F.,M0_CODFIL,SM0->M0_FILIAL} )
	EndIf	
	SM0->( DbSkip() )
EndDo

RestArea(aAreaSM0)

@ 70,25  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Filial","Nome" SIZE 160,110 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	//"Filial" / "Descricao"
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2],aFilial[oLstFilial:nAt,3]}}

DEFINE SBUTTON FROM 200,060 TYPE 1 ACTION( LjMsgRun("Aguarde..., Processando registros...",, {|| IntegraFin() }),oDlg:End()  )  ENABLE OF oDlg
DEFINE SBUTTON FROM 200,110 TYPE 2 ACTION(oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED
	
RestArea(aArea)

Return

Static Function LSVTroca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

Static Function IntegraFin()

Local	aArea		:= GetArea()
Local	_nRegCC		:= 0
Local	_nRegRS		:= 0
Local	_nValor		:= 0
Local	_aParc		:= "A"
Local	_aDtVenc	:= {}

If Empty(_dDatad) .Or. Empty(_dDataa)
	MsgStop("Parametros incorretos!")
	Return(.F.)
EndIf  

AEval(aFilial, {|x| If(x[1]==.T.,cStrFilia+="'"+SubStr(x[2],1,TamSX3("L1_FILIAL")[1])+"'"+",",Nil)})
cStrFil := Substr(cStrFilia,1,Len(cstrFilia)-1)      

If Empty(cStrFil)
	Aviso("Integra Financeiro","Informe uma filial para o procesamento!",{"Ok"})
	Return(.F.)
EndIf

cQry := " SELECT AE_CODCLI, ''AS FILIAL, L4_FILIAL AS FILORIG, L4_FILIAL AS MSFIL, L1_PARCELA, '01' AS MSEMP, 'PDV' AS PREFIXO, "
cQry += " L4_FILIAL+SUBSTRING(L4_DATA,7,2)+SUBSTRING(L4_DATA,3,2)+SUBSTRING(L4_ADMINIS,2,2)+CONVERT(CHAR(1),L1_PARCELA) AS NUM, "
cQry += " 'A  ' AS PARCELA, L4_FORMA AS TIPO, SUBSTRING(L4_ADMINIS,1,3) AS 'ADMINIS', "

cQry += " CASE WHEN L4_FORMA = 'CO'  THEN 'CONVENIO' ELSE "	
cQry += " CASE WHEN L4_FORMA = 'E$'  THEN 'EURO' ELSE "
cQry += " CASE WHEN L4_FORMA = 'R$'  THEN 'DINHEIRO' ELSE "
cQry += " CASE WHEN L4_FORMA = 'U$'  THEN 'DOLAR' ELSE "
cQry += " CASE WHEN L4_FORMA = 'CC'  THEN 'CARTAO' ELSE "
cQry += " CASE WHEN L4_FORMA = 'CD'  THEN 'CARTAO' ELSE "
cQry += " CASE WHEN L4_FORMA = 'VA'  THEN 'VALE' ELSE AE_DESC END END END END END END  END AS NATUREZ, "

cQry += " CASE WHEN L4_FORMA = 'CO'  THEN L4_ADMINIS ELSE "
cQry += " CASE WHEN L4_FORMA = 'E$'  THEN '999999' ELSE "
cQry += " CASE WHEN L4_FORMA = 'R$'  THEN '999999' ELSE "                                        
cQry += " CASE WHEN L4_FORMA = 'U$'  THEN '999999' ELSE "
cQry += " CASE WHEN L4_FORMA = 'CC'  THEN L4_ADMINIS ELSE "
cQry += " CASE WHEN L4_FORMA = 'CD'  THEN L4_ADMINIS ELSE "
cQry += " CASE WHEN L4_FORMA = 'VA'  THEN L4_ADMINIS ELSE '999999' END END END END END END  END AS CLIENTE, "

cQry += " CASE WHEN L4_FORMA = 'CO'  THEN '01' ELSE "
cQry += " CASE WHEN L4_FORMA = 'E$'  THEN L4_FILIAL ELSE "
cQry += " CASE WHEN L4_FORMA = 'R$'  THEN L4_FILIAL ELSE "
cQry += " CASE WHEN L4_FORMA = 'U$'  THEN L4_FILIAL ELSE "
cQry += " CASE WHEN L4_FORMA = 'CC'  THEN '01' ELSE "
cQry += " CASE WHEN L4_FORMA = 'CD'  THEN '01' ELSE "
cQry += " CASE WHEN L4_FORMA = 'VA'  THEN '01' ELSE '01' END END END END END END  END AS LOJA, "

cQry += " L4_DATA AS EMISSAO, L4_DATA AS VENCTO, SUM(L4_VALOR) AS VALOR, 'VENDA PDV '+L4_FILIAL AS HIST, "

cQry += " CASE WHEN LTRIM(L4_FORMA) = 'E$'  THEN 0 ELSE "
cQry += " CASE WHEN LTRIM(L4_FORMA) = 'R$'  THEN 0 ELSE "
cQry += " CASE WHEN LTRIM(L4_FORMA) = 'U$'  THEN 0 ELSE SUM(L4_VALOR) END END END AS SALDO, "

cQry += " '.' AS AGEDEP "

cQry += " FROM "+RetSqlName("SL4")+" SL4 (NOLOCK)"

cQry += " INNER JOIN "+RetSqlName("SAE")+" SAE  (NOLOCK)"
cQry += " ON LTRIM(L4_ADMINIS) = AE_COD AND SAE.D_E_L_E_T_ = '' "

cQry += " INNER JOIN "+RetSqlName("SL1")+" SL1 (NOLOCK) "
cQry += " ON L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM AND SL1.D_E_L_E_T_ = '' "

cQry += " WHERE " 

cQry += " L4_FILIAL IN (" +cStrFil+ ") AND "
cQry += " L4_DATA BETWEEN  '"+DTOS(_dDatad)+"' AND '"+DTOS(_dDataa)+"' AND "

cQry += " L4_FORMA NOT IN ('R$','E$','U$','CH') AND "

cQry += " SL4.D_E_L_E_T_ = '' "

cQry += " GROUP BY L4_FILIAL, L1_PARCELA, L4_ADMINIS, AE_DESC, L4_FORMA, L4_DATA, AE_CODCLI "
cQry += " ORDER BY L4_FILIAL, L4_DATA "

Memowrite("FINA004.SQL",cQry)  
TcQuery cQry NEW ALIAS "TRB" 

DbSelectArea("TRB")
TRB->( DbGoTop() )

If TRB->( !Eof() )

	While !TRB->( Eof() )
   	   		
   		DbSelectArea("SE1")
   		SE1->( DbSetOrder(1) ) 
   		If SE1->( !DbSeek(xFilial("SE1")+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO ))
    	    
			If Alltrim(TRB->TIPO) == "CC"
			
				_aDtVenc := {}
				
				For _nI := 1 To TRB->L1_PARCELA
				
					If _nI == 1
						_cParc	:= "A"	
						
						If TRB->L1_PARCELA > 1
							_nValor := Round(TRB->VALOR/TRB->L1_PARCELA,2)
						Else
							_nValor := TRB->VALOR
						EndIf
						
					Else
						_cParc	:= Soma1(_cParc)
					EndIf
					
					If Select("QRY") > 0
						QRY->( DbCloseArea() )
					EndIf					
					
					cQuery := " SELECT SUBSTRING(CONVERT(VARCHAR(8),dateadd(mm,+"+Alltrim(Str(_nI))+",'"+TRB->EMISSAO+"'),112),1,8) AS MES "
					TcQuery cQuery NEW ALIAS "QRY"

					DbSelectArea("QRY")
					QRY->( DbGoTop() )
					If QRY->( !Eof() )
						While !QRY->( Eof() )
							dData := STOD(QRY->MES)
							dVencR	:= DataValida(dData)								
							Aadd(_aDtVenc,{dVencR,_cParc})
							QRY->( DbSkip() )
						EndDo
					EndIf
					
					/*
					DbSelectArea("SAE")
					SAE->( DbSetOrder(1) )
					If SAE->( DbSeek( xFilial("SAE")+TRB->ADMINIS ) )	
						dData	:= dData+SAE->AE_DIAS
						dVencR	:= DataValida(dData)	
						Aadd(_aDtVenc,{dVencR,_cParc})
					Else 
						dVencR	:= STOD(TRB->EMISSAO)									
						_aDtVenc := {}
						Aadd(_aDtVenc,{dVencR,_cParc})
					EndIf
					*/
				
				Next _nI
				
				For _nI := 1 To Len(_aDtVenc)
			
					RecLock("SE1",.T.)
			
					SE1->E1_PREFIXO	:= TRB->PREFIXO
					SE1->E1_NUM		:= TRB->NUM
					SE1->E1_TIPO	:= TRB->TIPO	
					SE1->E1_NATUREZ	:= TRB->NATUREZ
					SE1->E1_CLIENTE	:= TRB->CLIENTE
					SE1->E1_LOJA	:= TRB->LOJA	
					SE1->E1_PARCELA	:= _aDtVenc[_nI,2]
					SE1->E1_NOMCLI	:= Substr(Posicione("SA1",1,xFilial("SA1")+Substr(TRB->CLIENTE,1,6)+"01","A1_NOME"),1,30)
					SE1->E1_EMISSAO	:= STOD(TRB->EMISSAO)
					SE1->E1_VENCTO	:= STOD(TRB->EMISSAO)		
					SE1->E1_VENCREA	:= _aDtVenc[_nI,1]
					SE1->E1_VALOR	:= _nValor
					SE1->E1_EMIS1	:= STOD(TRB->EMISSAO)		
					SE1->E1_MOVIMEN	:= STOD(TRB->EMISSAO)		
					SE1->E1_VALLIQ	:= _nValor
					SE1->E1_SALDO	:= _nValor
					SE1->E1_VENCORI	:= STOD(TRB->EMISSAO)		
					SE1->E1_MOEDA	:= 1
					SE1->E1_OK		:= "3V"
					SE1->E1_OCORREN	:= "01"
					SE1->E1_VLCRUZ	:= _nValor
					SE1->E1_STATUS	:= "B"
					//SE1->E1_ORIGEM	:= "FINA040"
					SE1->E1_ORIGEM	:= "FINA040A"
					SE1->E1_FLUXO	:= "S"
					SE1->E1_TIPODES	:= "1"
					SE1->E1_FILORIG	:= "01"
					SE1->E1_MULTNAT	:= "2"
					SE1->E1_MSFIL	:= TRB->MSFIL
					SE1->E1_MSEMP	:= "01"
					SE1->E1_PROJPMS	:= "2"
					SE1->E1_DESDOBR	:= "2"
					SE1->E1_MODSPB	:= "1"
					SE1->E1_SCORGP	:= "2" 					
					
					SE1->( MsUnLock() )
			
					_nRegCC++
				
				Next _nI	
				
			Else	
				
				dVencR	:= STOD(TRB->EMISSAO)				
				
				RecLock("SE1",.T.)
			
				SE1->E1_PREFIXO	:= TRB->PREFIXO
				SE1->E1_NUM		:= TRB->NUM
				SE1->E1_TIPO	:= TRB->TIPO	
				SE1->E1_NATUREZ	:= TRB->NATUREZ
				SE1->E1_CLIENTE	:= TRB->CLIENTE
				SE1->E1_LOJA	:= TRB->LOJA	
				SE1->E1_PARCELA	:= "A"
				SE1->E1_NOMCLI	:= Substr(Posicione("SA1",1,xFilial("SA1")+Substr(TRB->CLIENTE,1,6)+"01","A1_NOME"),1,30)
				SE1->E1_EMISSAO	:= STOD(TRB->EMISSAO)
				SE1->E1_VENCTO	:= STOD(TRB->EMISSAO)		
				SE1->E1_VENCREA	:= dVencR
				SE1->E1_VALOR	:= TRB->VALOR
				SE1->E1_EMIS1	:= STOD(TRB->EMISSAO)		
				SE1->E1_MOVIMEN	:= STOD(TRB->EMISSAO)		
				SE1->E1_VALLIQ	:= TRB->VALOR
				SE1->E1_SALDO	:= TRB->SALDO
				SE1->E1_VENCORI	:= STOD(TRB->EMISSAO)		
				SE1->E1_MOEDA	:= 1
				SE1->E1_OK		:= "3V"
				SE1->E1_OCORREN	:= "01"
				SE1->E1_VLCRUZ	:= TRB->VALOR
				SE1->E1_STATUS	:= "B"
				//SE1->E1_ORIGEM	:= "FINA040"
				SE1->E1_ORIGEM	:= "FINA040A"
				SE1->E1_FLUXO	:= "S"
				SE1->E1_TIPODES	:= "1"
				SE1->E1_FILORIG	:= "01"
				SE1->E1_MULTNAT	:= "2"
				SE1->E1_MSFIL	:= TRB->MSFIL
				SE1->E1_MSEMP	:= "01"
				SE1->E1_PROJPMS	:= "2"
				SE1->E1_DESDOBR	:= "2"
				SE1->E1_MODSPB	:= "1"
				SE1->E1_SCORGP	:= "2" 					
				
				SE1->( MsUnLock() )
			
				_nRegCC++
				
			EndIf
			
		EndIf	
   	
		TRB->( DbSkip() )
	
	EndDo
	
EndIf	

cQry1 := " SELECT PAT_FILIAL AS FILIAL, 'PDV' AS PREFIXO, 'A  ' AS PARCELA, PAT_FORMA AS TIPO, PAT_DTFECH AS DTFECH, SUM(PAT_VLRSIS) AS 'VALOR', "
cQry1 += " PAT_FILIAL+SUBSTRING(PAT_DTFECH,7,2)+SUBSTRING(PAT_DTFECH,5,2)+SUBSTRING(PAT_DTFECH,3,2)+'R' AS NUM,  PAT_BANCO, PAT_AGENCI, PAT_CONTA "
cQry1 += " FROM "+RetSqlname("PAT")+" PAT (NOLOCK) " 
cQry1 += " WHERE "
cQry1 += " PAT_FILIAL IN (" +cStrFil+ ") AND "
cQry1 += " PAT_DTFECH BETWEEN  '"+DTOS(_dDatad)+"' AND '"+DTOS(_dDataa)+"' AND "
cQry1 += " PAT_FORMA = 'R$' AND "
cQry1 += " PAT.D_E_L_E_T_ = '' "
cQry1 += " GROUP BY PAT_FILIAL, PAT_DTFECH, PAT_FORMA, PAT_BANCO, PAT_AGENCI, PAT_CONTA "

TcQuery cQry1 NEW ALIAS "TMP" 

DbSelectArea("TMP")
TMP->( DbGoTop() )

If TMP->( !Eof() )
	
	While !TMP->( Eof() )
   		
   		DbSelectArea("SE1")
		SE1->( DbSetOrder(1) ) 
   		If SE1->( !DbSeek(xFilial("SE1")+TMP->PREFIXO+TMP->NUM+TMP->PARCELA+TMP->TIPO ))
    	    
			RecLock("SE1",.T.)	

			SE1->E1_PREFIXO	:= "PDV"
			SE1->E1_NUM		:= TMP->NUM
			SE1->E1_TIPO	:= TMP->TIPO
			SE1->E1_NATUREZ	:= "DEPOSITO"
			SE1->E1_CLIENTE	:= "999999"
			SE1->E1_LOJA	:= TMP->FILIAL   
			SE1->E1_PARCELA	:= TMP->PARCELA
			SE1->E1_NOMCLI	:= Substr(Posicione("SA1",1,xFilial("SA1")+"999999"+TMP->FILIAL,"A1_NOME"),1,30)
			SE1->E1_EMISSAO	:= STOD(TMP->DTFECH)
			SE1->E1_VENCTO	:= STOD(TMP->DTFECH)
			SE1->E1_VENCREA	:= STOD(TMP->DTFECH)
			SE1->E1_VALOR	:= TMP->VALOR
			SE1->E1_EMIS1	:= STOD(TMP->DTFECH)
			SE1->E1_MOVIMEN	:= STOD(TMP->DTFECH)
			SE1->E1_VALLIQ	:= TMP->VALOR
			SE1->E1_SALDO	:= 0
			SE1->E1_VENCORI	:= STOD(TMP->DTFECH)
			SE1->E1_BAIXA	:= STOD(TMP->DTFECH)
			SE1->E1_SITUACA	:= "0"
			SE1->E1_MOEDA	:= 1
			SE1->E1_OK		:= "3V"
			SE1->E1_OCORREN	:= "01"
			SE1->E1_VLCRUZ	:= TMP->VALOR
			SE1->E1_STATUS	:= "B"
			SE1->E1_ORIGEM	:= "FINA040"   
			SE1->E1_ORIGEM	:= "FINA040A"
			SE1->E1_FLUXO	:= "S"
			SE1->E1_TIPODES	:= "1"
			SE1->E1_FILORIG	:= "01"
			SE1->E1_MULTNAT	:= "2"
			SE1->E1_MSFIL	:= TMP->FILIAL
			SE1->E1_MSEMP	:= "01"
			SE1->E1_PROJPMS	:= "2"
			SE1->E1_DESDOBR	:= "2"
			SE1->E1_MODSPB	:= "1"
			SE1->E1_SCORGP	:= "2"
			
			SE1->( MsUnLock() )

			RecLock("SE5",.T.)

			SE5->E5_FILIAL	:= TMP->FILIAL
			SE5->E5_DATA	:= STOD(TMP->DTFECH)
			SE5->E5_TIPO	:= TMP->TIPO	
			SE5->E5_PARCELA	:= TMP->PARCELA
			SE5->E5_VALOR	:= TMP->VALOR
			SE5->E5_NATUREZ	:= "DEPOSITO"
			SE5->E5_BANCO	:= TMP->PAT_BANCO
			SE5->E5_AGENCIA	:= TMP->PAT_AGENCI
			SE5->E5_CONTA	:= TMP->PAT_CONTA
			SE5->E5_RECPAG	:= "R"
			SE5->E5_BENEF	:= "LASELVA"
			SE5->E5_HISTOR	:= "DEPOSITO LOJA"
			SE5->E5_TIPODOC	:= "VL"
			SE5->E5_VLMOED2	:= TMP->VALOR
			SE5->E5_LA		:= "N"	
			SE5->E5_PREFIXO	:= "PDV"
			SE5->E5_NUMERO	:= TMP->NUM
			SE5->E5_CLIFOR	:= "999999"
			SE5->E5_LOJA	:= TMP->FILIAL
			SE5->E5_DTDIGIT	:= STOD(TMP->DTFECH)
			SE5->E5_MOTBX	:= "NOR"
			SE5->E5_SEQ		:= "01"
			SE5->E5_DTDISPO	:= STOD(TMP->DTFECH)
			SE5->E5_FILORIG	:= TMP->FILIAL
			SE5->E5_CLIENTE := "999999"
			
			SE5->( MsUnLock() )
			
			_nRegRS++
        
		EndIf
		
		TMP->( Dbskip() )
		
	EndDo	
	
EndIf	

If (_nRegCC == 0 .And. _nRegRS == 0)
	If _lJob 
		Conout("FINA004 - Nao existem registros para processamento!")					
	Else
		MsgStop("Nao existem registros para processamento!")
	EndIf
EndIf	

If (_nRegCC > 0 .And. _nRegRS == 0)
	If _lJob 
		Conout("FINA004 - Atencao apenas os registros ref. Cartoes foram importados!")					
	Else
		MsgStop("FINA004 - Atencao apenas os registros ref. Cartoes foram importados!")
	EndIf
EndIf	

If (_nRegCC == 0 .And. _nRegRS > 0)
	If _lJob 
		Conout("FINA004 - Atencao apenas os registros ref. R$ foram importados!")					
	Else
		MsgStop("FINA004 - Atencao apenas os registros ref. R$ foram importados!")
	EndIf
EndIf	

If (_nRegCC > 0 .And. _nRegRS > 0)
	If _lJob 
		Conout("FINA004 - Processamento efetuado com sucesso!")					
	Else
		MsgStop("FINA004 - Processamento efetuado com sucesso!")
	EndIf
EndIf	
	
RestArea(aArea)

TRB->( DbCloseArea() )
TMP->( DbCloseArea() )

Return Nil