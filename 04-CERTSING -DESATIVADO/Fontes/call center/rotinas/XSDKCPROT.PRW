#include "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | XSDKCProt    | Autor | Gustavo Prudente | Data | 03.11.2014 |
|-------------------------------------------------------------------------|
| Descricao | Copia numero de protocolo de atendimento do service-desk.   |
|-------------------------------------------------------------------------|
| Uso       | Tela de atendimento do modulo Service-Desk                  |
---------------------------------------------------------------------------
*/
User Function XSDKCProt

Local cProtocolo := M->ADE_CODIGO 

// Desabilita tecla F7 para evitar chamada recursiva
SetKey( VK_F7, { || } )
                                
// Coloca numero de protocolo na area de transferencia
CopyToClipboard( cProtocolo )
  
Aviso( "Copiar Protocolo", "Protocolo " + cProtocolo + " copiado para área de transferência.", { "&Sair" }, 1 )

// Habilita novamente a tecla F7 com a chamada da funcao de copia do protocolo
SetKey( VK_F7, { || u_XSDKCProt() } )

Return Nil