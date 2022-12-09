#include "rwmake.ch"
//
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Programa ...: LIQUIDO                             Modulo : SIGAGPE     //
//                                                                        //
// Descricao ..: Reprocessamento do Arquivo de Liquidos de Funcionarios   //
//                                                                        //
// Observacao .: Os arquivos processados serao em formato texto           //
//                                                                        //
////////////////////////////////////////////////////////////////////////////
//

///////////////////////
User Function Liquido()
///////////////////////
//
SetPrvt("CALIAS,NRECORD,CORDER,CPERG,CMSG,CTIT")
SetPrvt("CTIP,NREGS,LEND,BBLOCO,CNL,CARQ")
SetPrvt("CNUMBCO,CCAMLIQ,NTAM,CNOMARQ,ACAMPOS,NHDL")
SetPrvt("XREGISTRO,CLINHA,CARQLIQ,SALIAS,AREGS,I,J")
//
cAlias  := Alias()           // Salvar o Contexto em Utilizacao
nRecord := Recno()
cOrder  := IndexOrd()
//
cPerg   := "LIQUID"          // Pergunta Padrao Especificada
//
PgLiquido()
//
If !Pergunte(cPerg, .T.)
   Return (.T.)
Endif
//
If !MsgBox("Confirma o Processamento do Arquivo", "Liquido de Funcionarios", "YESNO")
   Return (.T.)
Endif
//
nRegs  := 0                  // Numero Total de Registros Processados
lEnd   := .F.
bBloco := {|lEnd| LiquidoTxt()}
//
MsAguarde(bBloco, "Aguarde", "Processando ...", .T.)
//
DbSelectArea(cAlias)
DbSetOrder(cOrder)
DbGoTo(nRecord)
//
Return (.T.)

////////////////////////////
Static Function LiquidoTxt()
////////////////////////////
//
cNL     := Chr(13) + Chr(10)           // Caracteres p/ "Nova Linha"
cArq    := AllTrim(Mv_Par01)           // Arquivo Texto de Liquidos
cNumBco := AllTrim(Mv_Par02)           // Numero do Banco
cCamLiq := AllTrim(Mv_Par03)           // Caminho para a Copia do Arquivo
nTam    := 200                         // Tamanho do Registro
cArqLiq := cCamLiq + cArq              // Arquivo de Saida de Liquidos
//
If !Empty(cArq)
   //
   cNomArq := ""                       // Criar Arquivo e Indices Temporarios
   aCampos := {}
   //
   Aadd(aCampos, {"REGISTRO", "C", 200, 0})
   //
   cNomArq := CriaTrab(aCampos, .T.)
   DbUseArea(.T.,, cNomArq, "TRB", .T., .F.)
   //
   Append From &cArq SDF
   //
   If File(cArqLiq)
      Delete File (cArqLiq)
   Endif
   //
   nHdl := Fcreate(cArqLiq)            // Criacao do Arquivo Texto
   //
   DbSelectArea("TRB")                 // Arquivo Temporario
   DbGoTop()
   //
   While TRB->(!Eof())
         //
         If Empty(TRB->REGISTRO)       // Desprezar "Linhas" em Branco
            TRB->(DbSkip())
            Loop
         Endif
         //
         xREGISTRO := Substr(TRB->REGISTRO, 1, nTam)
         //
         cLinha := xREGISTRO + cNL
         //
         Fwrite(nHdl, cLinha, Len(cLinha))       // Gravacao no Arquivo Texto
         //
         MsProcTxt("Processando a Sequencia : " + Substr(xREGISTRO, 195, 006))
         nRegs := nRegs + 1
         //
         TRB->(DbSkip())
         //
   Enddo
   //
   Fclose(nHdl)
   //
   DbSelectArea("TRB")                 // Deleta o Arquivo Temporario
   DbCloseArea()
   Delete File (cNomarq + ".DBF")
   //
Endif
//
MsProcTxt("Numero de Registros Processados : " + Str(nRegs, 8))
//
MsgBox("Geracao do Arquivo de Liquidos Concluida", "Liquido de Funcionarios", "INFO")
//
Return (.T.)

///////////////////////////
Static Function PgLiquido()
///////////////////////////
//
sAlias := Alias()
cPerg  := Padr(cPerg, LEN(SX1->X1_GRUPO))
aRegs  := {}
//
DbSelectArea("SX1")
DbSetOrder(1)
//
Aadd(aRegs,{cPerg,"01","Arq. de Liquidos   ?","","","mv_ch1","C",30,0,0,"G","",;
    "Mv_Par01","","","","LIQUIDO.TXT","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Numero do Banco    ?","","","mv_ch2","C",03,0,0,"G","",;
     "Mv_Par02","","","","999","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Caminho para Copia ?","","","mv_ch3","C",30,0,0,"G","",;
    "Mv_Par03","","","","\DADOSADV\","","","","","","","","","","","","","","","","","","","","","",""})
//
For i := 1 To Len(aRegs)
    //
    If !DbSeek(cPerg + aRegs[i, 2])
       //
       Reclock("SX1", .T.)
       For j := 1 To FCount()
           FieldPut(j, aRegs[i, j])
       Next
       MsUnlock()
       //
    Endif
    //
Next
//
DbSelectArea(sAlias)
//
Return (.T.)
