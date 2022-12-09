#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin05r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TAMANHO,AORD,CDESC1,CDESC2,CDESC3,CSTRING")
SetPrvt("CBCONT,CABEC1,CABEC2,CPERG,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,LI,LIMITE,LRODAPE,WNREL,TITULO")
SetPrvt("CBTXT,M_PAG,_NTOTDATA,_NTOTPRO,_NTOTGER,_CCHAVE")
SetPrvt("I,MV_PAR01,_CNUMLIQ,_NVALTOT,CQUERY,_NDIFEREN")
SetPrvt("_NINDSE5,_NRECSE5,_SALIAS,_AREGS,J,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ MDREFI05 ³ Autor ³ Richard B. Branco     ³ Data ³ 20.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Prestacao de Contas ( Titulos Recebidos via Cheque )       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MDREFI05                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO MANDO                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tamanho:= "P"
aOrd := {}
cDesc1 := "Este relatorio tem o objetivo de Imprimir os titulos liquidados" 
cDesc2 := "por cheque" 
cDesc3 := ""           
cString:="SE1"
cbCont := 0
cabec1 :=""
cabec2 :=""
cPerg  :="FIN05R    "
aReturn := {"Zebrado",1,"Administracao", 2, 2, 1, "",1 }
nomeprog:="KFIN05R"
nLastKey := 0
li:=80
limite:=80
lRodape:=.F.
wnrel  := "KFIN05R"
titulo  := "PRESTACAO DE CONTAS ( LIQUIDACAO )"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
Li      := 80
m_pag   := 1

_nTotData := 0
_nTotPro  := 0
_nTotGer  := 0

cabec1  := "  PREF. TITULO       NOME               TIPO  EMISSAO         VALOR     BAIXA"
cabec2  := ""
//                      123456789012345 123456789012345678901234567890 12 1234567890 123456   123456789012345 12345678901234567890 12345678901234
//                                1         2         3         4         5         6         7         8         9        10        11        12
//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


Validperg(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte( cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01	     	  De  Data de Emissao do cheque          ³
//³ mv_par02	     	  Ate Data de Emissao do cheque          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({||Imppc()},"Imprime")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({||Execute(Imppc)},"Imprime")


// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function IMPPC
Static Function IMPPC()

SetRegua(LastRec())

CabecPC()

_cChave := xFilial("SE1")+DTOS(MV_PAR01)+"CH"

DbSelectArea("SE1")
DbSetOrder(15)
DbSeek(_cChave)

If !FOUND()
	
	FOR I:=1 TO 50
        MV_PAR01 := MV_PAR01 + 1
		DbSeek(xFilial("SE1")+DTOS(MV_PAR01)+"CH")
		If FOUND()                           
     		_cChave := xFilial("SE1")+DTOS(MV_PAR01)+"CH"
			I:=60
		EndIf
	NEXT
EndIf

While !Eof() .And. SE1->E1_EMISSAO >= MV_PAR01 .AND. SE1->E1_EMISSAO <= MV_PAR02
	
	If SE1->E1_TIPO <> "CH" .OR. EMPTY(SE1->E1_NUMLIQ) .OR. EMPTY(SE1->E1_BCOCHQ)
		DbSelectArea("SE1")
		DBSKIP()
		LOOP
	EndIf
	
	_cNumLiq := SE1->E1_NUMLIQ
    _cChave  := _cChave+ _cNumLiq
	
	If lAbortPrint
		@Prow()+1,001 PSAY "ABORTADO PELO OPERADOR"
		Exit
	Endif
	
	Li := Li + 2
	
	If Li > 55
		roda(cbcont,cbtxt,tamanho)
		CabecPC(Tamanho)
	EndIf                             
	
	DbSelectArea("SA1")
	DbSetOrder(1)	
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE)
	
	@ LI, 003 PSAY SE1->E1_PREFIXO
	@ LI, 010 PSAY SE1->E1_NUM                       
    @ LI, 015 PSAY SE1->E1_PARCELA               
	@ LI, 020 PSAY SA1->A1_NREDUZ
	@ LI, 040 PSAY SE1->E1_TIPO
	@ LI, 045 PSAY SE1->E1_EMISSAO
	@ LI, 056 PSAY TRANSFORM(SE1->E1_VALOR,'@E 9999,999.99')
	@ LI, 070 PSAY SE1->E1_BAIXA   
	_nValtot :=  0
	
    Li := Li + 1 
	
    cQuery := " SELECT E1_PREFIXO, E1_NUM,  E1_EMISSAO,  E1_BAIXA,  E1_PARCELA, E1_TIPO,  E1_BCOCHQ,  E1_AGECHQ,  E1_CTACHQ,  E1_NUMLIQ,  E1_TIPOLIQ,  E1_VALOR, E1_VALLIQ "
    cQuery := cQuery +  " FROM "+RetSQLName("SE1") + " E1" 
    cQuery := cQuery +  " WHERE  E1_FILIAL='" +xFilial()+ "'"
    cQuery := cQuery +  " AND E1.D_E_L_E_T_<> '*'" 
    cQuery := cQuery +  " AND E1.E1_NUMLIQ = '" +SE1->E1_NUMLIQ+ "'"
    cQuery := cQuery +  " AND E1.E1_CLIENTE = '" +SE1->E1_CLIENTE+ "'" 
    cQuery := cQuery +  " AND E1.E1_BCOCHQ = ' '"
	
	cQuery := ChangeQuery(cQuery)
    MemoWrit("C:\LIXO.SQL",cQuery)                               
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .F.)	

//	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	TcSetField( "TRB", "E1_EMISSAO", "D" )
    TcSetField( "TRB", "E1_BAIXA", "D" )

	dbSelectArea("SE1")
	DbSkip()
	
	If SE1->E1_NUMLIQ <> _cNumLiq 
	
	//SE1->(E1_FILIAL+DTOS(E1_EMISSAO)+E1_TIPO+E1_NUMLIQ) <> _cchave
	                                                      
    //_cChave := SE1->(E1_FILIAL+DTOS(E1_EMISSAO)+E1_TIPO+E1_NUMLIQ)
    
	dbSelectArea("TRB")
	dbGoTop()
	
	While !Eof()
	
		@ LI, 003 PSAY TRB->E1_PREFIXO
		@ LI, 010 PSAY TRB->E1_NUM                   
		@ LI, 016 PSAY TRB->E1_PARCELA               
		@ LI, 040 PSAY TRB->E1_TIPO
		@ LI, 045 PSAY TRB->E1_EMISSAO
		@ LI, 056 PSAY TRANSFORM(TRB->E1_VALOR,'@E 9999,999.99')
		
		If TRB->E1_EMISSAO >= MV_PAR01 .AND. TRB->E1_EMISSAO <= MV_PAR02
		                                     
           If TRB->E1_TIPO == "PRO"
		       _nTotPro  :=  _nTotPro + TRB->E1_VALOR
		   Else
		      _nTotData  :=  _nTotData + TRB->E1_VALOR
		   EndIf
		
		EndIf   
	
		If TRB->E1_TIPO == "NCC"
			_nValtot := _nValtot - TRB->E1_VALOR
		Else
			_nValtot := _nValtot + TRB->E1_VALOR
		EndIf
		
        Li := Li + 1
		
        IF TRB->E1_VALOR <> TRB->E1_VALLIQ
	       Imp_NCC()                    
        EndIF
				
		If Li > 55
			roda(cbcont,cbtxt,tamanho)
			CabecPC(Tamanho)
		EndIf
		
		dbSelectArea("TRB")
		DbSkip()
		
	EndDo
	
	If _nValtot <> 0

        Li := Li + 1
		@ LI, 002 PSAY " Total  - "
		@ LI, 056 PSAY TRANSFORM(_nValtot,'@E 9999,999.99')
		_nTotGer  :=  _nTotGer + _nValtot
        Li := Li + 1
		_nValtot := 0
		
	EndIf
	
    EndIf
	
	dbSelectArea("TRB")
	DbCloseArea("TRB")
	
	//dbSelectArea("SE1")
	//DbSkip()
	
EndDo
    
If _nTotData <> 0
        Li := Li + 1
		@ LI, 002 PSAY " Total  do Periodo de "  + dtoc(Mv_Par01) + " ate " + dtoc(Mv_Par02) + " - "
		@ LI, 056 PSAY TRANSFORM(_nTotData,'@E 9999,999.99')
        Li := Li + 1
		@ LI, 002 PSAY " Total  do Periodo s/ Promessa  -"
		@ LI, 056 PSAY TRANSFORM(_nTotPro,'@E 9999,999.99')
        Li := Li + 1
		@ LI, 002 PSAY " Total  da Geral                -"
		@ LI, 056 PSAY TRANSFORM(_nTotGer,'@E 9999,999.99')
        Li := Li + 2
		@ LI, 002 PSAY " Valor Informado                -"
		@ LI, 056 PSAY TRANSFORM(mv_par03,'@E 9999,999.99')
        Li := Li + 1
		_nDiferen  :=  _nTotGer - mv_par03
    	@ LI, 002 PSAY " Diferenca                      -"
		@ LI, 056 PSAY TRANSFORM(_nDiferen,'@E 9999,999.99')
        Li := Li + 1
		@ LI, 002 PSAY " "
		_nTotData := 0
EndIf

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ CabecPC  ³ Autor ³ Richard B. Branco     ³ Data ³ 20.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime o cabecalho do relatorio der PRESTACAO DE CONTAS   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CabecPC
Static Function CabecPC()

LI := 4
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)

Return
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ IMP_NCC  ³ Autor ³ Angelo Alves Almeida  ³ Data ³ 21.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se ha NCC para o titulo Liquidado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³        	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION IMP_NCC
Static FUNCTION IMP_NCC()
		
      	dbSelectArea("SE5")		       
        _nIndSE5  := IndexOrd()
        _nRecSE5  := Recno()

      	dbSetOrder(7)                                                                 
      	_cChave := xFilial("SE5")+TRB->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
        dbSeek(_cChave)
		While !EOF() .And. E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO == _cChave
		      IF Substr(E5_DOCUMEN,11,3) $ "NCC"
		   
                 @ LI, 003 PSAY SE5->E5_PREFIXO
                 @ LI, 010 PSAY SE5->E5_NUMERO                   
            	 @ LI, 040 PSAY SUBS(SE5->E5_DOCUMEN,11,3)
             	 @ LI, 045 PSAY SE5->E5_DATA
            	 @ LI, 056 PSAY TRANSFORM(SE5->E5_VALOR,'@E 9999,999.99')
                 Li := Li + 1
                 _nValtot := _nValtot - SE5->E5_VALOR
		   
              EndIf
              dbSkip()
        End    
        
dbSelectArea("SE5") 
dbSetOrder(_nIndSE5)
dbGoTo(_nRecSE5)
              
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  10/05/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

_sAlias := Alias()
_aRegs := {}

dbSelectArea("SX1")
dbSetOrder(1)

//&& Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(_aRegs,{cPerg ,"01","Da Emissao       ?","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
aAdd(_aRegs,{cPerg ,"02","Ate a Emissao    ?","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
aAdd(_aRegs,{cPerg ,"03","Total em Cheques ?","","","mv_ch3","N",9,2,0,"G","","mv_par03","","","","","","","","","","","","","",""})

For i := 1 to Len(_aRegs)
    If !dbSeek(cPerg + _aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(_aRegs[i])
				FieldPut(j,_aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
