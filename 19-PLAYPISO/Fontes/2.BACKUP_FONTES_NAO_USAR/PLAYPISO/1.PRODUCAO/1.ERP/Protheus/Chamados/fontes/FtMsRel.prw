/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FTMSREL   ºAutor  ³Microsiga           º Data ³  08/15/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para incluir novas tabelas na funcao      º±±
±±º          ³ MSDOCUMENT                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico OMNILINK                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FtMsRel() 

Local aRet := {} 
Local aChave 	:= {} 
Local aChave2 	:= {} 
Local aChave3 	:= {} 
Local aChave4 	:= {} 
Local bMostra 
Local bMostra2 
Local bMostra3
Local bMostra4 
Local cTabela 	:= "" 
Local cTabela2 	:= "" 
Local cTabela3 	:= "" 
Local cTabela4 	:= "" 

cTabela  := "SCJ"        // Tabela do usuario
cTabela2 := "PZ8" // Tabela do usuario 
cTabela3 := "PZM" // Tabela do usuario 
cTabela4 := "PZN" // Tabela do usuario 

aChave  := {"CJ_NUM"} // Campos que compoe a chave na ordem. Nao passar filial (automatico)
aChave2 := {"PZ8_COD"} // Campos que compoe a chave na ordem. Nao 
aChave3 := {"PZM_NROATI"} // Campos que compoe a chave na ordem. Nao 
aChave4 := {"PZN_NROATI"} // Campos que compoe a chave na ordem. Nao 

// passar filial (automatico) 

bMostra  := { || OemToAnsi("Ordem de Serviço No. :")+SCJ->CJ_NUM  } // Bloco de codigo a ser exibido. Funcoes do sistema para. Identificar o registro 
bMostra2 := { || "CODIGO: " + PZ8->PZ8_COD + " - DESCRICAO: " + PZ8->PZ8_DESCRE } // Bloco de codigo a ser exibido 

bMostra3 := { || "CODIGO: " + PZM->PZM_NROATI + " - DESCRICAO: " + PZM->PZM_DESCRI } // Bloco de codigo a ser exibido 
bMostra4 := { || "CODIGO: " + PZN->PZN_NROATI + " - DESCRICAO: " + PZN->PZN_DESCRI } // Bloco de codigo a ser exibido 

// funcoes do sistema para 
// identificar o registro 

AAdd( aRet, { cTabela, aChave, bMostra } ) 
AAdd( aRet, { cTabela2, aChave2, bMostra2 } ) 
AAdd( aRet, { cTabela3, aChave3, bMostra3 } ) 
AAdd( aRet, { cTabela4, aChave4, bMostra4 } ) 

Return( aRet ) 
                       
