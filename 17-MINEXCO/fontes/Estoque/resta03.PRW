#include "rwmake.ch"
#include "protheus.ch"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³ Resta03  ³ Autor ³ Ricardo Yamashiro     ³ Data ³ 02.09.14 ³
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

User Function resta03()

Inclui:= .f.

Private cCadastro := "Gera Pre Nota"
Private aRotina   := {	{"Pesquisar","AxPesqui",0,1} ,; 
			{"Visualizar","U_Resta03A(1)",0,2} ,;        // STR0004 "Visualizar"
			{"Incluir","U_Resta03A(3)",0,3} ,;           // STR0005 "Incluir"
			{"Alterar","U_Resta03A(4)",0,4} ,;           // STR0006 "Alterar"
			{"Excluir","U_Resta03A(5)",0,5} ,;           // STR0007 "Excluir"           
			{"Legenda","U_Resta03D()",0,2} ,;           // STR0011 "Legenda"						
			{"Gera Pre Nota","processa({||U_Resta03C()})",0,2} }           // STR0011 "Legenda"			
//			{"Efetivar","U_Resta03C()",0,2} }           // STR0011 "Legenda"			
                      
aCores:= { {"!empty(SZ6->Z6_GERAPRE)",'DISABLE'} ,;
           {"empty(SZ6->Z6_GERAPRE)",'ENABLE'} }

//mBrowse( 6, 1,22,75,"SZF",,,,,,aCores,,,,,,,,cExprFilTop)
mBrowse( 6, 1,22,75,"SZ6",,,,,,aCores)

User Function Resta03A(nOpcx)
Local nRec:= recno()    
Local aButtons:= {}

if nOpcx == 5                     
   if !empty(SZ6->Z6_GERAPRE)
      msgbox("Container gerado não pode ser excluído !")
      return
   endif   
   if !msgnoyes("Confirma exclusão do Container " + SZ6->Z6_CONTAIN + " ?")  // STR0022 "Confirma exclusao da SE ?"
      return
   endif
endif

if nOpcx == 4 .and. !empty(SZ6->Z6_GERAPRE)
   msgbox("Container gerado não pode ser alterado !")
   return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("SZ6",(nOpcx == 3))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader:= {}

dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("Z7_CODPROD")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    		    

dbSeek("Z7_QTDDIG")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    		    

dbSeek("Z7_MEDIDA1")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,x3_vlduser,;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z7_MEDIDA2")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,x3_vlduser,;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z7_QTDPEC")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".t.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z7_QTDMET")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("Z7_QTDTOT")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    

dbSeek("Z7_QTDSAL")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    		    

dbSeek("Z7_VUNIT")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    

dbSeek("Z7_TES")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    

dbSeek("Z7_ITEM")
AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		    x3_tamanho, x3_decimal,".T.",;
		    x3_usado, x3_tipo, x3_arquivo, x3_context } )		    		    


nUsado 		:= 11
_cusuario   := ''
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpcx == 3
   acols:= {}
   aadd( acols, { "               ", 0, 0, 0, 0, 0, 0, 0, 0, "   ","    ", .f. } )
else
   acols:= {}
   dbSelectArea("SZ7")
   dbSetOrder(1)
   dbSeek(xFilial() + SZ6->Z6_CONTAIN)
   while !eof() .and. Z7_FILIAL + Z7_CONTAIN == xFilial() + SZ6->Z6_CONTAIN
      aadd(acols, { SZ7->Z7_CODPROD, SZ7->Z7_QTDDIG, SZ7->Z7_MEDIDA1 , SZ7->Z7_MEDIDA2 , SZ7->Z7_QTDPEC , SZ7->Z7_QTDMET, SZ7->Z7_QTDTOT, SZ7->Z7_QTDSAL, SZ7->Z7_VUNIT, SZ7->Z7_TES, SZ7->Z7_ITEM , .f. })
      dbskip()
   enddo
endif

If Len(aCols) > 0
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Executa a Modelo 3					    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  
   aCpoEnch:= NIL //{}

   cTitulo:= "Manutenção de Container" 
   cAliasEnchoice:= "SZ6"
   cAliasGetD:= "SZ7"
   cLinOk:= "U_Resta03B()"
   cTudOk:= "U_Resta03E()"
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
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,If(Obrigatorio(aGETS,aTELA) .And. U_Resta03E(),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()},,aButtons)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Executar processamento					    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nOpcA == 1

      if nOpcx == 3

	 	 reclock("SZ6",.T.)
	 	 SZ6->Z6_FILIAL := xFilial("SZ6")
	 	 SZ6->Z6_CONTAIN:= M->Z6_CONTAIN
	 	 //SZ6->Z6_CODPROD:= M->Z6_CODPROD
	 	 SZ6->Z6_CODFOR := M->Z6_CODFOR
 		 SZ6->Z6_TOTAL  := M->Z6_TOTAL
	 	 SZ6->Z6_USUARIO:= M->Z6_USUARIO

   	  else
	 	 reclock("SZ6",.f.)
   	  endif

      if nOpcx == 5

	     dbdelete()

      else
      
 		 SZ6->Z6_CONTAIN:= M->Z6_CONTAIN
 	 	 //SZ6->Z6_CODPROD:= M->Z6_CODPROD
 	     SZ6->Z6_CODFOR := M->Z6_CODFOR
		 SZ6->Z6_TOTAL  := M->Z6_TOTAL
	 	 SZ6->Z6_USUARIO:= M->Z6_USUARIO

      endif

      msunlock()

      dbselectarea("SZ7")
      dbsetorder(1)

      for _i:= 1 to len(acols)

	  		if empty(acols[_i][nUsado])

	     		if acols[_i][nUsado+1] == .f.

					reclock("SZ7",.T.)
					SZ7->Z7_FILIAL := xFilial("SZ7")
					SZ7->Z7_CONTAIN:= M->Z6_CONTAIN
					SZ7->Z7_CODPROD := acols[_i][1] 
					SZ7->Z7_QTDDIG  := acols[_i][2]
					SZ7->Z7_MEDIDA1 := acols[_i][3]
					SZ7->Z7_MEDIDA2 := acols[_i][4]
					SZ7->Z7_QTDPEC := acols[_i][5]
					SZ7->Z7_QTDMET := round((acols[_i][3]/100)*(acols[_i][4]/100),4)  // acols[_i][4]
					SZ7->Z7_QTDTOT := round(acols[_i][5]*acols[_i][6],4)  //acols[_i][5]					
					SZ7->Z7_QTDSAL := round(acols[_i][2]-acols[_i][7],4)
					SZ7->Z7_VUNIT  := ROUND(acols[_i][9],2)
					SZ7->Z7_TES    := acols[_i][10]
					SZ7->Z7_ITEM   := strzero(_i,3)
					msunlock()

	     		endif

	  		else

	     		if dbseek(xFilial() + M->Z6_CONTAIN + acols[_i][nUsado])

					if acols[_i][nUsado+1] == .f. .and. nOpcx != 5

		   			   reclock("SZ7",.f.)
						SZ7->Z7_MEDIDA1 := acols[_i][3]
						SZ7->Z7_MEDIDA2 := acols[_i][4]
						SZ7->Z7_QTDPEC := acols[_i][5]
						SZ7->Z7_QTDMET := round((acols[_i][3]/100)*(acols[_i][4]/100),4)  // acols[_i][4]
						SZ7->Z7_QTDTOT := round(acols[_i][5]*acols[_i][6],4)  //acols[_i][5]					
						SZ7->Z7_QTDSAL := round(acols[_i][2]-acols[_i][7],4)
						SZ7->Z7_VUNIT  := ROUND(acols[_i][9],2)
						SZ7->Z7_TES    := acols[_i][10]
					   msunlock()
       
					else

		   			   reclock("SZ7",.f.)
		   			   dbdelete()
		   			   msunlock()

					endif

	     		endif

	  		endif

      next

   Endif

Endif

User Function Resta03B()

if empty(acols[n][3])
   msgalert("Medida1 não preenchida !")	 // STR0017 "Codigo produto nao preenchido"
   return(.f.)
elseif empty(acols[n][4])
   msgalert("Medida2 não preenchida !")	 // STR0017 "Codigo produto nao preenchido"
   return(.f.)   
elseif empty(acols[n][5])
   msgalert("Quantidade de peças não preenchida !")	 // STR0017 "Codigo produto nao preenchido"
   return(.f.) 
elseif !U_VerSaldo(aCols[n][1])
   msgalert("Não há saldo suficiente para o produto informado ! ")
   return(.F.) 	   
endif

return(.t.)   

User Function Resta03C()

Private lMsErroAuto:= .F.    
private aCabec:= {}
private aItens:= {}
private aLinha:= {}

cQuery := "SELECT SUM(Z7_QTDTOT) AS QTDTOT, SUM(Z7_QTDPEC) AS QTDPEC "
cQuery += "FROM " + RetSqlName('SZ7') + ' SZ7 ' 
cQuery += " WHERE "
cQuery += "Z7_FILIAL = '" + xFilial('SZ7') + "' AND "
cQuery += "D_E_L_E_T_ = ' ' AND "
cQuery += "Z7_CONTAIN = '" + SZ6->Z6_CONTAIN + "' "
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
cQuery1 += " D1_FILIAL = '" + xFilial('SZ7') + "' AND "
cQuery1 += " D_E_L_E_T_ = ' ' AND "
cQuery1 += " D1_COD ='" + SZ7->Z7_CODPROD + "' "

cQuery1 := ChangeQuery(cQuery1)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery1), 'TMP1', .F., .T.)
dbSelectArea("TMP1")    

_nVUNIT:= TMP1->VUNIT

dbSelectArea("TMP1")    
dbCloseArea("TMP1")

if _nQtdTot <> SZ6->Z6_TOTAL
   msgbox("Total do Container não confere com total dos itens = " + trans(_nQtdTot,"@E 9,999,999.9999"))
   return
   
endif                            

//dbSelectArea("SB1")
//dbsetorder(1)
//dbseek(xFilial() + SZ6->Z6_CODPROD)

//_cDoc   := nextnumero("SD3",2,"D3_DOC",.T.)
_cSerie := "NFE"         
_cTipo	:= SuperGetMV("MV_TPNRNFS")
_lRet   := SX5NumNota()
_cNumero:= NxtSX5Nota( _cSerie,.T.,_cTipo)

aCabec := 	{	{'F1_TIPO'	,'N' ,NIL},;		
	{'F1_FORMUL','S'		     ,NIL},;		
	{'F1_DOC'	,_cNumero  	     ,NIL},;		
	{'F1_SERIE' ,_cSerie		 ,NIL},;		
	{'F1_EMISSAO',dDataBase	     ,NIL},;		
	{'F1_FORNECE',SZ6->Z6_CODFOR ,NIL},;		
	{'F1_ESPECIE','SPED'         ,NIL},;		
	{'F1_LOJA'	,'01'		     ,NIL} }				
	
	     
procregua(_nQtdPec)          
_nSeq:= 1
dbSelectArea("SZ7")
dbsetorder(1)
dbseek(xFilial() + SZ6->Z6_CONTAIN)

while !eof() .and. Z7_FILIAL + Z7_CONTAIN == xFilial() + SZ6->Z6_CONTAIN
           
	for _i:= 1 to SZ7->Z7_QTDPEC
	
	    _cLotef:= alltrim(SZ6->Z6_CONTAIN) + strzero(_nSeq,3) + ' ' + alltrim(trans(SZ7->Z7_MEDIDA1/100,"@E 99.99"))+"X"+alltrim(trans(SZ7->Z7_MEDIDA2/100,"@E 99.99"))                     
	    
	    incproc("Gerando lote " + _cLotef)  
  	    
	aadd(aItens, { {'D1_COD'	,SZ7->Z7_CODPROD 			,NIL},;		
	               {'D1_PRODUTO',Posicione("SB1",1,xFilial("SB1")+SZ7->Z7_CODPROD,"B1_DESC") 		    ,NIL},;				
	               {'D1_LOTECTL',U_EESTA01()  		    ,NIL},;				
	               {'D1_UM'	    ,Posicione("SB1",1,xFilial("SB1")+SZ7->Z7_CODPROD,"B1_UM") 		    ,NIL},;				
                   {'D1_QUANT'  ,SZ7->Z7_QTDMET			,NIL},;		
		           {'D1_VUNIT'  ,SZ7->Z7_VUNIT		    ,NIL},;		
		           {'D1_TOTAL'  ,SZ7->Z7_QTDMET*SZ7->Z7_VUNIT ,NIL},;		
		           {'D1_TES'    ,SZ7->Z7_TES		    ,NIL},;		
		           {'D1_LOCAL'  ,'01'			        ,NIL},;
	               {'D1_LOTEFOR',_cLotef 			    ,NIL},;
		           {'D1_ITEM'   ,strzero(_nSeq,4)       ,NIL},;
		           {'D1_GRUPO'  ,Posicione("SB1",1,xFilial("SB1")+SZ7->Z7_CODPROD,"B1_GRUPO") 		    ,NIL }} ) 

		_nSeq++	
		
	next
	
	dbSelectArea("SZ7") 
	xp:=SZ6->Z6_CONTAIN 
	dbskip()    
	if  SZ7->Z7_CONTAIN  <> xp
		reclock("SZ6",.F.)
		SZ6->Z6_GERAPRE:= ddatabase    
		SZ6->Z6_DOC    := _cNumero 
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
	reclock("SZ6",.F.)
	SZ6->Z6_GERAPRE:= ddatabase    
	SZ6->Z6_DOC    := _cNumero 
	msunlock()
	msgbox("Pre Nota " + trim(_cNumero) + " gerada com sucesso !")
endif


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Funcao para validacao dos saldos                                                                                            //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function VerSaldo(c_Produt)

Local l_Retorn := .T.
Local n_Contro := 0
Local n_VlrSld := 0
Local n_VlrPro := 0

For n_Contro := 1 To Len(aCols)
	If aCols[n_Contro][1] == c_Produt
		n_VlrSld += Iif(aCols[n_Contro][7]<0,aCols[n_Contro][7]*-1,aCols[n_Contro][7])
		If n_VlrPro < aCols[n_Contro][2]
			n_VlrPro := aCols[n_Contro][2]
		EndIf 
	EndIf
Next n_Contro

If n_VlrSld > n_VlrPro
	l_Retorn := .F.
EndIf

Return(l_Retorn)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Funcao para ultimo saldo do produto                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function AtuSaldo()

Local l_Retorn := .T.
Local n_Linhas := n
Local n_Contro := 0
Local n_VlrSld := 0
Local n_VlrTra := 0
Local c_Produt := GDFieldGet("Z7_CODPROD",n,.T.)

For n_Contro := 1 To Len(aCols)
	If aCols[n_Contro][1] == c_Produt
		If aCols[n_Contro][8] != 0  
			n_VlrSld := aCols[n_Contro][8]
		EndIf	
	EndIf
	If n_VlrTra == 0 
		n_VlrTra := n_VlrSld
	Else
		If n_VlrSld < n_VlrTra
			n_VlrTra := n_VlrSld
		EndIf
	EndIf  
Next n_Contro

aCols[n][2] := n_VlrTra

Return(l_Retorn)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Funcao para validacao do total no container                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function Resta03E()

Local n_Contro := 0
Local n_TotCon := 0
Local l_Retorn := .T.

For n_Contro := 1 To Len(aCols)
	n_TotCon += aCols[n_Contro][7]
Next n_Contro

If M->Z6_TOTAL < n_TotCon
   MsgAlert("Não há capacidade suficiente neste container ! ")
   l_Retorn := .F.
EndIf

Return(l_Retorn)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function Resta03D()

BrwLegenda(cCadastro, "Legenda", { {"DISABLE" , "Movimentos Gerados" } ,;
								   {"ENABLE" , "Movimentos não gerados" } } )
								   
return

