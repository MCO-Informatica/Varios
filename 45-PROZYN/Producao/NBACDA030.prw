#INCLUDE "Acda030.ch"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ NBACDA030 ³ Autor ³ NewBridge/Zanni       ³ Data ³ 23/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de manutencao no arquivo mestre de inventario     ³±±
±±³          ³ Personalizado para adicionar botoes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NBACDA030()
Local aCores := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := { { STR0001						, "AxPesqui"  	, 0 , 1},;	 		//"Pesquisar"
							 { STR0002				, "AxVisual"  	, 0 , 2},;		 	//"Visualizar"
							 { STR0003				, "ACDA30Inc"  	, 0 , 3},;		 	//"Incluir"
							 { STR0004				, "ACDA30Alt"  	, 0 , 4, 15},;	 	//"Alterar"
							 { STR0005				, "ACDA30Del"	, 0 , 5, 16} ,;	 	//"Excluir"
							 { STR0006				, "AIVA30Aut"	, 0 , 3, 16},;	 	//"Automatico"
							 { STR0017				, "ACDA032"		, 0 , 2, 16},;	    //"Monitor"
							 { STR0018				, "ACDR030"		, 0 , 1},;	        //"Relatorio"
							 { 'Planilha Prozyn'	, "U_PLAN030"	, 0 , 3},;	        //"Relatorio"
							 { STR0007				, "AIVA30Lg" 	, 0 , 3 }}  		//"Legenda"
PRIVATE cDelFunc := "ACDA30Exc()"
PRIVATE lLocaliz := GetMv('MV_LOCALIZ')=='S'

//CBChkTemplate()
If ! IntAcd(.t.)
   Return .f.
EndIF
                               
If ! SuperGetMV("MV_CBPE012",.F.,.F.)
	CBAlert(STR0019) //"Necessario ativar o parametro MV_CBPE012"
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := STR0008 // //"Mestre de inventario"

aCores := {  	{ "CBA->CBA_STATUS == '0'", "BR_VERDE" },;
				 	{ "CBA->CBA_STATUS == '1'", "BR_AMARELO" },;
				 	{ "CBA->CBA_STATUS == '2'", "BR_CINZA"  },;
				 	{ "CBA->CBA_STATUS == '3'", "BR_LARANJA"  },;				 	
				 	{ "CBA->CBA_STATUS == '4'", "BR_AZUL"  },;				 	
				 	{ "CBA->CBA_STATUS == '5'", "BR_VERMELHO"  }}
mBrowse( 6, 1, 22, 75, "CBA", , , , , , aCores, , , ,{|x|TimerBrw(x)})
Return      
                                                                
/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function PLAN030  
Local cPerg    := 'NBACDA030'
Local aArea    := GetArea()
Local aAreaDic := SX1->( GetArea() )
Local aEstrut  := {}
Local aStruDic := SX1->( dbStruct() )
Local aDados   := {}
Local nI       := 0
Local nJ       := 0
Local nTam1    := Len( SX1->X1_GRUPO )
Local nTam2    := Len( SX1->X1_ORDEM )

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }

aAdd( aDados, {'NBACDA030','01','Do Operador             ?','Do Operador             ?','Do Operador             ?','MV_CH0','C',15,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','CB1','','','','',''} )
aAdd( aDados, {'NBACDA030','02','Até Operador           ?','Até Operador           ?','Até Operador           ?','MV_CH0','C',15,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','CB1','','','','',''} )
aAdd( aDados, {'NBACDA030','03','Do Produto              ?','Do Produto              ?','Do Produto              ?','MV_CH0','C',15,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aDados, {'NBACDA030','04','Ate o Produto           ?','Ate o Produto           ?','Ate o Produto           ?','MV_CH0','C',15,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aDados, {'NBACDA030','05','Tipo Tolerancia (Qtd/%) ?','Tipo Tolerancia (Qtd/%) ?','Tipo Tolerancia (Qtd/%) ?','MV_CH0','N',1,0,2,'C','','MV_PAR05','Quantidade','Qtd','Qtd','','Percentual','%','%','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'NBACDA030','06','Tolerancia              ?','Tolerancia              ?','Tolerancia              ?','MV_CH0','C',8,0,2,'C','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'NBACDA030','07','Somente divergentes     ?','Somente divergentes     ?','Somente divergentes     ?','MV_CH0','N',1,0,2,'C','','MV_PAR07','Sim','Si','Yes','','Nao','Nao','No','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'NBACDA030','08','Tipo de Inventario      ?','Tipo de Inventario      ?','Tipo de Inventario      ?','MV_CH0','N',1,0,2,'C','','MV_PAR08','Normal','Si','Yes','','Rotativo','Rotativo','No','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'NBACDA030','09','Gerar SB7               ?','Gerar SB7               ?','Gerar SB7               ?','MV_CH0','N',1,0,2,'C','','MV_PAR09','Sim','Si','Yes','','Nao','Nao','No','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aDados, {'NBACDA030','10','Prod invent Rotativo    ?','Prod invent Rotativo    ?','Prod invent Rotativo    ?','MV_CH1','C',50,0,0,'C','','MV_PAR10','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )


//
// Atualizando dicionário
//
dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nI][1], nTam1 ) + PadR( aDados[nI][2], nTam2 ) ) )
		RecLock( "SX1", .T. )
		For nJ := 1 To Len( aDados[nI] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aDados[nI][nJ] ) )
			EndIf
		Next nJ
		MsUnLock()
	EndIf
Next nI

RestArea( aAreaDic )
RestArea( aArea )

If !Pergunte(cPerg, .T.)
   Return .F.
EndIf         

MsgRun( 'Efetuando pesquisas de estoque / leituras efetuadas',;
		'Aguarde...',;
		{|| PLAN030x()}) 
		
Return .T.

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
Static Function PLAN030x          
// Query oficial do Relatorio
_cQryTot := "Select CBC_CODINV, CBB_NCONT, CBC_COD, CBC_LOCAL, CBC_QUANT, CBC_LOCALI, CBC_LOTECT, CBC_CODETI, B1_DESC, CBB_USU, CB1_NOME"

// Avalia quantidade de leituras
_cQryLei := "Select Distinct CBB_NCONT"//"CBC_NUM"

_cQuery1 := "	From "+RetSqlName('CBC')+" CBC, "+RetSqlName('CBA')+" CBA, "+RetSqlName('SB1')+" SB1, "+RetSqlName('CBB')+" CBB, "+RetSqlName('CB1')+" CB1"
_cQuery1 += "	Where CBA_CODINV = CBC_CODINV And"
_cQuery1 += "		  CBA_CODINV = CBB_CODINV And"
_cQuery1 += "		  CBB_NUM    = CBC_NUM And"
_cQuery1 += "	      CB1_CODOPE = CBB_USU And"
_cQuery1 += "	      CBC_COD    = B1_COD And"
_cQuery1 += "	      CBA_CODINV = '"+CBA->CBA_CODINV+"' And"
_cQuery1 += "	      CB1_CODOPE Between '"+mv_par01+"' And '"+mv_par02+"' And"
_cQuery1 += "         B1_COD     Between '"+mv_par03+"' And '"+mv_par04+"' And"
_cQuery1 += "		  CBC.D_E_L_E_T_ = '' And CBA.D_E_L_E_T_ = '' And SB1.D_E_L_E_T_ ='' And CBB.D_E_L_E_T_ ='' And CB1.D_E_L_E_T_ =''" 

_cOrder  := "	Order By CBB_NCONT, CBC_COD, CBC_LOTECT"

// Efetua query para apurar qtde de leituras
_cQuery := _cQryLei+_cQuery1+' Order By CBB_NCONT'
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TMPCB',.T.,.T.)
_aLeituras := {}
Do While !EoF()
   aAdd(_aLeituras, StrZero(TMPCB->CBB_NCONT,2))//TMPCB->CBC_NUM)

   DbSkip()
EndDo
TMPCB->(DbCloseArea())

// Efetua query oficial do relatorio
_cQuery := _cQryTot+_cQuery1+_cOrder
Memowrite('QueryCBC.TXT', _cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TMPCB',.T.,.T.)
_aExcel := {}
Do While !EoF()
   //If mv_par08 == 2   	// Sintetico
      _nPos   := aScan( _aExcel, {|_x| _x[1] == TMPCB->CBC_COD .And. _x[4] == TMPCB->CBC_LOTECT})
      If Empty(_nPos)         
         _nSaldo := CalcEstL(TMPCB->CBC_COD,TMPCB->CBC_LOCAL,dDataBase+1,TMPCB->CBC_LOTECT)[1]
         SB2->(DbSeek(xFilial('SB2')+TMPCB->CBC_COD+TMPCB->CBC_LOCAL))
         _nCM    := SB2->B2_CM1
         TMPCB->(aAdd(_aExcel, {CBC_COD, B1_DESC, CBC_LOCAL, CBC_LOTECT, _nSaldo}))

         For _nI := 1 To Len(_aLeituras)
             _nTam := Len(_aExcel)
             //aAdd(_aExcel[_nTam], If(_aLeituras[_nI] == TMPCB->CBC_NUM, TMPCB->CBC_QUANT, 0)) 	//Leitura atual
             aAdd(_aExcel[_nTam], If(_aLeituras[_nI] == StrZero(TMPCB->CBB_NCONT,2), TMPCB->CBC_QUANT, 0)) 	//Leitura atual
             aAdd(_aExcel[_nTam], _aExcel[_nTam, (_nI*2)+4] - _nSaldo)   						//Diferenca perante ao estoque
         Next  
         aAdd(_aExcel[_nTam], _nCM)
         aAdd(_aExcel[_nTam], If(!Empty(TMPCB->CBC_CODETI),TMPCB->CBC_CODETI+'/',''))      
      Else   
         //_nPLei := aScan(_aLeituras, TMPCB->CBC_NUM) * 2
         _nPLei := aScan(_aLeituras, StrZero(TMPCB->CBB_NCONT,2)) * 2
         _aExcel[_nPos, _nPLei+4] += TMPCB->CBC_QUANT
         _aExcel[_nPos, _nPlei+5] := _aExcel[_nPos, _nPlei+4] - _aExcel[_nPos, 5]

         _nTam := Len(_aExcel[_nPos])
         _aExcel[_nPos, _nTam] := _aExcel[_nPos, _nTam]+If(!Empty(TMPCB->CBC_CODETI),TMPCB->CBC_CODETI+'/','')
      EndIf
   //Else					// Analitico
   //EndIf   
   DbSkip()   
EndDo

//COmplementa Planilha com itens em estoque nao lidos
_cQuery := "Select B8_PRODUTO, B8_LOCAL, B8_DATA, B8_SALDO, B8_LOTECTL "
_cQuery += "	From "+RetSqlName('SB8')+" SB8"
_cQuery += "	Where B8_LOCAL = '"+CBA->CBA_LOCAL+"' And "    
_cQuery += "	      B8_SALDO > 0 And"  
If mv_par08 == 2   	// Rotativo 
_cQuery += "	      B8_PRODUTO IN "+FormatIn(MV_PAR10,";")+"AND"
endif
_cQuery += "	      D_E_L_E_T_ = '' "

 dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TMPB8',.T.,.T.)

Do While !EoF()      
   _nPos   := aScan( _aExcel, {|_x| _x[1] == TMPB8->B8_PRODUTO .And. _x[4] == TMPB8->B8_LOTECTL}) 
   If Empty(_nPos)                            
      SB1->(DbSeek(xFilial('SB1')+TMPB8->B8_PRODUTO))  
      SB2->(DbSeek(xFilial('SB2')+TMPB8->B8_PRODUTO+TMPB8->B8_LOCAL))
      TMPB8->(aAdd(_aExcel, {B8_PRODUTO, SB1->B1_DESC, B8_LOCAL, B8_LOTECTL, B8_SALDO}))
      
      _nTam := 0
      For _nI := 1 To Len(_aLeituras)
          _nTam := Len(_aExcel)
          aAdd(_aExcel[_nTam],  0) 											//Leitura atual
          aAdd(_aExcel[_nTam], 0 - _aExcel[_nTam,5])   						//Diferenca perante ao estoque
      Next  
      If _nTam > 0
         aAdd(_aExcel[_nTam], SB2->B2_CM1)      
         aAdd(_aExcel[_nTam], '*** SEM LEITURA - ITEM EM ESTOQUE ***')      
      EndIf   
   EndIf
   
   DbSkip()
EndDo

TMPB8->(DbCloseArea())

// Recalcula o Saldo em estoque
For _nI := 1 To Len(_aExcel)
    If Empty(_aExcel[_nI, 5])   
       SB1->(DbSeek(xFilial('SB1')+_aExcel[_nI, 1]))
       If SB1->B1_RASTRO = 'L'
          _nSaldo := CalcEstL(_aExcel[_nI, 1], _aExcel[_nI, 3], dDataBase+1, _aExcel[_nI, 4])[1]
       Else 
          _nSaldo := CalcEst(_aExcel[_nI, 1], _aExcel[_nI, 3], dDataBase+1)[1]
       EndIf   
       _aExcel[_nI, 5] := _nSaldo
    EndIf                        
Next
TMPCB->(DbCloseArea())             

_cTitulo   := 'Relação de Inventario - '+DtoC(dDataBase)+' (Mestre: '+CBA->CBA_CODINV+')'
//If mv_par08 == 2	// Sintetico
   _aCabec    := {'Produto','Descricao','Armazem','Lote','Estoque'}                
   For _nI := 1 To Len(_aLeituras)
      aAdd(_aCabec, AllTrim(Str(_nI))+'a. Leitura')       
      aAdd(_aCabec, 'Diferenca')
   Next                           
   aAdd(_aCabec, 'Custo Medio')
   aAdd(_aCabec, 'Etiquetas lidas')

_cArqXls   := U_List2Excel(_aExcel, _aCabec, _cTitulo) //, _aCores)

If mv_par09 == 1 .and. MsgYesNo('Confirma a geracao do arquivo de inventario (SB7)?','Geracao de Invantario ERP')
   Processa({|| fProcessa() },'Geração de inventário (SB7)')   
   MsgInfo('Favor verificar os inventarios gerados no SB7.','Inventario ERP')
EndIf
Return .T.                                                       

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
Static Function fProcessa
ProcRegua(Len(_aExcel))
For _nI := 1 To Len(_aExcel)
    IncProc('Lancando inventario para produto '+_aExcel[_nI,2])
    
    //         TMPCB->(aAdd(_aExcel, {CBC_COD, B1_DESC, CBC_LOCAL, CBC_LOTECT, _nSaldo}))
    SB1->(DbSeek(xFilial('SB1')+_aExcel[_nI,1]))
    SB8->(DbSetOrder(3), DbSeek(xFilial('SB8')+SB1->B1_COD+_aExcel[_nI,3]+_aExcel[_nI, 4]))
    RecLock('SB7',.T.)
    Replace B7_FILIAL  With xFilial('SB7')
    Replace B7_LOCAL   With _aExcel[_nI,3]
    Replace B7_TIPO    With SB1->B1_TIPO
    Replace B7_COD     With SB1->B1_COD
    Replace B7_DOC     With CBA->CBA_CODINV
    Replace B7_QUANT   With If(Len(_aExcel[_nI])<6,0, _aExcel[_nI,6])
    Replace B7_QTSEGUM With 0
    Replace B7_DATA    With CBA->CBA_DATA
    Replace B7_LOTECTL With _aExcel[_nI,4]
    Replace B7_NUMLOTE With ''
    Replace B7_LOCALIZ With ''
    Replace B7_NUMSERI With ''
    Replace B7_STATUS  With '1'
    Replace B7_ESCOLHA With 'S'
    Replace B7_CONTAGE With '1'
    Replace B7_DTVALID With SB8->B8_DTVALID
    MsUnlock()    
Next


/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function List2Excel(_aLista, _aCab, _cTitulo, _aCores)    
_cNome   := CriaTrab(,.F.)
_cArqXls := AllTrim(GetTempPath())+_cNome+".XLS"
_nHdl := fCreate(_cArqXls)
If _nHdl == -1
	MsgAlert("O arquivo de nome "+_cArqXls+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

// Cria o cabeçalho do arquivo excel
_cHtml := "<html><body>"
_cHtml += "<meta http-equiv='Content-Type' content='application/vnd.ms-excel;charset=iso-8859-1'>"
_cHtml += "<style type='text/css'>"
_cHtml += "	td.tabela {"
_cHtml += "		font-size: 10px; "
_cHtml += "    	font-family: verdana,tahoma,arial,sans-serif; "
_cHtml += "    	border-width: 1px; "
_cHtml += "    	padding: 0px; "
_cHtml += "    	border-style: dotted; "
_cHtml += "    	border-color: gray; "
_cHtml += "    	-moz-border-radius: ; "
_cHtml += "	}"
_cHtml += "</style>"
_cHtml += "<font face=verdana,tahoma,arial,sans-serif size=3 color='#000066'><b>"+_cTitulo+"</b></font>"
_cHtml += "<table>"
_cHtml += "<tr>"

For _nCab := 1 To Len(_aCab) 
	_cHtml += "<td class=tabela bgcolor=#C0C0C0><b>"+_aCab[_nCab]+"</b></td>"
Next
_cHtml += "</tr>"
fWrite(_nHdl,_cHtml,Len(_cHtml))

//Cores possíveis
_aCor := {{'VERM','#FF0000'},;
          {'VERD','#00FF00'},;
          {'AMAR','#FFFF00'},;
          {'AZUL','#0000FF'},;
          {'PRET','#999999'},;
          {'LARA','#FFA500'},;
          {'CINZ','#C0C0C0'},;
          {'ZEBR','#E6E6FA'}}
For _nI := 1 To Len(_aLista)
    _cHtml := "<tr>"
    FOR _nX:=1 To Len(_aLista[_nI])
    	_cHtml += "<td class=tabela "                     
    	_lCor := .F.
    	If Type('_aCores') == 'A' .and. !Empty(_aCores)
    	   For _nC := 1 To Len(_aCores)
    	       If _nX == _aCores[_nC, 1]
    	          If ValType(_aLista[_nI, _nX]) == ValType(_aCores[_nC, 2]) .and. _aLista[_nI, _nX] == _aCores[_nC, 2]
    	             _nPos := aScan(_aCor, {|_x| _x[1] == _aCores[_nC,3]})
    	             If !Empty(_nPos)   
    	                _cHtml += "bgcolor="+_aCor[_nPos,2]
    	                _lCor  := .T.
    	             EndIf
    	          EndIf
    	       EndIf
    	   Next
    	EndIf

    	If Mod(_nI,2) == 0
    	   If !_lCor
              _cHtml += "bgcolor=##E6E6FA"
           EndIf	   
    	EndIf   
    	_cHtml += '>'   
    	
    	// Converte Tipos diferente de caracter
    	_xVar := _aLista[_nI,_nX]         
    	If Type('_xVar') == 'D'
    	   _xVar := DtoC(_xVar)
    	ElseIf Type('_xVar') == 'N'
    	   _xVar := Transform(_xVar, '@E 999,999,999.9999')   
    	ElseIf Type('_xVar') == 'L'   
    	   _xVar := If(_xVar, 'Sim','Nao')
    	ElseIf Type('_xVar') == 'O'
    	   _xVar := ''   
    	EndIf   
    	
        _cHtml += _xVar+" </td>"
    Next _nX
    _cHtml += "</tr>"
   	fWrite(_nHdl,_cHtml,Len(_cHtml))
Next _nI    
_cHtml := "<TR></TR>"
fWrite(_nHdl,_cHtml,Len(_cHtml))

fClose(_nHdl)
ShellExecute("open",_cArqXls,"","",5)
Return _cArqXls

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TimerBrw  ³ Autor ³ Eduardo Motta         ³ Data ³ 06/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que cria timer no mbrowse                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cMBrowse -> form em que sera criado o timer                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function TimerBrw(oMBrowse)
Local oTimer
DEFINE TIMER oTimer INTERVAL 1000 ACTION TmBrowse(GetObjBrow(),oTimer) OF oMBrowse
oTimer:Activate()
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TmBrowse ³ Autor ³ Eduardo Motta         ³ Data ³ 06/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de timer do mbrowse                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cMBrowse -> objeto mbrowse a dar refresh                   ³±±
±±³          ³ oTimer   -> objeto timer                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function TmBrowse(oObjBrow,oTimer)
oTimer:Deactivate()
oObjBrow:Refresh()
oTimer:Activate()
Return .T.


User Function MestreOper(_cOperCBA)
Public _cOper := CBRetOpe()
_lRet  := .T.
If !Empty(_cOperCBA)
   If _cOperCBA == _cOper
      _lRet := .T.
   Else
      _lret := .F.   
   EndIf
EndIf  

Return _lRet
