#include 'protheus.ch'
#Include "FILEIO.CH"
//Serviços
#Define ENV_PO        "EPO"
#Define ENV_DI        "EDI"
#Define REC_NUMERARIO "RNU"
#Define REC_DESPESAS  "RDE"
#Define REC_NF        "RNF"
//Status
#Define GERADOS       "GER"
#Define ENVIADOS	    "ENV"
#Define RECEBIDOS     "REC"
#Define INTEGRADOS    "INT"
#Define REJEITADOS    "REJ"


//-------------------------------------------------------------------
/*/{Protheus.doc} FIEICINT
Classe para sobrescrever métodos da classe EICIDESPAC do fonte EICEI100
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class FIEICINT FROM EICIDESPAC

   method new() constructor
   method ReceberArq()
   method ProcessarArq()
   method readCustom()
   method gravaAdic() 

   data aLineVL as array
   data aLineDP as string

endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new   
Método construtor 
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new (cName, cSrvName, cActName, cTreeSrvName, cTreeAcName, cPanelName, bOk, bCancel, cIconSrv, cIconAction) class FIEICINT
   _Super:New(cName, cSrvName, cActName, cTreeSrvName, cTreeAcName, cPanelName, bOk, bCancel, cIconSrv, cIconAction)
   self:aLineVL := {}
   self:aLineDP := {}
return

//-------------------------------------------------------------------
/*/{Protheus.doc} ReceberArq
Método responsável pelo recebimento do arquivo, método sobrescrito
para retirada de funções visuais.
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
@param   cWork, character, tabela temporária
@param   cServico, character, serviço do processamento (numerario, despesa)
@param   cMsgError, character, mensagem de erro
@return  logical, retorno do processamento
/*/
//-------------------------------------------------------------------
method  ReceberArq(cWork,cServico,cFileTxt,cMsgError) Class FIEICINT
Local lRet      := .F.
Local nInc      := 0
Local cDir      := ""
Local cFileDtHr := ""
Local cFileOK   := ""
local aStrFile  := {}

//Local cStatus   := ""
Local aDesp     := {}
Begin Sequence 

   Do Case
      Case cServico == REC_NUMERARIO 
         cDir := Self:cDirNumerario
      Case cServico == REC_DESPESAS 
         cDir := Self:cDirDespesas
      Case cServico == REC_NF 
         cDir := Self:cDirNF  
   End Case


   If Empty(cDir)
      cMsgError +="[EICIDESPAC]"+"Defina um diretorio local para importação de arquivos do serviço."
      Break
   EndIf
   
   // Guardando todos os arquivos com extensao .TXT do diretorio definido pelo usuario para recebimento
   aFiles := {{cFileTxt}} //Directory(cDir + "*.txt")
   If Empty(aFiles)
      cMsgError +="[EICIDESPAC]"+"Não existe arquivos para ser recebidos no diretorio local."
      Break
   Endif

   For nInc := 1 To Len(aFiles)

      // Guarda o caminho completo
      cFileRec := cDir + AllTrim(aFiles[nInc][1])
      
      //Leitura do arquivo de DI para verificar 
      if  cServico == REC_DESPESAS .and. file(cFileRec)
         self:readCustom(cFileRec)
      endif

      If Upper(Self:cDirRecebidos) $ Upper(cFileRec)      // GFP - 12/04/2013
         cMsgError +="[EICIDESPAC]"+"O diretório informado em 'Configurações' não é válido." + CRLF +;
                 "Informe um diretório local para importação de arquivos do serviço."+ CRLF
         Break
      EndIf

      // Guardando somente o nome do arquivo
      Self:cFile := aFiles[nInc][1]

      // Verificando se o arquivo ja foi recebido
      EWZ->(DbSetOrder(2))
      If EWZ->(DbSeek(xFilial("EWZ")+AvKey(cServico,"EWZ_SERVIC")+AvKey(Self:cFile,"EWZ_ARQUIV")))
         cMsgError +="[EICIDESPAC]"+"O arquivo " + AllTrim(Self:cFile) + " informado já foi recebido."+ CRLF
         Break
      EndIf

      aStrFile := Strtokarr2(  Self:cFile , "_", .T.)
      cServico := AvKey(cServico,"EWZ_SERVIC")

      //O processo de DI só pode ser processado apenas uma vez por processo.
      if cServico == "RDE" .and. !validProc(AvKey(alltrim(upper(aStrFile[3])),"EWZ_HAWB"), cServico)
         cMsgError +="[EICIDESPAC]"+"O arquivo RDI do processo " + alltrim(upper(aStrFile[3]))+ " já foi recebido e integrado."+ CRLF
         Break
      endif

      // Salvando do local para o servidor
      If !__COPYFILE(cFileRec, Self:cDirRecebidos+aFiles[nInc][1])
         cMsgError +="[EICIDESPAC]"+StrTran("Erro ao copiar o arquivo '###' para o diretório. Não será possível prosseguir.", "###", Self:cDirRecebidos)+ CRLF
         Break
      EndIf


      // Get dos dados do despachante, somente para o serviço numerario e despesas
      If cServico == REC_NUMERARIO .Or. cServico == REC_DESPESAS
         aDesp := GetDespachante(cServico,Self:cDirRecebidos+aFiles[nInc][1], @cMsgError)
         If Empty(aDesp)
            Break
         EndIf
      EndIf

      /*Renomeando a extensao do arquivo local
      cFileOK := Left(cFileRec, Len(cFileRec) - 4) + ".OK"
      If !(FRename(cFileRec, cFileOK) == 0)
         cMsgError +="[EICIDESPAC]"+"Não foi possível renomear o arquivo "+AllTrim(cFileRec)+" para " + AllTrim(cFileOK) + "."+ CRLF
      EndIf*/

      // Gravando na tabela de controle da nova integração com despachante
      If !Self:GravaEWZ(aFiles[nInc][1], cServico, RECEBIDOS, aDesp)
         Break
      EndIf

      lRet := .T.
   Next

End Sequence

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ProcessarArq
Método responsável pelo processamento do arquivo, método sobrescrito
para retirada de funções visuais.
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
@param   cWork, character, tabela temporária
@param   cServico, character, serviço do processamento (numerario, despesa)
@param   cMsgError, character, mensagem de erro
@return  logical, retorno do processamento
/*/
//-------------------------------------------------------------------
Method ProcessarArq(cWork,cServico, cMsgError) Class FIEICINT

Local lRet     := .T.
Local nOpcao   := 0
Local aDesp    := {}
Local cDestino := ""
Local cStatus  := ""
Local cFileOld := ""
local aAreaEWZ := (cWork)->(getArea())
local aStrFile := {}
local aArea2EWZ := {}
Private cFileEICEI100 := ""  // Variavel para guardar o nome do txt da nova integração para ser tratada na função IN100Integ()
Private cStatusEI100  := Nil // Variavel para verificar o status (aceito ou rejeitado) do arquivo na função IN100Integ()
Private lPrvEI100     := .F. // Variavel para verificar se é .T. - para integração ou .F. - para previa na função IN100Integ()
public cMsgEI100     := ""

Begin Sequence

   Do Case
      Case cServico == REC_NUMERARIO .Or. cServico == REC_DESPESAS
         aDesp  := {(cWork)->EWZ_CODDES,(cWork)->EWZ_NOMEDE,(cWork)->EWZ_EMAIL}
         nOpcao := 10
         If cServico == REC_NUMERARIO
            nOpcao := 13
         EndIf
      Case cServico == REC_NF
         aDesp  := {(cWork)->EWZ_CODDES,(cWork)->EWZ_NOMEDE,(cWork)->EWZ_EMAIL}
         nOpcao := 12                  
      Otherwise
         Return Nil
   EndCase

   If Empty((cWork)->EWZ_ARQUIV)
      cMsgError +="[EICIDESPAC]"+"Selecione um registro para ser processado."+CRLF
      Break
   Else 
      cFileEICEI100 := (cWork)->EWZ_ARQUIV
   EndIf

   // Alterando a extensao do arquivo na variavel para que seja possivel mover o arquivo // RRV - 04/10/2012 - Ajuste para gerar arquivo com extensão minuscula.
   cFileOld := StrTran((cWork)->EWZ_ARQUIV, ".txt", ".old") //RRV - 27/09/2012
   EWZ->(DbSetOrder(2))
   If EWZ->(DbSeek(xFilial("EWZ") + AvKey(cServico,"EWZ_SERVIC") + AvKey(cFileOld,"EWZ_ARQUIV")))

      lRet := EWZ->EWZ_STATUS == REJEITADOS

   EndIf

   If EWZ->(DbSeek(xFilial("EWZ") + AvKey(cServico,"EWZ_SERVIC") + AvKey(cFileEICEI100,"EWZ_ARQUIV")))
      aStrFile := strTokArr2((cWork)->EWZ_ARQUIV,"_", .F.)
      aArea2EWZ  := EWZ->(getArea())
      if len(aStrFile) > 3
         cNumHawb := UPPER(aStrFile[3])
         reclock("EWZ", .F.)
         EWZ->EWZ_HAWB := cNumHawb
         EWZ->(msUnlock())
      endif
      
      aSize(aStrFile,0)
   endif


   If lRet
      //--------------------------------------------------------
      //Realiza a leitura e integração dos arquivos pelo padrão
      //--------------------------------------------------------
      lRet := EICIN100(nOpcao,,.T., .T.)

      If lRet
         cDestino := Self:cDirProcessados+cFileOld
         cStatus  := INTEGRADOS

         //----------------------------------
         //Grava volumes e canal no processo
         //----------------------------------
         if cServico == REC_DESPESAS
            restArea(aArea2EWZ)
            aSize(aArea2EWZ,0)
            self:gravaAdic()
         endif

      Else
         cDestino := Self:cDirRejeitados+cFileOld
         cStatus  := REJEITADOS
         cMsgError += "[EICIDESPAC]"+cMsgEI100+CRLF
      EndIf

      If !CopiaArq(Self:cDirRecebidos+cFileOld,cDestino,.T., @cMsgError)
         Break
      EndIf

      //Retorna no registro do processamento do arquivo
      restArea(aAreaEWZ)     

      // Gravando na tabela de controle da nova integração com despachante
      If !Self:GravaEWZ((cWork)->EWZ_ARQUIV, cServico, cStatus, aDesp)
         Break
      EndIf

      

   EndIf

End Sequence

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} readCustom
Realiza a leitura do arquivo antes para verificar a linha de volumes
e canal
@author  marcio.katsumata
@since   24/10/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method readCustom(cFile) Class FIEICINT

   local cLineRead as character //Linha do arquivo
   local nHandle   as numeric

   nHandle := FT_FUse(cFile)

   If nHandle <= 0 
     Return
   Endif

   While !(FT_FEOF())
      cLineRead := FT_FREADLN()

      //Linhas de Volume
      if substr(cLineRead,1,2) == "VL"
         aadd(self:aLineVL, strTokArr2(cLineRead,";"))
      //Linhas de canal 
      elseif substr(cLineRead,1,2) == "DP"
         self:aLineDP := strTokArr2(cLineRead, ";", .F.)
      endif
      FT_FSKIP( )
   Enddo

   FT_FUSE( )

return

//-------------------------------------------------------------------
/*/{Protheus.doc} gravaAdic
Grava informações adicionais no processo (tabela SW6 e EIH)
@author  marcio.katsumata
@since   24/10/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method gravaAdic() class FIEICINT
   local nTotalVol as numeric
   local nIndVol   as numeric
   local nVolAtu   as numeric
   local cCodEmb   as character
   local cCanalW6  as character

   //---------------------
   //Inicializa variáveis
   //---------------------
   nTotalVol := 0
   cCodEmb   := ""
   nVolAtu   := 0

   dbSelectArea("EIH")
   EIH->(dbSetOrder(1))

   dbSelectArea("SW6")      
   SW6->(dbSetOrder(1))   


   /*
   Arquivo da DI
   #DPPOJ; SETOR ALFANDEGADO; ARMAZEM; CANAL (de 1 a 4)
   #VLnn; REF POJ; TIPO EMB.; QTDE;

   self:aLineVL array multidimensional
   3 posições por linha
   [1]VL + numero da linha + Numero do processo
   [2]Código da embalagem
   [3]Quantidade
   
   self:aLineDP
   [1]DP+numero do processo
   [2]Setor alfandegado
   [3]Armazem
   [4]Canal
   */
   
   BEGIN TRANSACTION


      for nIndVol := 1 to len(self:aLineVL)
         if len(self:aLineVL[nIndVol]) == 3
            nVolAtu := val(self:aLineVL[nIndVol][3])
         endif
         //--------------------------------
         //Checagem do código da embalagem
         //--------------------------------
         if !empty(self:aLineVL[nIndVol][2])
            cCodEmb   := strZero(val(self:aLineVL[nIndVol][2]), tamSx3("EIH_CODIGO")[1])
            nTotalVol += nVolAtu

            if !EIH->(dbSeek(xFilial("EIH")+padr(EWZ->EWZ_HAWB, tamSx3("EIH_HAWB")[1])+cCodEmb))
               reclock("EIH", .T.)
               EIH->EIH_FILIAL := xFilial("EIH")
               EIH->EIH_HAWB   := EWZ->EWZ_HAWB
               EIH->EIH_QTDADE := nVolAtu
               EIH->EIH_CODIGO := cCodEmb
               EIH->(msUnlock())
            endif

         endif

      next nIndVol
      //-----------------------------------
      //Preenchimento do canal e volume
      //-----------------------------------
      if SW6->(dbSeek(xFilial("SW6")+padr(EWZ->EWZ_HAWB, tamSx3("W6_HAWB")[1])))
         reclock("SW6", .F.)
         if len(self:aLineDP) == 4
            /*
               DE/PARA SYSFIORDE
               1	AMARELO
               2	CINZA
               3	VERDE
               4	VERMELHO
               1=Vermelho;2=Amarelo;3=Verde;4=Cinza
            */
            DO CASE 
               CASE self:aLineDP[4] == '1'
                  cCanalW6 := '2'
               CASE self:aLineDP[4] == '2'
                  cCanalW6 := '4'
               CASE self:aLineDP[4] == '3'   
                  cCanalW6 := '3'
               CASE self:aLineDP[4] == '4'   
                  cCanalW6 := '1'
            ENDCASE 

            SW6->W6_CANAL  := cCanalW6
            
         endif
         if !empty(nTotalVol)   
            SW6->W6_VOLUME := cValToChar(nTotalVol)
         endif
         SW6->(msUnlock())
      endif

   END TRANSACTION

   aSize(self:aLineVL,0)
   aSize(self:aLineDP,0)
   
return

//-------------------------------------------------------------------
/*/{Protheus.doc} GetDespachante
Sobrecrito a função do fonte eicei100.prw para retirar funções visuais
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
@param   cServico, character, serviço
@param   cArquivo, character, nome do arquivo
@param   cMsgError, character, mensagem de erro
@return  array, {codigo despachante, nome despachante, e-mail despachante}
/*/
//-------------------------------------------------------------------
Static Function GetDespachante(cServico, cArquivo,cMsgError)
Local aRet := {}
Local hFile      := 0
Local nTamArq    := 0
Local nPos       := 0
Local nCpo       := 0
Local cBuffer    := ""
Local cCodDesp   := ""
Local cNomeDesp  := ""
Local cEmailDesp := ""
Local cQuery     := ""
Local nOldArea   := SELECT()
Private aEstruDef := {}
Private lMV_GRCPNFE:= EasyGParam("MV_GRCPNFE",,.F.)

Begin Sequence

   // Abrindo o arquivo para buscar o código do despachante
   hFile:= FOpen(cArquivo, FO_READ)
   If hFile == -1
      cMsgError +="[EICIDESPAC]"+StrTran("O arquivo 'XXX' não pode ser aberto.","XXX", cArquivo)+ CRLF
      Break
   EndIf

   //Lê o tamanho do arquivo e retorna à posição inicial
   nTamArq := FSeek(hFile, 0, FS_END)
   FSeek(hFile, 0)
   If FRead(hFile, @cBuffer, nTamArq) <> nTamArq
      cMsgError +="[EICIDESPAC]"+StrTran("O arquivo 'XXX' não pode ser aberto.","XXX", cArquivo)+ CRLF
      Break
   EndIf

   FCLOSE(hFile)

   // Guardando o código do despachante de acordo com o arquivo recebido do despachante
   // Obs: o código do despachante se localiza na posição 37 do arquivo txt.
   nPos := 1
   If cServico == REC_NUMERARIO 
      In100DefEstru("NU")
      nCpo := aScan(aEstruDef,{|X| X[1] == "NNUDESP" })         
   ElseIf cServico == REC_DESPESAS
      In100DefEstru("DH")
      nCpo := aScan(aEstruDef,{|X| X[1] == "NDHDESP" })
   EndIf
   aEval(aEstruDef,{|X| nPos += X[3] },,nCpo-1)
      
   cCodDesp := SubStr(cBuffer,nPos,aEstruDef[nCpo][3])
   SY5->(DbSetOrder(1))
   ChkFile("SYU")
   If !Empty(cCodDesp) .And. SY5->(DbSeek(xFilial("SY5")+AvKey(cCodDesp,"Y5_COD")))
      cNomeDesp   := SY5->Y5_NOME
      cEmailDesp  := SY5->Y5_EMAIL
   ElseIf Len(SY5->Y5_COD) > aEstruDef[nCpo][3] .And. Len(SY5->Y5_COD) == Len(SYU->YU_EASY)

      If Select("REFDESPROC") > 0
         REFDESPROC->(DbCloseArea())
      EndIf      
      cQuery := "SELECT * FROM "+RetSQLName("SY5")+" SY5"
      cQuery += " INNER JOIN "+RetSQLName("SYU")+" SYU"
      cQuery += " ON SY5.Y5_FILIAL = SYU.YU_FILIAL"
      cQuery += " AND SY5.Y5_COD = SYU.YU_EASY"
      cQuery += " AND SYU.YU_GIP_1 = '"+cCodDesp+"'"
      cQuery += " AND SYU.YU_TIP_CAD = '5'" //LRS - 01/10/2017
      cQuery += " AND SY5.D_E_L_E_T_ = ' '"
      cQuery += " AND SYU.D_E_L_E_T_ = ' '" 
      
      EasyWkQuery(cQuery,"REFDESPROC",,,)
      
      If REFDESPROC->(RecCount()) == 0
         cMsgError +="[EICIDESPAC]"+"Não foi encontrado o código do despachante na relação DE/PARA."+CHR(13)+CHR(10)+;
                     "Verifique as informações na tabela e também o tamanho dos campos relacionados!"+ CRLF
         Break        
      ElseIf REFDESPROC->(RecCount()) > 1
         cMsgError +="[EICIDESPAC]"+"Foi encontrada mais de uma referência para este despachante "+CHR(13)+CHR(10)+;
                     "na tabela DE/PARA. Ajuste a referência na tabela para prosseguir!"+ CRLF
         Break
      Else
         cCodDesp    := REFDESPROC->Y5_COD
         cNomeDesp   := REFDESPROC->Y5_NOME
         cEmailDesp  := REFDESPROC->Y5_EMAIL      
      EndIf
      REFDESPROC->(DBCloseArea())
      DBSELECTAREA(nOldArea)  
   Else
      cMsgError +="[EICIDESPAC]"+"Não foi encontrado o código do despachante."+ CRLF
      Break
   EndIf
      
   aRet := {cCodDesp, cNomeDesp, cEmailDesp}

End Sequence

Return aClone(aRet)



//-------------------------------------------------------------------
/*/{Protheus.doc} CopiaArq
Sobrescrito a função do fonte eicei100.prw para retirada de funções
visuais.
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
@param   cArqOri, character, nome do arquivo origem
@param   cArqDest, character, nome do arquivo destino
@param   lDelArqOri, logical, remove o arquivo origem?
@param   cMsgError, character, mensagem de erro
@return  logical, copia do arquivo ok?
/*/
//-------------------------------------------------------------------
Static Function CopiaArq(cArqOri,cArqDest,lDelArqOri,cMsgError)
Local lRet := .F.
Default lDelArqOri := .F.

Begin Sequence

   If !File(cArqOri)
      cMsgError +="[EICIDESPAC]"+StrTran("O arquivo '###' não foi encontrado. Não será possível executar a rotina.", "###", cArqOri)+CRLF
      Break
   EndIf
   
   __CopyFile(cArqOri, cArqDest)
   
   If !File(cArqDest)
      cMsgError +="[EICIDESPAC]"+StrTran("O arquivo '###' não foi encontrado. Não será possível executar a rotina.", "###", cArqDest)+CRLF
      Break
   EndIf

   If lDelArqOri
      If FErase(cArqOri) <> 0
         cMsgError +="[EICIDESPAC]"+StrTran("O arquivo '###' não foi excluído.", "###", cArqOri)+CRLF
         Break
      EndIf
   EndIf
   
   lRet := .T.

End Sequence

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} validProc
Valida se o serviço já foi processado.
@author  marcio.katsumata
@since   31/01/2019
@version 1.0
@param   cProc, character, numero do processo
@param   cServ, character, serviço
@return  logical, não foi processado = .T.
                  foi processado     = .F.
/*/
//-------------------------------------------------------------------
static function validProc(cProc, cServ)
   local cAliasEWZ as character

   cAliasEWZ := getNextAlias()

   beginSql alias cAliasEWZ
      SELECT COUNT(*) QUANTIDADE 
      FROM %table:EWZ% EWZ
      WHERE EWZ.EWZ_SERVIC = %exp:cServ% AND
            EWZ.EWZ_HAWB   = %exp:cProc% AND
            EWZ.EWZ_STATUS = 'INT' AND
            EWZ.%notDel%
   endSql

   if (cAliasEWZ)->(!eof())
      lVldProc := (cAliasEWZ)->QUANTIDADE == 0
   endif
   
   (cAliasEWZ)->(dbCloseArea())

return lVldProc

