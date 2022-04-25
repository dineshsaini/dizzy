#!/usr/bin/env bash

###############################################################################
#                    DIZZY (terminal command mgr bot)
###############################################################################

__NAME__="dizzy"
__VERSION__="0.12"

# variables
c_red="$(tput setaf 196)"
c_cyan="$(tput setaf 44)"
c_light_green_2="$(tput setaf 10)"
c_yellow="$(tput setaf 190)"
c_orange="$(tput setaf 202)"
c_light_blue="$(tput setaf 42)"
c_light_green="$(tput setaf 2)"
c_light_red="$(tput setaf 9)"

b_black="$(tput setab 16)"
b_dark_black="$(tput setab 233)"
b_light_black="$(tput setab 236)"

s_bold="$(tput bold)"
s_dim="$(tput dim)"
s_underline="$(tput smul)"

p_reset="$(tput sgr0)"

home_dir="$(realpath ~)/.dizzy"

flag_disable_warnings=""    # 'y' --> disable warnings, '' --> display warnings
flag_verbose=""             # 'y' --> be verbose, '' --> no verbose
flag_no_exit=""         # '' --> exit after processing one argument, 'y' --> no exit 

ERR_ARGS=1


function __cont {
    echo "$(echo "$1" | sed -e "s/${p_reset/[/\\[}/$p_reset$2/g")"
}

function _color {
    echo "$2$(__cont "$1" "$2")$p_reset"
}

function as_red {
    echo "$(_color "$1" "$c_red")"
}

function as_cyan {
    echo "$(_color "$1" "$c_cyan")"
}

function as_yellow {
    echo "$(_color "$1" "$c_yellow")"
}

function as_orange {
    echo "$(_color "$1" "$c_orange")"
}

function as_light_blue {
    echo "$(_color "$1" "$c_light_blue")"
}

function as_light_green {
    echo "$(_color "$1" "$c_light_green")"
}

function as_light_green_2 {
    echo "$(_color "$1" "$c_light_green_2")"
}

function as_light_red {
    echo "$(_color "$1" "$c_light_red")"
}

function on_black {
    echo "$(_color "$1" "$b_black")"
}

function on_light_black {
    echo "$(_color "$1" "$b_light_black")"
}

function on_dark_black {
    echo "$(_color "$1" "$b_dark_black")"
}

function as_bold {
    echo "$(_color "$1" "$s_bold")"
}

function as_dim {
    echo "$(_color "$1" "$s_dim")"
}

function as_underline {
    echo "$(_color "$1" "$s_underline")"
}

function log_error {
    log "$(as_bold "$(as_red 'ERROR')")"  "$*"  >&2
}

function log_info {
    log "$(as_cyan 'INFO')" "$*"
}

function log_warn {
    if [ "x$flag_disable_warnings" != "xy" ]; then
        log "$(as_light_red 'WARN')" "$*"
    fi
}

function log {
    local sym="$(as_bold "$(as_light_blue '*')" )"
    if [ $# -eq 2 ]; then
        sym="$1"
        shift
    fi
    log_plain "[$sym]: $*" 
}

function log_plain {
    echo -e "$*"
}

function log_verbose {
    if [ "x$flag_verbose" = "xy" ]; then
        log "$*"
    fi
}

function log_verbose_info {
    if [ "x$flag_verbose" = "xy" ]; then
        log_info "$*"
    fi
}

function prompt {
    echo "$(log "$(as_cyan "$1")")"
}

function prompt_error {
    echo "$(log "$(as_red "$(as_bold "$1")")")"
}

function __banner__ {
    as_light_green_2 ''
    as_light_green_2 ' ██████╗ ██╗███████╗███████╗██╗   ██╗'
    as_light_green_2 ' ██╔══██╗██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝'
    as_light_green_2 ' ██║  ██║██║  ███╔╝   ███╔╝  ╚████╔╝ '
    as_light_green_2 ' ██║  ██║██║ ███╔╝   ███╔╝    ╚██╔╝  '
    as_light_green_2 ' ██████╔╝██║███████╗███████╗   ██║   '
    as_light_green_2 " $(as_underline '╚═════╝ ╚═╝╚══════╝╚══════╝   ╚═╝')"
    log_plain "$(as_orange "           $__NAME__ (v$__VERSION__)")"
}

function help {
    local idnt_l1="$1"
    local idnt_sc1="$idnt_l1   "
    local idnt_sc2="$idnt_sc1   "
    local idnt_sc3="$idnt_sc2   "
    local fsep_1="\t"
    local fsep_2="$fsep_1\t"
    local fsep_3="$fsep_2\t"
    local fsep_4="$fsep_3\t"

    log_plain "${idnt_l1}$(as_bold " -h")|$(as_bold "--help")${fsep_3}Show help and exit."
    log_plain "${idnt_l1}$(as_bold " --info")${fsep_4}Show detailed information and exit."
    log_plain "${idnt_l1}$(as_bold " -V")|$(as_bold "--version")${fsep_3}Print version and exit."
    log_plain "${idnt_l1}$(as_bold " -v")|$(as_bold "--verbose")${fsep_3}Be verbose."
    log_plain "${idnt_l1}$(as_bold " --no-warn")${fsep_3}Do not display warnings."
    log_plain "${idnt_l1}$(as_bold " --no-exit")${fsep_3}Do not exit after processing one action argument."

    log_plain "${idnt_l1}$(as_bold " --screen") [option]${fsep_2}Change screen settings."
    log_plain "${idnt_sc1}$(as_bold "--std")${fsep_3}Change brightness to standard."
    log_plain "${idnt_sc1}$(as_bold "--nmode")${fsep_3}Change brightness to night mode."
    log_plain "${idnt_sc1}$(as_bold "--inc") <$(as_bold "$(as_light_green "val")")>${fsep_3}Increase brightness by $(as_bold "$(as_light_green "val")")."
    log_plain "${idnt_sc1}$(as_bold "--dec") <$(as_bold "$(as_light_green "val")")>${fsep_3}Decrease brightness by $(as_bold "$(as_light_green "val")")."

    log_plain "${idnt_l1}$(as_bold " --mktd") <option>${fsep_2}Create timestamp named directory."
    log_plain "${idnt_sc1}$(as_bold "-d") [$(as_bold "$(as_light_green "dir")")]${fsep_3}Use $(as_bold "$(as_light_green "dir")") as parent directory."

    log_plain "${idnt_l1}$(as_bold " --vm") [option]${fsep_3}Virtual machine settings."
    log_plain "${idnt_sc1}$(as_bold "--service") [$(as_bold "$(as_light_green "action")")]${fsep_2}Run $(as_bold "$(as_light_green "action")")."

    log_plain "${idnt_l1}$(as_bold " --pass") [$(as_bold "$(as_light_green "len")")] [$(as_bold "$(as_light_green "rep")")] ${fsep_2}Generate random password of length $(as_bold "$(as_light_green "len")")."




    #TODO: [5] INSERT SORT HELP ABOVE THIS LINE, USE BELOW 2 LINES AS EXAMPLE FORMAT
    #log_plain "${idnt_l1}$(as_bold " -sort")|$(as_bold "--long")${fsep_3}yada yada."
    #log_plain "${idnt_sc1}$(as_bold " -sub")|$(as_bold "--sub_long") [$(as_bold "$(as_light_green "args")")]${fsep_1}more yada yada, check $(as_light_green '--info') for $(as_bold "$(as_light_green 'args')")."

    if [ -z "$idnt_l1" ]; then
        log_plain "Check $(as_light_green '--info') for option and their args detailed explanation.";
    fi
}

function _info {
    local idnt_sc1="  "
    local idnt_sc2="$idnt_sc1  "
    local idnt_sc3="$idnt_sc2  "

    __banner__

    log_plain "\n$(as_bold "[$(as_yellow "NAME")]")"
    log_plain "\t$(as_underline "$(as_bold "DIZZY") Terminal commands managing utility for GNU/Linux OS.")"

    log_plain "\n$(as_bold "[$(as_yellow "SYNOPSIS")]")"
    log_plain "\t$(as_bold "dizzy") $(as_underline "OPTIONS")"

    log_plain "\n$(as_bold "[$(as_yellow "DESCRIPTION")]")"
    log_plain "\tTerminal utility to manage usual bluk commands for which we dont want either so many short-hand scripts"
    log_plain "\tto remember or entries in bashrc file, or enabling/configuring at startup." 

    log_plain "\n$(as_bold "[$(as_yellow "HELP")]")"
    help '\t'

    log_plain "\n$(as_bold "[$(as_yellow "OPTIONS")]")"
    log_plain "$(as_bold "-h")|$(as_bold "--help")"
    log_plain "\tShow help and exit."

    log_plain "$(as_bold "--info")"
    log_plain "\tShow detailed information and explanation of options and exit."

    log_plain "$(as_bold "-V")|$(as_bold "--version")"
    log_plain "\tPrint version and exit."

    log_plain "$(as_bold "-v")|$(as_bold "--verbose")"
    log_plain "\tBe verbose."

    log_plain "$(as_bold "--no-warn")"
    log_plain "\tDo not print warnings messages."

    log_plain "$(as_bold "--no-exit")"
    log_plain "\tDo not exit after processing one action argument, default is to exit after one action and do not process"
    log_plain "\targs further, disabling this can sometime confuses."

    log_plain ""

    log_plain "$(as_bold "--screen") [option]"
    log_plain "\tAdjust screen related settings, eg brightness."

    log_plain "$idnt_sc1$(as_bold "--std")"
    log_plain "\tChange screen brightness to standard."
    
    log_plain "$idnt_sc1$(as_bold "--nmode")"
    log_plain "\tChange brightness to minimum, adjusted for darkness."
    
    log_plain "$idnt_sc1$(as_bold "--inc") <$(as_bold "$(as_light_green "val")")>"
    log_plain "\tIncrease brightness by $(as_bold "$(as_light_green "val")"), if $(as_bold "$(as_light_green "val")") is not given then default factor is $(as_bold "$(as_light_green "5")")."
    log_plain "\tsupplied value must be 0 <= $(as_bold "$(as_light_green "val")") <= 976"

    log_plain "$idnt_sc1$(as_bold "--dec") <$(as_bold "$(as_light_green "val")")>"
    log_plain "\tDecrease brightness by $(as_bold "$(as_light_green "val")"), if $(as_bold "$(as_light_green "val")") is not given then default factor is $(as_bold "$(as_light_green "5")")."
    log_plain "\tsupplied value must be 0 <= $(as_bold "$(as_light_green "val")") <= 976"

    log_plain ""

    log_plain "$(as_bold "--mktd") <option>"
    log_plain "\tCreate timestamp named directory in current directory, if $(as_bold '-d') is not supplied."

    log_plain "$idnt_sc1$(as_bold "-d") [$(as_bold "$(as_light_green "dir")")]"
    log_plain "\tUse $(as_bold "$(as_light_green "dir")") as parent directory."

    log_plain ""

    log_plain "$(as_bold "--vm") [option]"
    log_plain "\tManage virtual machine settings or services."

    log_plain "$idnt_sc1$(as_bold "--service") [$(as_bold "$(as_light_green "action")")]"
    log_plain "\tRun $(as_bold "$(as_light_green "action")"). It can be one from the following:"
    log_plain "\t$(as_bold "$(as_light_green "en")")|$(as_bold "$(as_light_green "enable")") to enable vmware services."
    log_plain "\t$(as_bold "$(as_light_green "dis")")|$(as_bold "$(as_light_green "disable")") to disable vmware services"
    log_plain "\t$(as_bold "$(as_light_green "start")") to start vmware services."
    log_plain "\t$(as_bold "$(as_light_green "stop")") to stop vmware services."
    log_plain "\t$(as_bold "$(as_light_green "restart")") to restart vmware services."
    log_plain "\t$(as_bold "$(as_light_green "status")") to check status of vmware services."
    log_plain "\t$(as_bold "$(as_light_green "insmod")") to try to load kernel modules, if services are not starting up."
    log_plain "\t$(as_bold "$(as_light_green "lsmod")") to print loaded kernel modules."

    log_plain ""

    log_plain "$(as_bold "--pass") [$(as_bold "$(as_light_green "len")")] [$(as_bold "$(as_light_green "rep")")]"
    log_plain "\tGenerate Random Password, of length $(as_bold "$(as_light_green "len")") and with character repeatable or not, provided in $(as_bold "$(as_light_green "rep")"),"
    log_plain "\twith values $(as_bold "$(as_light_green "0")") for no repeat and $(as_bold "$(as_light_green "1")") for repeat."




    

    #TODO: [6] INSERT DETAILED DESCRIPTION OF OPTIONS ABOVE THIS LINE, USE BELOW 2 LINES AS EXAMPLE FORMAT.
    #log_plain "$(as_bold "-h")|$(as_bold "--help")"
    #log_plain "\tShow help and exit."

    log_plain "\n$(as_bold "[$(as_yellow "EXIT CODES")]")"
    log_plain "\t$(as_bold "$__NAME__") exits with status $(as_bold "0") as success, greater than $(as_bold "0") if errors occur."
    log_plain "\t$(as_bold "0") --> success."
    log_plain "\t$(as_bold "1") --> error during argument parsing."




    #TODO: [7] INSERT NEW EXIT CODE ABOVE THIS LINE, USE BELOW LINE AS EXAMPLE FORMAT.
    #log_plain "\t$(as_bold "0") --> success."

    log_plain "\n$(as_bold "[$(as_yellow "AUTHORS")]")"
    log_plain "\tDinesh Saini <https://github.com/dineshsaini/>"

    log_plain "\n$(as_bold "[$(as_yellow "REPORTING BUGS")]")"
    log_plain "\tFor bug reports, use the issue tracker at https://github.com/dineshsaini/dizzy/issues"
}

function info {
    _info | less -IR
}

function version {
    log_plain "$__NAME__ (v$__VERSION__)"
}

function exit_check {
    if [ "x$flag_no_exit" = "x" ]; then
        exit 0
    fi
}

function _parse_args_screen {
    local n1="$#"
    local eflag=0
    local f_sbrt="/sys/class/backlight/intel_backlight/brightness"
    local v_std="333"
    local v_nmode="9"
    local v_diff="5"
    local v_cur=""
    local v_new=""

    while [[ $# -ne 0 && $eflag -eq 0 ]]; do
        local sarg1="$1"
        case "$sarg1" in 
            "--std")
                echo $v_std | sudo tee $f_sbrt > /dev/null
                shift 
                ;;
            "--nmode")
                echo $v_nmode | sudo tee $f_sbrt > /dev/null
                shift 
                ;;
            "--inc")
                v_cur=`cat $f_sbrt`
                
                if [ -n "$2" ] && [[ "$2" =~ ^[0-9]+$ ]]; then
                    v_diff="$2"
                    shift
                fi
                v_new=$(( v_cur + v_diff ))
                if [[ $v_new -gt 976 ]]; then
                    v_new=976
                elif [[ $v_new -lt 0 ]]; then
                    v_new=0
                fi

                echo "$v_new" | sudo tee $f_sbrt > /dev/null
                shift 
                ;;
            "--dec")
                v_cur=`cat $f_sbrt`

                if [ -n "$2" ] && [[ "$2" =~ ^[0-9]+$ ]]; then
                    v_diff="$2"
                    shift
                fi
                v_new=$(( v_cur - v_diff ))
                if [[ $v_new -gt 976 ]]; then
                    v_new=976
                elif [[ $v_new -lt 0 ]]; then
                    v_new=0
                fi 

                echo "$v_new" | sudo tee $f_sbrt > /dev/null
                shift 
                ;;
            *)
                eflag=1
                ;;
        esac
    done
    local n2="$#"
    shift_n="$((n1-n2))"

    if [[ $shift_n -eq 0 ]]; then
        log_error "Expected options, but found none. Check help."
        exit $ERR_ARGS
    fi
}

function _parse_args_mktd {
    local n1="$#"
    local eflag=0
    local pdir=""
    local d=""

    while [[ $# -ne 0 && $eflag -eq 0 ]]; do
        local sarg1="$1"
        case "$sarg1" in 
            "-d")
                pdir="$2"

                if [ -z $pdir ]; then
                    log_error 'Missing directory name. Check help.'
                    exit $ERR_ARGS
                fi
                shift
                shift 
                ;;
            *)
                eflag=1
                ;;
        esac
    done

    if [ -z "$pdir" ]; then
        pdir="."
    fi
    d=`date '+%Y_%m_%d_%r' | tr '[: ]' '_'`
    mkdir -p "$pdir/$d"
    log_info "created: '$pdir/$d'"

    local n2="$#"
    shift_n="$((n1-n2))"
}

function _parse_args_vm {
    local n1="$#"
    local eflag=0

    while [[ $# -ne 0 && $eflag -eq 0 ]]; do
        local sarg1="$1"
        case "$sarg1" in 
            "--service")
                local action="$2"
                
                if [ -z $action ]; then
                    log_error "Expected action name, found none. Check help."
                    exit $ERR_ARGS
                fi

                case $action in
                    "en"|"enable")
                        sudo systemctl enable vmware-usbarbitrator vmware vmware-networks-server
                        ;;
                    "dis"|"disable")
                        sudo systemctl disable vmware-usbarbitrator vmware vmware-networks-server
                        ;;
                    "start")
                        sudo systemctl start vmware-usbarbitrator vmware vmware-networks-server
                        ;;
                    "stop")
                        sudo systemctl stop vmware-usbarbitrator vmware vmware-networks-server
                        ;;
                    "restart")
                        sudo systemctl restart vmware-usbarbitrator vmware vmware-networks-server
                        ;;
                    "status")
                        sudo systemctl status vmware-usbarbitrator vmware vmware-networks-server
                        ;;
                    "insmod")
                        sudo modprobe -a vmw_vmci vmmon
                        ;;
                    "lsmod")
                        log_info 'searching for vmmon, vmw_vmci.'
                        lsmod | grep "vmw_vmci\|vmmon"
                        ;;
                    *)
                        log_error "invalid action '$action'. check help."
                        exit $ERR_ARGS
                        ;;
                esac

                shift
                shift 
                ;;
            *)
                eflag=1
                ;;
        esac
    done
    local n2="$#"
    shift_n="$((n1-n2))"

    if [[ $shift_n -eq 0 ]]; then
        log_error "Expected options, but found none. Check help."
        exit $ERR_ARGS
    fi
}

function genPasswd {
	local len=$1;
	local rFlag=$2;
	
	local p=$((/usr/bin/env perl -)< <(cat <<__END__
		use v5.28.1;
		use strict;
		use warnings;
		use List::Util 'shuffle';

		my \$alpha = "abcdefghijklmnopqrstuvwxyz";
		my @lAlpha = split //, \$alpha;
		my @uAlpha = split //, uc \$alpha;
		my @chars = split //, '~!@#\$%^&*()_+=-{[}]|\\:;,.</?>';
		my @num = split //, '0123456789';
		my @sets = ();

		push @sets, @lAlpha, @chars, @uAlpha, @num;
		my \$pLen = $len;
		my \$rep = $rFlag;
		# 0  -> no repetation
		# 1  -> repetation

		my \$pc = 1;
		my \$password = "";

		while (\$pc <= \$pLen){
			@sets = shuffle @sets;
			my \$t = \$sets[int rand \$#sets];
			next if \$rep == 0 and index (\$password, \$t) != -1;
			\$password .= \$t;  
			\$pc++;
		}

		say "password is '\$password'";
__END__
	));
    log_info "$p"
}

function _parse_args_gpassword {
    local n1="$#"
    local len="$1"
    local rep="$2"
    shift
    shift
    if [ -z "$len" ] || [ -z "$rep" ]; then
        log_error "Missing argument, check help."
        exit $ERR_ARGS
    fi

    if [[ "$len" =~ ^[0-9]+$ ]] && [[ "$rep" =~ ^[0-9]+$ ]]; then
        if [[ $len -eq 0 ]]; then
            log_error "Invalid length, check help."
            exit $ERR_ARGS
        elif [[ $rep -gt 1 ]]; then
            log_error "Invalid repeat flag, check help."
            exit $ERR_ARGS
        else
            genPasswd $len $rep
        fi
    else
        log_error "Expected numbers, found string ($len, $rep). check help."
        exit $ERR_ARGS
    fi

    local n2="$#"
    shift_n="$((n1-n2))"
}








#TODO: [2] INSERT FUNCTION FOR ARG PROCESS ABOVE THIS LINE, USE BELOW 22 LINES AS EXAMPLE FORMAT.
#function _parse_args_<optname> {
#    local n1="$#"
#    local eflag=0
#
#    while [[ $# -ne 0 && $eflag -eq 0 ]]; do
#        local sarg1="$1"
#        case "$sarg1" in 
#
#
##TODO: [3] INSERT SUB ARGS ABOVES THIS LINE, USE BELOW 4 LINES AS EXAMPLE FORMAT
##            "--<sub_arg>")
###TODO: [4] INSERT ACTUAL EXEC CODE HERE, IF CAPTURING VALUES THEN MODIFY SHIFT ACCORDINGLY
##                shift 
##                ;;
#            *)
#                eflag=1
#                ;;
#        esac
#    done
#    local n2="$#"
#    shift_n="$((n1-n2))"
#}

function parse_args {
    local shift_n=0
    while [ $# -gt 0 ]; do
        local arg="$1"
        shift
        case "$arg" in
            "--info")
                info
                exit 0
                ;;
            "-h"|"--help")
                help
                exit 0
                ;;
            "-V"|"--version")
                version
                exit 0
                ;;
            "-v"|"--verbose")
                flag_verbose='y'
                ;;
            "--no-warn")
                flag_disable_warnings='y'
                ;;
            "--no-exit")
                flag_no_exit='y'
                ;;
            "--screen")
                _parse_args_screen "$@"
                shift $shift_n
                exit_check;
                ;;
            "--mktd")
                _parse_args_mktd "$@"
                shift $shift_n
                exit_check;
                ;;
            "--vm")
                _parse_args_vm "$@"
                shift $shift_n
                exit_check;
                ;;
            "--pass")
                _parse_args_gpassword "$@"
                shift $shift_n
                exit_check;
                ;;




            #TODO: [1] INSERT CODE ABOVE THIS LINE TO ADD NEW ARGUMENT, UES BELOW 5 LINES AS EXAMPLE FORMAT.
            #"-sort"|"--long")
            #    _parse_args_<optname> "$@"
            #    shift $shift_n
            #    exit_check;
            #    ;;

            *)
                log_error "Unknow option '$arg', check help for details."
                exit $ERR_ARGS;
                ;;
        esac
    done
}

parse_args "$@"

