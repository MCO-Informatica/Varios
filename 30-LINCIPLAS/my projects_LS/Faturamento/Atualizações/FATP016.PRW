#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

User Function FATP016()

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0 
Private cCadastro	:= "Gera Movimentacao Interna"

AADD(aSays,"Este programa tem o objetivo de deletar pedidos e romaneios ")
//AADD(aSays,"Movimentação Interna (SD3) para atualização do campo  ")
//AADD(aSays,"custo ref. Movimentação de Saida.")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1
	LjMsgRun("Aguarde..., Processando registros...",, {|| DelRoma() })	
EndIf		

Return

Static Function DelRoma()

Local _aCabPv		:= {}
Local _aItemTemp	:= {}	
Local _aItemPv		:= {}
Local _nReg			:= 0

Private lMsErroAuto	:= .F.


IF SELECT("QRY") > 0  

   QRY->(DBCLOSEAREA())

ENDIF 

cQuery := " SELECT * "
cQuery += " FROM "	+RetSqlName("PA6")+" PA6 (NOLOCK)"
cQuery += " WHERE " 
cQuery += " PA6_NUMROM LIKE '%01" + "' AND "
cQuery += " PA6_DTROM BETWEEN '20080101' AND '20090904' AND "
cQuery += " PA6_STATUS = '01' AND "		
cQuery += " PA6.D_E_L_E_T_ = '' " 
cQuery += " ORDER BY PA6_DTROM"

TcQuery cQuery NEW ALIAS "QRY"

DbSelectArea("QRY")
QRY->( DbGoTop() ) 
If QRY->( !Eof() )
      
	While QRY->( !Eof() )

		DbSelectArea("SC5")	
		SC5->( DbSetOrder(1) )
		If SC5->( DbSeek(xFilial("SC5")+Substr(QRY->PA6_NUMROM,1,6) ))

			_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
			{"C5_NUM"		,   SC5->C5_NUM					,Nil},;
			{"C5_TIPO"		,   SC5->C5_TIPO	  			,Nil},;
			{"C5_CLIENTE"	,	SC5->C5_CLIENTE				,Nil},;
			{"C5_LOJACLI"	,	SC5->C5_LOJACLI				,Nil},;
			{"C5_TIPOCLI"	,	SC5->C5_TIPOCLI				,Nil},;
			{"C5_TRANSP"	,	SC5->C5_TRANSP	  			,Nil},;
			{"C5_TPFRETE"	,	SC5->C5_TPFRETE				,Nil},;
			{"C5_MOEDA"		,	SC5->C5_MOEDA				,Nil},;
			{"C5_CONDPAG"	,	SC5->C5_CONDPAG				,Nil},;
			{"C5_EMISSAO"	,	SC5->C5_EMISSAO	 	  	 	,Nil},;
			{"C5_VEND1"		,	SC5->C5_VEND1				,Nil}}
	        	
			
			DbSelectArea("SC6")	
			SC6->( DbSetOrder(1) )
			If SC6->( DbSeek( xFilial("SC6")+Substr(QRY->PA6_NUMROM,1,6) ) )
	    	
				While SC6->( !Eof() ) .And. xFilial("SC6") == SC6->C6_FILIAL .And. Substr(QRY->PA6_NUMROM,1,6) == SC6->C6_NUM 
			
					_aItemTemp :=	{{"C6_NUM"	,	SC6->C6_NUM		,Nil},;
					{"C6_FILIAL"	,	xFilial("SC6")			,Nil},;
					{"C6_ITEM"		,	SC6->C6_ITEM			,Nil},;	
					{"C6_PRODUTO"	,	SC6->C6_PRODUTO			,Nil},;
					{"C6_DESCRI"	,	SC6->C6_DESCRI			,Nil},;	  
					{"C6_UM"		,	SC6->C6_UM				,Nil},;
					{"C6_QTDVEN"	,	SC6->C6_QTDVEN			,Nil},; 
					{"C6_QTDEMP"	,	SC6->C6_QTDEMP			,Nil},;	 
					{"C6_QTDLIB"	,	SC6->C6_QTDLIB			,Nil},;	 
					{"C6_PRUNIT"	,	SC6->C6_PRUNIT			,Nil},;	
					{"C6_PRCVEN"	,	SC6->C6_PRCVEN			,Nil},;
					{"C6_VALOR"		,	SC6->C6_VALOR			,Nil},;
					{"C6_TES"		,	SC6->C6_TES				,Nil},;	
					{"C6_CF"		,	SC6->C6_CF				,Nil},;
					{"C6_LOCAL"		,	SC6->C6_LOCAL			,Nil},;	
					{"C6_CLI"		,	SC6->C6_CLI		 		,Nil},;
					{"C6_ENTREG"	,	SC6->C6_ENTREG			,Nil},;	
					{"C6_LOJA"		,	SC6->C6_LOJA			,Nil}}	 
	    		
					Aadd(_aItemPv,aClone(_aItemTemp))
			
					_nReg++
						
					SC6->( DbSkip() )	  
			
				EndDo	

			EndIf
			
			If _nReg > 0
			
			   cQryA := " UPDATE " + RetSqlName('PA6') 
			   cQryA += " SET D_E_L_E_T_ = '*' WHERE PA6_NUMROM = '"+QRY->PA6_NUMROM+"'"
	           cQryB := " UPDATE " + RetSqlName('PA7') 
	           cQryB += " SET D_E_L_E_T_ = '*' WHERE PA7_NUMROM = '"+QRY->PA6_NUMROM+"'"
	           
	           TcSQLExec(cQryB)
	           TcSQLExec(cQryA)
	          	          				
				MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,4)
           
                If lMsErroAuto
					MostraErro()
				EndIf
		
				MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,5)		
		
				If lMsErroAuto
					MostraErro()
				EndIf	
		
			EndIf
			
		EndIf	
			
		_nReg := 0
		QRY->( DbSkip() )
	
	EndDo
	
EndIf

Return