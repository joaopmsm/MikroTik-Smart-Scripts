###############################################
# MIKROTIK - REDE ESCOLAR
###############################################

###############################################
# 1. LISTAS DE ENDEREÇOS
###############################################

/ip firewall address-list
add list=ADM-LAN address=10.0.0.0/24 comment="Rede administrativa"
add list=CLIENT-LAN address=192.168.0.0/24 comment="Rede alunos"
add list=GESTAO-REMOTA address=x.x.x.x/yy comment="IP permitido acesso remoto"


###############################################
# 2. FIREWALL INPUT
###############################################

/ip firewall filter
add chain=input action=accept connection-state=established,related comment="INPUT estabelecido"
add chain=input action=accept src-address-list=ADM-LAN comment="INPUT ADM"
add chain=input action=accept protocol=icmp limit=50,5 comment="INPUT ICMP"
add chain=input action=accept protocol=tcp dst-port=<PORTA_CUSTOMIZADA> src-address-list=GESTAO-REMOTA comment="INPUT remoto"
add chain=input action=drop comment="INPUT drop geral"


###############################################
# 3. FIREWALL FORWARD
###############################################

add chain=forward action=accept connection-state=established,related comment="FORWARD estabelecido"
add chain=forward action=accept src-address-list=ADM-LAN dst-address-list=CLIENT-LAN comment="ADM -> ALUNOS"
add chain=forward action=drop src-address-list=CLIENT-LAN dst-address-list=ADM-LAN comment="ALUNOS -> ADM BLOQUEADO"


###############################################
# 4. FAILOVER
###############################################

/ip route
set [find comment="WAN1"] distance=1
set [find comment="WAN2"] distance=2


###############################################
# 5. NAT
###############################################

/ip firewall nat
add chain=srcnat action=masquerade out-interface=pppoe-wan1 comment="NAT WAN1"
add chain=srcnat action=masquerade out-interface=pppoe-wan2 comment="NAT WAN2"


###############################################
# 6. PRIORIDADE ADM
###############################################

/ip firewall mangle
add chain=prerouting src-address-list=ADM-LAN connection-mark=no-mark action=mark-connection new-connection-mark=ADM-CONN passthrough=yes comment="ADM-CONN"
add chain=prerouting connection-mark=ADM-CONN action=mark-routing new-routing-mark=to-WAN1 passthrough=no comment="ADM-WAN1"


###############################################
# 7. LOAD BALANCE (PCC)
###############################################

add chain=prerouting src-address-list=CLIENT-LAN connection-mark=no-mark per-connection-classifier=both-addresses:2/0 action=mark-connection new-connection-mark=WAN1-CONN passthrough=yes comment="PCC WAN1"
add chain=prerouting src-address-list=CLIENT-LAN connection-mark=no-mark per-connection-classifier=both-addresses:2/1 action=mark-connection new-connection-mark=WAN2-CONN passthrough=yes comment="PCC WAN2"

add chain=prerouting connection-mark=WAN1-CONN action=mark-routing new-routing-mark=to-WAN1 passthrough=no comment="ROTA WAN1"
add chain=prerouting connection-mark=WAN2-CONN action=mark-routing new-routing-mark=to-WAN2 passthrough=no comment="ROTA WAN2"


###############################################
# 8. ROTAS PCC
###############################################

/ip route
add dst-address=0.0.0.0/0 gateway=pppoe-wan1 routing-mark=to-WAN1 distance=1 comment="PCC WAN1"
add dst-address=0.0.0.0/0 gateway=pppoe-wan2 routing-mark=to-WAN2 distance=1 comment="PCC WAN2"


###############################################
# 9. SEGURANÇA SERVIÇOS
###############################################

/ip service
set winbox port=<PORTA_CUSTOMIZADA>
set winbox address=<FAIXA_PERMITIDA>
set www-ssl address=<FAIXA_PERMITIDA>


###############################################
# FIM
###############################################
