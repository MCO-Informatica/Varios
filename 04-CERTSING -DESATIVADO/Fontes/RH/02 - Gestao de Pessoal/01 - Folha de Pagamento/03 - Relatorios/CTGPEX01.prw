#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*
+-----------------------+-----------------------------+---------------------+
|Programa.:   CTGPEX01  | Autor.: Alexandre AS.       | Data.: 09/06/2016   |
+-----------------------+-----------------------------+---------------------+
|Descricao.: Gera CSV com informa็๕es de colaboradores.                     |
+---------------------------------------------------------------------------+
*/

User Function CTGPEX01()

Local bProcesso := {|oSelf| fProcessa( oSelf )}

Private cCadastro  := "Planilha com Informa็๕es de Colaboradores"
Private cPerg      := "CTGPEX01"
Private cStartPath := GetSrvProfString("StartPath","")
Private cDescricao := "Esta rotina irแ gerar arquivo Excel com informa็๕es de Funcionแrios."

fAsrPerg()
Pergunte(cPerg,.F.)

tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.F. ) 	

Return

/*
+---------------------------------------------------------------------------+
|Funcao.: fProcessa  | Autor.: Alexandre Alves          | Data.: 06/06/2016 |
+--------------------+----------------------------------+-------------------+
|Descricao.: Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA      |
|            monta a janela com a regua de processamento.                   |
+---------------------------------------------------------------------------+

*/
Static Function fProcessa( oSelf )

Local lSetCentury := __SetCentury( "on" )
Local cPath       := AllTrim( GetTempPath() )
Local nTotReg     := 0
Local cNomeArq    := ""

Local cLin
Local nPos, nX

Local lErrInc   := .F.
Local lErrExc   := .F.

Private nHdl

/*+----------------------------------------------------------------------+
  | PERGUNTES:                                                           |
  | mv_par01 - Filial De ?              -                                |
  | mv_par02 - Filial Ate ?             -                                |
  | mv_par03 - Matricula De ?           -                                |
  | mv_par04 - Matricula Ate ?          -                                |
  | mv_par05 - Centro Custo De ?        -                                |
  | mv_par06 - Centro Custo Ate ?       -                                |
  | mv_par07 - Situacao ?               -                                |
  +----------------------------------------------------------------------+
*/


cNomeArq  := CriaTrab(,.F.) + ".CSV"

// Cria Arquivo Texto
cPath    := cPath + If(Right(cPath,1) <> "\","\","")
cNomeArq := cPath + cNomeArq
nHdl     := fCreate( cNomeArq )

If nHdl == -1
   MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf

SRA->(dbSetOrder( 1 ))

// Monta Query Principal
MsAguarde( {|| fMtaQuery()}, "Processando...", "Selecionado Registros no Banco de Dados..." )

dbSelectArea( "WSRA" )
Count To nTotReg
If nTotReg <= 0
   Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
   Return
EndIf

dbGoTop()
oSelf:SetRegua1( RecCount() )

// Grava Cabecalho do Arquivo Texto
fGrvCab()

Do While !Eof()
   oSelf:IncRegua1( WSRA->(FILIAL + " - " + MATRICULA + " - " + NOME) )
   If oSelf:lEnd 
      Break
   EndIf
   
   SRA->(dbSeek( WSRA->(FILIAL + MATRICULA) ))
   
   cLin := '="' + WSRA->FILIAL + '"'                          + cSep	// 01 - Filial
   cLin += '="' + WSRA->MATRICULA + '"'                       + cSep	// 02 - Matricula
   cLin += fFrmtNom(Alltrim(WSRA->NOME))                      + cSep	// 03 - Nome
   cLin += Dtoc(WSRA->DATA_NASCIMENTO)                        + cSep	// 04 - Data de Nascimento
   cLin += If(Alltrim(WSRA->SEXO)="M","Masculino","Feminino") + cSep // 05 - Sexo
   cLin += Transform(WSRA->CPF,'@R 999.999.999-99')           + cSep	// 06 - CPF
   cLin += Dtoc(WSRA->ADMISSAO)                               + cSep	// 07 - Data de Admissao
   cLin += Dtoc(WSRA->DEMISSAO)                               + cSep	// 08 - Data de Demissao
   cLin += Alltrim(WSRA->DESC_FUNCAO)                         + cSep	// 09 - Descri็ใo Fun็ใo

   cLin += cEol
   fGravaTxt( cLin )
   dbSkip()
EndDo 

If !lSetCentury
   __SetCentury( "off" )
EndIf

WSRA->(dbCloseArea())  
fClose( nHdl )

// Integra Planilha ao Excel
MsAguarde( {|| fStartExcel( cNomeArq )}, "Aguarde...", "Integrando Planilha ao Excel..." )



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGPEM02   บAutor  ณMicrosiga           บ Data ณ  01/25/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaTxt( cLin )

 If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
    If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
       Return
    Endif
 Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPCNF01  บAutor  ณMicrosiga           บ Data ณ  12/13/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGrvCab()

Local cLin
 
cLin := "FILIAL" + cSep					    // 01 - Filial
cLin += "MATRICULA" + cSep			   		// 02 - Matricula
cLin += "NOME" + cSep			   			// 03 - Nome
cLin += "DATA_NASCIMENTO" + cSep			// 04 - Data de Nascimento
cLin += "SEXO" + cSep			            // 05 - Sexo
cLin += "CPF" + cSep			   			// 06 - CPF
cLin += "ADMISSAO" + cSep				    // 07 - Data de Admissao
cLin += "DEMISSAO" + cSep			        // 08 - Data de Demissao
cLin += "DESC_FUNCAO" + cSep                // 09 - Desci็ใo Fun็ใo
cLin += cEol
fGravaTxt( cLin )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPCNF01  บAutor  ณMicrosiga           บ Data ณ  12/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fStartExcel( cNomeArq )

 If !ApOleClient( 'MsExcel' )
    MsgAlert( 'MsExcel nao instalado' )
 Else
    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open( cNomeArq ) // Abre uma planilha
    oExcelApp:SetVisible(.T.)
    oExcelApp:Destroy()
 EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTLGPEM23  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery()

Local nX       := 0
Local cQuery   := ""
Local cSituac  := ""
Local cModoSRJ := fChkModo("SRJ")

For nX := 1 To Len(mv_par07)
    cSituac += If( Substr(mv_par07, nX, 1) <> "*", "'" + Substr(mv_par07, nX, 1) + "',", "") //-> Situacoes.
Next
cSituac  := Substr(cSituac, 1, Len(cSituac) -1)

cQuery += " SELECT RA_FILIAL  AS FILIAL,"
cQuery += "        RA_MAT     AS MATRICULA,"
cQuery += "        RA_NOME    AS NOME,"
cQuery += "        RA_NASC    AS DATA_NASCIMENTO,"
cQuery += "        RA_SEXO    AS SEXO,"
cQuery += "        RA_CIC     AS CPF,"
cQuery += "        RA_ADMISSA AS ADMISSAO,"
cQuery += "        RA_DEMISSA AS DEMISSAO,"
cQuery += "        RJ_DESC    AS DESC_FUNCAO"
cQuery += " FROM " + RetSqlName( "SRA" ) + " SRA"

If cModoSRJ = "E"
   cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRJ" ) + " SRJ ON SRJ.RJ_FILIAL = SRA.RA_FILIAL AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "
Else
   cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRJ" ) + " SRJ ON SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "
EndIf

cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "       SRJ.D_E_L_E_T_ <> '*' AND "
cQuery += "       RA_FILIAL  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "       RA_MAT     BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
cQuery += "       RA_CC      BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "

If !Empty(mv_par08) .And. !Empty(mv_par09)
   cQuery += "    RA_ADMISSA BETWEEN '"+DtoS(mv_par08)+"' AND '"+DtoS(mv_par09)+"' AND "
EndIf

cQuery += "       RA_SITFOLH IN("+cSituac+") "
cQuery := ChangeQuery( cQuery )

TCQuery cQuery New Alias "WSRA"
TcSetField( "WSRA" , "DATA_NASCIMENTO", "D", 08, 0 )
TcSetField( "WSRA" , "ADMISSAO",        "D", 08, 0 )
TcSetField( "WSRA" , "DEMISSAO",        "D", 08, 0 )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAsrPerg  บAutor  ณMicrosiga           บ Data ณ  11/21/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas do Sistema.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAsrPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()

aAdd(aRegs,{ cPerg,'01','Filial De ?              ','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?             ','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
aAdd(aRegs,{ cPerg,'03','Matricula De ?           ','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?          ','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De ?        ','','','mv_ch5','C',09,0,0,'G','           ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?       ','','','mv_ch6','C',09,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
aAdd(aRegs,{ cPerg,'07','Situacoes ?              ','','','mv_ch7','C',05,0,0,'G','fSituacao  ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'08','Admissao De ?            ','','','mv_ch8','D',08,0,0,'G','           ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'09','Admissao Ate ?           ','','','mv_ch9','D',08,0,0,'G','           ','mv_par09','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })

 //U_fDelSx1( cPerg, "11" )

ValidPerg(aRegs,cPerg)

Return


Static Function fChkModo(cXAlias)
/*+-------------------+----------------------------------------+
  | fChkModo(cXAlias) | Retorna Modo de Acesso de uma tabela.  |
  +-------------------+----------------------------------------+
  | 08/07/2013        | Alexandre Alves da Silva.              |
  +-------------------+----------------------------------------+
*/

Local nRegX2 := SX2->( Recno() )
Local cXModo := ""

dbSelectArea("SX2")
dbSeek(cXAlias)

cXModo := SX2->X2_MODO

SX2->( dbGoTo(nRegX2) )

Return(cXModo)



/*+-------------------+-----------------------------------------------------------------------------+
  | fFrmtNom(cNome)   | Formata nome do colaborador, retornando apenas o primeiro e o ultimo nome.  |
  +-------------------+-----------------------------------------------------------------------------+
  | 08/07/2013        | Alexandre Alves da Silva.                                                   |
  +-------------------+-----------------------------------------------------------------------------+
*/
Static Function fFrmtNom(cNome)

Local nPsUltBc := 0 //Posicao do ultimo espaco em branco do nome.
Local nPsPrtBc := 0 //Posicao do primeiro espaco em branco do nome.
Local nX       := 0

For nX:= 1 To Len(cNome)
    nPsPrtBc := If( (Empty(nPsPrtBc) .And. Substr(cNome,nX,1)=" "), nX, nPsPrtBc )
    nPsUltBc := If( Substr(cNome,nX,1)=" ", nX, nPsUltBc )
Next

cNome := Substr( cNome, 1, (nPsPrtBc -1) ) + " " + Substr( cNome, (nPsUltBc+1), (Len(cNome) - nPsUltBc) ) //-> Primeiro e Ultimo nome.


Return(cNome)
