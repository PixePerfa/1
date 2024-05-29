#!/bin/bash

# Define the color schemes
declare -a BACKGROUND_COLORS=(
    "\[\e[48;5;17m\]" # Dark Blue
    "\[\e[48;5;52m\]" # Dark Red
    "\[\e[48;5;94m\]" # Dark Yellow
    "\[\e[48;5;22m\]" # Dark Green
    "\[\e[48;5;55m\]" # Dark Purple
    "\[\e[48;5;234m\]" # Very Dark Gray
    "\[\e[48;5;236m\]" # Dark Gray
    "\[\e[48;5;238m\]" # Darker Gray
    "\[\e[48;5;240m\]" # Dark Gray
    "\[\e[48;5;242m\]" # Medium Dark Gray
    "\[\e[48;5;244m\]" # Medium Gray
    "\[\e[48;5;246m\]" # Light Gray
    "\[\e[48;5;248m\]" # Lighter Gray
    "\[\e[48;5;250m\]" # Light Gray
    "\[\e[48;5;252m\]" # Very Light Gray
)

declare -a TEXT_COLORS=(
    "\[\e[38;5;231m\]" # White
    "\[\e[38;5;15m\]"  # Light Gray
    "\[\e[38;5;253m\]" # Very Light Gray
    "\[\e[38;5;255m\]" # Bright White
    "\[\e[38;5;247m\]" # Medium Gray
    "\[\e[38;5;243m\]" # Dark Gray
    "\[\e[38;5;240m\]" # Dark Gray
    "\[\e[38;5;237m\]" # Very Dark Gray
    "\[\e[38;5;235m\]" # Black
    "\[\e[38;5;228m\]" # Pale Yellow
    "\[\e[38;5;229m\]" # Pale Yellow
    "\[\e[38;5;230m\]" # Pale Yellow
    "\[\e[38;5;187m\]" # Light Yellow
    "\[\e[38;5;223m\]" # Bright Yellow
    "\[\e[38;5;221m\]" # Bright Yellow
)

declare -a CODE_FILE_COLORS=(
    "\[\e[38;5;119m\]" # Bright Green
    "\[\e[38;5;81m\]"  # Sky Blue
    "\[\e[38;5;227m\]" # Bright Yellow
    "\[\e[38;5;159m\]" # Light Turquoise
    "\[\e[38;5;155m\]" # Mint Green
    "\[\e[38;5;48m\]"  # Bright Turquoise
    "\[\e[38;5;45m\]"  # Aqua
    "\[\e[38;5;39m\]"  # Sky Blue
    "\[\e[38;5;123m\]" # Sky Blue
    "\[\e[38;5;51m\]"  # Cyan
    "\[\e[38;5;87m\]"  # Turquoise
    "\[\e[38;5;114m\]" # Dark Green
    "\[\e[38;5;83m\]"  # Mint Green
    "\[\e[38;5;113m\]" # Bright Green
    "\[\e[38;5;193m\]" # Pale Green
)

declare -a FOLDER_COLORS=(
    "\[\e[38;5;69m\]"  # Blue
    "\[\e[38;5;105m\]" # Purple
    "\[\e[38;5;111m\]" # Light Blue
    "\[\e[38;5;75m\]"  # Sky Blue
    "\[\e[38;5;141m\]" # Light Purple
    "\[\e[38;5;177m\]" # Lavender
    "\[\e[38;5;183m\]" # Light Lavender
    "\[\e[38;5;189m\]" # Lavender
    "\[\e[38;5;219m\]" # Pink
    "\[\e[38;5;225m\]" # Light Pink
    "\[\e[38;5;57m\]"  # Medium Blue
    "\[\e[38;5;99m\]"  # Dark Purple
    "\[\e[38;5;135m\]" # Dark Purple
    "\[\e[38;5;171m\]" # Light Purple
    "\[\e[38;5;207m\]" # Pink
)

declare -a EXECUTABLE_COLORS=(
    "\[\e[38;5;119m\]" # Bright Green
    "\[\e[38;5;215m\]" # Bright Orange
    "\[\e[38;5;226m\]" # Bright Yellow
    "\[\e[38;5;49m\]"  # Turquoise
    "\[\e[38;5;193m\]" # Pale Green
    "\[\e[38;5;155m\]" # Mint Green
    "\[\e[38;5;46m\]"  # Bright Green
    "\[\e[38;5;82m\]"  # Bright Green
    "\[\e[38;5;118m\]" # Bright Green
    "\[\e[38;5;154m\]" # Bright Green
    "\[\e[38;5;190m\]" # Bright Green
    "\[\e[38;5;226m\]" # Bright Yellow
    "\[\e[38;5;220m\]" # Bright Yellow
    "\[\e[38;5;214m\]" # Bright Yellow
    "\[\e[38;5;208m\]" # Bright Orange
)

# Prompt the user to select color schemes
echo "Select a background color:"
for i in "${!BACKGROUND_COLORS[@]}"; do
    echo "$((i+1)). ${BACKGROUND_COLORS[$i]}Sample Text\[\e[0m\]"
done
read -p "Enter the number (1-15): " bg_choice

echo "Select a text color:"
for i in "${!TEXT_COLORS[@]}"; do
    echo "$((i+1)). ${TEXT_COLORS[$i]}Sample Text\[\e[0m\]"
done
read -p "Enter the number (1-15): " text_choice

echo "Select a color for code files:"
for i in "${!CODE_FILE_COLORS[@]}"; do
    echo "$((i+1)). ${CODE_FILE_COLORS[$i]}Sample.py\[\e[0m\]"
done
read -p "Enter the number (1-15): " code_file_color

echo "Select a color for folders:"
for i in "${!FOLDER_COLORS[@]}"; do
    echo "$((i+1)). ${FOLDER_COLORS[$i]}Sample Folder\[\e[0m\]"
done
read -p "Enter the number (1-15): " folder_color

echo "Select a color for executables:"
for i in "${!EXECUTABLE_COLORS[@]}"; do
    echo "$((i+1)). ${EXECUTABLE_COLORS[$i]}Sample.sh\[\e[0m\]"
done
read -p "Enter the number (1-15): " exec_color

# Set the selected color schemes
BACKGROUND_COLOR="${BACKGROUND_COLORS[$((bg_choice-1))]}"
TEXT_COLOR="${TEXT_COLORS[$((text_choice-1))]}"
CODE_FILE_COLOR="${CODE_FILE_COLORS[$((code_file_color-1))]}"
FOLDER_COLOR="${FOLDER_COLORS[$((folder_color-1))]}"
EXECUTABLE_COLOR="${EXECUTABLE_COLORS[$((exec_color-1))]}"
# Set the prompt with the selected color schemes
export PS1="${BACKGROUND_COLOR}${TEXT_COLOR}[\u@\h \W]\[\e[0m\] \$ "

if [ "${XS_BASHRC,,}" == "yes" ] ; then
    ## Customise bashrc (thanks broeckca)
    cat <<EOF >> /root/.bashrc
export HISTTIMEFORMAT="%d/%m/%y %T "
export PS1="${BACKGROUND_COLOR}${TEXT_COLOR}[\u@\h \W]\[\e[0m\] \$ "
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
source /etc/profile.d/bash_completion.sh
EOF
fi

# LS_COLORS environment variable used by GNU ls which determines the
# colors used to display file information.

# Extensions
.sh ${CODE_FILE_COLOR}
.py ${CODE_FILE_COLOR}

# Directories
di=${FOLDER_COLOR}

# Executable files
ex=${EXECUTABLE_COLOR}

# Current directory
ow=\[\e[38;5;226m\]

# Reset for all other file types
* \[\e[0m\]

# Load the new dircolors configuration
eval "$(dircolors ~/.dircolors)"

# Display a sample directory with colorized file types
echo "Sample directory with colorized file types:"
ls -l

# Add the dircolors configuration to the shell configuration file
if [ -f ~/.bashrc ]; then
    echo 'eval "$(dircolors ~/.dircolors)"' >> ~/.bashrc
elif [ -f ~/.zshrc ]; then
    echo 'eval "$(dircolors ~/.dircolors)"' >> ~/.zshrc
fi

echo "File colorization has been set up and will persist across terminal sessions."
