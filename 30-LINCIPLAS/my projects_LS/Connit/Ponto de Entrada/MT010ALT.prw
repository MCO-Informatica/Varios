#INCLUDE "RWMAKE.CH"  
#INCLUDE "PROTHEUS.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT010ALT º Autor ³Antonio Carlos          º Data ³  25/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa validacao em campos determinados na tabela SX5(ZA) paraº±±
±±º          ³ tratar a gravacao do produto.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livraria Laselva.              			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010ALT()  

Local aArea		:= GetArea()

Local _nMax		:= 0
Local _nCont	:= 0
Local _aCampos	:= {}	

Local cCod		:= SB1->B1_COD
Local cDesc		:= SB1->B1_DESC
Local cLocPad	:= SB1->B1_LOCPAD
Local cGrupo	:= SB1->B1_GRUPO
Local cEdicao	:= SB1->B1_EDICAO
Local cPreco1	:= SB1->B1_PRV1
Local cPreco2	:= SB1->B1_PRV2
Local dEncalhe	:= SB1->B1_ENCALHE

DbSelectArea("SX5")
SX5->( DbSetOrder(1) )
If DbSeek( Space(2)+"ZA" )       
	While SX5->( !Eof() ) .And. Alltrim(SX5->X5_TABELA) == "ZA"
		Aadd(_aCampos,{AllTrim(X5_DESCRI)})
		SX5->( DbSkip() )
	EndDo	
EndIf
	
If SB1->B1_GRUPO $ GetMv("MV_GRPISEN")
	_nMax := Len(_aCampos)-1
Else
	_nMax := Len(_aCampos)	
EndIf

For _nI := 1 To _nMax
   
	If Empty(&(_aCampos[_nI,1]))
		_nCont++
	EndIf
	
Next _nI                 

If (_nCont > 0 .Or. SB1->B1_MSBLQL == '1') .AND. SB1->B1_GRUPO <> '0200' // Alteração efetuada por Vanilson (.Or. SB1->B1_MSBLQL == '1')
	RecLock("SB1",.F.) 
	Replace SB1->B1_MSBLQL	With "1"	
	Replace SB1->B1_UREV	With dDataBase
	SB1->( MsUnLock() )                                     
	_cMsg := ''
	For _nI := 1 to len(_aCampos)
		If empty(&(_aCampos[_nI,1])) .AND. !SB1->B1_GRUPO $ GetMv("MV_GRPISEN")
			_cMsg += 'O campo ' + alltrim(Posicione('SX3',2,substr(_aCampos[_nI,1],6),'X3_TITULO')) + ' não foi informado, pasta '
			_cMsg += SX3->X3_FOLDER + ' - ' + Posicione('SXA',1,'SB1' + SX3->X3_FOLDER,'XA_DESCRIC') + _cEnter
		EndIf		
	Next     
	SX3->(DbSetOrder(1))
	
	If !empty(_cMsg)                               
		_cMsg := 'Verifique o preenchimento dos campos abaixo' + _cEnter + _cEnter + _cMsg
		MsgBox(_cMsg,'Produto não liberado','STOP')
	EndIf
	U_CADP003(SB1->B1_COD,SB1->B1_DESC,"ALTERACAO")
Else
	RecLock("SB1",.F.)
	Replace SB1->B1_MSBLQL	With "2"
	Replace SB1->B1_UREV	With dDataBase
	SB1->( MsUnLock() )
EndIf	      
                   
RestArea(aArea)
	
Return Nil