#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  M130PFIL   บ Autor ณ Pedro Augusto      บ Data ณ  12/03/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tratamento das linhas na geracao da cotacao                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RENOVA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/
User Function M130FIL
//	ALERT("M130FIL")
	Local _aArea := GetArea()
	Local _lRet := .t.      
	Local oDlg     := Nil
	Local cTitulo  := "Unidades requisitantes encontradas na sele็ใo"
	
//	Private _aCC := {}  
	
	Private oLbx     := Nil 
	Private aVetor   := {}
	Private _cFilUnReq  := "" 
	
	
	_cSelCC := " SELECT DISTINCT C1_FILIAL, C1_UNIDREQ"
	_cSelCC += "   FROM " + RetSqlName("SC1") + " SC1 "
	_cSelCC += "  WHERE C1_FILIAL='"+xFilial("SC1")+"'"
	_cSelCC += "    AND C1_NUM >= '"+MV_PAR09+"'"
	_cSelCC += "    AND C1_NUM <= '"+MV_PAR10+"'"
	_cSelCC += "    AND C1_EMISSAO >= '"+Dtos(MV_PAR02)+"'"
	_cSelCC += "    AND C1_EMISSAO <= '"+Dtos(MV_PAR03)+"'"
	_cSelCC += "    AND C1_COTACAO= '"+Space(Len(SC1->C1_COTACAO))+"' AND C1_QUJE<C1_QUANT AND C1_TPOP<>'P' AND C1_APROV IN(' ','L') "
	_cSelCC += "    AND D_E_L_E_T_ = ' '"
	_cSelCC += "  ORDER BY C1_FILIAL, C1_UNIDREQ"
	_cSelcc := ChangeQuery(_cSelCC)
	TCQUERY _cSelCC NEW ALIAS "C1UNIDREQ"
	dbGoTop()     
	While !Eof()
	    Aadd( aVetor, { C1UNIDREQ->C1_UNIDREQ , Posicione("SY3",1,xFilial("SY3")+C1UNIDREQ->C1_UNIDREQ, "Y3_DESC")})
		DbSkip()	
	EndDo
	DbSelectArea("C1UNIDREQ")
	DbCloseArea("C1UNIDREQ")
	
	If Len(aVetor) > 1 
		_cFilUnReq := " C1_UNIDREQ = '"+aVetor[1,1]+"'"
//		Alert("Tem mais de um CC")
		//+-----------------------------------------------+
		//| Monta a tela para usuario visualizar consulta |
		//+-----------------------------------------------+
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 240,500 PIXEL
		
		@ 030,010 LISTBOX oLbx FIELDS HEADER ;
		   "Un.Requis.", "Descricao" SIZE 230,080 OF oDlg PIXEL ON DBLCLICK( u_AddFil(oLbx:nAt),oDlg:End())
		                                      
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;
		                   aVetor[oLbx:nAt,2]}}
		
		@ 10,10 SAY "Foram encontrados mais de uma unidade requisitante para os parametros informados." SIZE 260,007 PIXEL OF oDlg
		@ 17,10 SAY "Para gerar cota็ใo para cada unidade requisitante, d๊ duplo click na unidade requisitante escolhida." SIZE 260,007 PIXEL OF oDlg
			                    
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
	RestArea(_aArea) 
	Return _cFilUnReq  
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑบPrograma  AddFil    บ Autor ณ Pedro Augusto       บ Data ณ  05/12/2011 บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescricao ณ Abre janela para selecao da unidade requisitante, quando   บฑฑ
	ฑฑบ          ณ houver mais de uma unidade requisitante no filtro de sele- บฑฑ
	ฑฑบ          ณ cao, e adiciona a unidade requisitante no filtro           บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ RENOVA                                                     บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	/*/
	User Function AddFil( nPos )
		Local cKey := ""
		_cFilUnReq := " C1_UNIDREQ = '"+aVetor[nPos,1]+"'"
		oLbx:Refresh()
		Return _cFilUnReq
			