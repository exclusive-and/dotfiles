{
    programs.bash.enable = true;
    programs.fish.enable = true;

    programs.fish.interactiveShellInit = ''
        # echo -ne "\e[?16;0;112;c"
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_replace_one underscore
        set -g fish_cursor_visual block
        set -g fish_cursor_external block
    '';
}
