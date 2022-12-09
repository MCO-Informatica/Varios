#INCLUDE "rwmake.ch"

//---------------------------------------------------------------------------------
// Rotina | (Nome da Rotina)  | Autor | Rickson Oliveira     | Data | (Data)
//---------------------------------------------------------------------------------
// Descr. | (Descrição sobre a Rotina)
//        | 
//---------------------------------------------------------------------------------
// Uso    | Protheus 12.1.27
//---------------------------------------------------------------------------------
// Links  | 
//---------------------------------------------------------------------------------

#INCLUDE 'TOTVS.CH'

USER FUNCTION MTA416PV()

Local _aArea	:=	GetArea()
Local nAcols 	:= 	Len(aCols)
Local _nEstoque := 0

dbSelectArea("SC5")

Reclock("SC5",.F.)


M->C5_ZNOMCLI       := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")
M->C5_TABELA        := SCJ->CJ_TABELA
M->C5_PARC1         := SCJ->CJ_PARC1
M->C5_PARC2         := SCJ->CJ_PARC2
M->C5_PARC3         := SCJ->CJ_PARC3
M->C5_PARC4         := SCJ->CJ_PARC4
M->C5_PARC5         := SCJ->CJ_PARC5
M->C5_PARC6         := SCJ->CJ_PARC6
M->C5_PARC7         := SCJ->CJ_PARC7
M->C5_PARC8         := SCJ->CJ_PARC8
M->C5_PARC9         := SCJ->CJ_PARC9
M->C5_PARCA         := SCJ->CJ_PARCA

M->C5_DATA1         := SCJ->CJ_DATA1
M->C5_DATA2         := SCJ->CJ_DATA2
M->C5_DATA3         := SCJ->CJ_DATA3
M->C5_DATA4         := SCJ->CJ_DATA4
M->C5_DATA5         := SCJ->CJ_DATA5
M->C5_DATA6         := SCJ->CJ_DATA6
M->C5_DATA7         := SCJ->CJ_DATA7
M->C5_DATA8         := SCJ->CJ_DATA8
M->C5_DATA9         := SCJ->CJ_DATA9
M->C5_DATAA         := SCJ->CJ_DATAA

M->C5_TPFRETE       := SCJ->CJ_TPFRETE
M->C5_CONDPAG       := SCJ->CJ_CONDPAG
M->C5_ZDESC         := SCJ->CJ_XDESCPG
M->C5_TRANSP        := SCJ->CJ_XTRANSP 
M->C5_VEND1         := SCJ->CJ_VEND1  
M->C5_NATUREZ       := SCJ->CJ_XNATURE 
M->C5_ESPECI1       := SCJ->CJ_XESPEC1 
M->C5_VOLUME1       := VAL(SCJ->CJ_VOLUME1)
M->C5_PESOL         := SCJ->CJ_XPESOL  
M->C5_PBRUTO        := SCJ->CJ_XPBRUTO 
M->C5_MENNOTA       := SCJ->CJ_XMENNOT 


    dbSelectArea("SB2")
	SB2->(dbSetOrder(1))
    SB2->(DbGoTop())


	If SB2->(dbSeek(xFilial("SB2")+_aCOLS[Len(_aCOLS),aScan(_aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_PRODUTO"})]+_aCOLS[Len(_aCOLS),aScan(_aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_LOCAL"})],.f.))
		_nEstoque	:=	SaldoSB2() - SB2->B2_QPEDVEN
	EndIf			
		

_aCOLS[Len(_aCOLS),aScan(_aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_XQTDDES"})]:= _nEstoque

RestArea(_aArea)

Return(_aCols)
