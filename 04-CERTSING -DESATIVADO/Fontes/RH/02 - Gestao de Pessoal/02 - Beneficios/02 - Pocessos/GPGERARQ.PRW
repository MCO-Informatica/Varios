#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH" 

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPGERARQ
Geração do arquivo de pedidos de Vales Refeição e Alimentação.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $22.05.2017}
/*/
//------------------------------------------------------------------------------------------
User Function GPGERARQ()
Local nOpca  := 0
Local aRegs	 :={}
Local aSays  :={ }, aButtons:= { } //<== arrays locais de preferencia
Local cTpPed := ""
Local cTipo  := ""

cCadastro := OemToAnsi("Geracao do Arquivo Visa Vale") 

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ "GPMXVT",'01','Mes/Ano ?                    ','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'02','Data credito ?               ','','','mv_ch2','D',08,0,0,'G','NaoVazio   ','mv_par02','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'03','Nome Arquivo ?               ','','','mv_ch3','C',30,0,0,'G','NaoVazio   ','mv_par03','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'04','Filial De ?                  ','','','mv_ch4','C',02,0,0,'G','           ','mv_par04','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ "GPMXVT",'05','Filial Ate ?                 ','','','mv_ch5','C',02,0,0,'G','NaoVazio   ','mv_par05','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ "GPMXVT",'06','Centro Custo De ?            ','','','mv_ch6','C',09,0,0,'G','           ','mv_par06','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ "GPMXVT",'07','Centro Custo Ate ?           ','','','mv_ch7','C',09,0,0,'G','NaoVazio   ','mv_par07','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ "GPMXVT",'08','Matricula De ?               ','','','mv_ch8','C',06,0,0,'G','           ','mv_par08','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ "GPMXVT",'09','Matricula Ate ?              ','','','mv_ch9','C',06,0,0,'G','NaoVazio   ','mv_par09','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aadd(aRegs,{ "GPMXVT",'10','Situacoes ?                  ','','','mv_cha','C',05,0,0,'G','fSituacao()','mv_par10','                 ','','','ADFT','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'11','Categorias  ?                ','','','mv_chb','C',12,0,0,'G','fCategoria ','mv_par11','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'12','Responsalvel ?               ','','','mv_chc','C',40,0,0,'G','NaoVazio   ','mv_par12','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'13','Telefone ?                   ','','','mv_chd','C',12,0,0,'G','NaoVazio   ','mv_par13','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'14','Num.Pedido ?                 ','','','mv_che','C',06,0,0,'G','NaoVazio   ','mv_par14','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'15','Tipo do Pedido ?             ','','','mv_chf','C',01,0,0,'C','NaoVazio   ','mv_par15','Normal           ','','','    ','','Complementar     ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'16','Vale ?                       ','','','mv_chg','C',01,0,0,'C','NaoVazio   ','mv_par16','Alimentacao      ','','','    ','','Refeicao         ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,''   ,'' })
aAdd(aRegs,{ "GPMXVT",'17','CNPJ do Contrato ?           ','','','mv_chh','C',20,0,0,'G','NaoVazio   ','mv_par17','                 ','','','    ','','                 ','','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CF6','' })

ValidPerg(aRegs,"GPMXVT")

Pergunte("GPMXVT",.F.)

AADD(aSays,OemToAnsi("Este programa gera arquivo do VISA VALE") )   

AADD(aButtons, { 5,.T.,{|| Pergunte("GPMXVT",.T. ) } 	} )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

IF nOpca == 1
		Processa({|| GPCRIAARQ() },"Processando...")
Endif

Return( Nil )


Static Function GPCRIAARQ()
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPCRIAARQ
Criação dos arquivos de pedidos.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $22.05.2017}
/*/
//------------------------------------------------------------------------------------------
Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2        
Local nP         := {}
Local nX         := 0
Local aArea      := {}
Local aCNPJ      := {}    
Local CCGC       := ""
Local cSituacao  := "("
Local cCategor   := "("
Local nTotal     := 0

Private cCnpj, cNomeEmpr, cFilCNPJ
Private aEmpr := {}

//->Ajusta var cSituacao para a query.
For nX := 1 To Len(mv_par10)
   If Subs(mv_par10,nX,1) <> '*'
      cSituacao  += "'"+Subs(mv_par10,nX,1)+"',"
   EndIf
Next nX
cSituacao  := Subs(cSituacao,1,Len(cSituacao) -1)+")"

//->Ajusta var cCategor para a query.
For nX := 1 To Len(mv_par11)
   If Subs(mv_par11,nX,1) <> '*'
      cCategor  += "'"+Subs(mv_par11,nX,1)+"',"
   EndIf
Next nX
cCategor  := Subs(cCategor,1,Len(cCategor) -1)+")"

cArqTxt := alltrim(mv_par03)
nRecno  := Recno()
nHandle := MSFCREATE(cArqTXT)

If FERROR() # 0 .Or. nHandle < 0
   Help("",1,"GPM600HAND")
   FClose(nHandle)
   Return Nil
EndIf

Set Century On
cCnpj      := mv_par17

// Busca o CNPJ da Empresa Principal
fBuscaCnpj( @cFilCNPJ, @cCnpj, @cNomeEmpr, @aEmpr )

/*
Estrutura de aEmpr.

aEmpr[01] 01 - Codigo da Filial
aEmpr[02] 02 - Nome Completo da Empresa
aEmpr[03] 03 - CNPJ
aEmpr[04] 04 - Nome Reduzido
aEmpr[05] 05 - Inscricao Estadual
aEmpr[06] 06 - Inscricao Municipal
*/

cAnoMes    := substr(MV_PAR01,3,4)+substr(MV_PAR01,1,2)

If Substr(cAnoMes,5,2) < '01' .or. Substr(cAnoMes,5,2) > '12'
   Alert('Mes de referencia invalido')
   Return
EndIf   

//IF empty(alltrim(getmv("MV_VISACNP")))
//   cCgc:= left(SM0->M0_CGC+space(14),14)
//ELSE
//   cCgc:= alltrim(getmv("MV_VISACNP"))/
//ENDIF
   
cDescEmp := aEmpr[01][02] //02 - Nome Completo da Empresa
cCgc     := aEmpr[01][03] //03 - CNPJ  
cDescFil := aEmpr[01][04] //04 - Nome Reduzido
     
cData      := Dtos(ddatabase)
cData      := Substr(cData,7,2)+Substr(cData,5,2)+Substr(cData,1,4)
 
IF mv_par16=1
   cContrato  := GetMv("MV_VISAALI")
   cContrato  := PADL(cContrato,11,"0")
ELSE
   cContrato  := GetMv("MV_VISAREF")
   cContrato  := PADL(cContrato,11,"0")
ENDIF
    
cDescEmp   := LEFT(cDescEmp+Space(35),35)
cDescFil   := Left(cDescFil+Space(35),35)
cDataCred  := Dtos(mv_par02)
cDataCred  := Substr(cDataCred,7,2)+Substr(cDataCred,5,2)+Substr(cDataCred,1,4)
cResp      := Left(mv_par12+space(35),35)
aFunc      := {}
cTelefone  := Strzero(val(mv_par13),12)
cTpPed     := STR(MV_PAR16,1)
cTipo      := STR(MV_PAR15,1)

//Registro 0
fWrite(nHandle,'0'+cData+"A001"+cDescEmp+cCgc+REPLICATE('0',11)+cContrato+MV_PAR14+cDataCred+cTpPed+cTipo+cAnoMes+Space(18)+'007'+Space(267)+'000001'+Space(50)+chr(13)+chr(10)) 
   
//Registro 1
fWrite(nHandle,'1'+cCGC+REPLICATE('0',10)+cDescFil+'0021'+cResp+Space(40)+cTelefone+REPLICATE('0',6)+Space(75)+REPLICATE('0',12)+REPLICATE('0',6)+Space(75)+REPLICATE('0',12)+REPLICATE('0',6)+Space(51)+'000002'+Space(50)+chr(13)+chr(10))

//Registro 5				                                         
nSeq      := 3
nTotVt    := 0
nTotvalor := 0
nValTot := 0

IF MV_PAR16 = 1

   cQuery := " SELECT ZD_FILIAL "+CRLF
   cQuery += "       ,ZD_MAT    "+CRLF
   cQuery += "       ,ZD_QUANT  "+CRLF
   cQuery += "       ,ZD_VLUNIT "+CRLF
   cQuery += "       ,ZD_TOTAL  "+CRLF
   cQuery += "       ,RA_NOME   "+CRLF
   cQuery += "       ,RA_CIC    "+CRLF
   cQuery += "       ,RA_NASC   "+CRLF
   cQuery += " FROM " +RETSQLNAME("SZD")+" SZD "+CRLF
   cQuery += " INNER JOIN "+RETSQLNAME("SRA")+" SRA ON RA_FILIAL = ZD_FILIAL AND RA_MAT = ZD_MAT AND SRA.D_E_L_E_T_ <> '*' "+CRLF
   cQuery += " WHERE ZD_FILIAL BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "+CRLF
   cQuery += "   AND ZD_CC     BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "+CRLF
   cQuery += "   AND ZD_MAT    BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "+CRLF
   cQuery += "   AND RA_SITFOLH IN "+cSituacao+" "+CRLF
   cQuery += "   AND RA_CATFUNC IN "+cCategor+"  "+CRLF
   cQuery += "   AND ZD_ANOMES = '"+cAnoMes+"'   "+CRLF
   cQuery += "   AND ZD_QUANT  > 0               "+CRLF   
   cQuery += "   AND SZD.D_E_L_E_T_ <> '*' "+CRLF
   cQuery := ChangeQuerY(cQuery)                             
   
   If Select("SZ8NEW") > 0
      SZ8NEW->(dbCloseArea())
   EndIF
   
   TcQuery cQuery New Alias "SZ8NEW"

   While SZ8NEW->(!EOF())
   
         IncProc( "Processando Filial / Matricula.: " + SZ8NEW->(ZD_FILIAL+" - "+ZD_MAT) )
         
   		 cNasc := SZ8NEW->(Substr(RA_NASC,7,2))+SZ8NEW->(Substr(RA_NASC,5,2))+SZ8NEW->(Substr(RA_NASC,1,4))
         cCPF  := SZ8NEW->(RA_CIC)
         cNome := SZ8NEW->(left(RA_NOME+Space(40),40))
	     nTotal:= SZ8NEW->ZD_TOTAL
   	  	 nValTot += nTotal
	     fGravaDet(nTotal)
 		 nSeq ++ 
         aAdd(aFunc,{SZ8NEW->ZD_FILIAL,SZ8NEW->ZD_MAT,SZ8NEW->RA_NOME,SZ8NEW->ZD_QUANT,SZ8NEW->ZD_VLUNIT,SZ8NEW->ZD_TOTAL})
	     SZ8NEW->(dbSkip())
   EndDo	    

ELSE

   cQuery := " SELECT ZC_FILIAL "+CRLF
   cQuery += "       ,ZC_MAT    "+CRLF
   cQuery += "       ,ZC_QUANT  "+CRLF
   cQuery += "       ,ZC_VLUNIT "+CRLF
   cQuery += "       ,ZC_TOTAL  "+CRLF
   cQuery += "       ,RA_NOME   "+CRLF
   cQuery += "       ,RA_CIC    "+CRLF
   cQuery += "       ,RA_NASC   "+CRLF
   cQuery += " FROM "+RetSqlName("SZC")+" SZC "+CRLF
   cQuery += " INNER JOIN "+RETSQLNAME("SRA")+" SRA ON RA_FILIAL = ZC_FILIAL AND RA_MAT = ZC_MAT AND SRA.D_E_L_E_T_ <> '*' "+CRLF
   cQuery += " WHERE ZC_FILIAL BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "+CRLF
   cQuery += "   AND ZC_CC     BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "+CRLF
   cQuery += "   AND ZC_MAT    BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "+CRLF
   cQuery += "   AND RA_SITFOLH IN "+cSituacao+" "+CRLF
   cQuery += "   AND RA_CATFUNC IN "+cCategor+"  "+CRLF
   cQuery += "   AND ZC_ANOMES = '"+cAnoMes+"'   "+CRLF
   cQuery += "   AND ZC_QUANT  > 0               "+CRLF   
   cQuery += "   AND SZC.D_E_L_E_T_ <> '*' "+CRLF   			
   cQuery := ChangeQuerY(cQuery)
   
   If Select("SZDNEW") > 0
      SZDNEW->(dbCloseArea())
   EndIF
   
   TcQuery cQuery New Alias "SZDNEW"
   While SZDNEW->(!EOF())
   
       IncProc( "Processando Filial / Matricula.: " + SZDNEW->(ZC_FILIAL+" - "+ZC_MAT) )
        
       cNasc := SZDNEW->(Substr(RA_NASC,7,2)+Substr(RA_NASC,5,2)+Substr(RA_NASC,1,4))
       cCPF  := SZDNEW->RA_CIC
       cNome := SZDNEW->(left(RA_NOME+Space(40),40))
       nTotal:= SZDNEW->ZC_TOTAL
       nValTot += nTotal
       fGravaDet(nTotal)
       nSeq ++ 
       aAdd(aFunc,{SZDNEW->ZC_FILIAL,SZDNEW->ZC_MAT,SZDNEW->RA_NOME,SZDNEW->ZC_QUANT,SZDNEW->ZC_VLUNIT,SZDNEW->ZC_TOTAL,SZC->ZC_DESCRIC})
       SZDNEW->(dbSkip())
   EndDo	    
ENDIF   

fWrite(nHandle,'9'+STRZERO(nSeq-3,6)+STRZERO(nvalTot * 100 ,15)+Space(372)+STRZERO(nSeq,6)+chr(13)+chr(10))
FClose(nHandle)

Set Century Off
fImprime()

Return nil

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} fGravaDet
Gravação do Registro de Detalhes.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $22.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fGravaDet(nTotal)

fWrite(nHandle,'5'+;
       STRZERO(nTotal * 100,11)+;
       Space(68)+;
       cNasc+;
       cCpf+;
       Space(40)+;
       Replicate('0',15)+;
       ' 0'+;
   	   Space(45)+;
   	   Replicate('0',13)+;
   	   Space(96)+;
   	   Replicate('0',28)+;
   	   space(1)+;
       Replicate('0',8)+;
       ' '+;
       cNome+;
       Space(6)+;
       STRZERO(nSeq,6)+;
       Space(50)+;
       chr(13)+chr(10))

Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} fImprime
Impressão do LOg de processamento.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $22.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fImprime()
cDesc1  := 'Log de Geracao do Arquivo de Vale Refeicao' 
cDesc2  := ''
cDesc3  := ''
cString := 'SX1'
aOrd    := {'Nome','Matricula'}
aReturn  := { 'Zebrado',1,'Administracao',1,2,1,'',1 }
NomeProg := 'GPEXVR'
At_Prg   := 'GPEXVR'
nLastKey := 0
nTamanho := "P"
Li       := 0
ContFl   := 1
cTit := 'Log do Arquivo de Vale Refeicao'
wCabec0 := 1
wCabec1 := 'Fl Matric Nome                              Qtda.  Valor  Total'
WnRel  :='GPEXVR'       //-- Nome Default do relatorio em Disco.
WnRel  :=SetPrint(cString,WnRel,,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd)
nOrdem := aReturn[8]
Titulo := "Arquivo Vale  "+MesExtenso(VAL(SUBS(MV_PAR01,1,2)))+"/"+SUBS(MV_PAR01,3,4)

If nLastKey == 27
   Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return Nil
Endif

RptStatus({|| IMP_REL1() })

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} IMP_REL1
Impressão do LOg de processamento.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $22.05.2017}
/*/
//------------------------------------------------------------------------------------------
STATIC Function IMP_REL1()
Local nTotFun          := 0
Local nTotValor := 0

If nOrdem = 1
   aSort(aFunc,,,{|x,y| x[3] < y[3]})
Else
   aSort(aFunc,,,{|x,y| x[2] < y[2]})    
EndIF   

SetRegua(Len(aFunc))

For n := 1 to Len(aFunc)
  IncRegua()
  Impr(aFunc[n,1] + ' ' + aFunc[n,2] + ' ' + aFunc[n,3] + '   ' + Transform(aFunc[n,4], '@e 999') + '   ' + Transform(aFunc[n,5], '@e 999.99') + '   '+ Transform(aFunc[n,6], '@e 999,999.99'))
  nTotfun ++
  nTotValor += aFunc[n,6]
Next

Impr('')
IMPR(REPLICATE('-',80))
Impr('Total de Funcionarios ' + Transform(nTotFun , '9999') + ' -  Valor Total  ' + Transform(nTotVALOR, "@e 999,999.99"))
IMPR(REPLICATE('-',80))

Set Device To Screen

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return   


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} fBuscaCnpj
Resgate do CNPJ.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $22.05.2017}
/*/
//------------------------------------------------------------------------------------------
Static Function fBuscaCnpj( cFilCNPJ, cCnpj, cNomeEmpr, aEmpr )

DEFAULT cCnpj     := ""
DEFAULT cNomeEmpr := ""
DEFAULT cFilCNPJ  := ""
DEFAULT aEmpr     := {}

SM0->( dbGoTop() )

Do While SM0->( !Eof() )

    If !Empty(cFilCNPJ)

       If SM0->( AllTrim(M0_CODFIL) ) = AllTrim(cFilCNPJ)
       
          cNomeEmpr := Alltrim( SM0->M0_NOMECOM )
       
          Aadd(aEmpr,{SM0->M0_CODFIL,;	 // 01 - Codigo da Filial
                      SM0->M0_NOMECOM,; // 02 - Nome Completo da Empresa
                      SM0->M0_CGC,;	 // 03 - CNPJ
                      SM0->M0_NOME,;	 // 04 - Nome Reduzido
                      SM0->M0_INSC,;	 // 05 - Inscricao Estadual
                      SM0->M0_INSCM,;	 // 06 - Inscricao Municipal
                     })
       EndIf    
    ElseIf !Empty(cCnpj)
	
	   If SM0->( AllTrim(M0_CGC) ) = AllTrim(cCnpj)
	
          cNomeEmpr := Alltrim( SM0->M0_NOMECOM )
       
          Aadd(aEmpr,{SM0->M0_CODFIL,;	 // 01 - Codigo da Filial
                      SM0->M0_NOMECOM,; // 02 - Nome Completo da Empresa
                      SM0->M0_CGC,;	 // 03 - CNPJ
                      SM0->M0_NOME,;	 // 04 - Nome Reduzido
                      SM0->M0_INSC,;	 // 05 - Inscricao Estadual
                      SM0->M0_INSCM,;	 // 06 - Inscricao Municipal
                     })
	   EndIf
	EndIf
	
	SM0->( dbSkip() )
EndDo

Return
