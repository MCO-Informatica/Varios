#INCLUDE "Protheus.CH"
#INCLUDE "RwMake.CH"
#INCLUDE "TopConn.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} M130FIL
Rotina para realização do fitlro ao gerar cotações. Por tipo de produto 
Produtivo, Improdutivo, Servicos ou Ambos.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		14/08/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function M130FIL()

	Local _cQuery		:= ""
	Local _cAliasFil	:= GetNextAlias()
	Local _cFiltro		:= ""
	Local _cPerg		:= "MTA130"

	If SB1->(FieldPos("B1_XTPMAT")) != 0
		AjustaSX1(_cPerg)
	    
		If MV_PAR18 <> 4
			_cQuery	:= " SELECT DISTINCT C1_PRODUTO "
			_cQuery += " FROM " + RetSqlName("SC1") + " SC1 "
			
			_cQuery	+= " JOIN " + RetSqlName("SB1") + " SB1 "
			_cQuery	+= " ON B1_FILIAL='"+xFilial("SB1")+"'"
			_cQuery	+= " AND B1_COD = C1_PRODUTO "
			_cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "
			
			Do Case
				Case MV_PAR18 == 1
					_cQuery	+= " AND B1_XTPMAT = 'P' "
				Case MV_PAR18 == 2
					_cQuery	+= " AND B1_XTPMAT = 'I' "
				//Case MV_PARXX == 3
				Case MV_PAR18 == 3
					_cQuery	+= " AND B1_GRUPO = 'SERV' "
			End Case
			
			_cQuery	+= " WHERE C1_FILIAL='"+xFilial("SC1")+"'"
			If ( MV_PAR01==1 ) // Filtra por Data
				_cQuery += " AND C1_EMISSAO >= '"+Dtos(MV_PAR02)+"'"
				_cQuery += " AND C1_EMISSAO <= '"+Dtos(MV_PAR03)+"'"
			EndIf
			If ( MV_PAR05==1 )
				_cQuery += " AND C1_COTACAO= '"+Space(Len(SC1->C1_COTACAO))+"' AND C1_QUJE<C1_QUANT AND C1_TPOP<>'P'"
			EndIf
			_cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "
			TcQuery _cQuery New Alias &(_cAliasFil)
			
			If (_cAliasFil)->(!EOF())
				While (_cAliasFil)->(!EOF())
					_cFiltro += AllTrim((_cAliasFil)->C1_PRODUTO) + "|"
					(_cAliasFil)->(dbSkip())
				EndDo
				_cFiltro	:= "ALLTRIM(C1_PRODUTO)$('" + _cFiltro + "')"
			Else
				_cFiltro	:= "C1_PRODUTO=' '"
			EndIf
		EndIf
	EndIf

//	_cFiltro := "C1_PRODUTO = 'PANP1100006    '"
Return(_cFiltro)

//-------------------------------------------------------------------
/*/{Protheus.doc} AjustaSX1
Função para ajustar o pergunte, incluindo o filtro do tipo de produto.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		14/08/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function AjustaSX1(_cPerg)

	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	aHelpPor := {'Define o tipo de produtos para realizar o filtro  ','Produtivo, Improdutivo, Serviço ou Ambos.  '}
	aHelpEng := {'Define o tipo de produtos para realizar o filtro  ','Produtivo, Improdutivo, Serviço ou Ambos.  '}
	aHelpSpa := {'Define o tipo de produtos para realizar o filtro  ','Produtivo, Improdutivo, Serviço ou Ambos.  '}
	xPutSx1(_cPerg,"18","Tipo Produtos ?","¿Imprime em Excel ?","Print in Excel ?","mv_chI","N",1,0,1,"C","","","","","mv_par18","Produtivos","Productivo","Productive","" ,"Improdutivos","Improductivo","Unproductive","Servicos","Servicio","Service","Ambos","Ambos","Both","","","",aHelpPor,aHelpEng,aHelpSpa) 

Return()

/*
+------------+----------+--------+------------------+-------+-------------+
| Programa:  | XPUTSX1  | Autor: | Willian Carvalho | Data: |  Abril/2018 |
+------------+----------+--------+------------------+-------+-------------+
| Descrição: | Função criada para substituição da PutSx1 descontinuada    |
|            | nas versões 12 do Microsiga Protheus, conforme TDN Link    |
|            | tdn.totvs.com/pages/releaseview.action?pageId=244740739    |
+------------+------------------------------------------------------------+
| Uso:       | H.C.I HIDRAULICA CONEXOES INDUSTRIAIS LTDA                 |
+------------+--------------------+---------------------------------------+
*/

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,; 
     cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3,cGrpSxg,cPyme,; 
     cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,; 
     cDef02,cDefSpa2,cDefEng2,; 
     cDef03,cDefSpa3,cDefEng3,; 
     cDef04,cDefSpa4,cDefEng4,; 
     cDef05,cDefSpa5,cDefEng5,; 
     aHelpPor,aHelpEng,aHelpSpa,cHelp) 

Local aArea := GetArea() 
Local cKey  := "" 
Local lPort := .F. 
Local lSpa  := .F. 
Local lIngl := .F. 

cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "." 

cPyme    := Iif( cPyme      == Nil, " ", cPyme      ) 
cF3      := Iif( cF3        == NIl, " ", cF3        ) 
cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	) 
cCnt01   := Iif( cCnt01     == Nil, "" , cCnt01     ) 
cHelp    := Iif( cHelp      == Nil, "" , cHelp      ) 

dbSelectArea( "SX1" ) 
dbSetOrder( 1 ) 

cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " ) 

If !( DbSeek( cGrupo + cOrdem )) 

	 cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt) 
	 cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa) 
	 cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng) 
	
	 Reclock( "SX1" , .T. ) 
	
	 Replace X1_GRUPO   With cGrupo 
	 Replace X1_ORDEM   With cOrdem 
	 Replace X1_PERGUNT With cPergunt 
	 Replace X1_PERSPA  With cPerSpa 
	 Replace X1_PERENG  With cPerEng 
	 Replace X1_VARIAVL With cVar 
	 Replace X1_TIPO    With cTipo 
	 Replace X1_TAMANHO With nTamanho 
	 Replace X1_DECIMAL With nDecimal 
	 Replace X1_PRESEL  With nPresel 
	 Replace X1_GSC     With cGSC 
	 Replace X1_VALID   With cValid 
	 Replace X1_VAR01   With cVar01 
	 Replace X1_F3      With cF3 
	 Replace X1_GRPSXG  With cGrpSxg 

     If Fieldpos("X1_PYME") > 0 
          If cPyme != Nil 
               Replace X1_PYME With cPyme 
          Endif 
     Endif 

     Replace X1_CNT01   With cCnt01 
     
     If cGSC == "C"            
          Replace X1_DEF01   With cDef01 
          Replace X1_DEFSPA1 With cDefSpa1 
          Replace X1_DEFENG1 With cDefEng1 

          Replace X1_DEF02   With cDef02 
          Replace X1_DEFSPA2 With cDefSpa2 
          Replace X1_DEFENG2 With cDefEng2 

          Replace X1_DEF03   With cDef03 
          Replace X1_DEFSPA3 With cDefSpa3 
          Replace X1_DEFENG3 With cDefEng3 

          Replace X1_DEF04   With cDef04 
          Replace X1_DEFSPA4 With cDefSpa4 
          Replace X1_DEFENG4 With cDefEng4 

          Replace X1_DEF05   With cDef05 
          Replace X1_DEFSPA5 With cDefSpa5 
          Replace X1_DEFENG5 With cDefEng5 
     Endif 

     Replace X1_HELP With cHelp 

     PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 

     MsUnlock() 
Else 

   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT) 
   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA) 
   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG) 

   If lPort .Or. lSpa .Or. lIngl 
          RecLock("SX1",.F.) 
          If lPort 
          	SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?" 
          EndIf 
          If lSpa 
          	SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?" 
          EndIf 
          If lIngl 
          	SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?" 
          EndIf 
          SX1->(MsUnLock()) 
     EndIf 
Endif 

RestArea( aArea ) 

Return