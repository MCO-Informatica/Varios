#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELMEDIO    ºAutor  ³ Mateus Hengle      ºData  ³ 25/02/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio que calcula o consumo medio por produto           º±±
±±º          ³				   											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RELMEDIO()                                                       
	
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/05/02
#include "topconn.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ACAMPOS,TAMANHO")
SetPrvt("NSALDOATU,NENTRADAS,NVALTOT,NSAIDAS,LIMITE,CSTRING")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,CSAVSCR1")
SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CBTXT,CBCONT")
SetPrvt("LI,M_PAG,WNREL,CABEC2,CABEC1,NTIPO,nest")
SetPrvt("NTOTBSB,NTOTBH,NTOTSP,NTOTGER,NTTBSB,NTTBH,ntot,npercent")
SetPrvt("NTTSP,NTTGER,NTREGS,NMULT,NANT,NATU,ntotmesrec,ntotmesdes")
SetPrvt("NCNT,CSAV20,CSAV7,CNATANT,CNOMEARQ,CCHAVE")
SetPrvt("_SALIAS,AREGS,I,J,CQUERY,nTotDes,nTotRec")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³          ³ Autor ³ Wagner Soarres        ³ Data ³ 16.05.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Consumo Medio dos Produtos -   Por Periodo      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MAQUISUL                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 titulo:="RELACAO DE CONSUMO MEDIO DOS PRODUTOS - POR PERIODO "
 cDesc1 :="Este programa ira emitir o relatorio consumo medio dos produ- "
 cDesc2 :="tos por periodo"
 cDesc3 :=""
 aCampos  :={}
 tamanho  :="G"
 nSaldoAtu:=0
 nTot     :=0
 nTotJan  := 0
 nTotFev  := 0
 nTotMar  := 0
 nTotAbr  := 0
 nTotMai  := 0
 nTotJun  := 0
 nTotJul  := 0
 nTotAgo  := 0
 nTotSet  := 0
 nTotOut  := 0
 nTotNov  := 0
 nTotDez  := 0
 nmed  :=0
 limite   := 65
 cString  :="SD2"

aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  :="RMEDCO"
aLinha    := { }
nLastKey  := 0
cPerg     :=PadR("RMEDCO",10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 65
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(CPERG,.F.)
ValidPerg()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // Da Data                              ³
//³ mv_par02            // ate Data                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "RMEDCO"            //Nome Default do relatorio em Disco

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .OR. nLastKey == 27
	Return
Endif

//CRIACAO DE ARQUIVO DE TRABALHO

aCampos:={ {"COD" ,"C", TamSX3("B1_COD")[1],0},;
   {"QtJan","N",14,2},;
   {"QtFev","N",14,2},;
   {"QtMar","N",14,2},;
   {"QtAbr","N",14,2},;
   {"QtMai","N",14,2},;
   {"QtJun","N",14,2},;         
   {"QtJul","N",14,2},;
   {"QtAgo","N",14,2},;
   {"QtSet","N",14,2},;         
   {"QtOut","N",14,2},;
   {"QtNov","N",14,2},;
   {"QtDez","N",14,2},; 
   {"nMesMed","N",14,2},;      
   {"Desc","C",35,0},;      
   {"QtEst","N",14,2},;         
   {"AnoMes","C", 6,0} }
   cNomeArq :=CriaTrab(aCampos)
   Use &cNomeArq Alias cNomeArq New
   IndRegua("cNomeArq",cNomeArq,"COD+DESC",,,;
            "Selecionando Registros...")
   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "CONSUMO MEDIO DOS PRODUTOS"
cabec2 := "Codigo           Descricao                                 JAN       FEV       MAR       ABR       MAI       JUN       JUL       AGO       SET       OUT       NOV       DEZ   MED.CON     SALDO"
//         XXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99 99.999,99
//                   1         2         3         4         5         6         7         8         9         0        11        12        13        14        15        16        17        18        19        20        21        22
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
cabec1 := "Periodo de " + DTOC(mv_par01) + " a " +Dtoc(mv_par02) + "   

nTipo  :=IIF(aReturn[4]==1,18,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia leitura do arquivo de notas fiscais                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
       

Processa( {|| GravaTrab() },"Gravando Arquivo Temporario" )

RptStatus({|| Imprime() })
                                          
dbSelectArea("SD2REL")
dbCloseArea()

dbSelectArea("cnomearq")
dbCloseArea()

Return

Static Function Imprime()

    
   dbSelectArea("CNOMEARQ")
   
   IF MV_PAR07==1
      IndRegua("cNomeArq",cNomeArq,"COD+DESC",,,;
            "Selecionando Registros...")
   ELSE
      IndRegua("cNomeArq",cNomeArq,"DESC+COD",,,;
            "Selecionando Registros...")    
   ENDIF

   dbGotop()

   nTregs:= Reccount()
	

While !EOF() 
		
       IF LastKey()==286
          @PROW()+1,0 PSAY "Cancelado pelo operador"
	      EXIT
       EndIF

       IF li>60                                                               
          cabec1 := "Periodo de " + DTOC(mv_par01) + " a " +Dtoc(mv_par02) + ' Almoxarifado: ' + MV_PAR09
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
       EndIF

       @li,000 PSAY cnomearq->cod
       @li,017 PSAY cnomearq->DESC
       @li,053 PSAY cnomearq->qtjan Picture "99,999,999"
       @li,063 PSAY cnomearq->qtfev Picture "99,999,999"
       @li,073 PSAY cnomearq->qtmar Picture "99,999,999"
       @li,083 PSAY cnomearq->qtabr Picture "99,999,999"
       @li,093 PSAY cnomearq->qtmai Picture "99,999,999"
       @li,103 PSAY cnomearq->qtjun Picture "99,999,999"
       @li,113 PSAY cnomearq->qtjul Picture "99,999,999"
       @li,123 PSAY cnomearq->qtago Picture "99,999,999"
       @li,133 PSAY cnomearq->qtset Picture "99,999,999"
       @li,143 PSAY cnomearq->qtout Picture "99,999,999"
       @li,153 PSAY cnomearq->qtnov Picture "99,999,999"
       @li,163 PSAY cnomearq->qtdez Picture "99,999,999"                                                                      
              
		nTot     := cnomearq->qtjan+cnomearq->qtfev+cnomearq->qtmar+cnomearq->qtabr+cnomearq->qtmai+cnomearq->qtjun+cnomearq->qtjul
		nTot     := ntot+cnomearq->qtago+cnomearq->qtset+cnomearq->qtout+cnomearq->qtnov+cnomearq->qtdez
		nTotJan  := cnomearq->qtjan
		nTotFev  := cnomearq->qtfev
 		nTotMar  := cnomearq->qtmar
 		nTotAbr  := cnomearq->qtabr
 		nTotMai  := cnomearq->qtmai
		nTotJun  := cnomearq->qtjun
		nTotJul  := cnomearq->qtJul
		nTotAgo  := cnomearq->qtAgo
		nTotSet  := cnomearq->qtSet
		nTotOut  := cnomearq->qtOut
 		nTotNov  := cnomearq->qtNov
		nTotDez  := cnomearq->qtDez
		
		@LI,173 PSAY (ntot/cNomeArq->nmesmed) Picture "99,999,999"
    	@LI,183 PSAY cNomeArq->qtest Picture "99,999,999"
		
       li := li + 1

       dbSelectArea("cnomearq")
       dbSkip()
EndDO

IF li+4>60
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
EndIF


IF li != 65
   roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen
SetCursor(cSavCur1)
Set Filter To

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH() 
Return

// Substituido pelo assistente de conversao do AP5 IDE em 11/05/02 ==> Function RunProc

Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Data De            ?","mv_ch1","D",8,0,0 ,"G","","mv_par01","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Ate           ?","mv_ch2","D",8,0,0 ,"G","","mv_par02","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Produto De         ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SB1",""})
AADD(aRegs,{cPerg,"04","Produto Ate        ?","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SB1",""})
AADD(aRegs,{cPerg,"05","Tipo De            ?","mv_ch5","C",2,0,0 ,"G","","mv_par05","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Tipo Ate           ?","mv_ch6","C",2,0,0 ,"G","","mv_par06","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Ordem              ?","mv_ch7","N",1,0,0 ,"C","","mv_par07","Codigo","","","","","Descricao","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Descricao Cont.Em  ?","mv_ch8","C",35,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Almoxarifado       ?","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]    
		SX1->X1_VALID	:= aRegs[i,27]
		MsUnlock()
		DbCommit()
	Endif
Next


dbSelectArea(_sAlias)

Return

Static Function Gravatrab()

   cQuery  := " SELECT case WHEN MONTH(D2_EMISSAO)='01' THEN 'JAN' WHEN MONTH(D2_EMISSAO)='02' THEN 'FEV'  "
   cQuery += " WHEN MONTH(D2_EMISSAO)='03' THEN 'MAR' WHEN MONTH(D2_EMISSAO)='04' THEN 'ABR'  "
   cQuery += " WHEN MONTH(D2_EMISSAO)='05' THEN 'MAI' WHEN MONTH(D2_EMISSAO)='06' THEN 'JUN'  "
   cQuery += " WHEN MONTH(D2_EMISSAO)='07' THEN 'JUL' WHEN MONTH(D2_EMISSAO)='08' THEN 'AGO'  "   
   cQuery += " WHEN MONTH(D2_EMISSAO)='09' THEN 'SET' WHEN MONTH(D2_EMISSAO)='10' THEN 'OUT' "
   cQuery += " WHEN MONTH(D2_EMISSAO)='11' THEN 'NOV' ELSE 'DEZ' END AS MES,  D2_COD, B1_DESC,  "
   cQuery += " Sum(D2_QUANT) D2_QUANT, SUBSTRING(D2_EMISSAO,1,6) D2_MES"
   cQuery += " FROM  "+RetSqlName("SD2") 
   cQuery += " INNER JOIN "+RetSqlName("SB1")+" ON D2_COD=B1_COD  AND B1_FILIAL = '" + xFilial("SB1") + "' "
   cQuery += " WHERE D2_FILIAL ='"+xFilial("SD2")+"' AND SD2010.D_E_L_E_T_<>'*' "
   cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' and D2_TIPO <> 'D' "
   cQuery += " AND D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND B1_TIPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
   if !Empty(mv_par08)
      cQuery += " AND B1_DESC LIKE '%"+ALLTRIM(UPPER(MV_PAR08))+"%' "
   ENDIF
   cQuery += " AND D2_LOCAL = '" + MV_PAR09 + "' "
   cQuery += " GROUP BY D2_COD, B1_DESC,  MONTH(D2_EMISSAO), SUBSTRING(D2_EMISSAO,1,6)"
   
   cQuery += " UNION ALL "

   cQuery += " SELECT case WHEN MONTH(D3_EMISSAO)='01' THEN 'JAN' WHEN MONTH(D3_EMISSAO)='02' THEN 'FEV'  "
   cQuery += " WHEN MONTH(D3_EMISSAO)='03' THEN 'MAR' WHEN MONTH(D3_EMISSAO)='04' THEN 'ABR'  "
   cQuery += " WHEN MONTH(D3_EMISSAO)='05' THEN 'MAI' WHEN MONTH(D3_EMISSAO)='06' THEN 'JUN'  "
   cQuery += " WHEN MONTH(D3_EMISSAO)='07' THEN 'JUL' WHEN MONTH(D3_EMISSAO)='08' THEN 'AGO'  "   
   cQuery += " WHEN MONTH(D3_EMISSAO)='09' THEN 'SET' WHEN MONTH(D3_EMISSAO)='10' THEN 'OUT' "
   cQuery += " WHEN MONTH(D3_EMISSAO)='11' THEN 'NOV' ELSE 'DEZ' END AS MES,  D3_COD, B1_DESC,  "
   cQuery += " Sum(D3_QUANT) D2_QUANT, SUBSTRING(D3_EMISSAO,1,6) D2_MES"
   cQuery += " FROM  "+RetSqlName("SD3") 
   cQuery += " INNER JOIN "+RetSqlName("SB1")+" ON D3_COD=B1_COD AND B1_FILIAL = '" + xFilial("SB1") + "' "
   cQuery += " WHERE D3_FILIAL ='"+xFilial("SD3")+"' AND SD3010.D_E_L_E_T_<>'*' "
   cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' and D3_TM >= '500' "
   cQuery += " AND D3_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND B1_TIPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
   if !Empty(mv_par08)
      cQuery += " AND B1_DESC LIKE '%"+ALLTRIM(UPPER(MV_PAR08))+"%' "
   ENDIF
   cQuery += " AND D3_LOCAL = '" + MV_PAR09 + "' "
   cQuery += " GROUP BY D3_COD, B1_DESC,  MONTH(D3_EMISSAO), SUBSTRING(D3_EMISSAO,1,6)"

   cQuery += " UNION ALL "

   cQuery += " SELECT case WHEN MONTH(D3_EMISSAO)='01' THEN 'JAN' WHEN MONTH(D3_EMISSAO)='02' THEN 'FEV'  "
   cQuery += " WHEN MONTH(D3_EMISSAO)='03' THEN 'MAR' WHEN MONTH(D3_EMISSAO)='04' THEN 'ABR'  "
   cQuery += " WHEN MONTH(D3_EMISSAO)='05' THEN 'MAI' WHEN MONTH(D3_EMISSAO)='06' THEN 'JUN'  "
   cQuery += " WHEN MONTH(D3_EMISSAO)='07' THEN 'JUL' WHEN MONTH(D3_EMISSAO)='08' THEN 'AGO'  "   
   cQuery += " WHEN MONTH(D3_EMISSAO)='09' THEN 'SET' WHEN MONTH(D3_EMISSAO)='10' THEN 'OUT' "
   cQuery += " WHEN MONTH(D3_EMISSAO)='11' THEN 'NOV' ELSE 'DEZ' END AS MES,  D3_COD, B1_DESC,  "
   cQuery += " (Sum(D3_QUANT)*-1) D2_QUANT, SUBSTRING(D3_EMISSAO,1,6) D2_MES"
   cQuery += " FROM  "+RetSqlName("SD3") 
   cQuery += " INNER JOIN "+RetSqlName("SB1")+" ON D3_COD=B1_COD AND B1_FILIAL = '" + xFilial("SB1") + "' "
   cQuery += " WHERE D3_FILIAL ='"+xFilial("SD3")+"' AND SD3010.D_E_L_E_T_<>'*' "
   cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' and D3_TM < '500' "
   cQuery += " AND D3_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND B1_TIPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
   if !Empty(mv_par08)
      cQuery += " AND B1_DESC LIKE '%"+ALLTRIM(UPPER(MV_PAR08))+"%' "
   ENDIF
   cQuery += " AND D3_LOCAL = '" + MV_PAR09 + "' "
   cQuery += " AND D3_ESTORNO = 'S' "
   cQuery += " GROUP BY D3_COD, B1_DESC,  MONTH(D3_EMISSAO), SUBSTRING(D3_EMISSAO,1,6)"

   cQuery += " ORDER BY D2_COD "

  
   cQuery := ChangeQuery(cQuery)
   MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"SD2REL",.T.,.T.)},"Seleccionado registros" )

   dbSelectArea("SD2REL")
   dbGotop()
   NMED:=INT(ROUND((ABS((mv_par02-mv_par01)/30)),1))
   nTregs:= Reccount()
   ProcRegua(nTregs)

   While !EOF() //.and. E2_VENCREA <= mv_par02 
		
                               
      dbSelectArea("SB2")
      dbseek(xFilial("SB2")+sd2rel->d2_cod+MV_PAR09)
      nest:=SaldoSB2(.F.,.F.)
      
      dbSelectArea("cNomeArq")
      cChave := sd2rel->d2_cod
      dbSeek(cChave)
      IF EOF()
         reclock("cNomeArq",.T.)
         cNomeArq->cod   := cChave          
         cNomeArq->desc  := sd2rel->b1_desc
         cNomeArq->anomes:= sd2rel->D2_MES
         if sd2rel->mes="JAN"
            cNomeArq->qtJan   := sd2rel->D2_QUANT 
         elseif sd2rel->mes="FEV"
            cNomeArq->qtFEV   := sd2rel->D2_QUANT
         elseif sd2rel->mes="MAR"
            cNomeArq->qtMAR   := sd2rel->D2_QUANT
         elseif sd2rel->mes="ABR"
            cNomeArq->qtABR   := sd2rel->D2_QUANT
         elseif sd2rel->mes="MAI"
            cNomeArq->qtMAI   := sd2rel->D2_QUANT
         elseif sd2rel->mes="JUN"
            cNomeArq->qtJUN   := sd2rel->D2_QUANT
         elseif sd2rel->mes="JUL"
            cNomeArq->qtJUL   := sd2rel->D2_QUANT
         elseif sd2rel->mes="AGO"
            cNomeArq->qtAGO   := sd2rel->D2_QUANT
         elseif sd2rel->mes="SET"
            cNomeArq->qtSET   := sd2rel->D2_QUANT
         elseif sd2rel->mes="OUT"
            cNomeArq->qtOUT   := sd2rel->D2_QUANT
         elseif sd2rel->mes="NOV"
            cNomeArq->qtNOV   := sd2rel->D2_QUANT
         ELSE
            cNomeArq->qtDEZ   := sd2rel->D2_QUANT
         ENDIF
      ELSE
         reclock("cNomeArq",.F.)
         if sd2rel->mes="JAN"
            cNomeArq->qtJan   := sd2rel->D2_QUANT
         elseif sd2rel->mes="FEV"
            cNomeArq->qtFEV   := sd2rel->D2_QUANT
         elseif sd2rel->mes="MAR"
            cNomeArq->qtMAR   := sd2rel->D2_QUANT
         elseif sd2rel->mes="ABR"
            cNomeArq->qtABR   := sd2rel->D2_QUANT
         elseif sd2rel->mes="MAI"
            cNomeArq->qtMAI   := sd2rel->D2_QUANT
         elseif sd2rel->mes="JUN"
            cNomeArq->qtJUN   := sd2rel->D2_QUANT
         elseif sd2rel->mes="JUL"
            cNomeArq->qtJUL   := sd2rel->D2_QUANT
         elseif sd2rel->mes="AGO"
            cNomeArq->qtAGO   := sd2rel->D2_QUANT
         elseif sd2rel->mes="SET"
            cNomeArq->qtSET   := sd2rel->D2_QUANT
         elseif sd2rel->mes="OUT"
            cNomeArq->qtOUT   := sd2rel->D2_QUANT
         elseif sd2rel->mes="NOV"
            cNomeArq->qtNOV   := sd2rel->D2_QUANT
         ELSE
            cNomeArq->qtDEZ   := sd2rel->D2_QUANT
         ENDIF
      ENDIF
      reclock("cNomeArq",.F.)  
      cNomeArq->nmesmed := NMED
      cNomeArq->qtest  := nest
            
      dbSelectArea("SD2REL")
      dbSkip()
   EndDO
   

Return
