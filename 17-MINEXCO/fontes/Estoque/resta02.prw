#include "rwmake.ch"
#include "protheus.ch"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³ RESTA02  ³ Autor ³ Ricardo Yamashiro     ³ Data ³ 02.09.14 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³ Manutenção de container
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso	   ³ SIGAEST							³
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Solicitante: Mariana		       ³ Chamado:				³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Revisoes:								³
ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

User Function resta02()

Inclui:= .f.

Private cCadastro := "Gera Pre Nota"
Private aRotina   := {	{"Pesquisar","AxPesqui",0,1} ,; 
			{"Visualizar","U_RESTA02A(1)",0,2} ,;        // STR0004 "Visualizar"
			{"Incluir","U_RESTA02A(3)",0,3} ,;           // STR0005 "Incluir"
			{"Alterar","U_RESTA02A(4)",0,4} ,;           // STR0006 "Alterar"
			{"Excluir","U_RESTA02A(5)",0,5} ,;           // STR0007 "Excluir"           
			{"Legenda","U_RESTA02D()",0,2} ,;           // STR0011 "Legenda"						
			{"Gera Pre Nota","processa({||U_RESTA02C()})",0,2} }           // STR0011 "Legenda"			
//			{"Efetivar","U_RESTA02C()",0,2} }           // STR0011 "Legenda"			
                      
aCores:= { {"!empty(SZ4->Z4_GERASD3)",'DISABLE'} ,;
           {"empty(SZ4->Z4_GERASD3)",'ENABLE'} }

//mBrowse( 6, 1,22,75,"SZF",,,,,,aCores,,,,,,,,cExprFilTop)
mBrowse( 6, 1,22,75,"SZ4",,,,,,aCores)

User Function RESTA02A(nOpcx)
Local nRec:= recno()    
Local aButtons:= {}

if nOpcx == 5                     
   if !empty(SZ4->Z4_GERASD3)
      msgbox("Container gerado não pode ser excluído !")
      return
   endif   
   if !msgnoyes("Confirma exclusão do Container " + SZ4->Z4_CONTAIN + " ?")  // STR0022 "Confirma exclusao da SE ?"
      return
   endif
endif

if nOpcx == 4 .and. !empty(SZ4->Z4_GERASD3)
   msgbox("Container gerado não pode ser alterado !")
   return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("SZ4",(nOpcx == 3))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader:= {}

dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("Z5_MEDIDA1")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,x3_vlduser,;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z5_MEDIDA2")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,x3_vlduser,;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z5_QTDPEC")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".t.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z5_QTDMET")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z5_QTDTOT")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    

dbSeek("Z5_VUNIT")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    

dbSeek("Z5_TES")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    

dbSeek("Z5_ITEM")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    		    

nUsado 		:= 8
_cusuario   := ''
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpcx == 3
   acols:= {}
   aadd( acols, { 0, 0, 0, 0, 0, 0,"   ","    ", .f. } )
else
   acols:= {}
   dbSelectArea("SZ5")
   dbSetOrder(1)
   dbSeek(xFilial() + SZ4->Z4_CONTAIN)
   while !eof() .and. Z5_FILIAL + Z5_CONTAIN == xFilial() + SZ4->Z4_CONTAIN
      aadd(acols, { SZ5->Z5_MEDIDA1 , SZ5->Z5_MEDIDA2 , SZ5->Z5_QTDPEC , SZ5->Z5_QTDMET, SZ5->Z5_QTDTOT, SZ5->Z5_VUNIT, SZ5->Z5_TES, SZ5->Z5_ITEM , .f. })
      dbskip()
   enddo
endif

If Len(aCols) > 0
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Executa a Modelo 3					    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  
   aCpoEnch:= NIL //{}

   cTitulo:= "Manutenção de Container" 
   cAliasEnchoice:= "SZ4"
   cAliasGetD:= "SZ5"
   cLinOk:= "U_RESTA02B()"
   cTudOk:= "AllwaysTrue()"
   cFieldOk:= "AllwaysTrue()"

   //EnChoice( cAliasEnchoice, nRec, nOpcx, , , , {"ZF_ATENDID","ZF_DTCONCL"}, aPosObj[1], {"ZF_ATENDID","ZF_DTCONCL"}, 3)

   // ----------------------------------------------
   aTELA := {}
   aGETS := {}
   nOpcA := 0
   aSize := {}
   aObjects := {}
   aInfo := {}
   aPosObj := {}

   aSize := MsAdvSize()
   aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

   aAdd(aObjects,{140,140,.T.,.T.})
   aAdd(aObjects,{40,40,.T.,.T.})

   aPosObj := MsObjSize(aInfo,aObjects)
   
   DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL
   EnChoice( cAliasEnchoice, nRec, nOpcx, , , , aCpoEnch, aPosObj[1], aCpoEnch, 3) 
   
   oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,cLinOk,cTudOk,,.T.)    
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,If(Obrigatorio(aGETS,aTELA),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()},,aButtons)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Executar processamento					    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nOpcA == 1

      if nOpcx == 3

	 	 reclock("SZ4",.T.)
	 	 SZ4->Z4_FILIAL := xFilial("SZ4")
	 	 SZ4->Z4_CONTAIN:= M->Z4_CONTAIN
	 	 SZ4->Z4_CODPROD:= M->Z4_CODPROD
	 	 SZ4->Z4_CODFOR := M->Z4_CODFOR
 		 SZ4->Z4_TOTAL  := M->Z4_TOTAL
	 	 SZ4->Z4_USUARIO:= M->Z4_USUARIO

   	  else
	 	 reclock("SZ4",.f.)
   	  endif

      if nOpcx == 5

	     dbdelete()

      else
      
 		 SZ4->Z4_CONTAIN:= M->Z4_CONTAIN
 	 	 SZ4->Z4_CODPROD:= M->Z4_CODPROD
 	     SZ4->Z4_CODFOR := M->Z4_CODFOR
		 SZ4->Z4_TOTAL  := M->Z4_TOTAL
	 	 SZ4->Z4_USUARIO:= M->Z4_USUARIO

      endif

      msunlock()

      dbselectarea("SZ5")
      dbsetorder(1)

      for _i:= 1 to len(acols)

	  		if empty(acols[_i][nUsado])

	     		if acols[_i][nUsado+1] == .f.

					reclock("SZ5",.T.)
					SZ5->Z5_FILIAL := xFilial("SZ5")
					SZ5->Z5_CONTAIN:= M->Z4_CONTAIN
					SZ5->Z5_MEDIDA1 := acols[_i][1]
					SZ5->Z5_MEDIDA2 := acols[_i][2]
					SZ5->Z5_QTDPEC := acols[_i][3]
					SZ5->Z5_QTDMET := round((acols[_i][1]/100)*(acols[_i][2]/100),4)  // acols[_i][4]
					SZ5->Z5_QTDTOT := round(acols[_i][4]*acols[_i][3],4)  //acols[_i][5]					
					SZ5->Z5_VUNIT  := ROUND(acols[_i][6],2)
					SZ5->Z5_TES    := acols[_i][7]
					SZ5->Z5_ITEM   := strzero(_i,3)
					msunlock()

	     		endif

	  		else

	     		if dbseek(xFilial() + M->Z4_CONTAIN + acols[_i][nUsado])

					if acols[_i][nUsado+1] == .f. .and. nOpcx != 5

		   			   reclock("SZ5",.f.)
					   SZ5->Z5_MEDIDA1 := acols[_i][1]
					   SZ5->Z5_MEDIDA2 := acols[_i][2]
					   SZ5->Z5_QTDPEC := acols[_i][3]
					   SZ5->Z5_QTDMET := round((acols[_i][1]/100)*(acols[_i][2]/100),4)  // acols[_i][4]
					   SZ5->Z5_QTDTOT := round(acols[_i][4]*acols[_i][3],4)  //acols[_i][5]
					   SZ5->Z5_VUNIT  := ROUND(acols[_i][6],2)
				       SZ5->Z5_TES    := acols[_i][7]					
					   msunlock()
       
					else

		   			   reclock("SZ5",.f.)
		   			   dbdelete()
		   			   msunlock()

					endif

	     		endif

	  		endif

      next

   Endif

Endif

User Function RESTA02B()

if empty(acols[n][1])
   msgalert("Medida1 não preenchida !")	 // STR0017 "Codigo produto nao preenchido"
   return(.f.)
elseif empty(acols[n][2])
   msgalert("Medida2 não preenchida !")	 // STR0017 "Codigo produto nao preenchido"
   return(.f.)   
elseif empty(acols[n][3])
   msgalert("Quantidade de peças não preenchida !")	 // STR0017 "Codigo produto nao preenchido"
   return(.f.)
endif

return(.t.)   

User Function RESTA02C()

Private lMsErroAuto:= .F.    
private aCabec:= {}
private aItens:= {}
private aLinha:= {}

cQuery := "SELECT SUM(Z5_QTDTOT) AS QTDTOT, SUM(Z5_QTDPEC) AS QTDPEC "
cQuery += "FROM " + RetSqlName('SZ5') + ' SZ5 ' 
cQuery += " WHERE "
cQuery += "Z5_FILIAL = '" + xFilial('SZ5') + "' AND "
cQuery += "D_E_L_E_T_ = ' ' AND "
cQuery += "Z5_CONTAIN = '" + SZ4->Z4_CONTAIN + "' "
cQuery := ChangeQuery(cQuery)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP', .F., .T.)
dbSelectArea("TMP")
dbgotop() 
_nQtdTot:= TMP->QTDTOT
_nQtdPec:= TMP->QTDPEC
dbclosearea()


cQuery1 := " SELECT MAX(D1_VUNIT)AS VUNIT "
cQuery1 += " FROM " + RetSqlName('SD1') 
cQuery1 += " WHERE "
cQuery1 += " D1_FILIAL = '" + xFilial('SZ4') + "' AND "
cQuery1 += " D_E_L_E_T_ = ' ' AND "
cQuery1 += " D1_COD ='" + SZ4->Z4_CODPROD + "' "

cQuery1 := ChangeQuery(cQuery1)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery1), 'TMP1', .F., .T.)
dbSelectArea("TMP1")    

_nVUNIT:= TMP1->VUNIT

dbSelectArea("TMP1")    
dbCloseArea("TMP1")

if _nQtdTot <> SZ4->Z4_TOTAL
   msgbox("Total do Container não confere com total dos itens = " + trans(_nQtdTot,"@E 9,999,999.9999"))
   return
   
endif                            

dbSelectArea("SB1")
dbsetorder(1)
dbseek(xFilial() + SZ4->Z4_CODPROD)

_cDoc   := nextnumero("SD3",2,"D3_DOC",.T.)
_cSerie := "NFE"         
_cTipo	:= SuperGetMV("MV_TPNRNFS")
_lRet   := SX5NumNota()
_cNumero:= NxtSX5Nota( _cSerie,.T.,_cTipo)

aCabec := 	{	{'F1_TIPO'	,'N' ,NIL},;		
	{'F1_FORMUL','S'		     ,NIL},;		
	{'F1_DOC'	,_cNumero  	     ,NIL},;		
	{'F1_SERIE' ,_cSerie		 ,NIL},;		
	{'F1_EMISSAO',dDataBase	     ,NIL},;		
	{'F1_FORNECE',SZ4->Z4_CODFOR ,NIL},;		
	{'F1_ESPECIE','SPED'         ,NIL},;		
	{'F1_LOJA'	,'01'		     ,NIL} }				
	
	     
procregua(_nQtdPec)          
_nSeq:= 1
dbSelectArea("SZ5")
dbsetorder(1)
dbseek(xFilial() + SUBSTR(SZ4->Z4_CONTAIN,1,4))

while !eof() .and. Z5_FILIAL + SUBSTR(Z5_CONTAIN,1,4) == xFilial() + SUBSTR(SZ4->Z4_CONTAIN,1,4)
           
	for _i:= 1 to SZ5->Z5_QTDPEC
	
	    _cLotef:= alltrim(SZ4->Z4_CONTAIN) + strzero(_nSeq,3) + ' ' + alltrim(trans(SZ5->Z5_MEDIDA1/100,"@E 99.99"))+"X"+alltrim(trans(SZ5->Z5_MEDIDA2/100,"@E 99.99"))                     
	    
	    incproc("Gerando lote " + _cLotef)  
  	    
	aadd(aItens, { {'D1_COD'	,Posicione("SZ4",1,xFilial("SZ4")+SZ5->Z5_CONTAIN,"Z4_CODPROD") 			,NIL},;		
	               {'D1_PRODUTO',Posicione("SB1",1,xFilial("SB1")+Posicione("SZ4",1,xFilial("SZ4")+SZ5->Z5_CONTAIN,"Z4_CODPROD"),"B1_DESC") 		    ,NIL},;				
	               {'D1_LOTECTL',U_EESTA01()  		    ,NIL},;				
	               {'D1_UM'	    ,Posicione("SB1",1,xFilial("SB1")+Posicione("SZ4",1,xFilial("SZ4")+SZ5->Z5_CONTAIN,"Z4_CODPROD"),"B1_UM") 			,NIL},;				
                   {'D1_QUANT'  ,SZ5->Z5_QTDMET			,NIL},;		
		           {'D1_VUNIT'  ,SZ5->Z5_VUNIT		    ,NIL},;		
		           {'D1_TOTAL'  ,SZ5->Z5_QTDMET*SZ5->Z5_VUNIT ,NIL},;		
		           {'D1_TES'    ,SZ5->Z5_TES		    ,NIL},;		
		           {'D1_LOCAL'  ,'01'			        ,NIL},;
	               {'D1_LOTEFOR',_cLotef 			    ,NIL},;
		           {'D1_ITEM'   ,strzero(_nSeq,4)       ,NIL},;
		           {'D1_GRUPO'  ,Posicione("SB1",1,xFilial("SB1")+Posicione("SZ4",1,xFilial("SZ4")+SZ5->Z5_CONTAIN,"Z4_CODPROD"),"B1_GRUPO")		    ,NIL} } ) 

		_nSeq++	
		
	next
	
	dbSelectArea("SZ5") 
	xp:=SZ4->Z4_CONTAIN 
	dbskip()    
	if  SZ5->Z5_CONTAIN  <> xp
		reclock("SZ4",.F.)
		SZ4->Z4_GERASD3:= ddatabase    
		SZ4->Z4_DOCSD3 := SZ5->Z5_CONTAIN 
		msunlock()
	endif
	
enddo  

Begin Transaction 

nOpc := 3
MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, nOpc)  				
If lMsErroAuto
	DisarmTransaction() 
	break
endif
End Transaction 

If lMsErroAuto
	MostraErro()
else	
	reclock("SZ4",.F.)
	SZ4->Z4_GERASD3:= ddatabase    
	SZ4->Z4_DOCSD3 := SZ5->Z5_CONTAIN 
	msunlock()
	msgbox("Pre Nota " + trim(_cNumero) + " gerada com sucesso !")
endif 

User Function RESTA02D()

BrwLegenda(cCadastro, "Legenda", { {"DISABLE" , "Movimentos Gerados" } ,;
								   {"ENABLE" , "Movimentos não gerados" } } )
								   
return

