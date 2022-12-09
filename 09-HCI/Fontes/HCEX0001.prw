#INCLUDE 'PROTHEUS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHCEX0001  บAutor  ณRobson Bueno da S   บ Data ณ 27/03/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta rotina tem a finalidade de gerar follow up entrega    บฑฑ
ฑฑบ          ณ gerando uma planilha excell                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCEX0001()
                             
Private cPerg    := 'HEX001' 

    //GravaSX1( cPerg )
	if Pergunte( cPerg, .T. )        
		If !ValidaParams()
		    ApMsgStop("****************Verifique os parametros informados************")
		 	Return
		EndIF
		
		If !HCFilReg()
		    MsgStop("Nใo hแ dados a serem gerados!!!")
		EndIf
    Endif
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSMPR0Que  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HCFilReg()

Local lRet	      := .T.
Local cQuery      := ''
Local cvirgula    := ", "

Local cOc		:=""
Local cOcItem	:=""
LocaL cOcForn	:=""
Local dOcData   :=""
Local dOcPrazo  :=""
Local nOcQtd	:=0
Local cOs		:=""
Local cOsItem	:=""
LocaL cOsForn	:=""
Local dOsData   :=""
Local dOsPrazo  :=""
Local nOsQtd	:=0   
Local cEstAv    :=0
Local cEstCom   :=0
Local cNomecli  :=Space(40)
                      
Private cFilial01 := ""
Private cFilial02 := ""
Private cFilial03 := ""
Private nCt       := 0            
Private cPathLoc  := ""
Private aItens		:= {}              
Processa(, "Aguarde.Selecionando Registros...")	

cQuery := "SELECT SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_PRODUTO,SC6.C6_DESCRI,SC6.C6_QTDVEN,SC6.C6_QTDVEN-SC6.C6_QTDENT AS C6_SALDO," + CRLF
cQuery += "SC6.C6_QTDLIB AS C6_QTDEST, SC6.C6_QTDLOC2 AS C6_QTDCOM, SC6.C6_QTDLOC3 AS C6_QTDOS, SC6.C6_SUGENTR AS C6_EMISSAO,SC6->C6_PROGRAM,SC6.C6_ENTREG,SC6.C6_NUMREF,SC6.C6_STATUS," + CRLF
cQuery += "SC6.C6_PV,SC6.C6_ITEMCLI,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_DATFAT,SC6.C6_XOBS " + CRLF
cQuery += "From " + RetSQLName( 'SC6' ) + " SC6 " + CRLF
cQuery += "WHERE SC6.C6_FILIAL = '" + xFilial("SC6")	+ "' " + CRLF //verificar o nome do campo
cQuery += "AND SC6.C6_PRODUTO >= '" + MV_PAR01 			+ "' " + CRLF
cQuery += "AND SC6.C6_PRODUTO <= '" + MV_PAR02 			+ "' " + CRLF
cQuery += "AND SC6.C6_CLI >= '" 	+ MV_PAR03 			+ "' " + CRLF                 
cQuery += "AND SC6.C6_CLI <= '" 	+ MV_PAR04 			+ "' " + CRLF
cQuery += "AND SC6.C6_LOJA>= '" 	+ MV_PAR05 			+ "' " + CRLF
cQuery += "AND SC6.C6_LOJA<= '"    	+ MV_PAR06 			+ "' " + CRLF
cQuery += "AND SC6.C6_NUM >= '" 	+ MV_PAR07 			+ "' " + CRLF                 
cQuery += "AND SC6.C6_NUM <= '" 	+ MV_PAR08 			+ "' " + CRLF
cQuery += "AND SC6.C6_ENTREG>= '" 	+ DTOS(MV_PAR09) 	+ "' " + CRLF
cQuery += "AND SC6.C6_ENTREG<= '"   + DTOS(MV_PAR10) 	+ "' " + CRLF 
if MV_PAR11=1 
  cQuery += "AND SC6.C6_QTDVEN<>SC6.C6_QTDENT" + CRLF 
ENDIF
if MV_PAR11=2 
  cQuery += "AND SC6.C6_QTDVEN=SC6.C6_QTDENT" + CRLF 
ENDIF
IF MV_PAR13=1
  cQuery += "AND SC6.C6_PROGRAM='VALVULAS'" + CRLF 
ENDIF
IF MV_PAR13=2
  cQuery += "AND SC6.C6_PROGRAM='TUBOS'" + CRLF 
ENDIF
IF MV_PAR13=3
  cQuery += "AND SC6.C6_PROGRAM='          '" + CRLF
ENDIF
cQuery += "AND SC6.D_E_L_E_T_ = ' ' ORDER BY SC6.C6_NUM,SC6.C6_ITEM ASC "                                                      
dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery ), 'TRB' , .T. , .F. )
TRB->( dbEval( { || nCt++ },, { || !EOF() } ) )//substitui o numero
TRB->( dbGoTop() )
// CRIA CABECALHO DA PLANILHA EXCELL                                                                                                                       
//aAdd( aItens,{[1]PEDIDO,[2]ITEM,[3]CODIGO,[4]DESCRICAO,[5]QTD,[6]SALDO,[7]PRAZO,[8]REFCLI,[9]PEDCLI,[10]ITEMCLI,[11]OS,[12]ITEM,[13]EMISSAO,[14]FORNECEDOR,[15]QTD,[16]PRAZO,[17]OC,[18]ITEM,[19]EMISSAO,[20]FORNECEDOR,[21]QTD,[22]PRAZO})
If TRB->(EOF())
   lRet := .F.
EndIf
aAdd(aItens,{"PEDIDO","ITEM","CLIENTE","LOJA","NOMERED","CODIGO","DESCRICAO","QTD","SALDO","SDO ESTOQUE","SDO COMPRA","QTD ESTOQUE","QTD COMPRA","QTD OS","PRAZO","REFCLI","PEDCLI","ITEMCLI","OS","ITEM","EMISSAO","FORNECEDOR","QTD","PRAZO","OC","ITEM","EMISSAO","FORNECEDOR","QTD","PRAZO","NOTA","SERIE","DATA FAT","FOLLOW","OBS"})
While ( !Eof())
  IF MV_PAR14=1
    cEstAv :=transform(U_SALRAP(TRB->C6_PRODUTO),"@e 99999.99")
    cEstCom:=transform(U_SALRA2(TRB->C6_PRODUTO),"@e 99999.99")
  else
    cEstAv :=transform(0,"@e 99999.99")
    cEstCom:=transform(0,"@e 99999.99")
  endif
  /*
  If ( Select ("SZK") <> 0 )
			dbSelectArea ("SZK")
			dbCloseArea ()
  Endif
  */
  cNomecli:=POSICIONE("SA1",1,XFILIAL("SA1")+TRB->C6_CLI+TRB->C6_LOJA,"A1_NREDUZ") 
  dbSelectArea("SZK")
  DbSetOrder(1)
  MsSeek(xFilial("SZK")+"PV"+TRB->C6_NUM+TRB->C6_ITEM)
  cOc:=""
  cOs:=""
  cOcItem	:=""
  cOcForn	:=""
  dOcData   :=""
  dOcPrazo  :=""
  nOcQtd	:=0
  cOs		:=""
  cOsItem	:=""
  cOsForn	:=""
  dOsData   :=""
  dOsPrazo  :=""
  nOsQtd	:=0
  // carrega amarracao oc x pv 
  While (SZK->ZK_REF=TRB->C6_NUM .AND. SZK->ZK_REFITEM=TRB->C6_ITEM)
    IF SZK->ZK_TIPO2="OC" 
      cOc		:=SZK->ZK_OC 	// NUMERO OS
      cOcItem	:=SZK->ZK_ITEM  
      cOcForn	:=SZK->ZK_FORN
      dOcData   :=DTOS(SZK->ZK_DT_VINC)
      dOcPrazo  :=DTOS(SZK->ZK_PRAZOC)
      nOcQtd	:=STR(SZK->ZK_QTC)
    endif
    IF SZK->ZK_TIPO2="OS" 
      cOs		:=SZK->ZK_OC 	// NUMERO OS
      cOsItem	:=SZK->ZK_ITEM  
      cOsForn	:=SZK->ZK_FORN
      dOsData   :=DTOS(SZK->ZK_DT_VINC)
      dOsPrazo  :=DTOS(SZK->ZK_PRAZOC)
      nOsQtd	:=STR(SZK->ZK_QTC)  
    ENDIF  
    dbskip()  	
  enddo		
  // carrega as liberacoes
  
  
  
  // CRIA ITENS DA PLANILHA DO EXCELL
  //aAdd( aItens,{[1]PEDIDO,[2]ITEM,[3]CODIGO,[4]DESCRICAO,[5]QTD,[6]SALDO,[7]PRAZO,[8]REFCLI,[9]PEDCLI,[10]ITEMCLI,[11]OS,[12]ITEM,[13]EMISSAO,[14]FORNECEDOR,[15]QTD,[16]PRAZO,[17]OC,[18]ITEM,[19]EMISSAO,[20]FORNECEDOR,[21]QTD,[22]PRAZO})
  IF cOs<>"" .and. cOc<>""
  	aAdd( aItens,{	TRB->C6_NUM,;
                 	TRB->C6_ITEM,;
                 	TRB->C6_CLI,;
                 	TRB->C6_LOJA,;
                 	cNomecli,;
                 	TRB->C6_PRODUTO,;
                 	TRB->C6_DESCRI,;
                 	STR(TRB->C6_QTDVEN),;
                 	STR(TRB->C6_SALDO),;
                 	cEstAv,;
                 	cEstCom,;
                 	STR(TRB->C6_QTDEST),;
                 	STR(TRB->C6_QTDCOM),;
                 	STR(TRB->C6_QTDOS),;
                 	TRB->C6_ENTREG,;
                 	TRB->C6_NUMREF,;
                 	TRB->C6_PV,;
                 	TRB->C6_ITEMCLI,;
                 	cOs,;
                 	cOsItem,;
                 	dOsData,;
                 	cOsForn,;
                 	nOsQtd,;
                 	dOsPrazo,;
                 	cOc,;
                 	cOcItem,;
                 	dOcData,;
                 	cOcForn,;
                 	nOcQtd,;
                 	dOcPrazo,;
                 	TRB->C6_NOTA,;
                 	TRB->C6_SERIE,;
                 	TRB->C6_DATFAT,;
                 	TRB->C6_STATUS,;
                 	TRB->C6_XOBS})
  endif
  IF cOs<>"" .and. cOc=""
  	aAdd( aItens,{	TRB->C6_NUM,;
                 	TRB->C6_ITEM,;
                 	TRB->C6_CLI,;
                 	TRB->C6_LOJA,;
                 	cNomecli,;
                 	TRB->C6_PRODUTO,;
                 	TRB->C6_DESCRI,;
                 	STR(TRB->C6_QTDVEN),;
                 	STR(TRB->C6_SALDO),;
                   	cEstAv,;
                 	cEstCom,;
                 	STR(TRB->C6_QTDEST),;
                 	STR(TRB->C6_QTDCOM),;
                 	STR(TRB->C6_QTDOS),;
                 	TRB->C6_ENTREG,;
                 	TRB->C6_NUMREF,;
                 	TRB->C6_PV,;
                 	TRB->C6_ITEMCLI,;
                 	cOs,;
                 	cOsItem,;
                 	dOsData,;
                 	cOsForn,;
                 	nOsQtd,;
                 	dOsPrazo,;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	TRB->C6_NOTA,;
                 	TRB->C6_SERIE,;
                 	TRB->C6_DATFAT,;
                 	TRB->C6_STATUS,;
                 	TRB->C6_XOBS})
  endif
  IF cOs="" .and. cOc<>""
  	aAdd( aItens,{	TRB->C6_NUM,;
                 	TRB->C6_ITEM,;
                 	TRB->C6_CLI,;
                 	TRB->C6_LOJA,;
                 	cNomecli,;
                 	TRB->C6_PRODUTO,;
                 	TRB->C6_DESCRI,;
                 	STR(TRB->C6_QTDVEN),;
                 	STR(TRB->C6_SALDO),;
                 	cEstAv,;
                 	cEstCom,;
                 	STR(TRB->C6_QTDEST),;
                 	STR(TRB->C6_QTDCOM),;
                 	STR(TRB->C6_QTDOS),;
                 	TRB->C6_ENTREG,;
                 	TRB->C6_NUMREF,;
                 	TRB->C6_PV,;
                 	TRB->C6_ITEMCLI,;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	cOc,;
                 	cOcItem,;
                 	dOcData,;
                 	cOcForn,;
                 	nOcQtd,;
                 	dOcPrazo,;
                 	TRB->C6_NOTA,;
                 	TRB->C6_SERIE,;
                 	TRB->C6_DATFAT,;
                 	TRB->C6_STATUS,;
                 	TRB->C6_XOBS})
  endif
  IF cOs="" .and. cOc=""
  	aAdd( aItens,{	TRB->C6_NUM,;
                 	TRB->C6_ITEM,;
                 	TRB->C6_CLI,;
                 	TRB->C6_LOJA,;
                 	cNomecli,;
                 	TRB->C6_PRODUTO,;
                 	TRB->C6_DESCRI,;
                 	STR(TRB->C6_QTDVEN),;
                 	STR(TRB->C6_SALDO),;
                 	cEstAv,;
                 	cEstCom,;
                 	STR(TRB->C6_QTDEST),;
                 	STR(TRB->C6_QTDCOM),;
                 	STR(TRB->C6_QTDOS),;
                 	TRB->C6_ENTREG,;
                 	TRB->C6_NUMREF,;
                 	TRB->C6_PV,;
                 	TRB->C6_ITEMCLI,;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	"",;
                 	TRB->C6_NOTA,;
                 	TRB->C6_SERIE,;
                 	TRB->C6_DATFAT,;
                 	TRB->C6_STATUS,;
                 	TRB->C6_XOBS})
  endif
  dbSelectArea("TRB")
  dbskip()
enddo     
TRB->( dbCloseArea() )
If !U_IntegExc()
	MsgAlert("Opera็ใo cancelada pelo usuแrio!")
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaSX1  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaSX1( _cPerg )

Local cDia 	 := AlLTrim( StrZero( Day( Date() ), 2 ) )
Local cMes 	 := AlLTrim( StrZero( Month( Date() ), 2 ) )
Local cAno 	 := Right( Str( Year( Date() ) ), 2 )
Local cData  := "'" + cDia  + "/" + cMes + "/" + cAno + "'"
Local _aArea := GetArea()
Local aRegs  := {}
Local _nI	 := 0
Local J		 := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do Array de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aRegs, { _cPerg, "01", "Produto de       ?", "Produto De       ?", "Produto De       ?", "mv_ch1" , "C", TamSX3( 'B1_COD' )[1], 0, 0, "G", "", "MV_PAR01", "", "", "", Space( TamSX3( 'B1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "" } )
aAdd( aRegs, { _cPerg, "02", "Produto ate      ?", "Produto Ate      ?", "Produto Ate      ?", "mv_ch2" , "C", TamSX3( 'B1_COD' )[1], 0, 0, "G", "", "MV_PAR02", "", "", "", Replicate( "z", TamSX3( 'B1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "" } )
aAdd( aRegs, { _cPerg, "03", "Cliente de       ?", "Cliente De       ?", "Cliente De       ?", "mv_ch3" , "C", TamSX3( 'A1_COD' )[1], 0, 0, "G", "", "MV_PAR03", "", "", "", Space( TamSX3( 'A1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", "", "" } )
aAdd( aRegs, { _cPerg, "04", "Cliente ate      ?", "Cliente Ate      ?", "Cliente Ate      ?", "mv_ch4" , "C", TamSX3( 'A1_COD' )[1], 0, 0, "G", "", "MV_PAR04", "", "", "", Replicate( "z", TamSX3( 'A1_COD' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", "", "" } )
aAdd( aRegs, { _cPerg, "05", "Loja De          ?", "Loja De          ?", "Loja De          ?", "mv_ch5" , "C", 2, 0, 0, "G", "", "MV_PAR05", "", "", "", "  ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "06", "Loja Ate         ?", "Loja Ate         ?", "Loja Ate         ?", "mv_ch6" , "C", 2, 0, 0, "G", "", "MV_PAR06", "", "", "", "  ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "07", "Num De           ?", "Num De           ?", "Num De           ?", "mv_ch7" , "C", TamSX3( 'C5_NUM' )[1], 0, 0, "G", "", "MV_PAR07", "", "", "", Space( TamSX3( 'C5_NUM' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "08", "Num Ate          ?", "Num Ate          ?", "Num Ate          ?", "mv_ch8" , "C", TamSX3( 'C5_NUM' )[1], 0, 0, "G", "", "MV_PAR08", "", "", "", Replicate( "z", TamSX3( 'C5_NUM' )[1] ), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "09", "Vencto De        ?", "Vencto De        ?", "Vencto De        ?", "mv_ch9" , "D", 8, 0, 0, "G", "", "MV_PAR09", "", "", "", cData, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { _cPerg, "10", "Vencto Ate       ?", "Vencto Ate       ?", "Vencto Ate       ?", "mv_chA" , "D", 8, 0, 0, "G", "", "MV_PAR10", "", "", "", cData, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
dbSelectArea( "SX1" )
dbSetOrder( 1 )
For _nI := 1 to Len( aRegs )
	If !dbSeek( _cPerg + aRegs[_nI, 2] )
		RecLock( "SX1", .T. )
		For j := 1 to fCount()
			If j <= Len( aRegs[_nI] )
				FieldPut( j, aRegs[_nI, j] )
			EndIf
		Next
		MsUnLock()
	EndIf
Next

RestArea( _aArea )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaParamsบAutor  ณ                            บ Data ณ   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaParams()

Local lRet := .T.
Local cMens := ""

If MV_PAR01 > MV_PAR02 //Codigo do Produto
	cMens := " - C๓digo inicial do produto ้ maior que o c๓digo final." + Chr( 10 )
EndIf

If MV_PAR03 > MV_PAR04 //Codigo do Fornecedor
	cMens += " - C๓digo inicial do Cliente ้ maior que o c๓digo final." + Chr( 10 )
EndIf

If DTOS(MV_PAR09) > DTOS(MV_PAR10) //Dt. Movimento
	cMens += " - Data inicial do movimento ้ maior que a data final." + Chr( 10 )
EndIf

If MV_PAR07 > MV_PAR08 //Codigo do Grupo de Produtos
	cMens += " - C๓digo inicial do Pedido ้ maior que o c๓digo final." + Chr( 10 )
EndIf

If Len( cMens ) > 0
	MsgInfo( "Por favor ajuste os parโmetros. Surgiram as seguintes inconsistencias: " + Chr( 10 ) + Chr( 10 ) + cMens )
	lRet := .F.
EndIf

Return lRet
/*                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIntegExc  บAutor  ณ            บ Data ณ        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio KARDEX                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCustomizacao                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function IntegExc()

Local lRet	   	:= .T.	
Local cDesc1    := "Esta rotina gera um arquivo em excel contendo as informa็๕es:                     "
Local cDesc2    := "Seguindo os parametros definidos pelo usuario                                     "
Local cDesc3 	:= "Sera salvo um arquivo no diretorio raiz c: Com a informacao extraida na pesquisau "
Local aSay      := {}
Local aButton   := {}
Local nOpc      := 0
Local cTitulo   := "Gera็ใo de Arquivo"

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., { || cPathLoc := SelArq()   } } )
aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( cTitulo, aSay, aButton )
	
If nOpc <> 1
	lRet := .F.
Else
    if Empty(cPathLoc)
    	cPathLoc := "C:\"
    Endif
	Processa({|| ProcInt()}, "Gerando integracao...")	
EndIf

Return lRet		
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcInt   บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para gerar um arquivo com extensใo .xls com os      บฑฑ
ฑฑบ          ณ dados filtrados pela query.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Customizacao                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcInt()

Local _aArea    := GetArea() 
Local cPath     := cPathLoc  
Local nHandle   := 0
Local cArqPesq 	:= cPath + "Posicli.xls"
//Local cArqPesq 	:= cPath
Local cCabHtml  := ""
Local cLinFile  := "" 
Local cFileCont := ""
Local nPedTotal
Local nQTDETot
Local nQTDSTot
Local nSaldTot                         
 
ProcRegua( LEN(aItens) ) 

	    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria um arquivo do tipo *.xls	                                                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nHandle := FCREATE(cArqPesq, 0)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se o arquivo pode ser criado, caso contrario um alerta sera exibido      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If FERROR() != 0
			Alert("Nใo foi possํvel abrir ou criar o arquivo: " + cArqPesq )
        EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
		//ณmonta cabe็alho de pagina HTML para posterior utiliza็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
		cCabHtml := "<!-- HCI Hidraulica Conexoes Industriais LTDA. --> " + CRLF
		cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
		cCabHtml += "<html>" + CRLF
		cCabHtml += "<head>" + CRLF
		cCabHtml += "  <title>POSICAO DE PEDIDO</title>" + CRLF
		cCabHtml += "  <meta name='GENERATOR' content='HCI Hidraulica Conexoes Industriais Ltda'>" + CRLF
		cCabHtml += "</head>" + CRLF
		cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF
		cCabHtml += "" + CRLF
 		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHง
		//ณMonta Rodape Html para posterior utiliza็aoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHง
		
		cRodHtml := "</body>" + CRLF
		cRodHtml += "</html>" + CRLF	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAqui come็a a montagem da pagina html propriamente ditaณ
		//ณ	 acrescenta o cabe็alho                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		cFileCont := cCabHtml    
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ//Aqui come็a o corpo da pagina mesmo                                                                                         ณ
		//ณ// Inicia uma tabela html e alimenta a variavel do relatorio ja que o relatorio inteiro estara contido em apenas uma variavelณ
		//ณ	// estrutura basica de tabela em html                                                                                        ณ
		//ณ	// <table> inicia uma tabela                                                                                                 ณ
		//ณ	// <TR> inicio de linha                                                                                                      ณ
		//ณ	// <TD> </TD> Coluna de uma tabela repetir tantas vezes quantas colunas existirem                                            ณ
		//ณ	// importante!!!! o numero de colunas nao podera ser alterado dentro da table ou seja todas as linhas tem que ter o mesmo    ณ
		//ณ	// numero de colunas (para aglutinar colunas ้ necessแrio utilizar um comando especifico do html, que nใo sera exemplificado ณ
		//ณ	// aqui                                                                                                                      ณ
		//ณ	// </TR> finaliza uma linha da tabela                                                                                        ณ
		//ณ	// </Table> finaliza a tabela                                                                                                ณ
		//ณ	// Utilizado o parametro Style das colunas para formatar cor da celula e tipo da fonte                                       ณ
		//ณ	                                                                                                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		
		cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='1' cellspacing='1'>"
		//Primeira linha da tabela 	  
		for x=1 to len(aItens)
		  cLinFile += "<TR>"
		  IncProc()
          // aAdd( aItens,{[1]PEDIDO,[2]ITEM,[3]CODIGO,[4]DESCRICAO,[5]QTD,[6]SALDO,[7]PRAZO,[8]REFCLI,[9]PEDCLI,[10]ITEMCLI,[11]OS,[12]ITEM,[13]EMISSAO,[14]FORNECEDOR,[15]QTD,[16]PRAZO,[17]OC,[18]ITEM,[19]EMISSAO,[20]FORNECEDOR,[21]QTD,[22]PRAZO})
		  IF X=1 
		   	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,1] + "</TD>" 	  		//[1]PEDIDO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,2] + "</TD>"     		//[2]ITEM
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,3] + "</TD>"     		//[3]CODIGO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,4] + "</TD>"     		//[4]DESCRICAO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,5] + "</TD>"     		//[5]QTD
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,6] + "</TD>"     		//[3]CODIGO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,7] + "</TD>"     		//[4]DESCRICAO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,8] + "</TD>"     		//[5]QTD
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,9] + "</TD>"       	//[6]SALDO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,10] + "</TD>"       	//[7]PRAZO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,11] + "</TD>"       	//[8]REFCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,12] + "</TD>"			//[9]PEDCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,13] + "</TD>"        	//[10]ITEMCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,14] + "</TD>"        	//[11]OS
		 	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,15] + "</TD>"        	//[12]ITEM 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,16] + "</TD>"      	//[13]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,17] + "</TD>"      	//[14]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,18] + "</TD>"      	//[15]QTD
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,19] + "</TD>" 			//[16]PRAZO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,20] + "</TD>"      	//[17]OC
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,21] + "</TD>"      	//[18]ITEM
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,22] + "</TD>"  		//[19]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,23] + "</TD>"		  	//[20]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,24] + "</TD>"      	//[21]QTD 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,25] + "</TD>"    		//[22]Prazo 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,26] + "</TD>"    		//[23]Nota 
	  		cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,27] + "</TD>"    		//[24]Serie
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,28] + "</TD>"    		//[25]Datafat 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,29] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,30] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,31] + "</TD>"    		//[25]Datafat 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,32] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,33] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,34] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,35] + "</TD>"    		//[25]Datafat
		  	cLinFile += "</TR>"
		  ELSE
		    if aItens[x,20]="" .AND. aItens[x,14]="" 
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,1] + "</TD>" 	  		//[1]PEDIDO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,2] + "</TD>"     		//[2]ITEM
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,3] + "</TD>"     		//[3]CODIGO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,4] + "</TD>"     		//[4]DESCRICAO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,5] + "</TD>"     		//[5]QTD
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,6] + "</TD>"       	//[6]SALDO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,7] + "</TD>"       	//[7]PRAZO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,8] + "</TD>"       	//[8]REFCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,9] + "</TD>"			//[9]PEDCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,10] + "</TD>"      	//[10]ITEMCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,11] + "</TD>"      	//[11]OS
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,12] + "</TD>"      	//[12]ITEM 
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,13] + "</TD>"      	//[13]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,14] + "</TD>"       	//[14]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,15] + "</TD>"      	//[15]QTD
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,16] + "</TD>" 			//[16]PRAZO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,17] + "</TD>"      	//[17]OC
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,18] + "</TD>"      	//[18]ITEM
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,19] + "</TD>"  		//[19]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,20] + "</TD>"		  	//[20]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,21] + "</TD>"      	//[21]QTD 
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,22] + "</TD>"  		//[21]Prazo
		   	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,23] + "</TD>"    		//[23]Nota 
	  		cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,24] + "</TD>"    		//[24]Serie
		  	cLinFile += "<TD rowspan='1' style='Background: #78FFC0; font-style: Bold;'>" + aItens[x,25] + "</TD>"    		//[25]Datafat
	  		cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,26] + "</TD>"    		//[23]Nota 
	  		cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,27] + "</TD>"    		//[24]Serie
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,28] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,29] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,30] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,31] + "</TD>"    		//[25]Datafat 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,32] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,33] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,34] + "</TD>"    		//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,35] + "</TD>"    		//[25]Datafat
		  	cLinFile += "</TR>" 
		  	else
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,1] + "</TD>" 	  		 		//[1]PEDIDO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,2] + "</TD>"     				//[2]ITEM
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,3] + "</TD>"     				//[3]CODIGO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,4] + "</TD>"     				//[4]DESCRICAO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,5] + "</TD>"     				//[5]QTD
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,6] + "</TD>"       			//[6]SALDO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,7] + "</TD>"       			//[7]PRAZO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,8] + "</TD>"       			//[8]REFCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,9] + "</TD>"					//[9]PEDCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,10] + "</TD>"      			//[10]ITEMCLI
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,11] + "</TD>"      			//[11]OS
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,12] + "</TD>"      			//[12]ITEM 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,13] + "</TD>"      			//[13]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,14] + "</TD>"       			//[14]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,15] + "</TD>"      	 		//[15]QTD
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,16] + "</TD>" 					//[16]PRAZO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,17] + "</TD>"      			//[17]OC
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,18] + "</TD>"      			//[18]ITEM
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,19] + "</TD>"  				//[19]EMISSAO
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,20] + "</TD>"		  			//[20]FORNECEDOR
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,21] + "</TD>"      	  		//[21]QTD 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,22] + "</TD>"  				//[21]Prazo
	        cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,23] + "</TD>"    	 			//[23]Nota 
	  		cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,24] + "</TD>"    				//[24]Serie
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFFF; font-style: Bold;'>" + aItens[x,25] + "</TD>"    				//[25]Datafat
		    cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,26] + "</TD>"    				//[23]Nota 
	  		cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,27] + "</TD>"    				//[24]Serie
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,28] + "</TD>"    				//[25]Datafat 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,29] + "</TD>"    				//[25]Datafat
	  		cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,30] + "</TD>"    				//[25]Datafat
		    cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,31] + "</TD>"    				//[25]Datafat 
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,32] + "</TD>"    				//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,33] + "</TD>"    				//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,34] + "</TD>"    				//[25]Datafat
		  	cLinFile += "<TD rowspan='1' style='Background: #FFFFC0; font-style: Bold;'>" + aItens[x,35] + "</TD>"    				//[25]Datafat
		  	cLinFile += "</TR>"                                   
		  	endif
		  ENDIF
		  // anexa a linha montada ao corpo da tabela
		  cFileCont += cLinFile
		  (FWRITE(nHandle, cFileCont) )
		  cLinFile := ""
		  cFileCont:= cLinFile
		next

cLinFile := "</Table>"
(FWRITE(nHandle, cLinFile) )
//Acrescenta o rodap้ html
(FWRITE(nHandle, cRodHtml))
	
// fecha a tabela aberta no inicio do arquivo

fCLose(nHandle)
ApmsgAlert("Abra o arquivo >>>>>" + cArqPesq + "<<<<<< atrav้s do Excel para ver o resultado!")

RestArea( _aArea )

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelArq    บAutor  ณ Ernani Forastieri  บ Data ณ  20/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar de Selecao do arquivo texto a ser importadoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelArq()
Private _cExtens   := "Arquivo Texto ( *.TXT ) |*.TXT|"
_cRet := cGetFile( _cExtens, "Selecione o Arquivo",,, .F., GETF_NETWORKDRIVE + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_RETDIRECTORY )
_cRet := ALLTRIM( _cRet )
Return( _cRet )
