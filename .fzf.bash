# Setup fzf
# ---------
if [[ ! "$PATH" == */home/liuchengqian/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/liuchengqian/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/liuchengqian/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/liuchengqian/.fzf/shell/key-bindings.bash"
