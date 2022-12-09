#Include "TopConn.ch"
#Include "Protheus.Ch"
#Include "TbiConn.ch"

User Function MT410INC()

Local _aArea 		:= GetArea() 
Local _aAreaSC5		:= sc5->(GetArea())
Local _aAreaSC6		:= sc6->(GetArea())
Local _aAreaSA1		:= sa1->(GetArea())
Local _aAreaSA4		:= sa4->(GetArea())
Local _aLinha 		:= {}
Local _aItens 		:= {}
Local _aCab   		:= {}
Local _nItem  		:= 0
Local _cPedRem 		:= ""

Local _cCliente		:= space(TAMSX3("C5_CLIENTE")[1])
Local _cLoja		:= space(TAMSX3("C5_LOJACLI")[1])
Local _cTransp		:= space(TAMSX3("C5_TRANSP")[1])

Local _lok			:= .f.

/*
Local lHasButton 	:= .F.
Local lNoButton  	:= .T.
Local cLabelText 	:= ""    //indica o texto que será apresentado na Label.
Local nLabelPos  	:= 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
Local oDlg
Local oGet01
Local oGet02
*/

if sc5->c5_xgremor == 'S'
	/*
	While !_lok
		DEFINE MSDIALOG oDlg TITLE "Dados Remessa a Ordem" FROM 000, 000 TO 105, 200 COLORS 0, 16777215 PIXEL
    	oPnl1:= tPanel():New(000,001,,oDlg,,,,,CLR_HCYAN,390,052)
    	cLabelText := "CLIENTE"
    	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,_cCliente ,_cCliente := u)},oPnl1,038,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"_cCliente",,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
		cLabelText := "LOJA"
		oGet02 := TGet():New(003,043,{|u|If(PCount()==0,_cLoja	  ,_cLoja    := u)},oPnl1,020,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"_cLoja"	  ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
		cLabelText := "TRANSPORTADORA"
		oGet02 := TGet():New(003,043,{|u|If(PCount()==0,_cTransp  ,_cTransp  := u)},oPnl1,020,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"_cTransp" ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
    	@ 030, 003 BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 action iif(critTl(_cCliente,_cLoja,_cTransp),(oDlg:End(),_lok:=.t.),_lok:=.f.) OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED
	end
	*/
	_cCliente := SC5->C5_XARMAZE //"010243"
	_cLoja    := SC5->C5_XLJARMA //"01"
	_lok 	  := critTl(_cCliente,_cLoja,_cTransp)

	if _lok

		sc5->(dbSetorder(1))
		_cPedRem := GetSxeNum("SC5","C5_NUM")
		While .t.
			ConFirmSX8()
			If !sc5->(dbseek(xfilial()+_cPedRem))
				exit
			endif
			_cPedRem := GetSxeNum("SC5","C5_NUM")
		End

		Restarea(_aAreaSC5)
		_aCab  := { {"C5_NUM"		,_cPedRem		,Nil},;
					{"C5_TIPO"      ,"N"      		,Nil},;
					{"C5_TPFRETE"   ,"C"			,Nil},; 
					{"C5_TPFREDE"   ,"D"			,Nil},; 
					{"C5_XTEMRED"   ,"S"			,Nil},; 
					{"C5_EMISSAO"   ,dDataBase		,Nil},;
					{"C5_DTENTR"	,SC5->C5_DTENTR ,Nil},;
					{"C5_CLIENTE"   ,SA1->A1_COD	,Nil},;
					{"C5_LOJACLI"   ,SA1->A1_LOJA	,Nil},;
					{"C5_TIPOCLI"   ,SA1->A1_TIPO	,Nil},;
					{"C5_CLIENT"    ,SA1->A1_COD	,Nil},;
					{"C5_LOJAENT"   ,SA1->A1_LOJA	,Nil},;
					{"C5_TABELA"	,SC5->C5_TABELA	,Nil},;
					{"C5_VEND1"		,SC5->C5_VEND1	,Nil},;
					{"C5_VEND2"		,SC5->C5_VEND2	,Nil},;
					{"C5_VEND3"		,SC5->C5_VEND3	,Nil},;
					{"C5_VEND4"		,SC5->C5_VEND4	,Nil},;
					{"C5_CONDPAG"   ,"003"			,Nil},; 
					{"C5_XPEDORD"   ,SC5->C5_NUM	,Nil}}

		SC6->( dbSetOrder(1) )
		SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )
		While SC6->(!Eof()) .AND. SC6->C6_NUM == SC5->C5_NUM

			_aLinha := {}

			aadd(_aLinha,{"C6_ITEM"   ,STRZERO(++_nItem,TAMSX3("C6_ITEM")[1]),nil})
			aadd(_aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO						,Nil})
			aadd(_aLinha,{"C6_LOCAL"  ,SC6->C6_LOCAL						,Nil})			
			aadd(_aLinha,{"C6_QTDVEN" ,SC6->C6_QTDVEN						,Nil})
			aadd(_aLinha,{"C6_PRCVEN" ,SC6->C6_PRCVEN						,Nil})
			aadd(_aLinha,{"C6_PRUNIT" ,SC6->C6_PRUNIT						,Nil})
			aadd(_aLinha,{"C6_VALOR"  ,SC6->C6_VALOR						,Nil})
			//aadd(_aLinha,{"C6_OPER"	  ,SC6->C6_OPER							,Nil})
			aadd(_aLinha,{"C6_TES"	  ,"564"								,Nil})
			aadd(_aLinha,{"C6_QTDLIB" ,SC6->C6_QTDVEN						,nil})
			aadd(_aLinha,{"C6_DTENTR" ,SC6->C6_DTENTR						,nil})
			aadd(_aLinha,{"C6_ENTREG" ,SC6->C6_ENTREG						,nil})

			aAdd(_aItens,_aLinha)

			SC6->(dbSkip())
		End

		_lok := MntPed(_aCab,_aItens,3)	//3 - FAZ A INCLUSAO DO PEDIDO

		if _lok
			Restarea(_aAreaSC5)
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XPEDORD := _cPedRem
			SC5->(MsUnlock())
		else
			Alert("Não consegui incluir pedido remessa a ordem!")
		endif

		aLinha := {}
		aItens := {}

	endif

endif

Restarea(_aAreaSA4)
Restarea(_aAreaSA1)
Restarea(_aAreaSC6)
Restarea(_aAreaSC5)
Restarea(_aArea)
return

//User Function M410STTS()
//return

Static Function critTl(_cCliente,_cLoja,_cTransp)

Local _lRet := .t.

SA1->( dbSetOrder(1) )
SA4->( dbSetOrder(1) )
if !empty(_cCliente+_cLoja)
   if !sa1->( dbSeek( xFilial() + _cCliente+_cLoja ) )
	  _lRet := .f.
	  Alert("Não encontrei esse cliente!")
   endif
endif
if !empty(_cTransp)
   if !sa4->( dbSeek( xFilial() + _cTransp ) )
	  _lRet := .f.
	  Alert("Não encontrei essa transportadora!")
   endif
endif

Return(_lRet)


Static Function MntPed(_aCab,_aItens,_nOpcao)  //_nOpcao = 3 - INCLUSAO DO PEDIDO

Local _lRet := .t.

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

Begin Transaction
	MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItens,_nOpcao)
	If lMsErroAuto	
	   _lRet := .f.
	   MostraErro()
	Endif
End Transaction

Return(_lRet)
