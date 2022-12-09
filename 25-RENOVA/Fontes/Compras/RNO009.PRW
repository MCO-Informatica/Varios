#INCLUDE "rwmake.ch" 
#INCLUDE "protdef.ch"
#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RNO009    ºAutor  ³ Antonio Carlos    º Data ³  04/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio para impressao do adiantamento x contrato        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RNO009()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Titulo     := "Acompanhamento dos adiantamento x contrato"
PRIVATE wnrel      := "Acompanhamento dos adiantamento x contrato"
PRIVATE cDesc1     := "Este relatorio apresentará os adiantamentos x contratos"
PRIVATE cDesc2     := ""
PRIVATE cDesc3     := ""
PRIVATE cString    := "CN9"
PRIVATE Tamanho    := "C"
PRIVATE cText := "TOTAL "
PRIVATE nTipo	   := 15
PRIVATE aOrd       := {}
PRIVATE lEnd	   := .F.
PRIVATE cFilerUser := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn  := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nLastKey := 0
PRIVATE cPerg 	 := "RNO009"
PRIVATE cAlias	 := Alias()
PRIVATE nRecno	 := Recno()
PRIVATE _nPC     := " "
PRIVATE _cOrigem := " "
PRIVATE _cLib    := " "
PRIVATE _nRevis  := " "
PRIVATE _cVencZ7 := " "
PRIVATE _nValZ7  := 0
PRIVATE _nValE2  := 0
PRIVATE _nBaixa  := 0
PRIVATE _cEmisE2 := " "
PRIVATE _cDoc    := " "
PRIVATE _cSerie  := " "
PRIVATE _cEmisE1 := " "
PRIVATE _cNumCNX := " "
PRIVATE _cTitCNX := " "
                                                                
oReport:= ReportDef()
oReport:PrintDialog()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Data Inicio                       ³
//³ mv_par02             // Ate a Data Final                     ³
//³ mv_par03             // Do Contrato                          ³
//³ mv_par04             // Ate o Contrato                       ³
//³ mv_par05             // Da Revisão                           ³
//³ mv_par06             // Ate a Revisão                        ³
//³ mv_par07             // Do Fornecedor                        ³
//³ mv_par08             // Ate o Fornecedor                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Validperg()
pergunte(cPerg,.F.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ReportDef  ³ Autor ³ Antonio Oliveira    ³ Data ³ 06/07/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oCell
Local nLoop    := Nil
Local cSecao   := "Cols"
Local aColunas := Nil

//{"ADIANTOLIB",        {|| SZ7->Z7_NUMSEQ }}, ;
//{"ADIANTONLIB",       {|| SZ7->Z7_NUMSEQ }}, ;
//{"VENCTOADN",         {|| SZ7->Z7_VENCTO }}, ;
//{"VALADN",            {|| SZ7->Z7_VALOR},"@E 9,999,999,999,999.99",.T.,"RIGHT"}, ;
//{"STATUSADN",         {|| "LIBERADO" }}, ;

aColunas  :={{"CONTRATO",          {|| _nPC },,.F.,}, ;
             {"FORNEC.",        {|| TRB->CNC_CODIGO },,.F.,}, ;
             {"LOJA",              {|| TRB->CNC_LOJA   },,.F.,}, ;
             {"TIPO",              {|| TRB->CN9_XTIPO  },,.F.,}, ;
             {"VIGENCIA",          {|| TRB->CN9_VIGE},"@E 999",.F.,"RIGHT"}, ;
             {"STATUS",            {|| TRB->CN9_SITUAC },,.F.,}, ;
             {"SALDO",             {|| TRB->CN9_SALDO},"@E 9,999,999,999,999.99",.F.,"RIGHT"}, ;
             {"VENCTOAD",          {|| _cVencZ7 },,.F.,}, ;
             {"VALORAD",           {|| _nValZ7  },"@E 9,999,999,999,999.99",.F.,"RIGHT"}, ;
             {"STATUSAD",          {|| _cLib    },,.F.,}, ;
             {"ORIGEM",            {|| _cOrigem },,.F.,}, ;  //Origem PC ou Contrato
             {"ADIANTO",           {|| _cNumCNX },,.F.,}, ;             
             {"TITULO",            {|| _cTitCNX },,.F.,}, ;             
             {"EMISSAO",           {|| _cEmisE2 },,.F.,}, ;             
             {"VALOR",             {|| _nValE2  },"@E 9,999,999,999,999.99",.F.,"RIGHT"}, ;             
             {"COMPENSADO",        {|| _nBaixa  },"@E 9,999,999,999,999.99",.F.,"RIGHT"}, ;             
             {"NFENTRADA",         {|| TRB->D1_DOC     },,.F.,}, ;             
             {"SERIE",             {|| TRB->D1_SERIE   },,.F.,}, ;             
             {"EMISSAONF",         {|| TRB->D1_EMISSAO },,.F.,}, ;                                                    
             {"VALORNF",           {|| TRB->D1_TOTAL   },"@E 9,999,999,999,999.99",.T.,"RIGHT" }}
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao do componente de impressao                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New(wnRel,Titulo, cPerg, {|oReport| ReportPrint(oReport, aColunas)}, cDesc1)
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Pergunte(cPerg,.F.)

oSection1 := TRSection():New(oReport, cSecao, cAlias) //"Contratos"
oSection1:SetHeaderPage(.F.)

For nLoop := 1 to Len(aColunas)
	aSize(aColunas[nLoop],  21)
	Default aColunas[nLoop,  3] := ""
	Default aColunas[nLoop,  4] := .F.
	Default aColunas[nLoop,  5] := ""  // cHeaderAlign
	Default aColunas[nLoop,  7] := 0   // Somatorio1
	Default aColunas[nLoop,  9] := 0   // Somatorio2
	Default aColunas[nLoop, 15] := 0   // Somatorio3	
	Default aColunas[nLoop, 17] := 0   // Somatorio4
	Default aColunas[nLoop, 21] := 0   // Somatorio5		
	Default aColunas[nLoop, 11] := "COL_" + StrZero(nLoop, 3)
	Default aColunas[nLoop, 12] := 0   // Tamanho Coluna

	/*
	METHOD New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold) CLASS TRCell
	*/

	TRCell():New(oSection1, aColunas[nLoop, 11], "", aColunas[nLoop, 1], aColunas[nLoop, 3], 50, .F., aColunas[nLoop, 2], aColunas[nLoop, 5],, aColunas[nLoop, 5],,, .F.)
Next
                                                    
oSection1:SetTotalInLine(.F.)     
//oSection1:SetTotalText(cText)	
Return(oReport)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportPrint ³ Autor ³ Antonio Carlos      ³ Data ³ 22/06/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento do Relatorio                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Definições: saldo, vigência e situação                                ³±±
±±³             Adiantamentos não liberados                               ³±±
±±³             Adiantamentos liberados                                   ³±±
±±³             Documentos de Entrada                                     ³±±
±±³             Títulos à Pagar                                           ³±±
±±³    Data Inclusão, Vencimento, Valor (com totalização)                 ³±±
±±³    Data compensação, Origem, Número e Série do Documento, Título      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport, aColunas)
Local nRegs := 0  
_nTotCtr  := 0.00
_nTotFaT  := 0.00
_nTotPan  := 0.00
_nTotPal  := 0.00
_nTotTl   := 0.00
_nTGCtr   := 0.00
_nTGFat   := 0.00
_nTGPan   := 0.00
_nTGPal   := 0.00
_nTGTl    := 0.00
cCN9	  := RetSqlName("CN9")
oSection1 := oReport:Section(1) 
cPerg     := oReport:GetParam()
cTitle    := oReport:cTitle
lPrim     := .T.
li		  := 80
M_Pag 	  := 1                          
  
oReport:SetTitle(cTitle + " - Emissão " + Dtoc(MV_PAR01) + " a " + Dtoc(MV_PAR02))
cCab01 	  := "                                          Adiantamento por contrato DE "+mv_par03+" ATE "+mv_par04
//                         XX  XXXXXXXXXXXXXXXXXXXXXXXX    XX/XX/XX        XX   999.999,99 99999999999      999,999.99  999,999.99   999,999.99  999.999,99  999,999.99
//                         0         1         2         3         4         5         6         7         8         9        10        11        12        13
//                         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//_cQuery += " Z7_NUMSEQ,Z7_VENCTO,Z7_VALOR,CNX_NUMERO,CNX_NUMTIT,E2_EMISSAO,E2_BAIXA,D1_DOC,D1_SERIE,D1_EMISSAO,D1_TOTAL " +Chr(10)                                                                                                                                                                                          //_cQuery += ",CNX_DTADT,CNX_VLADT,D1_DOC,D1_SERIE,D1_EMISSAO,D1_TOTAL,E2_VALOR,E2_NUM,E2_EMISSAO,E2_VALOR,E2_SALDO,E2_BAIXA FROM "+cCN9+ " CN9" +Chr(10)
//_cQuery += " INNER JOIN "+ RetSqlName( "SZ7" ) + " SZ7 ON SZ7.Z7_CONTRA=CN9.CN9_NUMERO AND SZ7.Z7_REVISAO=CN9.CN9_REVISA " +Chr(10)
//_cQuery += " INNER JOIN "+ RetSqlName( "CNC" ) + " CNC ON CNC.CNC_FILIAL=CN9.CN9_FILIAL AND CNC.CNC_NUMERO=CN9.CN9_NUMERO AND CNC.CNC_REVISA=CN9.CN9_REVISA AND CNC.D_E_L_E_T_<>'*' " +Chr(10) 
//_cQuery += " INNER JOIN "+ RetSqlName( "CNX" ) + " CNX ON CNX.CNX_FILIAL=CN9.CN9_FILIAL AND CNX.CNX_CONTRA=CN9.CN9_NUMERO AND CNX.D_E_L_E_T_<>'*'" +Chr(10) 
//_cQuery += " INNER JOIN "+ RetSqlName( "SD1" ) + " D1 ON D1.D1_FILIAL=CN9.CN9_FILIAL AND D1.D1_XCONTRA=CN9.CN9_NUMERO AND D1.D1_REVISAO=CN9.CN9_REVISA AND D1.D_E_L_E_T_<>'*'" +Chr(10)  
//_cQuery += " INNER JOIN "+ RetSqlName( "SE2" ) + " E2 ON E2.E2_FILIAL=CN9.CN9_FILIAL AND E2.E2_MDCONTR=CN9.CN9_NUMERO AND E2.E2_MDREVIS=CN9.CN9_REVISA " +Chr(10) 
   
_cQuery := ""
_cQuery := "SELECT CN9_NUMERO,CN9_REVISA,CN9_XTIPO,CN9_VIGE,CN9_DTINIC,CN9_SALDO,CN9_SITUAC,CNC_CODIGO,CNC_LOJA,A2_NOME,COALESCE(D1_DOC,'') D1_DOC,COALESCE(D1_SERIE,'') D1_SERIE,COALESCE(D1_EMISSAO,'') D1_EMISSAO,COALESCE(D1_TOTAL,0) D1_TOTAL " +Chr(10)
_cQuery += " FROM "+cCN9+ " CN9" +Chr(10)                                                                       
_cQuery += " INNER JOIN "+ RetSqlName( "CNC" ) + " CNC ON CNC.CNC_FILIAL=CN9.CN9_FILIAL AND CNC.CNC_NUMERO=CN9.CN9_NUMERO AND CNC.CNC_REVISA=CN9.CN9_REVISA AND CNC.D_E_L_E_T_<>'*' " +Chr(10) 
_cQuery += " LEFT JOIN "+ RetSqlName( "SD1" ) + " D1 ON D1.D1_FILIAL=CN9.CN9_FILIAL AND D1.D1_XCONTR=CN9.CN9_NUMERO AND D1.D1_XREVIS=CN9.CN9_REVISA AND D1.D_E_L_E_T_<>'*'" +Chr(10)
_cQuery += " INNER JOIN "+ RetSqlName( "SA2" ) + " SA2 ON SA2.A2_COD=CNC.CNC_CODIGO AND SA2.A2_LOJA=CNC.CNC_LOJA AND SA2.D_E_L_E_T_<>'*' " +Chr(10)           
_cQuery += " WHERE CN9_DTINIC BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND CN9.D_E_L_E_T_<>'*' " +Chr(10)
_cQuery += "AND "+"CN9.CN9_NUMERO BETWEEN '"+MV_PAR03      +"' AND '"+MV_PAR04+"' "+Chr(10)
_cQuery += "AND "+"CN9.CN9_REVISA BETWEEN '"+MV_PAR05      +"' AND '"+MV_PAR06+"' "+Chr(10)
_cQuery += "ORDER BY CN9_NUMERO,CN9_REVISA, CN9_XTIPO "+Chr(10)
_cQuery := ChangeQuery(_cQuery)
//Memowrite("C:\RENOVA\TB1P10.SQL",_cQuery )
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)
TCSetField("TRB","CN9_VENCIMENTO","D",8,0) 
TCSetField("TRB","D1_EMISSAO","D",8,0)
                                                                                                               
oSection1:Init()

/*
For nLoop := 1 to Len(aColunas)
	oSection1:Cell(aColunas[nLoop, 11]):SetSize(2 * Max(Len(aColunas[nLoop, 1]), Len(Transform(Eval(aColunas[nLoop, 2]), aColunas[nLoop, 3]))))
Next
*/
oSection1:Cell('COL_001'):SetSize(65)
oSection1:Cell('COL_003'):SetSize(15) 
oSection1:Cell('COL_004'):SetSize(30) 
oSection1:Cell('COL_005'):SetSize(15)
oSection1:Cell('COL_011'):SetSize(15) 
oSection1:Cell('COL_012'):SetSize(25)

dbSelectArea("TRB")
dbGotop()
//SetRegua(RecCount())

While  ! oReport:Cancel() .And. ! EOF()            

	If oReport:Cancel()
		Exit
	EndIf

	oReport:IncMeter()   
	
	IF _nPC <> TRB->CN9_NUMERO .OR. _nRevis <> TRB->CN9_REVISA
       	_nPC := TRB->CN9_NUMERO                                                        
       	_nRevis := TRB->CN9_REVISA
       	_nTotCtr  := 0.00
       	_nTotPan  := 0.00
       	_nTotPal  := 0.00        
       	_nTotTl   := 0.00    
       	_nTotFat  := 0.00
		_nTotCtr := _nTotCtr + TRB->CN9_SALDO
    EndIf    
       _cDoc    := " "
       _cSerie  := " "
       _cEmisE1 := " "
       _nTotFat := 0
       _nValE2  := 0
       _cEmisE2 := Ctod("//")
        _nBaixa := 0   
       _cVencZ7 := Ctod("//") 
       _nValZ7  := 0
       _cNumCNX := " "
       _cTitCNX := " "

       dbSelectArea("CNX")              //Adiantamentos de Contrato
       dbSetOrder(1)
       dbSeek(xFilial("CNX")+TRB->CN9_NUMERO)
       WHILE CNX->(!EOF()) .AND. CNX->CNX_FILIAL == xFilial('CNX') .And. CNX->CNX_CONTRA == TRB->CN9_NUMERO 
          _cNumCNX := CNX_NUMERO
          _cTitCNX := CNX_NUMTIT 
          dbSelectArea("SZ7")          //Título de Pagamento Antecipado Não Liberado
          dbSetOrder(3)  	//Z7_FILIAL+Z7_FORNECE+Z7_LOJA+Z7_CONTRA+Z7_REVISAO+Z7_PLANILHA+Z7_MEDICAO
          IF (dbSeek(xFilial("SZ7")+TRB->CNC_CODIGO+TRB->CNC_LOJA+CNX->CNX_CONTRA))  
             _cVencZ7:= SZ7->Z7_VENCTO
             _nValZ7 := SZ7->Z7_VALOR
             If !EMPTY(SZ7->Z7_NUMPED)
                  _cOrigem := "PC"                     
             ELSE   
                  _cOrigem := "CTR"
             ENDIF
             IF SZ7->Z7_STATUS == "1" 
                _nTotPal := _nTotPal + Z7_VALOR             
                _cLib := "Aprovado"	//"Liberado"
             ELSEIF SZ7->Z7_STATUS = "2"    //Título de Pagamento Antecipado Liberado   
                _cLib := "Aguardando Aprovação" //"Aguardando Lib"
                _nTotPan := _nTotPan + SZ7->Z7_VALOR  
             ELSEIF SZ7->Z7_STATUS = "3" 
                _cLib := "Rejeitado" 
             ENDIF
          ENDIF      

          dbSelectArea("SE2")           //Contas a Pagar - Título
          dbSetOrder(1)
          IF (dbSeek(xFilial("SE2")+CNX->CNX_PREFIX+CNX->CNX_NUMTIT))
              	_nValE2 := SE2->E2_VALOR
              	_cEmisE2:= Dtoc(SE2->E2_EMISSAO)  
	       		_nTotTl := _nTotTl + SE2->E2_VALOR
	       		_nBaixa	:= SE2->E2_VALOR - SE2->E2_SALDO 
		  Else
              _nValE2 := 0
              _cEmisE2:= Ctod("//")   
              _nBaixa	:= 0
          ENDIF                                     
          
          dbSelectArea("SE5")           //Movimento Bancário - verificar compensação
//          dbSetOrder(7)
//          IF (dbSeek(xFilial("SE5")+CNX->CNX_PREFIX+CNX->CNX_NUMTIT))


//          dbSetOrder(7)
//          IF (dbSeek(xFilial("SE5")+CNX->CNX_PREFIX+CNX->CNX_NUMTIT+"001"+"PA "+TRB->CNC_CODIGO+TRB->CNC_LOJA))
//              IF SE5->E5_MOTBX == "CMP"
//                 _nBaixa := SE5->E5_VALOR
//              ENDIF
//          ENDIF                                     
        
          dbSelectArea("SD1")
          DbOrderNickName(PADR("D1CTR",10))
          //DbSetOrder(9)
          IF (dbSeek(xFilial("SD1")+TRB->CN9_NUMERO+TRB->CN9_REVISA))
              _cDoc    := SD1->D1_DOC
              _cSerie  := SD1->D1_SERIE
              _cEmisE1 := SD1->D1_EMISSAO  
              _nTotFat := _nTotFat + SD1->D1_TOTAL  
		  Else
              _cDoc    := ""
              _cSerie  := ""
              _cEmisE1 := Ctod("//")
          ENDIF
          
          CNX->(DBSKIP())
          
       ENDDO  
    
    _nTGCtr = _nTGCtr + _nTotCtr
    _nTGFaT = _nTGFaT + _nTotFaT
    _nTGPan = _nTGPan + _nTotPan
    _nTGPal = _nTGPal + _nTotPal    
    _nTGTl  = _nTGTl  + _nTotTl            
    
	For nLoop := 1 to Len(aColunas)
		If aColunas[nLoop,  4] // SOMA
			aColunas[nLoop,  7] += Eval(aColunas[nLoop,  2])
			aColunas[nLoop,  9] += Eval(aColunas[nLoop,  2])
			aColunas[nLoop, 15] += Eval(aColunas[nLoop,  2])			
			aColunas[nLoop, 17] += Eval(aColunas[nLoop,  2])
			aColunas[nLoop, 21] += Eval(aColunas[nLoop,  2])						
		Endif
	Next

	oSection1:PrintLine()

	dbSelectArea("TRB")
	dbSkip()
End

For nLoop := 1 to Len(aColunas)
	If aColunas[nLoop,  4] // SOMA
	   oSection1:Cell(aColunas[nLoop, 11]):SetValue(aColunas[nLoop,  7])
	Else
	   oSection1:Cell(aColunas[nLoop, 11]):Hide()
	Endif
Next

oReport:ThinLine()
oSection1:PrintLine()
oSection1:Finish()

dbSelectArea("TRB")
dbClosearea()
SET DEVICE TO SCREEN
MS_FLUSH()
If (aReturn[ 5 ] == 1)
	SET PRINTER TO
	OurSpool( wnrel )
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³  Antonio Carlos       ³ Data ³ 29/06/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico - RENOVA                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg

Local aHelpPor0 := {'Informe a Data inicial ','Data inicial para o processamento'}
Local aHelpEng1 := {}
Local aHelpSpa1 := {}
Local aHelpPor1 := {'Informe o Data Final ','Data Final para o processamento'}                                                            
Local aHelpPor2 := {'Informe o Contrato Inicial ','Contrato inicial para o processamento'}
Local aHelpPor3 := {'Informe o Contrato Final ','Contrato final para o processamento'}
Local aHelpPor4 := {'Informe a Revisao inicial ','Revisao inicial para o processamento'}
Local aHelpPor5 := {'Informe a Revisao final ','a Revisao final para o processamento'}
Local aHelpPor6 := {'Informe o Fornecedor Inicial ','Fornecedor inicial para o processamento'}
Local aHelpPor7 := {'Informe o Fornecedor final ','o Fornecedor final para o processamento'}

cAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs :={}

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {"Data de"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"01","Data de ","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor0,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor := {"Data ate"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"02","Data ate ","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor1,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor := {"Contrato de"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"03","Contrato de ","","","mv_ch3","C",15,0,0,"G","","CN9","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor0,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor := {"Contrato ate"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"04","Contrato ate ","","","mv_ch4","C",15,0,0,"G","","CN9","","","mv_par04","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","",aHelpPor1,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor := {"Revisão de"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"05","Revisão de   ","","","mv_ch5","C",3,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor2,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR06--------------------------------------------------
aHelpPor := {"Revisão ate"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"06","Revisão ate    ","","","mv_ch6","C",3,0,0,"G","","","","","mv_par06","","","","ZZZ","","","","","","","","","","","","",aHelpPor3,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR07--------------------------------------------------
aHelpPor := {"Fornecedor de"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"07","Fornecedor de ","","","mv_ch7","C",6,0,0,"G","","SA2","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor5,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR08--------------------------------------------------
aHelpPor := {"Fornecedor ate"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"08","Fornecedor ate ","","","mv_ch8","C",6,0,0,"G","","SA2","","","mv_par08","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor5,aHelpEng,aHelpSpa)
Return