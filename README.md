# 🎓 MikroTik School Network

Configuração profissional de MikroTik para ambiente escolar com separação de redes, failover e balanceamento de carga.

---

## 🏫 Cenário

Este projeto simula a infraestrutura de rede de uma escola, separando dois ambientes principais:

### 👨‍🏫 Rede Administrativa (Colaboradores)
- Acesso à rede interna
- Prioridade na internet
- Pode acessar dispositivos da rede de alunos

### 🎓 Rede de Alunos
- Acesso apenas à internet
- Sem acesso à rede administrativa
- Tráfego balanceado entre dois links

---

## 🌐 Topologia

            INTERNET
            /      \
      [WAN1]      [WAN2]
         |           |
       +---------------+
       |   MikroTik    |
       +---------------+
        |             |
 Rede ADM        Rede Alunos

 
---

## ⚙️ Funcionalidades

- 🔁 Failover automático entre dois links
- ⚖️ Load balance (PCC) para rede de alunos
- 🎯 Prioridade para rede administrativa
- 🔐 Isolamento entre redes internas
- 🌍 Acesso remoto seguro ao roteador

---

## 🚀 Deploy

### 1. Fazer backup
/system backup save name=backup-pre-config


### 2. Importar script
/import file-name=mikrotik-school-config.rsc


---

## 🔐 Segurança

- Bloqueio total por padrão (DROP)
- Acesso remoto restrito por IP
- Porta de gerenciamento customizada
- Separação entre redes

---

## ⚠️ Importante

Antes de usar, altere:

- `<PORTA_CUSTOMIZADA>`
- `<FAIXA_PERMITIDA>`
- Interfaces (`pppoe-wan1`, `pppoe-wan2`)
- Faixas de IP conforme sua rede

---

## 🧪 Testes recomendados

- Desconectar WAN principal → verificar failover
- Testar navegação simultânea
- Testar acesso remoto externo
- Validar isolamento entre redes

---

## 👨‍💻 Autor João Pedro de Melo Silva Moisés

Projeto para estudo e aplicação prática em redes MikroTik.

---

## 📄 Licença

Uso livre para fins educacionais e profissionais.
