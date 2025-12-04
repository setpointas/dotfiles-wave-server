#!/bin/zsh

function prompt()
{
    read "response? $1 Continue? [Y/n] "
    response=${response:l} #tolower
    if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
        print -P '%F{green} \nContinuing...%f'
    else
        print -P '%F{red} \nAborting...%f'
        exit 1
    fi
}

CHECK_SYMBOL='\u2713'
X_SYMBOL='\u2A2F'

#
# Run the command passed as 1st argument and shows the spinner until this is done
#
# @param String $1 the command to run
# @param String $2 the title to show next the spinner
# @param var $3 the variable containing the return code
#
function execute_and_wait() {
  local __resultvar=$3

  eval $1 >/tmp/execute-and-wait.log 2>&1 &
  pid=$!
  delay=0.05

  frames=('\u280B' '\u2819' '\u2839' '\u2838' '\u283C' '\u2834' '\u2826' '\u2827' '\u2807' '\u280F')

  echo "$pid" >"/tmp/.spinner.pid"

  # Hide the cursor, it looks ugly :D
  tput civis
  index=0
  framesCount=${#frames[@]}
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    printf "${YELLOW}${frames[$index]}${NC} ${GREEN}$2${NC}"

    let index=index+1
    if [ "$index" -ge "$framesCount" ]; then
      index=0
    fi

    printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    sleep $delay
  done


  #
  # Wait the command to be finished, this is needed to capture its exit status
  #
  wait $!
  exitCode=$?

  if [ "$exitCode" -eq "0" ]; then
    printf "${CHECK_SYMBOL} ${2}                                                                \b\n"
  else
    printf "${X_SYMBOL} ${2}                                                                \b\n"
  fi

  # Restore the cursor
  tput cnorm

  # eval $__resultvar=$exitCode
}

function print_welcome_message()
{
    echo " ____  ____  ____  ____   __  __  __ _  ____    ____  ____  ____  _  _  ____  ____  ";
    echo "/ ___)(  __)(_  _)(  _ \ /  \(  )(  ( \(_  _)  / ___)(  __)(  _ \/ )( \(  __)(  _ \ ";
    echo "\___ \ ) _)   )(   ) __/(  O ))( /    /  )(    \___ \ ) _)  )   /\ \/ / ) _)  )   / ";
    echo "(____/(____) (__) (__)   \__/(__)\_)__) (__)   (____/(____)(__\_) \__/ (____)(__\_) ";
    print "\n"
    print -P "%F{blue} Welcome to the Wave server automated setup. This tool will install the necessary dependencies and configurations. %f"
    print -P "%F{blue} For the most part you will only need to hit \'Enter\' to continue. Input the password for user \'Setpoint\' when asked to %f"
}

function show_menu()
{
    print -P "\n%F{cyan}=== Wave Server Setup Menu ===%f"
    print -P "%F{white}Choose which steps to execute:%f\n"
    print -P "%F{yellow}0)%f Set static ip"
    print -P "%F{yellow}1)%f Fix power settings (disable hibernate/sleep)"
    print -P "%F{yellow}2)%f Configure git settings"
    print -P "%F{yellow}3)%f Install oh-my-zsh"
    print -P "%F{yellow}4)%f Install extra software (stow, neovim, docker, etc.)"
    print -P "%F{yellow}5)%f Clone and install dotfiles"
    print -P "%F{yellow}6)%f Enable and start SSH service"
    print -P "%F{yellow}7)%f Enable and start Docker service"
    print -P "%F{green}8)%f Run ALL steps"
    print -P "%F{red}9)%f Exit"
    print -P "\n%F{white}Enter your choices (e.g., 1,3,5 or 8 for all): %f"
}

function get_user_choices()
{
    local choices
    read "choices?> "
    echo $choices
}

function step_0_ip_settings()
{
    print -P "\n%F{blue}=== Step 0: Setting up IP address ===%f"
    IFACE=$(ip -o link show | awk -F': ' '!/lo/ {print $2; exit}')

    systemctl enable systemd-networkd.service
    systemctl enable systemd-resolved.service

    cat <<-EOF >/etc/systemd/network/20-static.network
	[Match]
	Name=$IFACE

	[Network]
	Address=10.0.0.180/24
	Gateway=10.0.0.99
	DNS=10.0.0.99
EOF

    systemctl restart systemd-networkd
    print -P "%F{green}✓ IP address configured%f"
}

function step_1_power_settings()
{
    print -P "\n%F{blue}=== Step 1: Fixing power settings ===%f"
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    print -P "%F{green}✓ Power settings configured%f"
}

function step_2_git_config()
{
    print -P "\n%F{blue}=== Step 2: Fixing git settings ===%f"
    git config --global user.email "setpoint@setpoint.no"
    git config --global user.name "Setpoint"
    print -P "%F{green}✓ Git settings configured%f"
}

function step_3_oh_my_zsh()
{
    print -P "\n%F{blue}=== Step 3: Installing oh-my-zsh ===%f"
    if (( ${+ZSH} )); then
        print -P '%F{yellow}$ZSH is already present.\n%f'
        prompt ''
    else
        export RUNZSH=no
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        prompt 'Oh-my-zsh installed.'
    fi
    print -P "%F{green}✓ Oh-my-zsh setup completed%f"
}

function step_4_install_software()
{
    print -P "\n%F{blue}=== Step 4: Installing extra software ===%f"
    sudo pacman -S --needed tmux stow neovim docker docker-compose ghostty fastfetch zoxide lazygit lazydocker bat
    print -P "%F{green}✓ Extra software installed%f"
}

function step_5_dotfiles()
{
    print -P "\n%F{blue}=== Step 5: Installing dotfiles ===%f"
    git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
    mv ~/.zshrc ~/.zshrc_old
    cd ~/.dotfiles
    stow .
    cd ~
    prompt 'Dotfiles installed.'
    print -P "%F{green}✓ Dotfiles setup completed%f"
}

function step_6_ssh_service()
{
    print -P "\n%F{blue}=== Step 6: Enabling and starting SSH service ===%f"
    if (sudo systemctl is-active --quiet sshd); then
        print -P "%F{yellow}SSH is already running.\n%f"
        prompt ''
    else
        sudo systemctl enable sshd
        sudo systemctl start sshd
        prompt 'SSH Daemon started.'
    fi
    print -P "%F{green}✓ SSH service setup completed%f"
}

function step_7_docker_service()
{
    print -P "\n%F{blue}=== Step 7: Enabling and starting Docker service ===%f"
    if (sudo systemctl is-active --quiet docker); then
        print -P "%F{yellow}Docker is already running.\n%f"
        prompt ''
    else
        sudo systemctl enable docker
        sudo systemctl start docker
        # Add setpoint user to docker group
        print "Adding setpoint user to docker group"
        sudo usermod -aG docker setpoint
        prompt 'Docker service started.'
    fi
    print -P "%F{green}✓ Docker service setup completed%f"
}

function execute_steps()
{
    local choices=$1
    local -a selected_steps

    # Parse comma-separated choices
    selected_steps=(${(s:,:)choices})

    for step in $selected_steps; do
        case $step in
            0)
                step_0_ip_settings
                ;;
            1)
                step_1_power_settings
                ;;
            2)
                step_2_git_config
                ;;
            3)
                step_3_oh_my_zsh
                ;;
            4)
                step_4_install_software
                ;;
            5)
                step_5_dotfiles
                ;;
            6)
                step_6_ssh_service
                ;;
            7)
                step_7_docker_service
                ;;
            8)
                print -P "\n%F{green}=== Running ALL steps ===%f"
                step_0_ip_settings
                step_1_power_settings
                step_2_git_config
                step_3_oh_my_zsh
                step_4_install_software
                step_5_dotfiles
                step_6_ssh_service
                step_7_docker_service
                break
                ;;
            9)
                print -P "\n%F{red}Exiting setup...%f"
                exit 0
                ;;
            *)
                print -P "%F{red}Invalid choice: $step%f"
                ;;
        esac
    done
}

# Main execution
print_welcome_message
prompt ''

while true; do
    show_menu
    choices=$(get_user_choices)

    # Handle exit choice
    if [[ $choices == "9" ]]; then
        print -P "\n%F{red}Exiting setup...%f"
        exit 0
    fi

    # Validate input
    if [[ -z $choices ]]; then
        print -P "%F{red}No choices entered. Please try again.%f"
        continue
    fi

    execute_steps $choices

    print -P "\n%F{green}=== Setup completed for selected steps ===%f"
    print -P "%F{blue}Now log out and log in again to start using the server%f"

    read "response?\nWould you like to run more steps? [y/N] "
    response=${response:l}
    if [[ ! $response =~ ^(y) ]]; then
        break
    fi
done

print -P "\n%F{green}Thank you for using the Wave server setup tool!%f"
