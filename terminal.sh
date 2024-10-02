#!/bin/bash
# Definições de cores
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
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

# Função para aplicar a cor selecionada ao banner gerado pelo figlet
apply_color() {
    case $color_choice in
        1) echo -e "${RED}$1${NOCOLOR}" ;;    # Vermelho
        2) echo -e "${GREEN}$1${NOCOLOR}" ;;  # Verde
        3) echo -e "${BLUE}$1${NOCOLOR}" ;;   # Azul
        4) echo -e "${YELLOW}$1${NOCOLOR}" ;; # Amarelo
        5) echo -e "${CYAN}$1${NOCOLOR}" ;;   # Ciano
        6) echo -e "${PURPLE}$1${NOCOLOR}" ;; # Magenta
        7) apply_gradient "$1" ;;             # Degradê
        *) echo "$1" ;;                       # Sem cor
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
        if [[ "$char" != " " ]]; then  # Evitar colorir espaços
            echo -ne "${colors[$index]}$char"
            ((index=(index+1)%color_count))
        else
            echo -ne "$char"
        fi
    done
    echo -e "${NOCOLOR}"  # Resetar cor
}

# Função para o efeito de digitação estilo hacker
type_hack() {
    text=( 'I' 'n' 'i' 'c' 'i' 'a' 'n' 'd' 'o' ' ' 'S' 'i' 's' 't' 'e' 'm' 'a')
    for i in "${text[@]}"; do
        printf " ${GREEN}${i}"
        sleep .1
    done
    printf "\n"
}

# Função de interrupção (Ctrl + C)
user_intrupt() {
    printf " \n${RED}[!]---->>${YELLOW}As configurações foram interrompidas, salvando informações originais >⁠.⁠<!\n"
    sleep 1
    exit 1
}

# Definir o trap para capturar Ctrl + C e chamar a função de interrupção
trap user_intrupt INT

# Verifica se o figlet está instalado, se não, instala
if ! command -v figlet &> /dev/null; then
    echo -e "${GREEN}[+] Instalando figlet...${NOCOLOR}"
    apt update && apt install figlet -y
fi

# Solicita ao usuário que insira o texto para o banner
echo -ne "${GREEN}
𝑆𝐶𝑅𝐼𝑃𝑇: 𝑏𝑦: 𝑃𝑒𝑑𝑟𝑜𝑧𝑧 𝑀𝑜𝑑𝑠 ☜⁠ ⁠(⁠↼⁠_⁠↼⁠)

Coloque o nome que você quer que seja o novo banner do teu termux: ${NOCOLOR}"
read banner_text

echo -ne "${GREEN}
𝑆𝐶𝑅𝐼𝑃𝑇: 𝑏𝑦: 𝑃𝑒𝑑𝑟𝑜𝑧𝑧 𝑀𝑜𝑑𝑠 ☜⁠ ⁠(⁠↼⁠_⁠↼⁠)

Coloque o nome que você quer que seja o novo footer do teu termux: ${NOCOLOR}(se n quiser e só apertar enter)"
read footer_text

# Escolher cor para o banner
choose_color

# Gera o texto do banner com o figlet, usando uma fonte pequena
figlet_output=$(figlet "$banner_text")

# Adiciona o texto "by: pedrozz Mods" em uma fonte menor
footer="by: pedrozz Mds"
figlet_footer=$(figlet -f small "$footer_text")

# Caminho para o arquivo motd (que exibe o banner ao iniciar o Termux)
motd_file="/data/data/com.termux/files/usr/etc/motd"

# Aplica a cor selecionada e grava no arquivo motd
colored_banner=$(apply_color "$figlet_output")
colored_footer=$(apply_color "$figlet_footer")

# Salva o banner e o rodapé no arquivo motd
echo "$colored_banner" > "$motd_file"
echo "$colored_footer" >> "$motd_file"

# Exibe o novo banner
echo -e "${GREEN}[+] Novo banner adicionado com sucesso!${NOCOLOR}"
cat "$motd_file"
sleep 2
# Aplicar tema hacker
apply_hacker_theme() {
echo -e "${GREEN}[+] Aplicando tema bonito...${NOCOLOR}"
sleep 2
# Caminho para o arquivo de configuração de cores do Termux
colors_file="/data/data/com.termux/files/home/.termux/colors.properties"

# Tema estilo hacker: fundo preto e texto verde
cat <<EOT > "$colors_file"
background=#000000
foreground=#00FF00
cursor=#00FF00
selection_background=#333333
selection_foreground=#00FF00
EOT

# Aplica as novas cores
termux-reload-settings

echo -e "${GREEN}[+]Um tema bonito foi aplicado no termux${NOCOLOR}"
}
sleep 2
# Adicionar atalhos no bash
apply_shortcuts() {
echo -e "${GREEN}[+] Adicionando atalhos ao Termux (facilitei sua vida O⁠_⁠o)...${NOCOLOR}"

bashrc_file="/data/data/com.termux/files/usr/etc/bash.bashrc"

# Adiciona os atalhos ao arquivo .bashrc
cat <<EOT >> $bashrc_file

# Atalhos personalizados
alias ll='ls -la'         # Lista arquivos com detalhes
alias cls='clear'         # Limpa a tela
alias update='pkg update && pkg upgrade -y'  # Atualiza pacotes do Termux
alias install='pkg install'  # Instala pacotes
alias rmrf='rm -rf'       # Remove arquivos/pastas de forma recursiva
alias home='cd /data/data/com.termux/files/home'  # Vai direto para a pasta home
alias editbash='nano ~/.bashrc'  # Edita o arquivo bashrc
alias reload='source ~/.bashrc'  # Recarrega o bashrc
alias myip='curl ifconfig.me'  # Mostra o IP público
alias src='source ~/.bashrc'   # Recarrega o bashrc de forma rápida
alias hist='cat ~/.bash_history'  # Mostra o histórico de comandos
alias sd='cd /sdcard'  # Acessa o cartão SD
alias srclog='cd /data/data/com.termux/files/usr/var/log' # Vai para logs
alias wgetr='wget --random-wait'       # Baixa arquivos com atraso aleatório
alias tree='pkg install tree && tree'  # Instala e exibe árvore de diretórios
alias grep='grep --color=auto'         # Pesquisa com destaque
EOT
sleep 2
echo -e "${GREEN}[+] Atalhos adicionados com sucesso!${NOCOLOR}"
sleep 2
echo -e "${CYAN}TABELA DE ATALHO ADICIONADOS
• ll - faz uma listagem detalhada
• cls - Limpa a tela
• update - Atualiza o pacote do termux
• install - Instala pacotes
• rmrf - Apaga arquivos/pastas recursivamente
• home - Vai para a home do termux
• editbash - Edita o bashrc
• reload - Recarrega o bashrc
• myip - Mostra o IP público
• src - Recarrega o bashrc
• hist - Mostra o histórico de comandos
• sd - Acessa o cartão SD
${NOCOLOR}"
}

# Executar funções
apply_hacker_theme
apply_shortcuts
sleep 2
echo -e "${YELLOW}[+] Termux foi totalmente personalizado! Digite assim agora no termux:

Comando: exit 

Ele vai fechar o seu termux ai quando vc abrir ele as configurações vão ta adicionadas ^⁠_⁠^${NOCOLOR}"
