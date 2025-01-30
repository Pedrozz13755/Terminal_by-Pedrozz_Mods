#!/bin/bash
# Definições de cores
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'

# Função para exibir uma lista de cores e aplicar a cor escolhida ao banner
choose_color() {
    echo "Escolha a cor para o banner:"
    echo "1) Vermelho"
    echo "2) Verde"
    echo "3) Azul"
    echo "4) Amarelo"
    echo "5) Ciano"
    echo "6) Magenta"
    echo "7) Degradê (todas as cores)"
    echo -ne "Digite o número da sua escolha: "
    read color_choice
}

# Função para aplicar a cor selecionada ao banner
apply_color() {
    case $color_choice in
        1) echo -e "${RED}$1${NOCOLOR}" ;;
        2) echo -e "${GREEN}$1${NOCOLOR}" ;;
        3) echo -e "${BLUE}$1${NOCOLOR}" ;;
        4) echo -e "${YELLOW}$1${NOCOLOR}" ;;
        5) echo -e "${CYAN}$1${NOCOLOR}" ;;
        6) echo -e "${PURPLE}$1${NOCOLOR}" ;;
        7) apply_gradient "$1" ;;
        *) echo "$1" ;;
    esac
}

# Função para aplicar degradê ao texto
apply_gradient() {
    text="$1"
    colors=("${RED}" "${GREEN}" "${YELLOW}" "${BLUE}" "${PURPLE}" "${CYAN}")
    color_count=${#colors[@]}
    index=0
    for (( i=0; i<${#text}; i++ )); do
        char="${text:$i:1}"
        if [[ "$char" != " " ]]; then
            echo -ne "${colors[$index]}$char"
            ((index=(index+1)%color_count))
        else
            echo -ne "$char"
        fi
    done
    echo -e "${NOCOLOR}"
}

# Função de interrupção (Ctrl + C)
user_intrupt() {
    printf " \n${RED}[!]---->>${YELLOW} As configurações foram interrompidas, salvando informações originais >⁠.⁠<!\n"
    sleep 1
    exit 1
}

trap user_intrupt INT

# Verifica se o figlet está instalado
if ! command -v figlet &> /dev/null; then
    echo -e "${GREEN}[+] Instalando figlet...${NOCOLOR}"
    apt update && apt install figlet -y
fi

# Solicita o nome do banner
echo -ne "${GREEN}Digite o nome do novo banner do Termux: ${NOCOLOR}"
read banner_text
echo -ne "${GREEN}Digite o nome do footer do Termux (ou aperte Enter para pular): ${NOCOLOR}"
read footer_text

# Escolher cor para o banner
choose_color

figlet_output=$(figlet "$banner_text")
figlet_footer=$(figlet -f small "$footer_text")

motd_file="/data/data/com.termux/files/usr/etc/motd"

colored_banner=$(apply_color "$figlet_output")
colored_footer=$(apply_color "$figlet_footer")

echo "$colored_banner" > "$motd_file"
echo "$colored_footer" >> "$motd_file"

echo -e "${GREEN}[+] Novo banner adicionado com sucesso!${NOCOLOR}"
cat "$motd_file"
sleep 2

# Aplicar tema hacker
apply_hacker_theme() {
echo -e "${GREEN}[+] Aplicando tema bonito...${NOCOLOR}"
sleep 2
colors_file="/data/data/com.termux/files/home/.termux/colors.properties"
cat <<EOT > "$colors_file"
background=#000000
foreground=#00FF00
cursor=#00FF00
selection_background=#333333
selection_foreground=#00FF00
EOT
termux-reload-settings
echo -e "${GREEN}[+] Um tema bonito foi aplicado no Termux.${NOCOLOR}"
}

# Adicionar atalhos no bash
apply_shortcuts() {
echo -e "${GREEN}[+] Adicionando atalhos ao Termux...${NOCOLOR}"
bashrc_file="/data/data/com.termux/files/usr/etc/bash.bashrc"

# Adiciona os atalhos ao arquivo .bashrc
cat <<EOT >> $bashrc_file

# Atalhos personalizados
alias ll='ls -la'
alias cls='clear'
alias update='pkg update && pkg upgrade -y'
alias install='pkg install'
alias rmrf='rm -rf'
alias home='cd /data/data/com.termux/files/home'
alias editbash='nano ~/.bashrc'
alias reload='source ~/.bashrc'
alias myip='curl ifconfig.me'
alias src='source ~/.bashrc'
alias hist='cat ~/.bash_history'
alias sd='cd /sdcard'
alias laura='cd /sdcard/laura-bot && sh laura.sh'
alias laura2='cd /sdcard/Laura-privat && sh laura.sh'
alias shs='sh start.sh'
alias shl='sh laura.sh'
alias nd='node index.js'
alias bot='cd /sdcard/<arquivo>'
alias host='termux-open-url https://speedhosting.cloud'
alias api='termux-open-url https://darkstars-api.onrender.com'
alias srclog='cd /data/data/com.termux/files/usr/var/log'
alias wgetr='wget --random-wait'
alias tree='pkg install tree && tree'
alias grep='grep --color=auto'

# Comando 'helpc' para exibir a lista de atalhos
alias helpc='echo -e "${CYAN}
TABELA DE ATALHOS:
• ll      - Lista arquivos detalhadamente
• cls     - Limpa a tela
• update  - Atualiza pacotes
• install - Instala pacotes
• rmrf    - Remove arquivos/pastas
• home    - Vai para home do Termux
• editbash - Edita o bashrc
• reload  - Recarrega bashrc
• myip    - Mostra IP público
• src     - Recarrega bashrc
• hist    - Histórico de comandos
• sd      - Acessa memória do celular
• laura   - Inicia a Laura padrão
• laura2  - Inicia a Laura do Git
• shs     - Inicia bot
• shl     - Inicia Laura
• nd      - Executa node index.js
• bot    - Acessa pasta do seu bot
• host    - abre o link da hospedagem 
• api      - Entre na dark API 
• srclog  - Acessa logs do Termux
• wgetr   - Baixa arquivos com atraso aleatório
• tree    - Instala e exibe árvore de diretórios
• grep    - Pesquisa com destaque
• helpc   - Exibe esta tabela de atalhos
${NOCOLOR}"'

EOT
sleep 2
echo -e "${GREEN}[+] Atalhos adicionados com sucesso!${NOCOLOR}"
}

apply_hacker_theme
apply_shortcuts

echo -e "${YELLOW}[+] Termux foi totalmente personalizado! Para aplicar as mudanças, digite:

Comando: exit 

Reabra o Termux para ver as configurações aplicadas.${NOCOLOR}"