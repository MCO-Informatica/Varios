#include "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSUPORTE  บJean   ณTI-Omnilink         บ Data ณ  07/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Ult Atualizacao - 07/06/2006                               บฑฑ
ฑฑบDesc.     ณ Este relatorio imprimi a lista de tarefas cadastradas      บฑฑ
ฑฑบ          ณna rotina de suporte para atendimentos a usuarios microsiga.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Desenvolvido para atender necessidade do Ti-Omnilink       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSUPORTE()

Local cDesc1  := "Ult Atualizacao - 01/12/2005"         
Local cDesc2  := "Este relatorio imprimi a lista de tarefas cadastradas"                      
Local cDesc3  := "na rotina de suporte para atendimentos a usuarios microsiga."
Private cString  := "SB2"
Private Tamanho  := "G"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RSUPORTE"
Private NomeProg := "RSUPORTE"
Private nLastKey := 0
Private Limite   := 220
Private cPerg    := "RSUP01"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}
Private cabec1   := "ID.TAREFA|DESCRICAO                                |PRIORID.|ANALISTA             |DEPTO |SOLICITANTE             |MODULO           |ENTRADA    |CONC(%) |CHECK-POINT |PREVISAO   |CONCLUSAO  |RELEVANCIA   |STATUS       "  
Private Cabec2   := ""
Private Titulo   := "CHECK-LIST DE TAREFAS / TI-OMNILINK"

#IFNDEF TOP
   MsgInfo("Nใo ้ possํvel executar este programa, estแ base de dados nใo ้ TopConnect")
   RETURN
#ENDIF

// Verifica permissao de acesso ao relatorio
_cUser_ssi	:= GETMV("MV_XUSRSSI")  
if !(__CUSERID) $ _cUser_ssi 
  msginfo("Voc๊ nใo tem permissใo para executar este relat๓rio. Informe o CPD.","Acesso Negado")
  return .f.
endif


ValidPerg()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01              Status de                              ณ
//ณ mv_par02              Status Ate                             ณ
//ณ mv_par03              Setor de                               ณ
//ณ mv_par04              Setor Ate                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------
Pergunte(cPerg,.F.)
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,.F.,.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

nTipo := Iif(aReturn[4] == 1, 15, 18)

If nLastKey == 27
   Return
Endif

//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
RptStatus({|lEnd| RelPROCImp(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return

//+-------------------------------------------------------------------------------
//| funcao que processa os dados
//+-------------------------------------------------------------------------------
Static Function RelPROCImp(lEnd,wnrel,cString)
Local cFilSD4   := xFilial(cString)
Local cQuery    := ""
Local aCol      := {}

//+-----------------------
//| Cria filtro temporario
//+-----------------------


cQuery := "SELECT PZ8_COD, PZ8_DESCRE, PZ8_POSICA, PZ8_MODULO, PZ8_ANALI, PZ8_DEPTO, PZ8_NOMESO, "
cQuery += "PZ8_DATASO, PZ8_DTINIC,PZ8_PORCEN, PZ8_CKPOIN, PZ8_PREVIS, PZ8_PRIORI, PZ8_DTSOLU, PZ8_STATUS "
cQuery += "FROM PZ8010 " 
cQuery += "WHERE PZ8_STATUS >= '"+MV_PAR01+"' "
cQuery += "AND PZ8_STATUS <= '"+MV_PAR02+"' "
cQuery += "AND PZ8_DEPTO >= '"+MV_PAR03+"' "
cQuery += "AND PZ8_DEPTO <= '"+MV_PAR04+"' "
cQuery += "ORDER BY PZ8_STATUS, PZ8_DTINIC ASC "

alert(cQuery)
//+-------------------------
//| Cria uma view no banco
//+-------------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
dbSelectArea("TRB")
dbGoTop()
SetRegua( RecCount() )

// ID.TAREFA|DESCRICAO                                |PRIORID.|ANALISTA             |DEPTO |SOLICITANTE             |MODULO           |ENTRADA    |CONC(%) |CHECK-POINT |PREVISAO   |CONCLUSAO  |RELEVANCIA   |STATUS       "  
// XXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |XXXX     XXXXXXXXXXXXXXXXXXXX  XXXX   XXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXX  XX/XX/XXXX  XXXX     XX/XX/XXXX   XX/XX/XXXX  XX/XX/XXXX  XXXXXXXXXX    XXXXXXXXXXXXXX
// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//           1         2         3         4         5         6         7         8         9        10        11        12         13        14        15        16        17        18        19        20        21        220

//+--------------------
//| Coluna de impressao
//+--------------------
aAdd( aCol, 000 ) // ID DA TAREFA
aAdd( aCol, 010 ) // DESCRICAO
aAdd( aCol, 053 ) // POSICAO
aAdd( aCol, 061 ) // ANALISTA
aAdd( aCol, 083 ) // DEPTO
aAdd( aCol, 090 ) // SOLICITANTE
aAdd( aCol, 115 ) // MODULO
aAdd( aCol, 133 ) // DATA ENTRADA
aAdd( aCol, 145 ) // CONC(%)
aAdd( aCol, 154 ) // CHECK-POINT
aAdd( aCol, 167 ) // PREVISAO
aAdd( aCol, 179 ) // CONCLUSAO
aAdd( aCol, 191 ) // PRIORIDADE
aAdd( aCol, 205 ) // STATUS

cStatus := TRB->PZ8_STATUS

While !Eof() .And. !lEnd 
   
   If Li > 65
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   Endif

   DbSelectArea("TRB")
   
   nTotQuant  := 0

   While !Eof() .And. !lEnd .And. TRB->PZ8_STATUS == cStatus

    cStatus := TRB->PZ8_STATUS

      IncRegua()
      
      If Li > 65
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

      Endif
      @ Li, aCol[01] PSay TRB->PZ8_COD
      @ Li, aCol[02] PSay Substr(TRB->PZ8_DESCRE,1,40)+" |"
      @ Li, aCol[03] PSay TRB->PZ8_POSICA + "      |"
      @ Li, aCol[04] PSay SUBSTR(TRB->PZ8_ANALI,1,20)
      @ Li, aCol[05] PSay SUBSTR(TRB->PZ8_DEPTO,1,4) 
      @ Li, aCol[06] PSay SUBSTR(TRB->PZ8_NOMESO,1,24)   
      @ Li, aCol[07] PSay SUBSTR(TRB->PZ8_MODULO,1,16)
      @ Li, aCol[08] PSay STOD(TRB->PZ8_DATASO)
      @ Li, aCol[09] PSay TRB->PZ8_PORCEN
      @ Li, aCol[10] PSay STOD(TRB->PZ8_CKPOIN)
      @ Li, aCol[11] PSay STOD(TRB->PZ8_PREVIS)
      @ Li, aCol[12] PSay STOD(TRB->PZ8_DTSOLU)

      If TRB->PZ8_PRIORI == 'A'
  	      @ Li, aCol[13] PSay "Alta"
  	  Elseif TRB->PZ8_PRIORI == 'B'    
  	      @ Li, aCol[13] PSay "Baixa"
  	  Elseif TRB->PZ8_PRIORI == 'M'    
  	      @ Li, aCol[13] PSay "Media"
  	  Elseif TRB->PZ8_PRIORI == ' '    
  	      @ Li, aCol[13] PSay "N/D"
	  Endif 	  	      

      If TRB->PZ8_STATUS == '1'
	      @ Li, aCol[14] PSay "Aberto"
      Elseif TRB->PZ8_STATUS == '2'
	      @ Li, aCol[14] PSay "Andamento"
      Elseif TRB->PZ8_STATUS == '3'
	      @ Li, aCol[14] PSay "Encerrado"
      Elseif TRB->PZ8_STATUS == '4'
	      @ Li, aCol[14] PSay "Cancelado"
      Elseif TRB->PZ8_STATUS == ' '
	      @ Li, aCol[14] PSay "N/D"
      Endif 
      
      Li++
      @ Li, 000 PSay Replicate("_",Limite)
      Li++

      if TRB->PZ8_STATUS == cStatus
	      nTotQuant := nTotQuant  + 1 
	  else
		  nTotQuant  := 0	  
	  Endif		  


      DbselectArea("TRB")
      dbSkip()


   Enddo

      cStatus := TRB->PZ8_STATUS


	
	  Li++
      @ Li, 000 pSay "Total Chamados --->>"
	  @ Li, 200  PSay nTotQuant  Picture  PesqPictQt("D4_QUANT",13)
	  Li++
      @ Li, 000 PSay Replicate("_",Limite)
	  Li++



Enddo


If lEnd
   @ Li, aCol[1] PSay cCancel
   Return
Endif
   
If Li <> 80
   Roda(cbCont,cbTxt,Tamanho)
Endif

dbSelectArea("TRB")
dbCloseArea()

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   Ourspool(wnrel)
EndIf

Ms_Flush()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  25/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,6)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Status de      ? ","","","MV_CH1","C",01,0,0,"G","","MV_PAR01","Abertos","","","","","Em Andamento","","","","","Encerrado","","","","","Cancelados","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Status At้     ? ","","","MV_CH2","C",01,0,0,"G","","MV_PAR02","Abertos","","","","","Em Andamento","","","","","Encerrado","","","","","Cancelados","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Setor de       ? ","","","MV_CH3","C",04,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	aAdd(aRegs,{cPerg,"04","Setor At้      ? ","","","MV_CH4","C",04,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	DbSelectArea(_sAlias)
	
Return Nil