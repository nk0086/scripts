#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    exit 1
fi

# Container selection function
select_container() {
    echo -e "${GREEN}Running containers:${NC}"
    
    # Get container info and store in variable
    selected=$(sudo docker ps --format "{{.ID}} {{.Image}}" | fzf --height 40% --reverse --header="Select a container")
    
    if [ -z "$selected" ]; then
        echo "No container selected"
        exit 1
    fi
    
    container_id=$(echo $selected | cut -d' ' -f1)
}

# Action selection function
select_action() {
    action=$(echo -e "Connect to container\nStop container\nCancel" | fzf --height 40% --reverse --header="Select an action")
    
    case "$action" in
        "Connect to container")
            sudo docker exec -it $container_id /bin/bash || sudo docker exec -it $container_id /bin/sh
            ;;
        "Stop container")
            sudo docker stop $container_id
            echo "Container stopped"
            ;;
        "Cancel")
            exit 0
            ;;
    esac
}

# Main process
echo -e "${GREEN}Docker Helper${NC}"

# Check for running containers
if [ -z "$(sudo docker ps -q)" ]; then
    echo "No running containers found"
    
    # Check if docker-compose.yml exists
    if [ -f "docker-compose.yml" ]; then
        echo -e "\n${YELLOW}Found docker-compose.yml in current directory${NC}"
        read -p "Do you want to run 'docker-compose up -d'? (y/n): " answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            sudo docker-compose up -d
            echo "Containers started"
            exit 0
        fi
    fi
    
    exit 1
fi

select_container
select_action 
