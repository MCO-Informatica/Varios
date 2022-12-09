#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"           
#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  |SFATA003   บAutor  ณFelipe Valenca      บ Data ณ  05/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela cotendo resumo de metas por regiao...                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Shangri-la                                                     บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*---------------------*
User Function SFATA003
*---------------------*

Local aArea 	:= GetArea()
Local aAlias	:= {}

Local cCadastro := "Consulta de Metas por Regiใo -= Shangri-la =-"
Local nDeleted2 := 0

Private oDlg
Private _oBrowse1
Private _aBrowse1 := {}
//Private _cImgFund  := "_LgrFun.bmp"                 
     
DEFINE FONT oFont5 NAME "Verdana" SIZE 10,20 BOLD                           
Private nOpcx := 0

Private	cGetReg	  := " "

Private _aBrwREG  := {}
Private _oBrwREG

Private _aBrwVEN  := {}
Private _oBrwVEN 

Private _aBrwGRP  := {}
Private _oBrwGRP

Private _aBrwMET  := {}
Private _oBrwMET

Private _aBrwCUM  := {}
Private _oBrwCUM

Private _cQryZ5 := ''
Private _aVend := {}
Private _aRegiao	:= {}

Private _cRegiao	:= ""
Private _cVend		:= ""
Private _nTotPrd 	:= 0
Private _TotPrev	:= 0

Private oOK := LoadBitmap(GetResources(),'br_verde')
Private oNO := LoadBitmap(GetResources(),'br_vermelho')

Private lTotReg := .T.


DEFINE FONT oFont5 NAME "Verdana" SIZE 10,20 BOLD

/* SELECIONA TODOS AS REGIOES DO CADASTRO DE METAS */
_cQryZ4 := " SELECT Z4_COD, Z4_DESC, Z4_META FROM SZ4010 Z4 "
_cQryZ4 += " WHERE Z4.D_E_L_E_T_ = ' ' "
_cQryZ4 += " ORDER BY Z4_COD "
                      	
If Select("_Z4") > 0
	_Z4->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryZ4),"_Z4",.F.,.T.) 

xPrevisao()
DbSelectArea("_Z4")
_Z4->(dbGoTop())
_nMetReg := 0
While _Z4->(!EOF())
	Aadd(_aBrwREG,{.T.,_Z4->Z4_COD,_Z4->Z4_DESC,_Z4->Z4_META,(_Z4->Z4_META/100)*_TotPrev})
	_nMetReg += _Z4->Z4_META
	_Z4->(DbSkip())
EndDo  
//TOTAL DE METAS DA REGIAO
Aadd(_aBrwREG,{Iif(_nMetReg=100,.T.,.F.),"TOTAL",,_nMetReg,_TotPrev})

/* MONTA ESTRUTRA DA TELA */
DEFINE MSDIALOG oDlg FROM 09,00 TO 042,136 TITLE cCadastro OF oMainWnd

@ 015,006 TO 130, 183 OF oDlg	PIXEL /** BOX 1 **/ 
@ 017,075 SAY OemToAnsi("Regiใo") FONT oFont5 OF oDlg PIXEL COLOR CLR_HBLUE
@ 027,006 TO 027.5, 183 OF oDlg	PIXEL

//aADD(_aBrwREG,{'','',''}) Nao sei por que esta adicionando uma linha em branco... depois apagar
// Cria Browse
_oBrwREG := TCBrowse():New(033,012,165,090,,;
							{"","C๓digo","Descri็ใo","Meta","Total"},;
							{10,25,70,15,40},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
// Seta vetor para a browse                            
_oBrwREG:SetArray(_aBrwREG) 
    
// Monta a linha a ser exibina no Browse
_oBrwREG:bLine := {||{  If(_aBrwREG[_oBrwREG:nAt,01],oOK,oNO),;
						 _aBrwREG[_oBrwREG:nAt,02],;
                         _aBrwREG[_oBrwREG:nAt,03],;
                         _aBrwREG[_oBrwREG:nAt,04],;
                         Transform(_aBrwREG[_oBrwREG:nAt,05],"@E 999,999,999.99" )}}
                                                     

_oBrwREG:bLDblClick   := {|| xDuplREG(_oBrwREG:ColPos)}

/******************** VENDEDORES ********************/
@ 015,183 TO 130, 360 OF oDlg	PIXEL /** BOX 1 **/ 
@ 017,235 SAY OemToAnsi("Representantes") FONT oFont5 OF oDlg PIXEL COLOR CLR_HBLUE
@ 027,183 TO 027.5, 360 OF oDlg	PIXEL /** Linha Cabec **/ 

If Len(_aBrwVEN) <= 0
	aADD(_aBrwVEN,{.F.,'','','',''})
Endif
// Cria Browse 
_oBrwVEN := TCBrowse():New(033,189,165,090,,;
							{"","C๓digo","Nome","Meta","Total"},;
							{10,25,70,15,40},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

// Seta vetor para a browse                            
_oBrwVEN:SetArray(_aBrwVEN) 

_oBrwVEN:bLine := {||{   If(_aBrwVEN[_oBrwVEN:nAt,01],oOK,oNO),;
                         _aBrwVEN[_oBrwVEN:nAt,02],;
                         _aBrwVEN[_oBrwVEN:nAt,03],;
                         _aBrwVEN[_oBrwVEN:nAt,04],;
                         Transform(_aBrwVEN[_oBrwVEN:nAt,05],"@E 999,999,999.99")}}


// Evento de duploclick
_oBrwVEN:bLDblClick   := {|| xDuplVEN(_oBrwVEN:ColPos)}



/******************** GRUPO DE PRODUTOS ********************/
@ 015,360 TO 130, 537 OF oDlg	PIXEL /** BOX 1 **/ 
@ 017,445 SAY OemToAnsi("Grupo") FONT oFont5 OF oDlg PIXEL COLOR CLR_HBLUE
@ 027,360 TO 027.5, 537 OF oDlg	PIXEL /** Linha Cabec **/ 

If Len(_aBrwGRP) <= 0
	aADD(_aBrwGRP,{.F.,'','','',''})
Endif
// Cria Browse 
_oBrwGRP := TCBrowse():New(033,366,165,090,,;
							{"","C๓digo","Descri็ใo","Meta","Total"},;
							{10,25,70,15,40},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

// Seta vetor para a browse                            
_oBrwGRP:SetArray(_aBrwGRP) 

_oBrwGRP:bLine := {||{ Iif(_aBrwGRP[_oBrwGRP:nAt,01],oOk,oNo),;
                         _aBrwGRP[_oBrwGRP:nAt,02],;
                         _aBrwGRP[_oBrwGRP:nAt,03],;
                         _aBrwGRP[_oBrwGRP:nAt,04],;
                         Transform(_aBrwGRP[_oBrwGRP:nAt,05],"@E 999,999,999.99")}}
                         
// Evento de duploclick
_oBrwGRP:bLDblClick   := {|| xDuplGRP(_oBrwGRP:ColPos)}


/******************** METAS ********************/

@ 135,006 TO 250, 537 OF oDlg	PIXEL /** BOX 1 **/ 
@ 137,240 SAY OemToAnsi("Metas") FONT oFont5 OF oDlg PIXEL COLOR CLR_HBLUE
@ 147,006 TO 147.5, 537 OF oDlg	PIXEL /** Linha Cabec **/ 

If Len(_aBrwMET) <= 0
	AADD(_aBrwMET,{.F.,'','','','','','','',''})
Endif
// Cria Browse 
_oBrwMET := TCBrowse():New(153,012,518,090,,;
							{"","Produto","Meta","Qtd Grp","Vlr Grp","Qtd Vend","Vlr Vend","Qtd Reg","Vlr Reg"},;
							{},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

// Seta vetor para a browse                            
_oBrwMET:SetArray(_aBrwMET) 

_oBrwMET:bLine := {||{   Iif(_aBrwMET[_oBrwMET:nAt,01],oOk,oNo),;
                         _aBrwMET[_oBrwMET:nAt,02],;
                         _aBrwMET[_oBrwMET:nAt,03],;
                         _aBrwMET[_oBrwMET:nAt,04],;
                         _aBrwMET[_oBrwMET:nAt,05],;
                         _aBrwMET[_oBrwMET:nAt,06],;
                         _aBrwMET[_oBrwMET:nAt,07],;
                         _aBrwMET[_oBrwMET:nAt,08],;
                         _aBrwMET[_oBrwMET:nAt,09]}}
                         
ACTIVATE MSDIALOG oDlg  CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()})

Return(.T.)                                                      


Static Function xExecRegiao(_cRegiao)

Local _nSubMet 	:= 0
Local cVendedor	:= ""
Local _cCodVend := ""
Local _cNomVend	:= ""
Local _lRet := .T.
Local _nValReg	:= 0
Default _cRegiao := ""


If _aBrwREG[Len(_aBrwREG)][4] > 100
	Alert("Aten็ao! A Soma dos percentuais das regi๕es passou de 100%.")
	_lRet := .F.
Elseif _aBrwREG[Len(_aBrwREG)][4] < 100
	Alert("Aten็ao! A Soma dos percentuais das regi๕es nใo atingiu 100%.")
	_lRet := .F.
Endif

If _lRet
	_cQrySZ5 := ""
	_aBrwVEN := {}
	
	_cQrySZ5 := "SELECT Z5_VEND, Z5_NOMVEND, Z5_META "
	_cQrySZ5 += "FROM "+RetSqlName("SZ5")+" Z5 " 
	_cQrySZ5 += "WHERE Z5.D_E_L_E_T_ = ' ' AND Z5_FILIAL = '"+xFilial("SZ5")+"' "
	_cQrySZ5 += "AND Z5_REGIAO = '"+_cRegiao+"' "
	_cQrySZ5 += "ORDER BY Z5_VEND "
	If Select("_Z5REG") > 0
		_Z5REG->(DbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySZ5),"_Z5REG",.F.,.T.)
	
	DbSelectArea("_Z5REG")
	_Z5REG->(dbGoTop())
	_nMetVend := 0
	Do While !_Z5REG->(Eof())
		
		cVendedor := _Z5REG->Z5_VEND
		Do While !_Z5REG->(Eof()) .And. cVendedor == _Z5REG->Z5_VEND
			_cCodVend := Alltrim(_Z5REG->Z5_VEND)
			_cNomVend := Alltrim(_Z5REG->Z5_NOMVEND)
			_nSubMet  += Z5_META
			_nMetVend += Z5_META
			_Z5REG->(dbSkip())
		EndDo
		Aadd(_aBrwVEN,{.T.,_cCodVend,_cNomVend,_nSubMet,(_nSubMet/100)*_aBrwREG[_oBrwREG:nAt,05]})
		_nSubMet := 0
	EndDo
	//TOTAL
	Aadd(_aBrwVEN,{Iif(_nMetVend=100,.T.,.F.),"TOTAL",,_nMetVend,_aBrwREG[_oBrwREG:nAt,05]})
		
	IF Len(_aBrwVEN) <= 0
		aADD(_aBrwVEN,{.F.,'','','',''})
	Endif                       
	                            
	
	// Seta vetor para a browse                                                      
	_oBrwVEN:SetArray(_aBrwVEN) 
	    
	// Monta a linha a ser exibina no Browse
	_oBrwVEN:bLine := {||{  Iif(_aBrwVEN[_oBrwVEN:nAt,01],oOK,oNO),;
							_aBrwVEN[_oBrwVEN:nAt,02],;
							_aBrwVEN[_oBrwVEN:nAt,03],;
							_aBrwVEN[_oBrwVEN:nAt,04],;
							Transform(_aBrwVEN[_oBrwVEN:nAt,05],"@E 999,999,999.99")}}

Endif						

Return

Static Function xExecVend(_cRegiao,_cVend)

Local _nSomaMeta	:= 0
Local _nTotMet		:= 0
Local _lRet			:= .T.

Default _cVend		:= ""
Default _cRegiao	:= ""


If _aBrwVEN[Len(_aBrwVEN)][4] > 100
	Alert("Aten็ao! A Soma dos percentuais dos representantes passou de 100%.")
	_lRet := .F.
Elseif _aBrwVEN[Len(_aBrwVEN)][4] < 100
	Alert("Aten็ao! A Soma dos percentuais dos representantes nใo atingiu 100%.")
	_lRet := .F.
Endif

If _lRet
	_cQrySZ5 := ""
	_aBrwGRP := {}
	
	_cQrySZ5 := "SELECT Z5_GRUPO, Z5_META "
	_cQrySZ5 += "FROM "+RetSqlName("SZ5")+" Z5 " 
	_cQrySZ5 += "WHERE Z5.D_E_L_E_T_ = ' ' AND Z5_FILIAL = '"+xFilial("SZ5")+"' "
	_cQrySZ5 += "AND Z5_REGIAO = '"+_cRegiao+"' AND Z5_VEND = '"+_cVend+"' "
	
	If Select("_Z5VEND") > 0
		_Z5VEND->(DbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySZ5),"_Z5VEND",.F.,.T.)
	
	DbSelectArea("_Z5VEND")
	_Z5VEND->(dbGoTop())
	_nMetGrp := 0
	_nSomaMeta 	:= fSomaMet(_cRegiao,_cVend)
	Do While !_Z5VEND->(Eof())
		_nTotMet 	:= ((_Z5VEND->Z5_META/_nSomaMeta)*100)
		_nMetGrp	+= _nTotMet
		Aadd(_aBrwGRP,{.T.,_Z5VEND->Z5_GRUPO,Alltrim(Posicione("SBM",1,xFilial("SMB")+_Z5VEND->Z5_GRUPO,"BM_DESC")),_nTotMet,(_nTotMet/100)*_aBrwVEN[_oBrwVEN:nAt,05]})
		_Z5VEND->(dbSkip())
	EndDo
	//TOTAL
	Aadd(_aBrwGRP,{Iif(_nMetGrp=100,.T.,.F.),"TOTAL",,_nMetGrp,_aBrwVEN[_oBrwVEN:nAt,05]})
	
	IF Len(_aBrwGRP) <= 0
		aADD(_aBrwGRP,{.F.,'','','',''})
	Endif                       
	                            
	// Seta vetor para a browse                                                      
	_oBrwGRP:SetArray(_aBrwGRP) 
	    
	// Monta a linha a ser exibina no Browse
	_oBrwGRP:bLine := {||{  Iif(_aBrwGRP[_oBrwGRP:nAt,01],oOk,oNo),;
							_aBrwGRP[_oBrwGRP:nAt,02],;
							_aBrwGRP[_oBrwGRP:nAt,03],;
							_aBrwGRP[_oBrwGRP:nAt,04],;
							Transform(_aBrwGRP[_oBrwGRP:nAt,05],"@E 999,999,999.99")}}
Endif
							
Return


Static Function xExecGrupo(_cRegiao,_cVend,_cGrupo)

Local	_lRet		:= .T.

Default _cVend		:= ""
Default _cRegiao	:= ""
Default _cGrupo		:= ""


If _aBrwGRP[Len(_aBrwGRP)][4] > 100
	Alert("Aten็ao! A Soma dos percentuais dos grupos passou de 100%.")
	_lRet := .F.
Elseif _aBrwGRP[Len(_aBrwGRP)][4] < 100
	Alert("Aten็ao! A Soma dos percentuais dos grupos nใo atingiu 100%.")
	_lRet := .F.
Endif

If _lRet
	_cQrySZ5 := ""
	_aBrwMET := {}
	
	_cQrySZ5 := "SELECT Z5_DESC,B1_COD, B1_DESC,((C4_QUANT * Z4_META)/100) QTDREGIA, ((C4_VALOR * Z4_META)/100) VLRREGIA "
	_cQrySZ5 += "FROM SZ5010 Z5 "
	
	_cQrySZ5 += "INNER JOIN SZ4010 Z4 ON Z4.D_E_L_E_T_ = ' ' "
	_cQrySZ5 += "AND Z4_FILIAL = Z5_FILIAL "
	_cQrySZ5 += "AND Z4_COD = Z5_REGIAO "
	
	_cQrySZ5 += "INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_ = ' ' "
	_cQrySZ5 += "AND B1_GRUPO = Z5_GRUPO "
	
	_cQrySZ5 += "INNER JOIN SC4010 C4 ON C4.D_E_L_E_T_ = ' ' "
	_cQrySZ5 += "AND C4_PRODUTO = B1_COD "
	
	_cQrySZ5 += "WHERE Z5.D_E_L_E_T_ = ' ' "
	_cQrySZ5 += "AND Z5_REGIAO = '"+_cRegiao+"' AND Z5_VEND = '"+_cVend+"' AND Z5_GRUPO = '"+_cGrupo+"' "
	
	
	If Select("_Z5GRP") > 0
		_Z5GRP->(DbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySZ5),"_Z5GRP",.F.,.T.)
	
	DbSelectArea("_Z5GRP")
	_Z5GRP->(dbGoTop())
	
	Do While !_Z5GRP->(Eof())

		fMetaPrd(_cRegiao,_cVend,_cGrupo)
		 
		Aadd(_aBrwMET,{.F.,;
		 Alltrim(_Z5GRP->B1_COD)+ " - "+ _Z5GRP->B1_DESC,;
		 Transform((_Z5GRP->QTDREGIA/_nTotPrd)*100, "@E 999.99"),;
	 	 Transform((((_Z5GRP->QTDREGIA * _aBrwGRP[_oBrwGRP:nAt,04])/100) * _aBrwVEN[_oBrwVEN:nAt,04])/100  , "@E 999,999.99"),;
		 Transform((((_Z5GRP->VLRREGIA * _aBrwVEN[_oBrwVEN:nAt,04])/100)* _aBrwGRP[_oBrwGRP:nAt,04])/100, "@E 999,999.99" ),;
		 Transform(( _Z5GRP->QTDREGIA * _aBrwVEN[_oBrwVEN:nAt,04])/100 , "@E 999,999.99"),;
		 Transform((_Z5GRP->VLRREGIA * _aBrwVEN[_oBrwVEN:nAt,04])/100,"@E 999,999.99"),;
		 Transform(_Z5GRP->QTDREGIA, "@E 999,999.99"),;
		 Transform(_Z5GRP->VLRREGIA,"@E 999,999.99")})
	 
		_Z5GRP->(dbSkip())
	EndDo
	
	IF Len(_aBrwGRP) <= 0
		aADD(_aBrwGRP,{.F.,'','','',''})
	Endif                       
	                            
	// Seta vetor para a browse                                                      
	_oBrwMET:SetArray(_aBrwMET) 
	    
	// Monta a linha a ser exibina no Browse
	_oBrwMET:bLine := {||{  Iif(_aBrwMET[_oBrwMET:nAt,01],oOk,oNo),;
							_aBrwMET[_oBrwMET:nAt,02],;
							_aBrwMET[_oBrwMET:nAt,03],;
							_aBrwMET[_oBrwMET:nAt,04],;
							_aBrwMET[_oBrwMET:nAt,05],;
							_aBrwMET[_oBrwMET:nAt,06],;
							_aBrwMET[_oBrwMET:nAt,07],;
							_aBrwMET[_oBrwMET:nAt,08],;
							_aBrwMET[_oBrwMET:nAt,09]}}
Endif
						
Return


/* SOMA DAS METAS PARA CALCULO DA PORCENTAGEM DO GRUPO */

Static Function fSomaMet(_cRegiao,_cVend)

_cQrySZ5 := "SELECT SUM(Z5_META) TOTAL "
_cQrySZ5 += "FROM "+RetSqlName("SZ5")+" Z5 " 
_cQrySZ5 += "WHERE Z5.D_E_L_E_T_ = ' ' AND Z5_FILIAL = '"+xFilial("SZ5")+"' "
_cQrySZ5 += "AND Z5_REGIAO = '"+_cRegiao+"' AND Z5_VEND = '"+_cVend+"' "

If Select("_SOMMETA") > 0
	_SOMMETA->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySZ5),"_SOMMETA",.F.,.T.)

_nSomaMeta := _SOMMETA->TOTAL
Return(_nSomaMeta)

Static Function fMetaPrd(_cRegiao,_cVend,_cGrupo)


_cQrySZ5 := "SELECT SUM(((C4_QUANT * Z4_META)/100)) QTDREGIA "
_cQrySZ5 += "FROM SZ5010 Z5 "

_cQrySZ5 += "INNER JOIN SZ4010 Z4 ON Z4.D_E_L_E_T_ = ' ' "
_cQrySZ5 += "AND Z4_FILIAL = Z5_FILIAL "
_cQrySZ5 += "AND Z4_COD = Z5_REGIAO "

_cQrySZ5 += "INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_ = ' ' "
_cQrySZ5 += "AND B1_GRUPO = Z5_GRUPO "

_cQrySZ5 += "INNER JOIN SC4010 C4 ON C4.D_E_L_E_T_ = ' ' "
_cQrySZ5 += "AND C4_PRODUTO = B1_COD "

_cQrySZ5 += "WHERE Z5.D_E_L_E_T_ = ' ' "
_cQrySZ5 += "AND Z5_REGIAO = '"+_cRegiao+"' AND Z5_VEND = '"+_cVend+"' AND Z5_GRUPO = '"+_cGrupo+"' "


If Select("_Z5MET") > 0
	_Z5MET->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySZ5),"_Z5MET",.F.,.T.)

DbSelectArea("_Z5MET")

_nTotPrd := _Z5MET->QTDREGIA 

Return(_nTotPrd)


Static Function xPrevisao

_cQrySC4 := "select SUM(C4_VALOR) TOTAL from "+RetSqlName("SC4")+" WHERE C4_FILIAL = '"+xFilial("SC4")+"' AND C4_VALOR <> 0 "

If Select("_C4PREV") > 0
	_C4PREV->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySC4),"_C4PREV",.F.,.T.)

DbSelectArea("_C4PREV")

_TotPrev := _C4PREV->TOTAL

Return

//APOS VALIDACAO APAGAR ESSA FUNCAO - FELIPE VALENวA ** 20120522 **
/*Static Function ValidREG()

Local _nSomaMet := 0
Local _lRet := .T.

_oBrwREG:Refresh()

For _nY := 1 to Len(_aBrwREG)-1
	If _aBrwREG[_nY,01] == .T.
		_nSomaMet += _aBrwREG[_nY][4]	
	Endif
Next

_aBrwREG[Len(_aBrwREG)][4] := _nSomaMet
_oBrwREG:Refresh()

If _nSomaMet <> 100
    If _nSomaMet > 100
		Alert("Aten็ใo! Porcentagem superior a 100%")
	Else
		Alert("Aten็ใo! Porcentagem inferior a 100%")
	Endif
	_lRet := .F.
//	_aBrwREG[Len(_aBrwREG),01] := .F.
Else
//	_aBrwREG[Len(_aBrwREG),01] := .T.
Endif

Return _lRet */

Static Function ValidVend()

Local _nSomaMet := 0
Local _lRet := .T.

_oBrwVEN:Refresh()

For _nY := 1 to Len(_aBrwVEN)-1
	_nSomaMet += _aBrwVEN[_nY][3]	
Next

_aBrwVEN[Len(_aBrwVEN)][3] := _nSomaMet
_oBrwVEN:Refresh()

If _nSomaMet > 100
	Alert("Aten็ใo! Porcentagem superior a 100%")
	_lRet := .F.
Endif


Return

Static Function ValidGRP()

Local _nSomaMet := 0
Local _lRet := .T.

_oBrwGRP:Refresh()

For _nY := 1 to Len(_aBrwGRP)-1
	_nSomaMet += _aBrwGRP[_nY][4]	
Next

_aBrwGRP[Len(_aBrwGRP)][4] := _nSomaMet
_oBrwGRP:Refresh()

If _nSomaMet > 100
	Alert("Aten็ใo! Porcentagem superior a 100%")
	_lRet := .F.
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxDelete  บAutor  ณFelipe Valenca      บ Data ณ  22/05/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็๕es para valida็ใo dos itens deletados para cada       บฑฑ
ฑฑบ          ณ janela. 													  บฑฑ
ฑฑบ          ณ------------------------------------------------------------บฑฑ
ฑฑบ          ณ Fun็ใo ProcName inviแvel, pois a chamada da fun็ใo pode virบฑฑ
ฑฑบ          ณ de diferentes lugares.                           		  บฑฑ
ฑฑบ          ณ xDeleteREG()				                                  บฑฑ
ฑฑบ          ณ xDeleteVEN()			                                      บฑฑ
ฑฑบ          ณ xDeleteGRP()			                                      บฑฑ
ฑฑบ          ณ xDeleteMET()			                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//ROTINA PARA VALIDAR ITENS DELETADOS DA REGIAO
Static Function xDeleteREG(_lStatus)

_nSomaMet := 0

If _oBrwREG:nAt <> Len(_aBrwREG)
	If _lStatus == .T.
		_aBrwREG[_oBrwREG:nAt,01] := .F.
		xSemaOkREG()
	Else
		_aBrwREG[_oBrwREG:nAt,01] := .T.
		xSemaOkREG()
	Endif
Endif

Return 


//ROTINA PARA VALIDAR ITENS DELETADOS DO VENDEDOR
Static Function xDeleteVEN(_lStatus)

_nSomaMet := 0
If _oBrwVEN:nAt <> Len(_aBrwVEN)
	If _lStatus == .T.
		_aBrwVEN[_oBrwVEN:nAt,01] := .F.
		xSemaOkVEN()
	Else
		_aBrwVEN[_oBrwVEN:nAt,01] := .T.
		xSemaOkVEN()
	Endif
Endif

Return 


//ROTINA PARA VALIDAR ITENS DELETADOS DO GRUPO
Static Function xDeleteGRP(_lStatus)

_nSomaMet := 0
If _oBrwGRP:nAt <> Len(_aBrwGRP)
	If _lStatus == .T.
		_aBrwGRP[_oBrwGRP:nAt,01] := .F.
		xSemaOkGRP()
	Else
		_aBrwGRP[_oBrwGRP:nAt,01] := .T.
		xSemaOkGRP()
	Endif
Endif


//ROTINA PARA VALIDAR ITENS DELETADOS DOS PRODUTOS
Static Function xDeleteMET(_lStatus)

_nSomaMet := 0
If _oBrwMET:nAt <> Len(_aBrwMET)
	If _lStatus == .T.
		_aBrwMET[_oBrwMET:nAt,01] := .F.
//		xSemaOkMET()
	Else
		_aBrwMET[_oBrwMET:nAt,01] := .T.
//		xSemaOkMET()
	Endif
Endif

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxDuplCl  บAutor  ณFelipe Valenca      บ Data ณ  22/05/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็๕es para valida็ใo da fun็ใo DuploClick para cada      บฑฑ
ฑฑบ          ณ janela. 													  บฑฑ
ฑฑบ          ณ------------------------------------------------------------บฑฑ
ฑฑบ          ณ Fun็ใo ProcName inviแvel, pois a chamada da fun็ใo pode virบฑฑ
ฑฑบ          ณ de diferentes lugares.                           		  บฑฑ
ฑฑบ          ณ xDuplREG()				                                  บฑฑ
ฑฑบ          ณ xDuplVEN()			                                      บฑฑ
ฑฑบ          ณ xDuplGRP()			                                      บฑฑ
ฑฑบ          ณ xDuplMET()			                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


//ROTINA PARA VALIDAR O DUPLO CLICK DA REGIAO
Static Function xDuplREG(_xColuna)

If _xColuna == 1
	xDeleteREG(_aBrwREG[_oBrwREG:nAt,01])
ElseIf _xColuna == 4
	xSemaOkREG(lEditCell( @_aBrwREG, _oBrwREG,"@E 999.99", _oBrwREG:ColPos,,,))
Else
	(xExecRegiao(_aBrwREG[_oBrwREG:nAt,02]), _oBrwVEN:Refresh(), oDlg:Refresh())
Endif

Return

//ROTINA PARA VALIDAR O DUPLO CLICK DO REPRESENTANTE
Static Function xDuplVEN(_xColuna)

If _xColuna == 1
	xDeleteVEN(_aBrwVEN[_oBrwVEN:nAt,01])
ElseIf _xColuna == 4
	xSemaOkVEN(lEditCell( @_aBrwVEN, _oBrwVEN,"@E 999.99", _oBrwVEN:ColPos,,,))
Else
	(xExecVend(_aBrwREG[_oBrwREG:nAt,02],_aBrwVEN[_oBrwVEN:nAt,02]),_oBrwGRP:Refresh(), oDlg:Refresh())
Endif

Return


//ROTINA PARA VALIDAR O DUPLO CLICK DO GRUPO
Static Function xDuplGRP(_xColuna)

If _xColuna == 1
	xDeleteGRP(_aBrwGRP[_oBrwGRP:nAt,01])
ElseIf _xColuna == 4
	xSemaOkGRP(lEditCell( @_aBrwGRP, _oBrwGRP,"@E 999.99", _oBrwGRP:ColPos,,,))
Else
	(xExecGrupo(_aBrwREG[_oBrwREG:nAt,02],_aBrwVEN[_oBrwVEN:nAt,02],_aBrwGRP[_oBrwGRP:nAt,02]),_oBrwMET:Refresh(), oDlg:Refresh())
Endif


//ROTINA PARA VALIDAR O DUPLO CLICK DOS PRODUTOS
Static Function xDuplMET(_xColuna)

If _xColuna == 1
	xDeleteMET(_aBrwMET[_oBrwMET:nAt,01])
ElseIf _xColuna == 4
//	xSemaOkMET(lEditCell( @_aBrwMET, _oBrwMET,"@E 999.99", _oBrwMET:ColPos,,,))
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSemaOk  บAutor  ณFelipe Valenca      บ Data ณ  22/05/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็๕es para valida็ใo de semแforo (verde/vermelho) para   บฑฑ
ฑฑบ          ณ cada janela.												  บฑฑ
ฑฑบ          ณ------------------------------------------------------------บฑฑ
ฑฑบ          ณ Fun็ใo ProcName inviแvel, pois a chamada da fun็ใo pode virบฑฑ
ฑฑบ          ณ de diferentes lugares.                           		  บฑฑ
ฑฑบ          ณ xSemaOkREG()				                                  บฑฑ
ฑฑบ          ณ xSemaOkVEN()			                                      บฑฑ
ฑฑบ          ณ xSemaOkGRP()			                                      บฑฑ
ฑฑบ          ณ xSemaOkMET()			                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//ROTINA PARA VALIDAR SEMAFORO DA REGIAO
Static Function xSemaOkREG()

_nSomaMet := 0

For _nY := 1 to Len(_aBrwREG)-1
	If _aBrwREG[_nY,01] == .T.
		_nSomaMet += _aBrwREG[_nY][4]	
		_aBrwREG[_nY][5] := (_aBrwREG[_nY][4]/100)*_TotPrev
	Endif
Next

_aBrwREG[Len(_aBrwREG)][4] := _nSomaMet
_aBrwREG[Len(_aBrwREG),05] := (_nSomaMet/100)*_TotPrev
If _nSomaMet <> 100
	_aBrwREG[Len(_aBrwREG),01] := .F.
Else
	_aBrwREG[Len(_aBrwREG),01] := .T.
Endif
_oBrwREG:Refresh()

Return


//ROTINA PARA VALIDAR SEMAFORO DO VENDEDOR
Static Function xSemaOkVEN()

_nSomaMet := 0

For _nY := 1 to Len(_aBrwVEN)-1
	If _aBrwVEN[_nY,01] == .T.
		_nSomaMet += _aBrwVEN[_nY][4]	
		_aBrwVEN[_nY][5] := (_aBrwVEN[_nY][4]/100)*_TotPrev
	Endif
Next

_aBrwVEN[Len(_aBrwVEN)][4] := _nSomaMet
_aBrwVEN[Len(_aBrwVEN)][5] := (_nSomaMet/100)*_aBrwVEN[_nY][5]//_TotPrev
If _nSomaMet <> 100
	_aBrwVEN[Len(_aBrwVEN),01] := .F.
Else
	_aBrwVEN[Len(_aBrwVEN),01] := .T.
Endif
_oBrwVEN:Refresh()

Return


//ROTINA PARA VALIDAR SEMAFORO DO GRUPO
Static Function xSemaOkGRP()

_nSomaMet := 0

For _nY := 1 to Len(_aBrwGRP)-1
	If _aBrwGRP[_nY,01] == .T.
		_nSomaMet += _aBrwGRP[_nY][4]	
		_aBrwGRP[_nY][5] := (_aBrwGRP[_nY][4]/100)*_aBrwGRP[_nY][5]//_TotPrev
	Endif
Next

_aBrwGRP[Len(_aBrwGRP)][4] := _nSomaMet
_aBrwGRP[Len(_aBrwGRP)][5] := (_nSomaMet/100)*_aBrwGRP[_nY][5]//_TotPrev
If _nSomaMet <> 100
	_aBrwGRP[Len(_aBrwGRP),01] := .F.
Else
	_aBrwGRP[Len(_aBrwGRP),01] := .T.
Endif
_oBrwGRP:Refresh()

Return


//ROTINA PARA VALIDAR SEMAFORO DOS PRODUTOS
Static Function xSemaOkMET()

_nSomaMet := 0

For _nY := 1 to Len(_aBrwMET)-1
	If _aBrwMET[_nY,01] == .T.
		_nSomaMet += _aBrwMET[_nY][4]	
		_aBrwMET[_nY][5] := (_aBrwMET[_nY][4]/100)*_TotPrev
	Endif
Next

_aBrwMET[Len(_aBrwMET)][4] := _nSomaMet
_aBrwMET[Len(_aBrwMET)][5] := (_nSomaMet/100)*_TotPrev
If _nSomaMet <> 100
	_aBrwMET[Len(_aBrwMET),01] := .F.
Else
	_aBrwMET[Len(_aBrwMET),01] := .T.
Endif
_oBrwMET:Refresh()

Return
