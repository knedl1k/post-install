rm install_packages.txt > /dev/null 2>&1

if ! [ -x "$(command -v paru)" ]; then
    sudo pacman --noconfirm -Syyu
    sudo pacman --noconfirm --needed -S git base-devel wget
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    clear
    echo  "==> Run script again..."
    exit 1
fi

if [ "$1" == "" ]; then
    echo ""
    echo "Select profile:"
    echo "----------------"
    echo "ntb ==> notebook basics"
    echo "all ==> ntb + all big apps like kicad or blender"
    echo ""
    exit 0
fi

while IFS= read -r line;do
    if ! [[ "$line" == *"#"* ]]; then
        group=$(echo "$line" | awk -F'[][]' '{print $2}')
        cmd=$(echo "$line" | awk -F'\"' '{print $2}')        
        if [[ "$group" == *"$1"* ]]; then
            pkg_list+=("$cmd")
        fi
    fi
    echo "${pkg_list[@]}" > install_packages.txt
done < "./packages.conf" | sed -r '/^\s*$/d'

paru --noconfirm --needed -Syu $(cat install_packages.txt)
